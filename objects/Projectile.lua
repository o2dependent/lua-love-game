Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)

	self.homing = opts.homing or false
	self.homing_strength = opts.homing_strength or 0.1
	self.target = nil
	self.s = opts.s or 2.5 -- radius of collider
	self.v = opts.v or 200 -- velocity
	self.color = opts.color or default_color
	self.damage = opts.damage or 100

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
	self.collider:setCollisionClass('Projectile')

	if self.homing then
		self.timer:every(0.01, function ()
			local r, g, b = unpack(self.color)
			r, g, b = r + 0.1, g + 0.1, b + 0.1
			self.area:addGameObject(
				'TrailParticle',
				self.x,
				self.y,
				{
					r = self.s, -- radius
					-- d = random(0.2, 0.35), -- duration
					d = 0.05, -- duration
					color = {r, g, b} -- color
				}
			)
		end)
	end
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)

	if self.homing then
		-- if there is a target just move towards it
		if not self.target then
			-- get all enemies in the area
			local targets = self.area:getGameObjects(function (obj)
				for _, enemy in ipairs(enemies) do
					if obj:is(_G[enemy]) and (distance(obj.x, obj.y, self.x, self.y) < 400) then return true end
				end
			end)
			-- find the closest enemy
			local closest = nil
			local closest_distance = 100000
			for _, target in ipairs(targets) do
				local d = distance(target.x, target.y, self.x, self.y)
				if d < closest_distance then
					closest = target
					closest_distance = d
				end
			end
			-- set the target
			self.target = closest
		end

		-- if the target is dead then do not home in on it
		if self.target and self.target.dead then
			self.target = nil
		end

		-- if there is a target then home in on it
		if self.target then
			local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
			local angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
			local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
			local final_heading = (projectile_heading + (self.homing_strength*to_target_heading)):normalized()
			-- set rotation to represent the direction of the projectile
			self.r = math.atan2(final_heading.y, final_heading.x)
			self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
		end
	else
		self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
	end

	if self.x < 0 then self:die() end
	if self.y < 0 then self:die() end
	if self.x > gw then self:die() end
	if self.y > gh then self:die() end
end


function Projectile:draw()
	love.graphics.setColor(default_color)
	pushRotate(self.x, self.y, self.r)
	if self.homing then
		love.graphics.setColor(self.color)
		draft:rhombus(self.x, self.y, self.s * 2, self.s * 2, 'fill')
	else
		love.graphics.setLineWidth(self.s - self.s/4)
		love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
		love.graphics.setColor(self.color)
		love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
		love.graphics.setLineWidth(1)
	end
		love.graphics.pop()
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = hp_color, w = self.s * 3})
end