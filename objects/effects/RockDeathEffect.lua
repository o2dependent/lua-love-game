RockDeathEffect = GameObject:extend()

function RockDeathEffect:new(area, x, y, opts)
	RockDeathEffect.super.new(self, area, x, y, opts)

	-- position
	self.w, self.h = self.s * 2, self.s * 2
	self.depth = 100

	-- tween the height to 0 and kill object when done
	self.timer:after(0.13, function () self.dead = true end)
end

function RockDeathEffect:update(dt)
	RockDeathEffect.super.update(self, dt)
end

function RockDeathEffect:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
	love.graphics.setColor(default_color)
end