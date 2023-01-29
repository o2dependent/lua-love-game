PlayerItem = Object:extend()

PlayerItem.name = 'Item'
PlayerItem.abbreviation = 'I'
PlayerItem.color = default_color
PlayerItem.description = 'This is an item.'

function PlayerItem:new(area, player)
	self.area = area
	self.player = player
	self.timer = Timer()

	self.aspd_multiplier = nil
	self.boost_multiplier = nil
	self.ammo_multiplier = nil
	self.hp_multiplier = nil
	self.boost_cooldown_multiplier = nil

	self.flat_boost_cooldown = nil
	self.flat_boost = nil
	self.flat_hp = nil
	self.flat_ammo = nil
	self.flat_ammo_gain = nil
end

function PlayerItem:updateStats()
	for k, v in pairs(self) do
		if k:find('_multiplier') and type(v) == 'number' then
			self.player[k] = self.player[k] + v
		elseif k:find('flat_') and type(v) == 'number' then
			self.player[k] = self.player[k] + v
		end
	end
end

function PlayerItem:update(dt)
	if self.timer then self.timer:update(dt) end
end

function PlayerItem:draw()

end

function PlayerItem:destroy()
	self.timer:destroy()
end