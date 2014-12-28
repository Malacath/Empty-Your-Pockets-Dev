
local assets=
{
	Asset("ANIM", "anim/silver.zip"),

	Asset("IMAGE", "images/inventoryimages/silver_onecoin.tex"),
	Asset("ATLAS", "images/inventoryimages/silver_onecoin.xml"),

	Asset("IMAGE", "images/inventoryimages/silver_twocoin.tex"),
	Asset("ATLAS", "images/inventoryimages/silver_twocoin.xml"),

	Asset("IMAGE", "images/inventoryimages/silver_threecoin.tex"),
	Asset("ATLAS", "images/inventoryimages/silver_threecoin.xml"),

}

local function AddMoney(inst, owner)
	if owner.components.upgradeable then
		owner:DoTaskInTime(0, function()
			owner.components.upgradeable:MoneyDelta(inst.components.stackable.stacksize)
			owner.components.inventory:RemoveItem(inst)
			inst:Remove()
		end)
	end
end

local function OnPlayerNear(inst)
	local player = GetPlayer()
	if inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld() and not player.components.inventory:IsFull() then
		player.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(AddMoney)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/silver_onecoin.xml"
	inst.components.inventoryitem.imagename = "silver_onecoin"
    MakeInventoryPhysics(inst)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 100
	inst.components.stackable.stacksize = math.random(1,3)

    anim:SetBank("silver")
    anim:SetBuild("silver")
    if inst.components.stackable.stacksize <= 1 then
    	anim:PlayAnimation("single")
    elseif inst.components.stackable.stacksize == 2 then
    	anim:PlayAnimation("double")
    else
    	anim:PlayAnimation("triple")
    end
    anim:SetScale(1.3, 1.3, 1.3)

    inst:AddComponent("inspectable")

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)

    return inst
end

return Prefab( "common/silver", fn, assets)
