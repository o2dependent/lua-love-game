ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
	ProjectileDeathEffect.super.new(self, area, x, y, opts)

	self.first = true
	self.timer:after(0.1, function()
		self.first = false
		self.second = true
		self.timer:after(0.15, function()
			self.second = false
			self.dead = true
		end)
	end)
end

function ProjectileDeathEffect:draw()
	if self.first then love.graphics.setColor(hp_color)
	elseif self.second then love.graphics.setColor(self.color) end
	love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end

