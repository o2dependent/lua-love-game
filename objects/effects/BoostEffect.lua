BoostEffect = GameObject:extend()

function BoostEffect:new(area, x, y, opts)
	BoostEffect.super.new(self, area, x, y, opts)

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

function BoostEffect:draw()
	-- don't draw if not visible
	if not self.visible then return end

	-- draw particle
	love.graphics.setLineWidth(self.line_width)
	love.graphics.setColor(self.color)
	draft:rhombus(
		self.x,
		self.y,
		self.w*self.sx*2,
		self.h*self.sy*2,
		'line'
	)
	draft:rhombus(
		self.x,
		self.y,
		self.w*1.35,
		self.h*1.35,
		'fill'
	)
	-- reset graphics
	love.graphics.setColor(default_color)
	love.graphics.setLineWidth(1)
end
