ShopItem = GameObject:extend()

function ShopItem:new(area, x, y, opts)
	print(x, y, x == gw/2, y == gh/2)
	ShopItem.super.new(self, area, x, y, opts)

	-- amount of ShopItem to add
	self.amount = opts.amount or 5

	-- position
	self.x, self.y = x, y
	print(x, y, x == gw/2, y == gh/2)

	self.w, self.h = 24, 24
	self.collider = self.area.world:newRectangleCollider(
		self.x - self.w/2,
		self.y - self.h/2,
		self.w,
		self.h
	)
	self.collider:setObject(self)
	self.collider:setCollisionClass('Consumables')
end

function ShopItem:update(dt)
	ShopItem.super.update(self, dt)
end

function ShopItem:draw()
	love.graphics.setColor(skill_point_color)
	draft:circle(
		self.x,
		self.y,
		self.w*1.5,
		self.h*1.5,
		'line'
	)
	draft:circle(
		self.x,
		self.y,
		self.w*0.5,
		self.h*0.5,
		'fill'
	)
	love.graphics.setColor(default_color)
end

function ShopItem:die()
	current_room.player:addItem(self.item)
	-- self.dead = true
end