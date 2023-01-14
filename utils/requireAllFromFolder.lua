local recursiveEnumerate = require "utils/recursiveEnumerate"
local requireFiles = require "utils/recursiveEnumerate"

function requireAllFromFolder(folder, file_list)
	recursiveEnumerate(folder, file_list)
	requireFiles(file_list)
end
