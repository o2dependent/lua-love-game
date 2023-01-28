InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
	InfoText.super.new(self, area, x, y, opts)

	self.depth = 80

	self.color = opts.color or default_color
	self.text = opts.text or 'InfoText'

	self.visible = true

	self.timer:after(
		0.7,
		function()
			self.visible = false
			-- randomly swap characters
			self.timer:every(
				0.035,
				function ()
					local random_characters = {
						'!@#$%¨&*()-=+[]^~/;?><.,|',
						'0123456789',
						'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
					}
					for i, character in ipairs(self.characters) do
						if math.random(1, 20) == 1 then
							local char_type_index = 1
							for j = 1, #random_characters do
								if random_characters[j] and random_characters[j]:find(character) then
									char_type_index = j
									break
								end
							end
							local r = love.math.random(1, #random_characters[char_type_index])
							self.characters[i] = random_characters[char_type_index]:utf8sub(r, r)
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

		love.graphics.setColor(self.color)
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