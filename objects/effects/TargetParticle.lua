TargetParticle = GameObject:extend()

function TargetParticle:new(area, x, y, opts)
	TargetParticle.super.new(self, area, x, y, opts)

	-- location of target
	self.target_x = opts.target_x
	self.target_y = opts.target_y
	-- find rotation to target
	self.r = math.atan2(self.target_y - self.y, self.target_x - self.x)
	-- draw over others
	self.depth = 80
	self.timer:after(0.13, function () self.dead = true end)
end

function TargetParticle:draw()
	love.graphics.setColor(self.color)
	draft:rhombus(self.x, self.y, 2*self.r, 2*self.r, 'fill')
	love.graphics.setColor(default_color)
end