ShieldsItem = PlayerItem:extend()

ShieldsItem.name = 'Shields'
ShieldsItem.abbreviation = 'S'
ShieldsItem.color = hp_color
ShieldsItem.description = 'Add 10% to max HP.'

function ShieldsItem:new(area, player)
	ShieldsItem.super.new(self, area, player)

	self.level = 1

	self.area:getGameObjects(function (obj)
		if obj:is(ShieldsItem) then
			self.level = obj.level + 1
			obj:destroy()
		end
	end)


	self.hp_multiplier = 0.1 * self.level

	self.font = fonts.m5x7_16
end

function ShieldsItem:draw()
	self.player.ship:draw()
end
