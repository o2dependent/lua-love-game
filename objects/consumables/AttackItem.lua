AttackItem = GameObject:extend()

function AttackItem:new(area, x, y, opts)
	AttackItem.super.new(self, area, x, y, opts)

	-- amount of skill point to add
	self.attack = opts.attack or "Neutral"
	self.abbreviation = _G[self.attack].abbreviation
	self.color = _G[self.attack].color
	self.font = fonts.m5x7_16

	self.characters = {}
	for i = 1, #self.abbreviation do
		table.insert(self.characters, self.abbreviation:utf8sub(i, i))
	end

	-- position
	local direction = table.random({-1, 1})
	self.x = gw/2 + direction*(gw/2 + 48)
	self.y = random(48, gh - 48)

	self.w, self.h = 16, 16
	self.collider = self.area.world:newRectangleCollider(
		self.x,
		self.y,
		self.w,
		self.h
	)
	self.collider:setObject(self)
	self.collider:setFixedRotation(false)
	self.r = random(0, 2*math.pi)
	self.v = -direction*random(20, 40)
	self.collider:setLinearVelocity(
		self.v,
		0
	)
	self.collider:applyAngularImpulse(random(-12, 12))
	self.collider:setCollisionClass('Consumables')
end

function AttackItem:update(dt)
	AttackItem.super.update(self, dt)

	-- seek player
  self.collider:setLinearVelocity(
		self.v,
		0
	)
end

function AttackItem:draw()
	pushRotate(
		self.x - self.w/2,
		self.y - self.w/2,
		0
	)
	love.graphics.setColor(self.color)
	love.graphics.setFont(self.font)
	for i = 1, #self.characters do
		local width = 0
		if i > 1 then
			for j = 1, i-1 do
				width = width + self.font:getWidth(self.characters[j])
			end
		end

		love.graphics.setColor(self.color)
		love.graphics.print(
			self.characters[i],
			self.x + width,
			self.y,
			0,
			1,
			1,
			self.font:getWidth(self.characters[i])/2,
			self.font:getHeight()/2
		)
	end
	love.graphics.pop()
	love.graphics.setLineWidth(0.5)
		love.graphics.setColor(self.color)
		draft:rhombus(
		self.x,
		self.y,
		self.w*1.5,
		self.h*1.5,
		'line'
	)
	draft:rhombus(
		self.x,
		self.y,
		self.h*1.2,
		self.w*1.2,
		'line'
	)
	love.graphics.setColor(default_color)
	love.graphics.setLineWidth(1)
end

function AttackItem:die()
	current_room.player:setAttack(self.attack)
	self.dead = true
	self.area:addGameObject(
		'AttackItemEffect',
		self.x,
		self.y,
		{
			color = _G[self.attack].color,
			w = self.w,
			h = self.h
		}
	)
	self.area:addGameObject(
		'InfoText',
		math.max(0, self.x + random(-self.w, self.h)),
		math.max(0, self.y + random(-self.w, self.h)),
		{
			color = _G[self.attack].color,
			text = self.attack
		}
	)
end