Object = require "libs/rxi/classic"
Input = require "libs/boipushy/Input"
Timer = require "libs/chrono/Timer"

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
			local file = folder .. '/' .. item
			if love.filesystem.getInfo(file, "file") then
					table.insert(file_list, file)
			elseif love.filesystem.getInfo(file, "directory") then
					recursiveEnumerate(file, file_list)
			end
	end
end

function requireFiles(files)
	for _, file in ipairs(files) do
			local file = file:sub(1, -5)
			require(file)
	end
end

local objects = {}

hp = 100
full_hp_width = 500

function animate_hp(new_hp)
	if hp_time_handler1 then timer:cancel(hp_time_handler1) end
	if hp_time_handler2 then timer:cancel(hp_time_handler2) end

	new_hp_width = new_hp / 100 * full_hp_width

	hp_time_handler1 = timer:tween(0.5, hp_rect_1, {w = new_hp_width}, "in-out-cubic")
	hp_time_handler2 = timer:tween(1, hp_rect_2, {w = new_hp_width}, "in-out-cubic")
end

function love.load()
	input = Input()
	timer = Timer()

	input:bind('d', function()
		if hp > 0 then
			hp = hp - 10
		else
			hp = 100
		end
		animate_hp(hp)
	end)

	hp_rect_1 = {x = 400, y = 300, w = full_hp_width, h = 50}
	hp_rect_2 = {x = 400, y = 300, w = full_hp_width, h = 50}
end

function love.update(dt)
	timer:update(dt)
end

function love.draw()
	love.graphics.setColor(255, 0, 0, 1)
	love.graphics.rectangle('fill', hp_rect_1.x - full_hp_width/2, hp_rect_1.y - hp_rect_1.h/2, hp_rect_1.w, hp_rect_1.h)
	love.graphics.setColor(255, 0, 0, 0.5)
	love.graphics.rectangle('fill', hp_rect_2.x - full_hp_width/2, hp_rect_2.y - hp_rect_2.h/2, hp_rect_2.w, hp_rect_2.h)
end
