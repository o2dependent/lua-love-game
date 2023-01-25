Double = Attack:extend()

Double.abbreviation = '2'
Double.color = ammo_color

function Double:new(player)
	Double.super.new(self, player)

	self.cooldown = 0.32
	self.ammo_cost = 2
	self.color = ammo_color
end

function Double:shoot()
	local d = 1.2*self.player.w

	self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r + math.pi/12),
			self.player.y + 1.5*d*math.sin(self.player.r + math.pi/12),
			{
				r = self.player.r + math.pi/12,
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
		self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r - math.pi/12),
			self.player.y + 1.5*d*math.sin(self.player.r - math.pi/12),
			{
				r = self.player.r - math.pi/12,
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
end
