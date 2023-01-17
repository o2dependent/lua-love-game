function pushRotate(x, y, r)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.translate(-x, -y)
end