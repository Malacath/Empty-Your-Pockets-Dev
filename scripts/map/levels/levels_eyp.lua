AddLevel(_G.LEVELTYPE.CUSTOM, {
		id="HELL",
		name="Hell",
		nomaxwell=true,
		overrides={
			{"day", 			"onlynight"},
			{"weather", 		"never"},
			{"season", 			"onlysummer"},
			{"weather", 		"never"},
			{"lightning", 		"never"},
			{"creepyeyes", 		"always"},
			{"boons",			"never"},
			{"start_setpeice",  "HellLayout"},
			{"start_node",      "HellRoom"},
			{"areaambient",   	"VOID"},
		},	
		tasks = {
			"HellTask",
		},
		numoptionaltasks =0,
		hideminimap = false,
		teleportaction = "restart",
		optionaltasks = {},
		required_prefabs = {},
		override_level_string = "Hell",
	})

AddLevel(_G.LEVELTYPE.CUSTOM, {
		id="UNDERWORLD",
		name="Underworld",
		nomaxwell=true,
		overrides={
			{"day", 			"onlynight"},
			{"weather", 		"never"},
			{"season", 			"onlysummer"},
			{"lightning", 		"never"},
			{"creepyeyes", 		"always"},
			{"boons",			"never"},
			{"start_setpeice",  "UnderworldLayout"},
			{"start_node",      "UnderworldRoom"},
			{"areaambient",   	"VOID"},
			{"waves", 			"off"}
		},	
		tasks = {
			"UnderworldTask",
		},
		numoptionaltasks =0,
		hideminimap = false,
		teleportaction = "restart",
		optionaltasks = {},
		required_prefabs = {},
		override_level_string = "Underworld",
	})
