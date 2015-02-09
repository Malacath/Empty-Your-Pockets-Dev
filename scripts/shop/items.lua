local Upgrades =
{
	{
		{
			name = STRINGS.NAMES.BOMB_RETRIBUTION,
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
			name = STRINGS.NAMES.BOMB_RETRIBUTION,
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
			name = STRINGS.NAMES.BOMB_SUICIDE,
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
			name = STRINGS.NAMES.ANTI_GRUE,
			desc = STRINGS.UPGRADES.TEASER.ANTI_GRUE,
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
			name = STRINGS.NAMES.CHESTER_BE_SAFE,
			desc = STRINGS.UPGRADES.TEASER.CHESTER_BE_SAFE,
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
			name = STRINGS.NAMES.LIFE_VACUUM,
			desc = STRINGS.UPGRADES.TEASER.LIFE_VACUUM,
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
			name = STRINGS.NAMES.HAT_MOURNING,
			desc = STRINGS.UPGRADES.TEASER.HAT_MOURNING,
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
			name = STRINGS.NAMES.POCKET_JUMPER,
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
			name = STRINGS.NAMES.MINDSHAKER,
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