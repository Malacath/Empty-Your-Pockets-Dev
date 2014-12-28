
local assets=
{
	Asset("ANIM", "anim/chester_be_safe.zip"),

	Asset("ATLAS", "images/inventoryimages/chester_be_safe.xml"),
	Asset("IMAGE", "images/inventoryimages/chester_be_safe.tex"),
}

local function FreeBees(inst)
	local x, y, z = inst:GetPosition():Get()
	local ents = TheSim:FindEntities(x, y, z, 15, nil, {"player", "nothreat"})
	for _, ent in pairs(ents) do
		print(tostring(ent))
		if ent ~= inst and ent.components.combat and not (ent.components.follower and ent.components.follower.leader == GetPlayer()) then
			local bee = SpawnPrefab("killerbee")
			bee.Transform:SetPosition(x, y, z)
			bee.components.combat:SuggestTarget(ent)
			ent.components.combat:SuggestTarget(bee)
			ent:ListenForEvent("death", function()
				if bee then
					bee.components.health:Kill()
				end
			end)
		end
	end
	inst:RemoveEventCallback("attacked", FreeBees)
end

local function RaiseDefenses(inst)
	local owner = inst.components.inventoryitem.owner
	inst.chester = owner
	inst.chester:ListenForEvent("attacked", function()
		FreeBees(owner)
		owner.components.container:RemoveItem(inst)
		inst:Remove()
	end)
	print("Rasing Defenses")
end

local function LowerDefenses(inst)
	if inst.chester then
		inst.chester:RemoveEventCallback("attacked", FreeBees)
		inst.chester = nil
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    anim:SetBank("chester_be_safe")
    anim:SetBuild("chester_be_safe")
    anim:PlayAnimation("idle", false)
    anim:SetScale(1.3, 1.3, 1.3)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_be_safe.xml"
	inst.components.inventoryitem.imagename = "chester_be_safe"

    MakeInventoryPhysics(inst)

    if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.prefab == "chester" and not inst.chester then
   		RaiseDefenses(inst)
    end

    inst:DoPeriodicTask(10, function()
    	if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.prefab == "chester" and not inst.chester then
    		RaiseDefenses(inst)
    	elseif inst.chester then
    		LowerDefenses(inst)
    	end
    end)

    inst:AddComponent("inspectable")

    return inst
end

return Prefab( "common/chester_be_safe", fn, assets)