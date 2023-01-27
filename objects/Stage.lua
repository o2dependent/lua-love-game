Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()

	-- director
	self.director = Director(self)

	-- set collision classes
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Enemy')
	self.area.world:addCollisionClass('Projectile',{ignores = {'Projectile'}})
	self.area.world:addCollisionClass('EnemyProjectile',{ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
	self.area.world:addCollisionClass('Consumables',{ignores = {'Consumables', 'Player', 'Projectile'}})

	-- add player, score and stage canvas
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	self.player = self.area:addGameObject('Player', gw/2, gh/2)
	self.score = 0


	-- testing ammo
	input:bind('r', function()
		self.area:addGameObject('Rock', random(0, gw), random(0, gh), {v = random(-75, 75), s = random(8, 16)})
	end)
	input:bind('s', function()
		self.area:addGameObject('Shooter')
	end)
	input:bind('p', function()
		self.area:addGameObject('Ammo')
	end)
	input:bind('b', function()
		self.area:addGameObject('Boost')
	end)
	input:bind('h', function()
		self.area:addGameObject('Health')
	end)
	input:bind('k', function()
		self.area:addGameObject('SkillPoint')
	end)

	-- ui variables
	self.font = fonts.m5x7_16

end

function Stage:update(dt)
	self.director:update(dt)
	self.area:update(dt)
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0, 0, gw, gh)
	self.area:draw()
	camera:detach()
	love.graphics.setFont(self.font)
	love.graphics.setColor(default_color)
	love.graphics.print(
		'' .. self.score,
		gw - 20,
		10,
		0,
		1,
		1,
		math.floor(self.font:getWidth('' .. self.score)/2),
		self.font:getHeight()/2
	)
	love.graphics.setColor(255, 255, 255)

	-- HP
	local r, g, b = unpack(hp_color)
	local hp, max_hp = self.player.hp, self.player.max_hp
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
	love.graphics.setColor(r - (32/255), g - (32/255), b - (32/255))
	love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)
	love.graphics.print('HP', gw/2 - 52 + (48/2), gh - 24, 0, 1, 1, math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))

	-- Boost
	local r, g, b = unpack(boost_color)
	local boost, max_boost = self.player.boost, self.player.max_boost
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 - 52, 16, 48*(boost/max_boost), 4)
	love.graphics.setColor(r - (32/255), g - (32/255), b - (32/255))
	love.graphics.rectangle('line', gw/2 - 52, 16, 48, 4)
	love.graphics.print('Boost', gw/2 - 52 + (48/2), 24, 0, 1, 1, math.floor(self.font:getWidth('Boost')/2), math.floor(self.font:getHeight()/2))

	-- ammo
	local r, g, b = unpack(ammo_color)
	local ammo, max_ammo = self.player.ammo, self.player.max_ammo
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 + 4, 16, 48*(ammo/max_ammo), 4)
	love.graphics.setColor(r - (32/255), g - (32/255), b - (32/255))
	love.graphics.rectangle('line', gw/2 + 4, 16, 48, 4)
	love.graphics.print('Ammo', gw/2 + 4 + (48/2), 24, 0, 1, 1, math.floor(self.font:getWidth('Ammo')/2), math.floor(self.font:getHeight()/2))

	-- Cycle
	local r, g, b = unpack(skill_point_color)
	local round_timer, round_duration = self.director.round_timer, self.director.round_duration
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 + 4, gh - 16, 48*(round_timer/round_duration), 4)
	love.graphics.setColor(r - (32/255), g - (32/255), b - (32/255))
	love.graphics.rectangle('line', gw/2 + 4, gh - 16, 48, 4)
	love.graphics.print('Cycle', gw/2 + 4 + (48/2), gh - 24, 0, 1, 1, math.floor(self.font:getWidth('Cycle')/2), math.floor(self.font:getHeight()/2))
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

function Stage:finish()
	timer:after(1, function()
		timer:clear()
		gotoRoom('Stage')
	end)
end