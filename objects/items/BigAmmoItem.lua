BigAmmoItem = PlayerItem:extend()

BigAmmoItem.name = 'Big Ammo'
BigAmmoItem.abbreviation = 'BA'
BigAmmoItem.color = default_color
BigAmmoItem.description = 'Increases ammo capacity by 50.'

function BigAmmoItem:new(area, player)
	BigAmmoItem.super.new(self, area, player)

	self.flat_ammo = 50

	self.font = fonts.m5x7_16
end

function BigAmmoItem:draw()
	-- draw item name at bottom right
	love.graphics.setColor(self.color)
	love.graphics.setFont(self.font)
	love.graphics.print(self.name, gw - self.font:getWidth(self.name) - 32, gh - self.font:getHeight() - 32)
	love.graphics.setColor(default_color)
end
