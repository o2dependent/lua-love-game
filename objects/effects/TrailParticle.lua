TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
	TrailParticle.super.new(self, area, x, y, opts)
	-- set radius or randomize
	self.r = opts.r or random(4, 6)

	-- set color or set default
	self.color = opts.color or default_color

	-- tween to 0 and kill object when done
	self.timer:tween(opts.d or random(0.3, 0.5), self, {r=0}, 'linear', function() self.dead = true end)
end


function TrailParticle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.r)
end