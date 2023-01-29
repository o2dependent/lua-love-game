InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
	InfoText.super.new(self, area, x, y, opts)

	self.depth = 80

	self.color = opts.color or default_color
	self.text = opts.text or 'InfoText'

	self.visible = true
	self.fade = 1


	self.timer:after(
		0.7,
		function()
			self.visible = false
			-- randomly swap characters
			self.timer:every(
				0.035,
				function ()
					local random_characters =
						'!@#$%¨&*()-=+[]^~/;?><.,|0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
					for i, character in ipairs(self.characters) do
						if math.random(1, 20) == 1 then
							local r = love.math.random(1, #random_characters)
							self.characters[i] = random_characters:utf8sub(r, r)
						else
							self.characters[i] = character
						end
					end
				end,
				#self.text
			)
			-- flash the effect
			self.timer:every(
				0.05,
				function ()
					self.visible = not self.visible
				end,
				6
			)
			-- make sure the effect is visible before death
			self.timer:after(
				0.35,
				function()
					self.visible = true
				end
			)
			-- fade text out
			self.timer:tween(0.35, self, {fade = 0}, 'in-out-cubic')
			-- kill the effect
			self.timer:after(
				1.1,
				function ()
					self.dead = true
				end
			)
		end
	)

	self.characters = {}
	for i = 1, #self.text do
		table.insert(self.characters, self.text:utf8sub(i, i))
	end

	self.font = fonts.m5x7_16

	-- move this text if there is another info text colliding with it
	local colliding_texts = self.area:getGameObjects(function(object)
		if object:is(InfoText) and object ~= self then
			return object.x > self.x - 8 and object.x < self.x + 8 and object.y > self.y - 8 and object.y < self.y + 8
		end
	end)
	if #colliding_texts > 0 then
		self.x = self.x + self.font:getWidth(colliding_texts[1].text)
		self.y = self.y + self.font:getHeight()
	end
end

function InfoText:update(dt)
	InfoText.super.update(self, dt)
end

function InfoText:draw()
	if not self.visible then return end

	love.graphics.setFont(self.font)
	for i = 1, #self.characters do
		local width = 0
		if i > 1 then
			for j = 1, i-1 do
				width = width + self.font:getWidth(self.characters[j])
			end
		end
		local r,g,b = unpack(self.color)
		local a = self.fade
		if a < 1 then
			a = a * random(0.5, 2)
		end
		love.graphics.setColor({r,g,b,a})
		love.graphics.print(
			self.characters[i],
			self.x + width,
			self.y,
			0,
			1,
			1,
			0,
			self.font:getHeight()/2
		)
	end
	love.graphics.setColor(default_color)
end