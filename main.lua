Physics = require "libs/windfield/init"
Object = require "libs/rxi/classic"
Input = require "libs/boipushy/Input"
Timer = require "libs/enhanced_timer/EnhancedTimer"
Camera = require "libs/a327ex/Camera"
UTF8 = require "libs/utf8/utf8"
Vector = require "libs/hump/vector"
Draft = require "libs/draft/draft"
UUID = require "utils/UUID"
RequireAllFromFolder = require "utils/RequireAllFromFolder"
M = require "libs.Moses.moses"
require("globals")
require("GameObject")

draft = Draft()

function resize(s)
	love.window.setMode(s*gw, s*gh)
	sx, sy = s, s
end

local objects = {}
fonts = {}
input = nil
slow_amount = 1

rooms = {}

function love.load()
	-- apply astectic settings
	resize(3)
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- seed random
	math.randomseed(os.time())

	-- require all object
	RequireAllFromFolder("objects", objects)

	-- load fonts
	fonts['m5x7_16'] = love.graphics.newFont("resourses/fonts/m5x7.ttf", 16)

	slow_amount = 1

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
	input:bind('up', 'up')
	input:bind('down', 'down')
	input:bind('space', 'space')

	local utils = {}
	RequireAllFromFolder("utils", utils)

	-- initialize rooms and current room var
	RequireAllFromFolder("rooms", rooms)
	current_room = Stage()

	-- setup camera
	camera = Camera()
end

function love.update(dt)
	-- keep timer up to date
	timer:update(dt * slow_amount)

	-- update camera
	camera:update(dt * slow_amount)
	input:bind('f3', function() camera:shake(4, 1, 60) end)

	-- update room if it exists
	if current_room then current_room:update(dt * slow_amount) end
end

function love.draw()
	-- draw room if it exists
	if current_room then current_room:draw() end


	if flash_frames then
		flash_frames = flash_frames - 1
		if flash_frames == -1 then flash_frames = nil end
	end
	if flash_frames then
		love.graphics.setColor(background_color)
		love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
		love.graphics.setColor(default_color)
	end

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


---- effects
-- slow down time
function slow(amount, duration)
	slow_amount = amount
	timer:tween('slow', duration, _G, {slow_amount = 1}, 'in-out-cubic')
end

-- flash background
flash_frames = nil
function flash(frames)
	flash_frames = frames
end


