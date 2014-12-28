
local assets=
{
	Asset("ANIM", "anim/void.zip"),

}

local function OnExplodeFn(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:KillSound("hiss")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local explode = PlayFX(pos,"explode", "explode", "small")
    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetScale(5, 5, 5, 1)
    explode.AnimState:SetLightOverride(1)
end

local function DetonateBomb(inst)
	inst.owner.components.health:SetInvincible(true)
	inst.components.explosive:OnBurnt()
	inst.owner:DoTaskInTime(1, function() inst.owner.components.health:SetInvincible(false) end)
end

local function DeFuseBomb(inst)
	inst:RemoveEventCallback("healthdelta", function()
		if owner.components.health.currenthealth <= TUNING.BOMB_RETRIBUTION_THRESH then
			DetonateBomb(inst)
		end
	end, owner)
	inst:RemoveComponent("explosive")
	inst.owner = nil
end

local function FuseBomb(inst, owner)
	inst:ListenForEvent("healthdelta", function()
		if owner.components.health.currenthealth <= TUNING.BOMB_RETRIBUTION_THRESH then
			DetonateBomb(inst)
		end
	end, owner)
	inst:AddComponent("explosive")
	inst.components.explosive.explosiverange = 10
	inst.components.explosive.explosivedamage = 400
   	inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
	inst.owner = owner
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	anim:SetBank("void")
	anim:SetBuild("void")
	anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(FuseBomb)
	inst.components.inventoryitem:SetOnDroppedFn(DeFuseBomb)

	if inst.components.inventoryitem:IsHeld() and inst.components.inventoryitem.owner.health then
		FuseBomb(inst, inst.components.inventoryitem.owner)
	end

	--inst.components.inventoryitem.atlas = "images/inventoryimages/silver.xml"
	--inst.components.inventoryitem.imagename = "silver"
	inst.components.inventoryitem.imagename = "teleportato_ring"

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("common/bomb_retribution", fn, assets)
