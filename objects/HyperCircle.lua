HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, line_width, outer_radius)
	Circle.new(self, x, y, radius)

	self.line_width = line_width or 10
	self.outer_radius = outer_radius or self.radius + self.line_width
end

function HyperCircle:update(dt)
end

function HyperCircle:draw()
	Circle.draw(self)
	love.graphics.setLineWidth(self.line_width)
	love.graphics.circle("line", self.x, self.y, self.outer_radius)
end