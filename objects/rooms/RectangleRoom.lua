RectangleRoom = Stage:extend()

function RectangleRoom:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", 200, 150, 400, 300)
end

