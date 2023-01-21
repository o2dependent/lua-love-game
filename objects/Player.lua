
Player = GameObject:extend()

function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	-- set position
	self.x, self.y = x, y
	self.w, self.h = 12, 12

	-- create new collider for player
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self) -- bind collider to player

	-- set other options
	self.r = -math.pi/2 -- player rotation
	self.rv = 1.66 * math.pi -- rotation velocity
	self.v = 0 -- velocity
	self.base_max_v = 100 -- base level max velocity
	self.max_v = self.base_max_v -- current max velocity
	self.a = 100 -- acceleration
	self.attack_speed = 1 -- attack speed multiplier

	-- start attack loop
	self:attackLoop()

	-- start tick loop
	self.timer:every(5, function() self:tick() end)

	-- set up ship
	self.ship = Fighter(self.area, self)
	input:bind('f5', function() self.ship = Fighter(self.area, self) end)
	input:bind('f6', function() self.ship = Scorpion(self.area, self) end)

	-- boost trail
	self.boosting = false
	self.trail_color = skill_point_color
	self.timer:every(0.02, function ()
		self.ship:trail()
	end)

end

function Player:tick()
	self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:attackLoop()
	-- don't shoot if player is dead
	if self.dead then return end
	timer:after(0.12 * self.attack_speed, function()
		if input:down('space') then
			self:shoot()
		end
		self:attackLoop()
	end)
end

function Player:update(dt)
	Player.super.update(self, dt)

	-- reset max velocity
	self.max_v = self.base_max_v
	self.boosting = false

	-- check inputs for velocity and rotation changes
	if input:down('up') then
		self.max_v = 1.5*self.base_max_v
		self.boosting = true
	end
	if input:down('down') then
		self.max_v = 0.5*self.base_max_v
		self.boosting = true
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

	-- player dies if they go off screen
	if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
end

function Player:draw()
	-- TESTING: if player is close to the edge of the screen, draw a line to the center
	if self.x < self.w + self.h or self.x > gw - self.w - self.h or self.y < self.w + self.h or self.y > gh - self.w - self.h then
		love.graphics.setColor(default_color)
		love.graphics.line(self.x, self.y, gw/2, gh/2)
	end

	-- draw ship
	self.ship:draw()
	-- pushRotate(self.x, self.y, self.r)
	-- love.graphics.setColor(default_color)
	-- for _, polygon in ipairs(self.polygons) do
	-- 		local points = M.map(polygon, function(v, k)
	-- 			if k % 2 == 1 then
	-- 					return self.x + v + random(-1, 1)
	-- 			else
	-- 					return self.y + v + random(-1, 1)
	-- 			end
	-- 		end)

	-- 		love.graphics.polygon('line', points)
	-- end
	-- love.graphics.pop()
end

function Player:shoot()
	local d = 1.2*self.w

	self.area:addGameObject(
		'ShootEffect',
		self.x + d*math.cos(self.r),
		self.y + d*math.sin(self.r),
		{player = self, d = d}
	)
	self.area:addGameObject(
		'Projectile',
		self.x + 1.5*d*math.cos(self.r),
		self.y + 1.5*d*math.sin(self.r),
		{
			r = self.r,
			s = 2.5,
			v = 200
		}
	)
	-- self.area:addGameObject(
	-- 	'Projectile',
	-- 	self.x + 1.8*d*math.cos(self.r + math.pi/4),
	-- 	self.y + 1.8*d*math.sin(self.r + math.pi/4),
	-- 	{
	-- 		r = self.r,
	-- 		s = 2.5,
	-- 		v = 200
	-- 	}
	-- )
	-- self.area:addGameObject(
	-- 	'Projectile',
	-- 	self.x + 1.8*d*math.cos(self.r - math.pi/4),
	-- 	self.y + 1.8*d*math.sin(self.r - math.pi/4),
	-- 	{
	-- 		r = self.r,
	-- 		s = 2.5,
	-- 		v = 200
	-- 	}
	-- )
end

function Player:die()
	slow(0.15, 1)
	flash(4)
	camera:shake(6, 60, 0.4)
	self.dead = true

	for i = 1, love.math.random(8, 16) do
		self.area:addGameObject(
			'ExplodeParticle',
			self.x,
			self.y
		)
	end
end