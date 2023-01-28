Attack = Object:extend()

Attack.abbreviation = 'N'
Attack.color = default_color

function Attack:new(player)
	self.player = player
	self.cooldown = 0.24
	self.ammo_cost = 0
	self.color = default_color
end

function Attack:update(dt)

end

function Attack:shoot()

end



