Tadpole = Object:extend()

function Tadpole:new(area, player)
	self.area = area
	self.player = player

	self.polygons = {}
	self.polygons[1] = {
			self.player.w, 0, -- 1
			self.player.w/2, -self.player.w/2, -- 2
			-self.player.w*2/10, -self.player.w*2/10, -- 3
			-self.player.w , 0, -- 4
			-self.player.w*2/10, self.player.w*2/10, -- 5
			self.player.w/2, self.player.w/2, -- 6
	}
end

function Tadpole:trail()
	self.area:addGameObject(
		'TrailParticle',
		-- x position
		self.player.x - 0.9*self.player.w*math.cos(self.player.r),
		-- y position
		self.player.y - 0.9*self.player.w*math.sin(self.player.r),
		-- opts
		{
			r = random(2, 4), -- radius
			d = random(0.2, 0.35), -- duration
			color = self.player.trail_color -- color
		}
	)
end

function Tadpole:draw()
	pushRotate(self.player.x, self.player.y, self.player.r)
	love.graphics.setColor(default_color)
	for _, polygon in ipairs(self.polygons) do
			local points = M.map(polygon, function(v, k)
				if k % 2 == 1 then
						return self.player.x + v + random(-1, 1)
				else
						return self.player.y + v + random(-1, 1)
				end
			end)

			love.graphics.polygon('line', points)
	end
	love.graphics.pop()
end