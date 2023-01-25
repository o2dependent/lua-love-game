Back = Attack:extend()

Back.abbreviation = 'B'
Back.color = default_color

function Back:new(player)
	Back.super.new(self, player)

	self.cooldown = 0.32
	self.ammo_cost = 2
	self.color = default_color
end

function Back:shoot()
	local d = 1.2*self.player.w

	self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r),
			self.player.y + 1.5*d*math.sin(self.player.r),
			{
				r = self.player.r,
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
	self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r + math.pi),
			self.player.y + 1.5*d*math.sin(self.player.r + math.pi),
			{
				r = self.player.r + math.pi,
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
end
