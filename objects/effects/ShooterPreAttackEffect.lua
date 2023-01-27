ShooterPreAttackEffect = GameObject:extend()

function ShooterPreAttackEffect:new(area, x, y, opts)
	ShooterPreAttackEffect.super.new(self, area, x, y, opts)

	self.w, self.h = 12, 6
	self.depth = 100
	self.timer:every(
		0.02,
		function ()
			self.area:addGameObject(
				'TargetParticle',
				self.x + random(-20, 20),
				self.y + random(-20, 20),
				{
					target_x = self.x,
					target_y = self.y,
					color = self.color
				}
			)
		end
	)
	self.timer:after(self.duration - self.duration/4, function() self.dead = true end)
end

function ShooterPreAttackEffect:update(dt)
	ShooterPreAttackEffect.super.update(self, dt)

	if self.parent and not self.parent.dead then
		self.x = self.parent.x + 1.4*self.parent.w*math.cos(self.parent.collider:getAngle())
		self.y = self.parent.y + 1.4*self.parent.w*math.sin(self.parent.collider:getAngle())
	end
end