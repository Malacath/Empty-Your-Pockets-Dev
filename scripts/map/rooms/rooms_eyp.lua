AddRoom("HellRoom", {
	colour={r=0.6,g=.2,b=.2,a=.50},
	value = _G.GROUND.IMPASSABLE,
	contents =  {
		countstaticlayouts={
			["HellLayout"]=1,
		},
	}
})

AddRoom("UnderworldRoom", {
	colour={r=0.2,g=.8,b=.1,a=.50},
	value = _G.GROUND.IMPASSABLE,
	contents =  {
		countstaticlayouts={
			["UnderworldLayout"]=1,
		},
	}
})