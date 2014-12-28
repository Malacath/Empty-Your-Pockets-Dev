local assets=
{
	Asset("ANIM", "anim/itemshop.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 1)

    anim:SetBank("itemshop")
    anim:SetBuild("itemshop")
    anim:PlayAnimation("idle", true)
    anim:SetScale(1.7, 1.7, 1.7)


	inst:AddComponent("inspectable")
	inst:AddComponent("shopsection")
	inst.components.shopsection:SetUpgrades("items")

    return inst
end

return Prefab( "common/item_shop", fn, assets)
