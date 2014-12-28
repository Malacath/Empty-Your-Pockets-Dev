local assets = {
	Asset("ANIM", "anim/void.zip")
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	anim:SetBank("void")
	anim:SetBuild("void")
	anim:PlayAnimation("idle")

	inst:AddComponent("enemywavespawner")

    return inst
end

return Prefab("common/underworld_spawner", fn)