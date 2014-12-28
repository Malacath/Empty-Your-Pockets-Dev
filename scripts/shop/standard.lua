local Upgrades =
{
	{
		{
			name = STRINGS.UPGRADES.NAMES.SPEED.ONE,
			desc = STRINGS.UPGRADES.TEASER.SPEED.ONE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * TUNING.UPGRADES.SPEED_MULT.ONE
				inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * TUNING.UPGRADES.SPEED_MULT.ONE
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.SPEED.TWO,
			desc = STRINGS.UPGRADES.TEASER.SPEED.TWO,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * TUNING.UPGRADES.SPEED_MULT.TWO
				inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * TUNING.UPGRADES.SPEED_MULT.TWO
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.SPEED.THREE,
			desc = STRINGS.UPGRADES.TEASER.SPEED.THREE,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * TUNING.UPGRADES.SPEED_MULT.THREE
				inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * TUNING.UPGRADES.SPEED_MULT.THREE
			end,
			image = "bomb_suicide"
		},
	},
	{
		{
			name = STRINGS.UPGRADES.NAMES.HEALTH.ONE,
			desc = STRINGS.UPGRADES.TEASER.HEALTH.ONE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				inst.components.health:SetMaxHealth(inst.components.health.maxhealth * TUNING.UPGRADES.HEALTH_MULT.ONE)
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.HEALTH.TWO,
			desc = STRINGS.UPGRADES.TEASER.HEALTH.TWO,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				inst.components.health:SetMaxHealth(inst.components.health.maxhealth * TUNING.UPGRADES.HEALTH_MULT.TWO)
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.HEALTH.THREE,
			desc = STRINGS.UPGRADES.TEASER.HEALTH.THREE,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				inst.components.health:SetMaxHealth(inst.components.health.maxhealth * TUNING.UPGRADES.HEALTH_MULT.THREE)
			end,
			image = "bomb_suicide"
		},
	},
	{
		{
			name = STRINGS.UPGRADES.NAMES.DAMAGE.ONE,
			desc = STRINGS.UPGRADES.TEASER.DAMAGE.ONE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				if inst.components.combat.damagemultiplier then
					inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier * TUNING.UPGRADES.DAMAGE_MULT.ONE
				else
					inst.components.combat.damagemultiplier = TUNING.UPGRADES.DAMAGE_MULT.ONE
				end
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.DAMAGE.TWO,
			desc = STRINGS.UPGRADES.TEASER.DAMAGE.TWO,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier * TUNING.UPGRADES.DAMAGE_MULT.TWO
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.DAMAGE.THREE,
			desc = STRINGS.UPGRADES.TEASER.DAMAGE.THREE,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier * TUNING.UPGRADES.DAMAGE_MULT.THREE
			end,
			image = "bomb_suicide"
		},
	},
	{
		{
			name = STRINGS.UPGRADES.NAMES.SANITY.ONE,
			desc = STRINGS.UPGRADES.TEASER.SANITY.ONE,
			cost = {rocks = 1, silver = 50},
			effectfn = function(inst)
				inst.components.sanity.max = inst.components.sanity.max * TUNING.UPGRADES.SANITY_MULT.ONE
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.SANITY.TWO,
			desc = STRINGS.UPGRADES.TEASER.SANITY.TWO,
			cost = {goldnugget = 1, silver = 50},
			effectfn = function(inst)
				inst.components.sanity.max = inst.components.sanity.max * TUNING.UPGRADES.SANITY_MULT.ONE
			end,
			image = "bomb_suicide"
		},
		{
			name = STRINGS.UPGRADES.NAMES.SANITY.THREE,
			desc = STRINGS.UPGRADES.TEASER.SANITY.THREE,
			cost = {marble = 1, silver = 50},
			effectfn = function(inst)
				inst.components.sanity.max = inst.components.sanity.max * TUNING.UPGRADES.SANITY_MULT.ONE
			end,
			image = "bomb_suicide"
		},
	},
}

return Upgrades