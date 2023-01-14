function RequireFiles(files)
	for _, file in ipairs(files) do
			local file = file:sub(1, -5)
			require(file)
	end
end

return RequireFiles