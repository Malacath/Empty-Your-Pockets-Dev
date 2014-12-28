local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local light = inst.entity:AddLight()

	light:SetRadius(10.42)
    light:SetFalloff(1)
    light:SetIntensity(.75)
    light:SetColour(83/255, 183/255, 16/255)

    return inst
end

return Prefab("common/underworld_light", fn)