Boost = GameObject:extend()

function Boost:new(area, x, y, opts)
	Boost.super.new(self, area, x, y, opts)

	-- amount of boost to add
	self.amount = opts.amount or 5

	-- position
	local direction = table.random({-1, 1})
	self.x = gw/2 + direction*(gw/2 + 48)
	self.y = random(48, gh - 48)

	self.w, self.h = 12, 12
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

function Boost:update(dt)
	Boost.super.update(self, dt)

	-- seek player
  self.collider:setLinearVelocity(
		self.v,
		0
	)
end

function Boost:draw()
	love.graphics.setColor(boost_color)
	pushRotate(
		self.x,
		self.y,
		self.collider:getAngle()
	)
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
		self.w*0.5,
		self.h*0.5,
		'fill'
	)
	love.graphics.pop()
	love.graphics.setColor(default_color)
end

function Boost:die()
	current_room.player:addBoost(self.amount)
	self.dead = true
	self.area:addGameObject(
		'BoostEffect',
		self.x,
		self.y,
		{
			color = boost_color,
			w = self.w,
			h = self.h
		}
	)
	self.area:addGameObject(
		'InfoText',
		self.x,
		self.y,
		{
			color = boost_color,
			text = '+BOOST'
		}
	)
end