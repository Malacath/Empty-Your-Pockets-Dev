local assets=
{
	Asset("ANIM", "anim/surgery_bed.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 1)

    anim:SetBank("surgery_bed")
    anim:SetBuild("surgery_bed")
    anim:PlayAnimation("test")
    anim:SetScale(2.5, 2.5, 2.5)

	inst:AddComponent("shopsection")
	inst:AddComponent("inspectable")

    return inst
end

return Prefab( "common/surgery_bed", fn, assets)
