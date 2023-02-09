
WalkingPlayer = GameObject:extend()

function WalkingPlayer:new(area, x, y, opts)
	WalkingPlayer.super.new(self, area, x, y, opts)

	-- set position
	self.x, self.y = x, y
	self.w, self.h = 12, 12

	-- direction
	self.direction = opts.direction or {}

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
	self.xv = 0 -- x velocity
	self.yv = 0 -- y velocity
	self.base_max_v = 100 -- base level max velocity
	self.max_v = self.base_max_v -- current max velocity
	self.a = 0 -- acceleration

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

function WalkingPlayer:generateChances()
	self.chances = {}
	for k, v in pairs(self) do
		if k:find('_chance') and type(v) == 'number' then
			self.chances[k] = chanceList({true, math.ceil(v)}, {false, 100 - math.ceil(v)})
		end
	end
end


function WalkingPlayer:setStats()
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

function WalkingPlayer:addItem(item_name)
	-- add item to player
	if _G[item_name] then
		table.insert(self.items, _G[item_name](self.area, self))
		self:setStats()
		self:generateChances()
	end
end

function WalkingPlayer:onAmmoPickup()
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

function WalkingPlayer:onSkillPointPickup()
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

function WalkingPlayer:cycle()
	-- self.timer:after(self.cycle_cooldown, function()
		self.area:addGameObject('CycleEffect', self.x, self.y, {parent = self})
		-- self:cycle()
	-- end)
end

function WalkingPlayer:fireShot()
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

function WalkingPlayer:update(dt)
	-- dt = delta time between frames
	-- multiply "per second" values by dt to get "per frame" values
	-- this keeps increase/decrease of values between frames consistent

	WalkingPlayer.super.update(self, dt)
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
	if input:down('space') and self.boost > 1 and self.can_boost then
		self.boosting = true
		self.max_v = 1.5*self.base_max_v
		self.boost = self.boost - 50*dt -- reduce by 50 per second
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
		end
	end

	self.direction = {}

	if input:down('up') then
		table.insert(self.direction, 'up')
		self.r = -math.pi/2
	end
	if input:down('down') and self.boost > 1 and self.can_boost then
		table.insert(self.direction, 'down')
		self.r = math.pi/2
	end
	if input:down('left') then
		table.insert(self.direction, 'left')
		self.r = math.pi
	end
	if input:down('right') then
		table.insert(self.direction, 'right')
		self.r = 0
	end

	local is_moving_x = false
	local is_moving_y = false

	if #self.direction > 0 then
		for _, direction in ipairs(self.direction) do
			if direction == 'up' then
				self.yv = self.yv - self.v*dt
				is_moving_y = true
			elseif direction == 'down' then
				self.yv = self.yv + self.v*dt
				is_moving_y = true
			elseif direction == 'left' then
				self.xv = self.xv - self.v*dt
				is_moving_x = true
			elseif direction == 'right' then
				self.xv = self.xv + self.v*dt
				is_moving_x = true
			end
		end
		self.a = math.min(self.a + 200*dt, 300)
		self.v = math.min(self.v + self.a*dt, self.max_v)
	end

	-- slow down if no input is given for x and y

	if not is_moving_y and self.yv > 0 then
		self.yv = self.yv - self.v*dt
	elseif not is_moving_y and self.yv < 0 then
		self.yv = self.yv + self.v*dt
	end
	if not is_moving_x and self.xv > 0 then
		self.xv = self.xv - self.v*dt
	elseif not is_moving_x and self.xv < 0 then
		self.xv = self.xv + self.v*dt
	end

	-- limit velocity of x and y to max velocity
	local max_xv = 150
	local max_yv = 150
	if self.xv > max_xv then self.xv = max_xv end
	if self.xv < -max_xv then self.xv = -max_xv end
	if self.yv > max_yv then self.yv = max_yv end
	if self.yv < -max_yv then self.yv = -max_yv end

	-- update trail color
	self.trail_color = skill_point_color
	if self.boosting then self.trail_color = boost_color end

	-- update position and velocity
	print(self.a, self.v)
	-- self.xv = self.xv*math.cos(self.r)
	-- self.yv = self.yv*math.sin(self.r)
	self.collider:setLinearVelocity(self.xv, self.yv)

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

function WalkingPlayer:draw()
	if self.visible then
		-- draw ship
		-- draw circle
		love.graphics.setColor(default_color)
		love.graphics.circle('fill', self.x, self.y, self.w)
		-- draw direction indicator
		love.graphics.setColor(255, 255, 255)
		love.graphics.line(self.x, self.y, self.x + self.w*math.cos(self.r), self.y + self.w*math.sin(self.r))
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

function WalkingPlayer:shoot()
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

function WalkingPlayer:die()
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

function WalkingPlayer:takeDamage(damage)
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

function WalkingPlayer:iframeBlink(duration)
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

function WalkingPlayer:addAmmo(amount)
	self.ammo = math.min(self.ammo + self.flat_ammo_gain + amount, self.max_ammo)
	current_room.score = current_room.score + 50
end

function WalkingPlayer:addBoost(amount)
	self.boost = math.min(self.boost + amount, self.max_boost)
	current_room.score = current_room.score + 150
end


function WalkingPlayer:addHp(amount)
	self.hp = math.min(self.hp + amount, self.max_hp)
end

function WalkingPlayer:addSkillPoint(amount)
	skill_points = skill_points + amount
	current_room.score = current_room.score + 250
	self:onSkillPointPickup()
end

function WalkingPlayer:setAttack(attack)
	self.attack = _G[attack](self)
	self.ammo = self.max_ammo
	if current_room then current_room.score = current_room.score + 500 end
end
