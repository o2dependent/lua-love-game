Physics = require "libs/windfield/init"
Object = require "libs/rxi/classic"
Input = require "libs/boipushy/Input"
Timer = require "libs/chrono/Timer"
Camera = require "libs/a327ex/Camera"
UUID = require "utils/UUID"
RequireAllFromFolder = require "utils/RequireAllFromFolder"
require "utils/pushRotate"
require "utils/pushRotateScale"

function resize(s)
	love.window.setMode(s*gw, s*gh)
	sx, sy = s, s
end

local objects = {}
input = nil

rooms = {}

function love.load()
	-- apply astectic settings
	resize(3)
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- seed random
	math.randomseed(os.time())

	-- require all object
	RequireAllFromFolder("objects", objects)


	-- create input listener and timer
	input = Input()
	timer = Timer()

	-- DEBUG -- bind f1 to print garbage
	input:bind('f1', function()
		print("Before collection: " .. collectgarbage("count")/1024)
		collectgarbage()
		print("After collection: " .. collectgarbage("count")/1024)
		print("Object count: ")
		local counts = type_count()
		for k, v in pairs(counts) do print(k, v) end
		print("-------------------------------------")
	end)

	-- setup input bindings
	input:bind('left', 'left')
	input:bind('right', 'right')

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

function gotoRoom(room_type, ...)
	if current_room and current_room.destroy then current_room:destroy() end
	current_room = _G[room_type](...)
end

function count_all(f)
	local seen = {}
	local count_table
	count_table = function(t)
			if seen[t] then return end
					f(t)
		seen[t] = true
		for k,v in pairs(t) do
				if type(v) == "table" then
			count_table(v)
				elseif type(v) == "userdata" then
			f(v)
				end
end
	end
	count_table(_G)
end

function type_count()
	local counts = {}
	local enumerate = function (o)
			local t = type_name(o)
			counts[t] = (counts[t] or 0) + 1
	end
	count_all(enumerate)
	return counts
end

global_type_table = nil
function type_name(o)
	if global_type_table == nil then
			global_type_table = {}
					for k,v in pairs(_G) do
				global_type_table[v] = k
		end
global_type_table[0] = "table"
	end
	return global_type_table[getmetatable(o) or 0] or "Unknown"
end