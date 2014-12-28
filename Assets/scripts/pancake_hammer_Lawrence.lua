local assets=
{
	Asset("ANIM", "anim/hammer.zip"),
	Asset("ANIM", "anim/swap_hammer.zip"),
}

local prefabs =
{
	"collapse_small",
	"collapse_big",
}

local function onfinished(inst)
    inst:Remove()
end

--The Pancake Hammer (random name, yeah!) shrinks the target, making him flat-looking and slower than normal.
--Maybe needs a OnSave, OnLoad function... Idk
--Lawrence Caustic Sorrow

local function shrink(inst, attacker, target) 
		
	if target then
	target.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.25, 0.03, .5, 6)
		
		if target.components.health and target.components.health:IsDead() then
			target.Transform:SetScale(1.8,0.35,1.8)
		elseif target.components.health and not target.components.health:IsDead() then
		
		if target.components.combat and not target:HasTag("hammered") then
			target:AddTag("hammered")
			
			if target.components.locomotor then 
			target.Transform:SetScale(1.2,0.65,1.2)
				local tws = target.components.locomotor.walkspeed
				local trs = target.components.locomotor.runspeed
				print("walkspeed", tws)
				print("walkspeed", trs)
				if target.components.locomotor.walkspeed then 
					target.components.locomotor.walkspeed = (tws/2.5)
				end
				
				if target.components.locomotor.runspeed then 
					target.components.locomotor.runspeed = (trs/2.5)
				end
				
				print("walkspeed after", target.components.locomotor.walkspeed)
				print("walkspeed after", target.components.locomotor.runspeed)
				
			target:DoTaskInTime(10, function()
			
			target:RemoveTag("hammered")
			
			if target.sg then
				target.sg:GoToState("hit")
			end
			
			target.Transform:SetScale(1,1,1)
			target.SoundEmitter:PlaySound("dontstarve/common/destroy_tool")
				if target.components.locomotor.walkspeed then 
					target.components.locomotor.walkspeed = tws
				end
				
				if target.components.locomotor.runspeed then 
					target.components.locomotor.runspeed = trs
				end
			end)
			
				end

			end
		end
	end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_hammer", "swap_hammer")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
    
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("hammer")
    anim:SetBuild("hammer")
    anim:PlayAnimation("idle")
    
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE*2)
	inst.components.weapon:SetOnAttack(shrink)

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, 5)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HAMMER_USES)
    inst.components.finiteuses:SetUses(TUNING.HAMMER_USES)
    
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    -------
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end


return Prefab( "common/inventory/dahammer", fn, assets, prefabs) 
