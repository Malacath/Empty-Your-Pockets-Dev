_G.require("map/lockandkey")

AddTask("HellTask", {
		lock=_G.LOCKS.NONE,
		key_given=_G.KEYS.NONE,
		room_choices={
			["HellRoom"] = 1,
		},
		room_bg=_G.GROUND.IMPASSABLE,
		background_room="BGImpassable",
		colour={r=.05,g=.05,b=.05,a=1}
	})

AddTask("UnderworldTask", {
		lock=_G.LOCKS.NONE,
		key_given=_G.KEYS.NONE,
		room_choices={
			["UnderworldRoom"] = 1,
		},
		room_bg=_G.GROUND.IMPASSABLE,
		background_room="BGImpassable",
		colour={r=.05,g=.05,b=.05,a=1}
	})