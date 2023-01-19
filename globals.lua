default_color = {222, 222, 222}
background_color = {16, 16, 16}
ammo_color = {123, 200, 164}
boost_color = {76, 195, 217}
hp_color = {241, 103, 69}
skill_point_color = {255, 198, 93}

-- convert 255 color to 1 color
function color255To1(color)
	return {color[1]/255, color[2]/255, color[3]/255}
end

default_color = color255To1(default_color)
background_color = color255To1(background_color)
ammo_color = color255To1(ammo_color)
boost_color = color255To1(boost_color)
hp_color = color255To1(hp_color)
skill_point_color = color255To1(skill_point_color)
