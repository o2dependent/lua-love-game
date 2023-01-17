Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	self.player = self.area:addGameObject('Player', gw/2, gh/2)
end

function Stage:update(dt)
	self.area:update(dt)
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0, 0, gw, gh)
	self.area:draw()
	camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.setBlendMode("alpha","premultiplied")
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode("alpha")
end

function Stage:destroy()
	self.area:destroy()
	self.area = nil
end