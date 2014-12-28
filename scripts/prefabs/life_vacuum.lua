require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/pinecone.zip"),
}

local function SuckLife(inst, deployer, pt, num)
	num = num or 0
	num = num + 1

	local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, TUNING.LIFE_VACUUM_REACH, nil)
	
	for _, ent in pairs(ents) do
		if ent ~= deployer and ent.components.health then
			local del = ent.components.health.currenthealth*TUNING.LIFE_VACUUM_LIFE_PERCENT_LARGE
			if ent.components.health:GetPercent() < 75 then
				del = ent.components.health.currenthealth*TUNING.LIFE_VACUUM_LIFE_PERCENT_SMALL
			end
			ent.components.health:DoDelta(-del)
			deployer.components.health:DoDelta(del)
			if ent.components.combat then
				ent.components.combat:GetAttacked(deployer, 0)
			end
		end
	end

	if num < TUNING.LIFE_VACUUM_NUM_SUCKS then
		inst:DoTaskInTime(math.random()*1+1, function() SuckLife(inst, deployer, pt, num) end)
	else
		inst:Remove()
	end
end

local function OnDeploy (inst, pt, deployer) 
    inst.Transform:SetPosition(pt:Get())

    inst:RemoveComponent("inventoryitem")
    inst.AnimState:PlayAnimation("idle_planted")

	inst:DoTaskInTime(math.random()*1+1, function() SuckLife(inst, deployer, pt) end)	
end

local notags = {'NOBLOCK', 'player', 'FX'}
local function TestGround(inst, pt)
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GROUND.IMPASSABLE
	
	if ground_OK then
	    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4, nil, notags)
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function OnInspect(inst)
end

local function OnSave(inst, data)
end

local function OnLoad(inst, data)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pinecone")
    inst.AnimState:SetBuild("pinecone")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = OnInspect
    
    inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.atlas = "images/inventoryimages/silver.xml"
	--inst.components.inventoryitem.imagename = "silver"
	inst.components.inventoryitem.imagename = "teleportato_ring"
    
    inst:AddComponent("deployable")
    inst.components.deployable.test = TestGround
    inst.components.deployable.ondeploy = OnDeploy

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab( "common/inventory/life_vacuum", fn, assets),
	   MakePlacer( "common/life_vacuum_placer", "pinecone", "pinecone", "idle_planted" ) 


