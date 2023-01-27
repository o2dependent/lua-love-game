Shooter = GameObject:extend()

function Shooter:new(area, x, y, opts)
	Shooter.super.new(self, area, x,   y, opts)

	self.hp = 100
	self.attack_damage = 10
	self.collide_damage = 10

		-- position
	local direction = table.random({-1, 1})
	self.x = gw/2 + direction*(gw/2 + 48)
	self.y = random(48, gh - 48)
	self.r = random(0, 2*math.pi)
	self.v = -direction*random(20, 40)
	self.w, self.h = 12, 6

	-- create a new polygon collider
	self.collider = self.area.world:newPolygonCollider({
		self.w, 0,
		-self.w/2, self.h,
		-self.w, 0,
		-self.w/2, -self.h
	})
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
	-- set angle of the collider
	self.collider:setAngle(direction == -1 and 0 or math.pi)
	-- allow collider to rotate
	self.collider:setFixedRotation(true)

	-- set shooting loop
	self:attackLoop()
end

function Shooter:attackLoop()
	self.timer:after(
		random(3, 5),
		function()
			self.area:addGameObject(
				'ShooterPreAttackEffect',
				self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
				self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
				{
					duration = 1,
					color = hp_color,
					parent = self
				}
			)
			self.timer:after(
				1,
				function()
					self.area:addGameObject(
						'EnemyProjectile',
						self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
						self.y + 1.4*self.h*math.sin(self.collider:getAngle()),
						{
							-- set angle towards the player
							-- this is done with the following formula:
							-- angle = math.atan2(target.y - source.y, target.x - source.x)
							-- where target is the player and source is the projectile
							r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x),
							v = random(80, 100),
							s = 3.5,
							color = hp_color,
						}
					)
					if not self.dead then
						self:attackLoop()
					end
				end
			)
		end
	)
end

function Shooter:update(dt)
	Shooter.super.update(self, dt)

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
		local damage = object.damage
		if not damage then
			damage = 100
		end
		self:hit(damage)
	end
end

function Shooter:draw()
	love.graphics.setColor(hp_color)
	local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
	love.graphics.polygon('line', points)
	love.graphics.setColor(default_color)
end

function Shooter:hit(damage)
	self.hp = self.hp - damage
	if self.hp <= 0 then
		self:die()
	end
end

function Shooter:die()
	self.dead = true

	self.area:addGameObject(
		'Ammo',
		self.x,
		self.y,
		{ amount = 5 }
	)

	self.area:addGameObject(
		'ShooterDeathEffect',
		self.x,
		self.y,
		{ w = self.w, h = self.h, color = hp_color }
	)
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject(
			'ExplodeParticle',
			self.x,
			self.y
		)
	end
end

function Shooter:takeDamage(damage)
	self.hp = self.hp - damage
	if self.hp <= 0 then
		self:die()
	end
end