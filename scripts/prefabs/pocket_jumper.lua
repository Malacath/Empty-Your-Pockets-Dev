--BY LAWRENCE CAUSTIC SORROW
--This is the script example for the ''pocket jumper'' item.
--It works basically like the boomerang, but it will appear in player's hand after it hits something.

local assets=
{
	Asset("ANIM", "anim/boomerang.zip"), --basic boomerang sprites
	Asset("ANIM", "anim/swap_boomerang.zip"),
}

    
local prefabs =
{
}

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_boomerang", "swap_boomerang")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
end

local function ReturnToOwner(inst, owner)
    if owner and not (inst.components.finiteuses and inst.components.finiteuses:GetUses() < 1) then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst:Remove()
		
		local loot = SpawnPrefab(inst.prefab)
		local uses = inst.components.finiteuses:GetUses()
                
				if loot then
					
                    owner.components.inventory:GiveItem(loot) --magic! It came back!
					loot.components.finiteuses:SetUses(uses)
					GetPlayer().components.inventory:Equip(loot, true)
					
                end
    end
	end

local function OnHit(inst, owner, target)
    if owner == target then
        OnDropped(inst)
    else
        ReturnToOwner(inst, owner)
    end
    local impactfx = SpawnPrefab("impact")
    if impactfx then
	    local follower = impactfx.entity:AddFollower()
	    follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
        impactfx:FacePoint(inst.Transform:GetWorldPosition())
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst .entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("boomerang")
    anim:SetBuild("boomerang")
    anim:PlayAnimation("idle")
    anim:SetRayTestOnBB(true);
    
    inst:AddTag("projectile")
    inst:AddTag("thrown")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BOOMERANG_DAMAGE*1.2)
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE+2)
    -------
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(15)
    inst.components.finiteuses:SetUses(15)
    
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("inspectable")
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(18)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(ReturnToOwner)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    
    return inst
end

return Prefab( "common/inventory/pocket_jumper", fn, assets) 
