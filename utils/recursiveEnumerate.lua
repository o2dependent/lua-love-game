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