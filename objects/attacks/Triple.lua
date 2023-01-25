Triple = Attack:extend()

Triple.abbreviation = '3'
Triple.color = skill_point_color

function Triple:new(player)
	Triple.super.new(self, player)

	self.cooldown = 0.48
	self.ammo_cost = 3
	self.color = skill_point_color
end

function Triple:shoot()
	local d = 1.2*self.player.w

	for i = 1, 3 do
		self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r + math.pi/12*(i-2)),
			self.player.y + 1.5*d*math.sin(self.player.r + math.pi/12*(i-2)),
			{
				r = self.player.r + math.pi/12*(i-2),
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
	end
end
