Homing = Attack:extend()

Homing.abbreviation = 'H'
Homing.color = skill_point_color

function Homing:new(player)
	Homing.super.new(self, player)

	self.cooldown = 0.32
	self.homing_strength = 0.1
	self.ammo_cost = 1
	self.color = ammo_color
	self.damage = 100
end

function Homing:shoot()
	local d = 1.2*self.player.w

	self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r),
			self.player.y + 1.5*d*math.sin(self.player.r),
			{
				r = self.player.r,
				s = 2.5,
				v = 250,
				color = self.color,
				homing = true,
				damage = self.damage,
				homing_strength = self.homing_strength
			}
		)
end
