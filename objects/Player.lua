
Player = GameObject:extend()

function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	-- set position
	self.x, self.y = x, y
	self.w, self.h = 12, 12

	-- create new collider for player
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self) -- bind collider to player
	self.collider:setCollisionClass('Player')

	-- set other options
	self.iframe_active = false
	self.visible = true
	self.r = -math.pi/2 -- player rotation
	self.rv = 1.66 * math.pi -- rotation velocity
	self.v = 0 -- velocity
	self.base_max_v = 100 -- base level max velocity
	self.max_v = self.base_max_v -- current max velocity
	self.a = 100 -- acceleration

	-- set up attacks
	self.attack_timer = 0
	self.attack = _G['Neutral'](self)
	self:setAttack("Neutral")
	self.aspd_multiplier = 1

	input:bind('1', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Neutral"}) end)
	input:bind('2', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Double"}) end)
	input:bind('3', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Rapid"}) end)
	input:bind('4', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Triple"}) end)
	input:bind('5', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Spread"}) end)
	input:bind('6', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Back"}) end)
	input:bind('7', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Side"}) end)
	input:bind('8', function() self.area:addGameObject("AttackItem",random(0, gw), random(0, gh), {attack = "Homing"}) end)

	-- start cycle loop
	-- self.cycle_cooldown = 5
	-- self:cycle()

	-- set up ship
	self.ship = Fighter(self.area, self)
	input:bind('f5', function() self.ship = Fighter(self.area, self) end)
	input:bind('f6', function() self.ship = Scorpion(self.area, self) end)
	input:bind('/', function() self:addItem('BigAmmoItem') end)

	-- boost trail
	self.flat_boost = 0
	self.boost_multiplier = 1
	self.boosting = false
	self.max_boost = 100
	self.boost = self.max_boost

	self.can_boost = true
	self.boost_timer = 0
	self.boost_cooldown = 2

	self.trail_color = skill_point_color
	self.timer:every(0.02, function ()
		self.ship:trail()
	end)

	-- player hp
	self.flat_hp = 0
	self.hp_multiplier = 1
	self.max_hp = 100
	self.hp = self.max_hp

	-- ammo
	self.flat_ammo = 0
	self.ammo_multiplier = 1
	self.max_ammo = 100
	self.ammo = self.max_ammo
	self.manual_shooting = false

	self.flat_ammo_gain = 0

	-- items and skills
	self.items = {}
	self.skills = {}

	self:setStats()

	-- chances
	self.chances = {}
	self.launch_homing_projectile_on_ammo_pickup_chance = 25
	self.regain_hp_on_ammo_pickup_chance = 25
	self.regain_hp_on_sp_pickup_chance = 25

	self:generateChances()
end

function Player:generateChances()
	self.chances = {}
	for k, v in pairs(self) do
		if k:find('_chance') and type(v) == 'number' then
			self.chances[k] = chanceList({true, math.ceil(v)}, {false, 100 - math.ceil(v)})
		end
	end
end


function Player:setStats()
	self.aspd_multiplier = 1
	self.flat_boost = 0
	self.boost_multiplier = 1
	self.flat_hp = 0
	self.hp_multiplier = 1
	self.max_hp = 100
	self.flat_ammo = 0
	self.ammo_multiplier = 1
	self.max_ammo = 100
	self.manual_shooting = false
	self.flat_ammo_gain = 0

	-- set stats based on items
	for _, item in ipairs(self.items) do
		if item.updateStats then
			print(item.updateStats)

			item:updateStats()
		end
	end
	-- set stats based on skills
	for _, item in ipairs(self.skills) do
		if item.updateStats then item:updateStats() end
	end

	self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier
	self.hp = self.max_hp

	self.max_ammo = (self.max_ammo + self.flat_ammo)*self.ammo_multiplier
	self.ammo = self.max_ammo

	self.max_boost = (self.max_boost + self.flat_boost)*self.boost_multiplier
	self.boost = self.max_boost
end

function Player:addItem(item_name)
	-- add item to player
	if _G[item_name] then
		table.insert(self.items, _G[item_name](self.area, self))
		self:setStats()
		self:generateChances()
	end
end

function Player:onAmmoPickup()
	if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
		local d = 1.2*self.w
		self.area:addGameObject(
			'Projectile',
			self.x + d*math.cos(self.r),
			self.y + d*math.sin(self.r),
			{
				r = self.r,
				s = 2.5,
				v = 250,
				color = ammo_color,
				homing = true
			}
		)
		self.area:addGameObject(
			'InfoText',
			self.x,
			self.y,
			{
				color = boost_color,
				text = 'Homing Projectile!'
			}
		)
	end
	if self.chances.regain_hp_on_ammo_pickup_chance:next() then
		self:addHp(25)
		self.area:addGameObject(
			'InfoText',
			self.x,
			self.y,
			{
				color = boost_color,
				text = 'HP Regain!'
			}
		)
	end
end

function Player:onSkillPointPickup()
	if self.chances.regain_hp_on_ammo_pickup_chance:next() then
		self:addHp(25)
		self.area:addGameObject(
			'InfoText',
			self.x,
			self.y,
			{
				color = boost_color,
				text = 'HP Regain!'
			}
		)
	end
end

function Player:cycle()
	-- self.timer:after(self.cycle_cooldown, function()
		self.area:addGameObject('CycleEffect', self.x, self.y, {parent = self})
		-- self:cycle()
	-- end)
end

function Player:fireShot()
	-- don't shoot if player is dead
	if self.dead then return end

	if self.manual_shooting then
		if input:down('space') and self.ammo > 0 then
			self:shoot()
		end
	else
		self:shoot()
	end
	-- reset to Neutral if ammo is 0
	if self.ammo <= 0 then
		self:setAttack('Neutral')
		self.ammo = self.max_ammo
	end
end

function Player:update(dt)
	-- dt = delta time between frames
	-- multiply "per second" values by dt to get "per frame" values
	-- this keeps increase/decrease of values between frames consistent

	Player.super.update(self, dt)
	if self.attack and self.attack.update then self.attack:update(dt) end

	-- update items
	for _, item in ipairs(self.items) do
		if item.update then item:update(dt) end
	end

	-- update skills
	for _, skill in ipairs(self.skills) do
		if skill.update then skill:update(dt) end
	end

	-- set boost
	self.boost = math.min(self.boost + 10*dt, self.max_boost)
	self.boost_timer = self.boost_timer + dt
	if self.boost_timer > self.boost_cooldown then
		self.can_boost = true
	end
	self.boosting = false

	-- reset max velocity
	self.max_v = self.base_max_v

	-- check inputs for velocity and rotation changes
	if input:down('up') and self.boost > 1 and self.can_boost then
		self.boosting = true
		self.max_v = 1.5*self.base_max_v
		self.boost = self.boost - 50*dt -- reduce by 50 per second
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
		end
	end
	if input:down('down') and self.boost > 1 and self.can_boost then
		self.boosting = true
		self.max_v = 0.5*self.base_max_v
		self.boost = self.boost - 50*dt -- reduce by 50 per second
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
		end
	end
	if input:down('left') then
		self.r = self.r - self.rv*dt
	end
	if input:down('right') then
		self.r = self.r + self.rv*dt
	end
	-- update trail color
	self.trail_color = skill_point_color
	if self.boosting then self.trail_color = boost_color end

	-- update position and velocity
	self.v = math.min(self.v + self.a*dt, self.max_v)
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

	-- shoot
	self.attack_timer = self.attack_timer + dt
	if self.attack_timer > self.attack.cooldown * self.aspd_multiplier then
		self.attack_timer = 0
		self:fireShot()
	end

	-- player dies if they go off screen
	if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end

	if self.collider:enter('Consumables') then
		local collision_data = self.collider:getEnterCollisionData('Consumables')
		local object = collision_data.collider:getObject()
		if object and object.die then
			object:die()
		end
	end
	if self.collider:enter('Enemy') then
		local collision_data = self.collider:getEnterCollisionData('Enemy')
		local object = collision_data.collider:getObject()
		if object and object.die then
			self:takeDamage(object.collide_damage)
			object:takeDamage(10)
		end
	end
end

function Player:draw()
	if self.visible then
	-- draw ship
		self.ship:draw()
	end
	-- draw items
	for _, item in ipairs(self.items) do
		if item.draw then item:draw() end
	end

	-- draw skills
	for _, skill in ipairs(self.skills) do
		if skill.draw then skill:draw() end
	end
end

function Player:shoot()
	local d = 1.2*self.w

	self.area:addGameObject(
		'ShootEffect',
		self.x + d*math.cos(self.r),
		self.y + d*math.sin(self.r),
		{player = self, d = d}
	)

	-- reduce ammo based on the current attack type
	self.ammo = self.ammo - self.attack.ammo_cost

	-- create projectile
	self.attack:shoot()
end

function Player:die()
	slow(0.15, 1)
	flash(4)
	camera:shake(4, 5, 60)
	self.dead = true

	for i = 1, love.math.random(8, 16) do
		self.area:addGameObject(
			'ExplodeParticle',
			self.x,
			self.y
		)
	end

	current_room:finish()
end

function Player:takeDamage(damage)
	damage = damage or 10
	if self.iframe_active then return end
	self.hp = self.hp - damage
	if self.hp <= 0 then
		self:die()
	else
		if damage > 30 then
			self:iframeBlink(1)
		else
			self:iframeBlink(0.25)
		end
	end
end

function Player:iframeBlink(duration)
	self.iframe_active = true
	slow(0.25, duration)
	camera:shake(4, 1, 60)
	self.timer:after(
		duration,
		function()
			self.iframe_active = false
			self.visible = true
		end
	)
	self.timer:every(0.05, function()
		self.visible = not self.visible
	end,
	math.floor(duration/0.05) - 1
)
end

function Player:addAmmo(amount)
	self.ammo = math.min(self.ammo + self.flat_ammo_gain + amount, self.max_ammo)
	current_room.score = current_room.score + 50
end

function Player:addBoost(amount)
	self.boost = math.min(self.boost + amount, self.max_boost)
	current_room.score = current_room.score + 150
end


function Player:addHp(amount)
	self.hp = math.min(self.hp + amount, self.max_hp)
end

function Player:addSkillPoint(amount)
	skill_points = skill_points + amount
	current_room.score = current_room.score + 250
	self:onSkillPointPickup()
end

function Player:setAttack(attack)
	self.attack = _G[attack](self)
	self.ammo = self.max_ammo
	if current_room then current_room.score = current_room.score + 500 end
end
