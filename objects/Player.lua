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
end

function Player:attackLoop()
	timer:after(0.24 * self.attack_speed, function()
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
end

function Player:draw()
	love.graphics.circle('line', self.x, self.y, self.w)
	love.graphics.line(self.x, self.y, self.x + self.w*2*math.cos(self.r), self.y + self.w*2*math.sin(self.r))
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
			r = self.r
		}
	)
end
