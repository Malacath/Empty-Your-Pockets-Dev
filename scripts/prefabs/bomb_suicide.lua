
local assets=
{
	Asset("ANIM", "anim/bomb_suicide.zip"),

	Asset("ATLAS", "images/inventoryimages/bomb_suicide.xml"),
	Asset("IMAGE", "images/inventoryimages/bomb_suicide.tex"),
}

local function OnExplodeFn(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:KillSound("hiss")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetScale(5, 5, 5, 1)
    explode.AnimState:SetLightOverride(1)
end

local function DetonateBomb(inst, data)
	if data and data.cause ~= "NeedForbiddenCauses" then
		inst.AnimState:PlayAnimation("nearexplode", true)
		inst:DoTaskInTime(2, function()
			inst.AnimState:PlayAnimation("explode")
			inst:ListenForEvent("animover",  function()
				inst.components.explosive:OnBurnt()
			end)
		end)
	end
end

local function DeFuseBomb(inst)
	if not inst.owner.components.health:IsDead() then
		inst:RemoveEventCallback("death", function(dead, data)
			DetonateBomb(inst, data)
		end, inst.owner)
		inst:RemoveComponent("explosive")
	end
	inst.owner = nil
end

local function FuseBomb(inst, owner)
	inst:ListenForEvent("death", function(dead, data)
		DetonateBomb(inst, data)
	end, owner)
	inst:AddComponent("explosive")
	inst.components.explosive.explosiverange = 50
	inst.components.explosive.explosivedamage = 1000
   	inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
	inst.owner = owner
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()

	anim:SetBank("bomb_suicide")
	anim:SetBuild("bomb_suicide")
	anim:PlayAnimation("idle", false)
	anim:SetScale(2, 2, 2)
	
    MakeInventoryPhysics(inst)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(FuseBomb)
	inst.components.inventoryitem:SetOnDroppedFn(DeFuseBomb)

	if inst.components.inventoryitem:IsHeld() and inst.components.inventoryitem.owner.health then
		FuseBomb(inst, inst.components.inventoryitem.owner)
	end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/bomb_suicide.xml"
	inst.components.inventoryitem.imagename = "bomb_suicide"

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("common/bomb_suicide", fn, assets)
