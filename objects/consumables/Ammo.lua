Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
	Ammo.super.new(self, area, x, y, opts)

	-- amount of ammo to add
	self.amount = opts.amount or 5

	-- position
	self.w, self.h = 8, 8
	self.collider = self.area.world:newRectangleCollider(
		self.x,
		self.y,
		self.w,
		self.h
	)
	self.collider:setObject(self)
	self.collider:setFixedRotation(false)
	self.r = random(0, 2*math.pi)
	self.v = random(10, 20)
	self.collider:setLinearVelocity(
		self.v*math.cos(self.r),
		self.v*math.sin(self.r)
	)
	self.collider:applyAngularImpulse(random(-12, 12))
	self.collider:setCollisionClass('Consumables')
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)

	-- seek player
	local target = current_room.player
    if target then
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
    else self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) end
end

function Ammo:draw()
	love.graphics.setColor(ammo_color)
	pushRotate(
		self.x,
		self.y,
		self.collider:getAngle()
	)
	draft:rhombus(
		self.x,
		self.y,
		self.w,
		self.h,
		'line'
	)
	love.graphics.pop()
	love.graphics.setColor(default_color)
end

function Ammo:die()
	current_room.player:addAmmo(self.amount)
	current_room.player:onAmmoPickup()
	self.dead = true
	self.area:addGameObject(
		'AmmoEffect',
		self.x,
		self.y,
		{
			color = ammo_color,
			w = self.w,
			h = self.h
		}
	)
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject(
			'ExplodeParticle',
			self.x,
			self.y,
			{
				s = 3,
				color = ammo_color,
			}
		)
	end
end