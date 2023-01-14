CircleRoom = Stage:extend()

function CircleRoom:update(dt)

end

function CircleRoom:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", 400, 300, 200)
end