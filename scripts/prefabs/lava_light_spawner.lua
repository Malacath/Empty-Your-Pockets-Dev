local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()

	local static_layout = require "map/static_layout"
	local Get = static_layout.Get
	local layout = Get("map/static_layouts/layout_hell")

	inst:DoTaskInTime(0, function()
		local x, y, z = trans:GetWorldPosition()
		for prefab, entries in pairs(layout.layout) do
			if prefab == "lava_light" then
				for _, properties in pairs(entries) do
					local spawn = SpawnPrefab(prefab)
					if spawn then
						spawn:DoTaskInTime(0, function()
							local newx = x + properties.x * 4
							local newz = z + properties.y * 4
							spawn.Transform:SetPosition(newx, y, newz)
						end)
					end
				end
				break
			end
		end
	end)

	inst:DoTaskInTime(1, inst.Remove)

    return inst
end

return Prefab("common/lava_light_spawner", fn)