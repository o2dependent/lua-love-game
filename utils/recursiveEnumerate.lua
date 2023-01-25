-- This function recursively enumerates all files in a folder and its subfolders.
-- It returns a list of file paths.
function RecursiveEnumerate(folder, file_list)
	-- Get a list of items in the folder.
	local items = love.filesystem.getDirectoryItems(folder)

	-- Loop through each item in the folder.
	for _, item in ipairs(items) do
			-- Build the file path
			local file = folder .. '/' .. item

			-- If the item is a file, add it to the list.
			if love.filesystem.getInfo(file, "file") then
					table.insert(file_list, file)

			-- If the item is a folder, enumerate it recursively.
			elseif love.filesystem.getInfo(file, "directory") then
					RecursiveEnumerate(file, file_list)
			end
	end
end

return RecursiveEnumerate