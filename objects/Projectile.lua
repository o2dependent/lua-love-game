Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)

	self.s = opts.s or 2.5 -- radius of collider
	self.v = opts.v or 200 -- velocity

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)

	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

	if self.x < 0 then self:die() end
	if self.y < 0 then self:die() end
	if self.x > gw then self:die() end
	if self.y > gh then self:die() end
end


function Projectile:draw()
	love.graphics.setColor(hp_color)
	love.graphics.circle('line', self.x, self.y, self.s)
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = hp_color, w = self.s * 3})
end