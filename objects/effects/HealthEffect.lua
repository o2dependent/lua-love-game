HealthEffect = GameObject:extend()

function HealthEffect:new(area, x, y, opts)
	HealthEffect.super.new(self, area, x, y, opts)

	-- colors
	self.color = {hp_color[1], hp_color[2], hp_color[3]}
	self.timer:tween(
		.2,
		self.color,
		{default_color[1], default_color[2], default_color[3]},
		'linear',
		function()
			self.timer:every(
				0.05,
				function()
					self.color = self.color == hp_color and default_color or hp_color
				end
			)
		end
	)

	-- effect visual properties
	self.visible = true -- is visible
	self.color = opts.color or default_color -- color
	self.current_color = default_color -- current color to display
	self.timer:after(0.2, function()
		-- set current color to the effect color
		self.current_color = self.color
		-- kill the effect after
		self.timer:after(0.35, function()
			self.dead = true
			self.visible = true
		end)
		-- flash the effect
		self.timer:every(0.05, function()
			self.visible = not self.visible
		end)
	end)
	self.sx, self.sy = 1, 1 -- scale
	self.timer:tween(0.35, self, {sx = 2, sy = 2}, 'in-out-cubic')


	self.line_width = 1
end

function HealthEffect:draw()
	-- don't draw if not visible
	if not self.visible then return end

	-- draw particle
	-- set origin to center
	love.graphics.translate(self.x, self.y)
	love.graphics.translate(-self.x, -self.y)
	love.graphics.setLineWidth(self.line_width)
	love.graphics.setColor(default_color)
	draft:circle(
		self.x,
		self.y,
		self.w*self.sx,
		self.h*self.sy,
		'line'
	)
	love.graphics.setColor(self.color)
	draft:rectangle(
		self.x,
		self.y,
		self.w*math.max(1,self.sx*0.6),
		self.h*0.25*math.max(1,self.sy*0.525),
		'fill'
	)
	draft:rectangle(
		self.x,
		self.y,
		self.w*0.25*math.max(1,self.sx*0.525),
		self.h*math.max(1,self.sy*0.6),
		'fill'
	)
	-- reset graphics
	love.graphics.setColor(default_color)
	love.graphics.setLineWidth(1)
end
