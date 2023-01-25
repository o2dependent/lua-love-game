function createIrregularPolygon(size, point_amount)
	local point_amount = point_amount or 8
	local points = {}
	for i = 1, point_amount do
			local angle_interval = 2*math.pi/point_amount
			local distance = size + random(-size/4, size/4)
			local angle = (i-1)*angle_interval + random(-angle_interval/4, angle_interval/4)
			table.insert(points, distance*math.cos(angle))
			table.insert(points, distance*math.sin(angle))
	end
	return points
end