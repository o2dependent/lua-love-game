TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
	TrailParticle.super.new(self, area, x, y, opts)
	-- set radius or randomize
	self.r = opts.r or random(4, 6)

	-- set color or set default
	-- get color values without reference
	local r, g, b = unpack(default_color)
	if opts.color then
		r, g, b = unpack(opts.color)
	end
	self.color = {r, g, b}

	-- tween to 0 and kill object when done
	local darkened_color = {r - (175/255), g - (175/255), b - (175/255)}
	self.timer:tween(opts.d or random(0.3, 0.5), self, {r=0, color=darkened_color}, 'linear', function() self.dead = true end)
end


function TrailParticle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.r)
end