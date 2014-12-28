
local assets=
{
	Asset("ANIM", "anim/anti_grue.zip"),

	Asset("IMAGE", "images/inventoryimages/anti_grue.tex"),
	Asset("ATLAS", "images/inventoryimages/anti_grue.xml"),

	Asset("IMAGE", "images/inventoryimages/anti_grue_on.tex"),
	Asset("ATLAS", "images/inventoryimages/anti_grue_on.xml"),
}

local function StartFade(inst, int)
	int = int or 0.75
	int = int - 0.05
	inst.Light:SetIntensity(int)
	if int > 0 then
		inst:DoTaskInTime(0.05, function() StartFade(inst, int) end)
	elseif inst.owner then
		inst.owner.components.inventory:RemoveItem(inst)
		inst:Remove()
	else
		inst:Remove()
	end
end

local function LightPlayer(inst, player)
	inst.Light:Enable(true)
	if inst.task then
		inst.task:Cancel()
	end
	inst.task = inst:DoTaskInTime(15 + math.random()*15, StartFade)
	inst.activate = true
	inst.components.inventoryitem.atlasname = "images/inventoryimages/anti_grue_on.xml"
	inst.components.inventoryitem.imagename = "anti_grue_on"
    inst.AnimState:PlayAnimation("idle_on")
end

local function LeavePlayer(inst)
	inst.owner:RemoveEventCallback("heargrue", function() LightPlayer(inst, inst.owner) end)
	inst.owner = nil
	if not inst.activate then
		inst.Light:Enable(false)
	end
end

local function ProtectPlayer(inst, owner)
	if owner.components.grue and not inst.activate then
		owner:ListenForEvent("heargrue", function() LightPlayer(inst, inst.owner) end)
		inst.Light:Enable(false)
		inst.owner = owner
	end
end

local function OnSave(inst, data)
   	if inst.activate and not inst.double then 
   		data.active = true 
   	end
end

local function OnLoad(inst, data)
   	if data.activate then
   		inst:DoTaskInTime(0, function()
   			LightPlayer(inst, player)
   			inst.double = true
   		end) 
   	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()

	anim:SetBank("anti_grue")
	anim:SetBuild("anti_grue")
	anim:PlayAnimation("idle", true)
	anim:SetScale(1.3, 1.3, 1.3)

    MakeInventoryPhysics(inst)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(ProtectPlayer)
	inst.components.inventoryitem:SetOnDroppedFn(LeavePlayer)

	if inst.components.inventoryitem:IsHeld() then
		ProtectPlayer(inst, inst.components.inventoryitem.owner)
	end

	inst.entity:AddLight()
	inst.Light:SetRadius(.75)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(255/255, 255/255, 255/255)
	inst.Light:Enable(false)
	inst.Light:SetDisableOnSceneRemoval(false)

	--inst.task = inst:DoPeriodicTask(0, function() inst.Light:Enable(false) end)

	inst.components.inventoryitem.atlasname = "images/inventoryimages/anti_grue.xml"
	inst.components.inventoryitem.imagename = "anti_grue"

    inst:AddComponent("inspectable")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("common/anti_grue", fn, assets)
