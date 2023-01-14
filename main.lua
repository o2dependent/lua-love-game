Object = require "libs/rxi/classic"
Input = require "libs/boipushy/Input"
Timer = require "libs/chrono/Timer"
RequireAllFromFolder = require "utils/RequireAllFromFolder"


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
	-- require all object
	object_files = {}
	RequireAllFromFolder("objects", object_files)

	-- create input listener and timer
	input = Input()
	timer = Timer()

	-- initialize rooms and current room var
	rooms = {CircleRoom = CircleRoom(), RectangleRoom = RectangleRoom(), PolygonRoom = PolygonRoom()}
	current_room = rooms["CircleRoom"]

	input:bind('1', function() gotoRoom(CircleRoom, 'CircleRoom') end)
	input:bind('2', function() gotoRoom(RectangleRoom, 'RectangleRoom') end)
	input:bind('3', function() gotoRoom(PolygonRoom, 'PolygonRoom') end)

	-- health bar init functions
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
	-- keep timer up to date
	timer:update(dt)

	-- update room if it exists
	if current_room then current_room:update(dt) end
end

function love.draw()
	-- draw health bar
	-- love.graphics.setColor(255, 0, 0, 1)
	-- love.graphics.rectangle('fill', hp_rect_1.x - full_hp_width/2, hp_rect_1.y - hp_rect_1.h/2, hp_rect_1.w, hp_rect_1.h)
	-- love.graphics.setColor(255, 0, 0, 0.5)
	-- love.graphics.rectangle('fill', hp_rect_2.x - full_hp_width/2, hp_rect_2.y - hp_rect_2.h/2, hp_rect_2.w, hp_rect_2.h)

	-- draw room if it exists
	if current_room then current_room:draw() end
end

function addRoom(room_type, room_name, ...)
	local room = _G[room_type](room_name, ...)
	rooms[room_name] = room
	return room
end

function gotoRoom(room_type, room_name, ...)
	if current_room and rooms[room_name] then
		if current_room.deactivate then current_room:deactivate() end
		current_room = rooms[room_name]
		if current_room.activate then current_room:activate() end
	else
		current_room = addRoom(room_type, room_name, ...)
	end
end

