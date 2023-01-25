Neutral = Attack:extend()

Neutral.abbreviation = 'N'
Neutral.color = default_color

function Neutral:new(player)
	Neutral.super.new(self, player)

	self.cooldown = 0.24
	self.ammo_cost = 0
	self.color = default_color
end

function Neutral:shoot()
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
end
