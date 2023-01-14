Circle = Object:extend()

function Circle:new(x, y, radius)
	print("Circle:new")

	self.x = x or 0
	self.y = y or 0
	self.radius = radius or 50
	self.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
	print("Circle:draw")

	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end