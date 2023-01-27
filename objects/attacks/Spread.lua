Spread = Attack:extend()

Spread.abbreviation = 'Sp'
Spread.color = skill_point_color

function Spread:new(player)
	Spread.super.new(self, player)

	self.cooldown = 0.12
	self.ammo_cost = 1
	self.color = skill_point_color
end

function Spread:shoot()
	local d = 1.2*self.player.w
	local angle = random(-math.pi/12, math.pi/12)

	self.player.area:addGameObject(
			'Projectile',
			self.player.x + 1.5*d*math.cos(self.player.r + angle),
			self.player.y + 1.5*d*math.sin(self.player.r + angle),
			{
				r = self.player.r + angle,
				s = 2.5,
				v = 200,
				color = self.color
			}
		)
end
