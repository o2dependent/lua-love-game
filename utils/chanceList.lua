function chanceList(...)
	return {
		chance_list = {},
		chance_definitions = {...},
		next = function(self)
			if #self.chance_list == 0 then
				for _, definition in ipairs(self.chance_definitions) do
					for i = 1, definition[2] do
						table.insert(self.chance_list, definition[1])
					end
				end
			end
			return table.remove(self.chance_list, love.math.random(1, #self.chance_list))
		end
	}
end
