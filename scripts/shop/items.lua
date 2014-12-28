local Upgrades =
{
	{
		{
			name = STRINGS.UPGRADES.NAMES.BOMB.ONE,
			desc = STRINGS.UPGRADES.TEASER.BOMB.ONE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					--local item = SpawnPrefab("bomb_retribution")
					local item = SpawnPrefab("bomb_escape")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.BOMB.TWO,
			desc = STRINGS.UPGRADES.TEASER.BOMB.TWO,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("bomb_retribution")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			nolevels = true,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.BOMB.THREE,
			desc = STRINGS.UPGRADES.TEASER.BOMB.THREE,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("bomb_suicide")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			nolevels = true,
			image = "bomb_suicide"
		},
	},

	{
		{
			name = STRINGS.UPGRADES.NAMES.GRUE,
			desc = STRINGS.UPGRADES.TEASER.GRUE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("anti_grue")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			image = "anti_grue"
		},
		{
			name = STRINGS.UPGRADES.NAMES.CHESTER,
			desc = STRINGS.UPGRADES.TEASER.CHESTER,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("chester_be_safe")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			nolevels = true,
			image = "chester_be_safe"
		},
		{
			name = STRINGS.UPGRADES.NAMES.VACUUM,
			desc = STRINGS.UPGRADES.TEASER.VACUUM,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("life_vacuum")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			nolevels = true,
			image = "bomb_suicide"
		},
	},
	{
		{
			name = STRINGS.UPGRADES.NAMES.MOUNRNING_HELMET,
			desc = STRINGS.UPGRADES.TEASER.MOUNRNING_HELMET,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("hat_mourning")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.POCKET_JUMPER,
			desc = STRINGS.UPGRADES.TEASER.POCKET_JUMPER,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("pocket_jumper")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			nolevels = true,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.MINDSHAKER,
			desc = STRINGS.UPGRADES.TEASER.MINDSHAKER,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.inventory then
					local item = SpawnPrefab("mindshaker")
					inst.components.inventory:Give(item, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
				end
			end,
			multi = true,
			nolevels = true,
			image = "mindshaker"
		},
	},
}

return Upgrades