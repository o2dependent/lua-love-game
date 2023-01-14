RecursiveEnumerate = require "utils/RecursiveEnumerate"
RequireFiles = require "utils/RequireFiles"

function RequireAllFromFolder(folder, file_list)
	RecursiveEnumerate(folder, file_list)
	RequireFiles(file_list)
end

return RequireAllFromFolder