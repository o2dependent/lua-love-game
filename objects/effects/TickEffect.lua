TickEffect = GameObject:extend()

function TickEffect:new(area, x, y, opts)
	TickEffect.super.new(self, area, x, y, opts)

	-- position
	self.w, self.h = 48, 32
	self.depth = 100

	-- y offset to anchor the effect to the top of the player
	self.y_offset = 0

	-- tween the height to 0 and kill object when done
	self.timer:tween(0.13, self, {h = 0, y_offset = 32}, 'in-out-cubic', function () self.dead = true end)
end

function TickEffect:update(dt)
	TickEffect.super.update(self, dt)

	if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end
end

function TickEffect:draw()
	love.graphics.setColor(default_color)
	love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end