CircleRoom = Stage:extend()

function CircleRoom:update(dt)

end

function CircleRoom:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("line", gw/2, gh/2, gh/4)
end