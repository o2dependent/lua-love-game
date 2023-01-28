-- skill points (TEMP GLOBAL)
skill_points = 0

-- colors
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

-- get percentage between two colors
function tweenColors(color1, color2, percent)
	return {
		color1[1] + (color2[1] - color1[1])*percent,
		color1[2] + (color2[2] - color1[2])*percent,
		color1[3] + (color2[3] - color1[3])*percent
	}
end

default_color = color255To1(default_color)
background_color = color255To1(background_color)
ammo_color = color255To1(ammo_color)
boost_color = color255To1(boost_color)
hp_color = color255To1(hp_color)
skill_point_color = color255To1(skill_point_color)

-- attacks
attacks = {
	['Neutral'] = {
		cooldown = 0.24,
		ammo_cost = 0,
		abbreviation = 'N',
		color = default_color,
	},
	['Double'] = {
		cooldown = 0.32,
		ammo_cost = 2,
		abbreviation = '2',
		color = ammo_color,
	}
}

-- all enemies classes as strings
enemies = {'Rock', 'Shooter'}

-- tree
tree = {}
tree[2] = {'HP', {'6% Increased HP', 'hp_multiplier', 0.06}}
tree[15] = {'Flat HP', {'+10 Max HP', 'flat_hp', 10}}
