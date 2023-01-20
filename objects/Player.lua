Player = GameObject:extend()

function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.x, self.y = x, y
	self.w, self.h = 12, 12
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)

	self.r = -math.pi/2 -- player rotation
	self.rv = 1.66 * math.pi -- rotation velocity
	self.v = 0 -- velocity
	self.max_v = 100 -- max velocity
	self.a = 100 -- acceleration

	self.attack_speed = 1

	self:attackLoop()

	self.timer:every(5, function() self:tick() end)
end

function Player:tick()
	self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:attackLoop()
	if self.dead then return end
	timer:after(0.12 * self.attack_speed, function()
		self:shoot()
		self:attackLoop()
	end)
end

function Player:update(dt)
	Player.super.update(self, dt)

	if input:down('left') then self.r = self.r - self.rv*dt end
	if input:down('right') then self.r = self.r + self.rv*dt end

	self.v = math.min(self.v + self.a*dt, self.max_v)
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

	-- player dies if they go off screen
	if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
end

function Player:draw()
	-- if player is close to the edge of the screen, draw a line to the center
	if self.x < self.r or self.x > gw - self.r or self.y < self.r or self.y > gh - self.r then
		love.graphics.setColor(default_color)
		love.graphics.line(self.x, self.y, gw/2, gh/2)
	end
	love.graphics.setColor(default_color)
	love.graphics.circle('line', self.x, self.y, self.w)
	-- love.graphics.line(self.x, self.y, self.x + self.w*2*math.cos(self.r), self.y + self.w*2*math.sin(self.r))
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