Health = GameObject:extend()

function Health:new(area, x, y, opts)
	Health.super.new(self, area, x, y, opts)

	-- amount of health to add
	self.amount = opts.amount or 25

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

function Health:update(dt)
	Health.super.update(self, dt)

	-- seek player
  self.collider:setLinearVelocity(
		self.v,
		0
	)
end

function Health:draw()
	love.graphics.setColor(default_color)
	draft:circle(
		self.x,
		self.y,
		self.w*1.5,
		self.h*1.5,
		'line'
	)
	love.graphics.setColor(hp_color)
	draft:rectangle(
		self.x,
		self.y,
		self.w,
		self.h*0.25,
		'fill'
	)
	draft:rectangle(
		self.x,
		self.y,
		self.w*0.25,
		self.h,
		'fill'
	)
	love.graphics.setColor(default_color)
end

function Health:die()
	current_room.player:addHp(self.amount)
	self.dead = true
	self.area:addGameObject(
		'HealthEffect',
		self.x,
		self.y,
		{
			color = hp_color,
			w = self.w,
			h = self.h
		}
	)
	self.area:addGameObject(
		'InfoText',
		self.x,
		self.y,
		{
			color = hp_color,
			text = '+HP'
		}
	)
end