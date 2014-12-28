local WAVES = {
	{
		bat = {
			num = 4,
		},
	},
	{
		pigman = {
			num = 4,
			delay = 5,
			delayfn = function(inst)
				if inst and not inst.components.health:IsDead() then
					inst.components.werebeast:TriggerDelta(5)
				end
			end
		},
		pigguard = {},
	},
	{
		tallbird = {},
		teenbird = {
			num = 2,
		},
	},
	boss = {
		deerclops = {},
		hound = {
			num = 3,
		},
	}
}

return WAVES