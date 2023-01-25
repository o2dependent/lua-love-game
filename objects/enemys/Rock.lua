Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
	Rock.super.new(self, area, x, y, opts)

	local direction = table.random({-1, 1})
	self.r = random(0, 2*math.pi)
	self.v = self.v or random(-40, 40)
	self.s = opts.s or 8

	-- create a new polygon collider
	self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(self.s))
	-- set the position of the collider
	self.collider:setPosition(self.x, self.y)
	-- set the object that the collider is associated with
	self.collider:setObject(self)
	-- set the collision class of the collider
	self.collider:setCollisionClass('Enemy')
	-- set whether the collider should rotate with the object
	self.collider:setFixedRotation(false)
	-- set the linear velocity of the collider
	self.collider:setLinearVelocity(self.v, 0)
	-- apply an angular impulse to the collider
	self.collider:applyAngularImpulse(random(-100, 100))
end

function Rock:update(dt)
	Rock.super.update(self, dt)

	-- seek player
  self.collider:setLinearVelocity(
		self.v,
		0
	)

	if self.collider:enter('Projectile') then
		local collision_data = self.collider:getEnterCollisionData('Projectile')
		local object = collision_data.collider:getObject()
		if object and object.die then
			object:die()
		end
		self:die()
	end
end

function Rock:draw()
	love.graphics.setColor(hp_color)
	local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
	love.graphics.polygon('line', points)
	love.graphics.setColor(default_color)
end

function Rock:die()
	self.dead = true

	self.area:addGameObject(
		'Ammo',
		self.x,
		self.y,
		{ amount = 5 }
	)
	self.area:addGameObject(
		'RockDeathEffect',
		self.x,
		self.y,
		{ s = self.s, color = hp_color }
	)
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject(
			'ExplodeParticle',
			self.x,
			self.y
		)
	end
end