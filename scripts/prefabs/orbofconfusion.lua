local assets=
{
	Asset("ANIM", "anim/orbofconfusion.zip"),

    Asset("ATLAS", "images/inventoryimages/orbofconfusion.xml"),
    Asset("IMAGE", "images/inventoryimages/orbofconfusion.tex"),

    Asset("ATLAS", "images/inventoryimages/orbofconfusion_on.xml"),
    Asset("IMAGE", "images/inventoryimages/orbofconfusion_on.tex"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("orbofconfusion")
    inst.AnimState:SetBuild("orbofconfusion")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryPhysics(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/orbofconfusion.xml"
	inst.components.inventoryitem.imagename = "orbofconfusion"

    return inst
end

return Prefab( "common/orbofconfusion", fn, assets)
