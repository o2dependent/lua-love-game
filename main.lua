Object = require "libs/rxi/classic"

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

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
	local circle = Circle(400, 300, 50)
	table.insert(objects, circle)
end

function love.update(dt)
end

function love.draw()
	for _, object in ipairs(objects) do
		if object.draw then
			object:draw()
		end
	end
end

