Object = require "libs/rxi/classic"
Input = require "libs/boipushy/Input"
Timer = require "libs/chrono/Timer"
UUID = require "utils/UUID"
RequireAllFromFolder = require "utils/RequireAllFromFolder"
Camera = require "libs/a327ex/Camera"

function resize(s)
	love.window.setMode(s*gw, s*gh)
	sx, sy = s, s
end

local objects = {}

rooms = {}

function love.load()
	-- apply astectic settings
	resize(3)
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- seed random
	math.randomseed(os.time())

	-- require all object
	object_files = {}
	RequireAllFromFolder("objects", object_files)


	-- create input listener and timer
	input = Input()
	timer = Timer()

	-- initialize rooms and current room var
	RequireAllFromFolder("rooms", rooms)
	current_room = Stage()

	-- setup camera
	camera = Camera()
end

function love.update(dt)
	-- keep timer up to date
	timer:update(dt)

	-- update camera
	camera:update(dt)
	input:bind('f3', function() camera:shake(4, 1, 60) end)

	-- update room if it exists
	if current_room then current_room:update(dt) end
end

function love.draw()
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

