Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()
	-- set collision classes
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Enemy')
	self.area.world:addCollisionClass('Projectile',
		{
			ignores = {'Projectile'}
		}
	)
	self.area.world:addCollisionClass('EnemyProjectile',
		{
			ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}
		}
	)
	self.area.world:addCollisionClass('Consumables',
		{
			ignores = {'Consumables', 'Player', 'Projectile'}
		}
	)

	-- add player and stage canvas
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	self.player = self.area:addGameObject('Player', gw/2, gh/2)


	-- testing ammo
	input:bind('r', function()
		self.area:addGameObject('Rock', random(0, gw), random(0, gh), {v = random(-75, 75), s = random(8, 16)})
	end)
	input:bind('s', function()
		self.area:addGameObject('Shooter', random(0, gw), random(0, gh))
	end)
	input:bind('p', function()
		self.area:addGameObject('Ammo', random(0, gw), random(0, gh))
	end)
	input:bind('b', function()
		self.area:addGameObject('Boost', random(0, gw), random(0, gh))
	end)
	input:bind('h', function()
		self.area:addGameObject('Health', random(0, gw), random(0, gh))
	end)
	input:bind('k', function()
		self.area:addGameObject('SkillPoint', random(0, gw), random(0, gh))
	end)
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