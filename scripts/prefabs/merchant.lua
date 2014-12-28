local assets=
{
	Asset("ANIM", "anim/merchant.zip"),
}

prefabs = {
	"surgery_bed",
	"lucky_scrapyard",
	"item_shop",
}

local function GetInspectStatus(inst)
    return "GENERIC"
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 1)

    anim:SetBank("merchant")
    anim:SetBuild("merchant")
    anim:PlayAnimation("idle", true)
	anim:SetScale(1.3, 1.3, 1.3)

	inst:AddComponent("talker")
	inst.components.talker.offset = Vector3(0,-850,0)
	inst:AddComponent("shopkeeper")
	inst.components.shopkeeper:Initialize()

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(150)
	inst:AddComponent("combat")

	inst:AddComponent("locomotor")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetInspectStatus

	inst:SetStateGraph("SGmerchant")

    return inst
end

return Prefab( "common/merchant", fn, assets)
