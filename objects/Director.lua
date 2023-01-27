Director = Object:extend()

function Director:new(stage)
	self.stage = stage

	self.difficulty = 1
	self.round_duration = 22
	self.round_timer = 0

	self.difficulty_to_points = {}
	self.difficulty_to_points[1] = 16
	for i = 2, 1024, 4 do
		self.difficulty_to_points[i] = self.difficulty_to_points[i-1] + 8
		self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
		self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1]/1.5)
		self.difficulty_to_points[i+3] = math.floor(self.difficulty_to_points[i+2]*2)
	end

	self.enemy_to_points = {
		['Rock'] = 1,
		['Shooter'] = 2,
	}

	self.enemy_spawn_chances = {
		[1] = chanceList({'Rock', 1}),
		[2] = chanceList({'Rock', 8}, {'Shooter', 4}),
		[3] = chanceList({'Rock', 8}, {'Shooter', 8}),
		[4] = chanceList({'Rock', 4}, {'Shooter', 8})
	}
	for i = 5, 1024 do
		self.enemy_spawn_chances[i] = chanceList(
			{'Rock', love.math.random(2, 12)},
			{'Shooter', love.math.random(2, 12)}
		)
	end

	self.consumable_duration = 16
	self.consumable_timer = 0
	self.available_consumables = chanceList({'Boost', 28}, {'Health', 14}, {'SkillPoint', 58})

	self.attack_duration = 30
	self.attack_timer = 0
	self.available_attacks = chanceList({'Triple', 30}, {'Spread', 20}, {'Side', 20}, {'Rapid', 20}, {'Double', 20}, {'Back', 10})

	self:setEnemySpawnsForThisRound()
end

function Director:update(dt)
	self.round_timer = self.round_timer + dt
	if self.round_timer > self.round_duration then
		self.round_timer = 0
		self.difficulty = self.difficulty + 1
		self:setEnemySpawnsForThisRound()
	end

	self.consumable_timer = self.consumable_timer + dt
	if self.consumable_timer > self.consumable_duration then
		self.consumable_timer = 0
		self.stage.area:addGameObject(
			self.available_consumables:next(),
			random(0, gw),
			random(0, gh)
		)
	end

	self.attack_timer = self.attack_timer + dt
	if self.attack_timer > self.attack_duration then
		self.attack_timer = 0
		self.stage.area:addGameObject(
			'AttackItem',
			random(0, gw),
			random(0, gh),
			{
				attack = self.available_attacks:next()
			}
		)
	end
end

function Director:setEnemySpawnsForThisRound()
	local points = self.difficulty_to_points[self.difficulty]

	-- find enemies
	local enemy_list = {}
	while points > 0 do
		local enemy = self.enemy_spawn_chances[self.difficulty]:next()
		points = points - self.enemy_to_points[enemy]
		table.insert(enemy_list, enemy)
	end

	local enemy_spawn_times = {}
	for i = 1, #enemy_list do
		enemy_spawn_times[i] = random(0, self.round_duration)
	end
	table.sort(enemy_spawn_times, function(a, b) return a < b end)
	for i = 1, #enemy_spawn_times do
		timer:after(enemy_spawn_times[i], function()
			print('spawned ' .. enemy_list[i])
			self.stage.area:addGameObject(enemy_list[i])
		end)
	end
end