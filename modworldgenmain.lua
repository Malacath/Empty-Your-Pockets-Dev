_G = GLOBAL

_G.require("map/level")
local LEVELTYPE = _G.LEVELTYPE

local Layouts = _G.require("map/layouts").Layouts
local StaticLayout = _G.require("map/static_layout")

Layouts["HellLayout"] = StaticLayout.Get("map/static_layouts/layout_hell",
{
	start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = _G.LAYOUT_POSITION.CENTER,
	disable_transform = true
})

Layouts["UnderworldLayout"] = StaticLayout.Get("map/static_layouts/layout_underworld",
{
	start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = _G.LAYOUT_POSITION.CENTER,
	disable_transform = true
})

modimport("scripts/map/rooms/rooms_eyp.lua")
modimport("scripts/map/tasks/tasks_eyp.lua")
modimport("scripts/map/levels/levels_eyp.lua")