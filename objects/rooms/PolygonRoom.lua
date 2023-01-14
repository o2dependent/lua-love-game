PolygonRoom = Stage:extend()

function PolygonRoom:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.polygon("fill", 75, 45, 400, 45, 20, 300, 0, 300)
end