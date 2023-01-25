Rapid = Attack:extend()

Rapid.abbreviation = 'R'
Rapid.color = boost_color

function Rapid:new(player)
	Rapid.super.new(self, player)

	self.cooldown = 0.12
	self.ammo_cost = 1
	self.color = boost_color
end

function Rapid:shoot()
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
