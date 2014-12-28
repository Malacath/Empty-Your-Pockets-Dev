local assets=
{
	Asset("ANIM", "anim/ds_rabbit_basic.zip"),
	Asset("ANIM", "anim/beard_monster.zip"),
	
}

local function GoAwayTime(inst)
local TimeToRemove = math.random(20,30)
if inst.RemoveTime <  TimeToRemove then
inst.RemoveTime = inst.RemoveTime+1
else
local disappear = SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/death")
inst:Remove()
end
end

local function onsave(inst, data)
    data.timeleft = (inst.RemoveTime)
end

local function onload(inst, data) 
    if data.timeleft then
        inst.RemoveTime = data.timeleft
		if inst.RemoveTime > 0 then
			if not inst.task1 then
				inst.task1 = inst:DoPeriodicTask(1, function() GoAwayTime(inst) end)
				
			end
		else
			if inst.task1 then inst.task1:Cancel() inst.task1 = nil end
			
		end
    end
end

local function Retarget(inst)
		return FindEntity(inst, TUNING.PIG_TARGET_DIST,
        	function(guy)
			
			if guy.components.health and not guy.components.health:IsDead() and not guy:HasTag("ghostrat") and not (inst.components.follower and inst.components.follower.leader == guy) then
				return true
			end
            		return guy:HasTag("monster") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
            	end)
end

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
          and not (inst.components.follower and inst.components.follower.leader == target)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("ghostrat")
               and not dude.components.health:IsDead()
               and dude.components.follower
               and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
end

local function fn()

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	
	
    anim:SetBank("rabbit")
    anim:SetBuild("beard_monster")
	
	inst:AddTag("ghostrat")
	inst:AddTag("scarytoprey")
	
	inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 10, .5)
	
	inst.Transform:SetScale(1.2, 0.8, 1.2)
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({0,0,0,.5}, 0)
	
	inst.entity:AddSoundEmitter()
	
		inst:AddComponent("locomotor")
		inst.components.locomotor.walkspeed = 7
		inst.components.locomotor.runspeed = 9

		inst:AddComponent("follower")
		inst.components.follower.leader = GetPlayer()
					
	inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chest"
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetRange(1.3)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
     inst.components.combat:SetAttackPeriod(1)

    inst:AddComponent("knownlocations")

	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(10)
	
	local brain = require "brains/ghostrat_brain"
    inst:SetBrain(brain)
    
	inst:ListenForEvent("attacked", OnAttacked)
	
	inst:SetStateGraph("SGghostrat")
	
	inst.RemoveTime = 0
	inst.task1 = inst:DoPeriodicTask(1, function() GoAwayTime(inst) end)
	
	inst.OnSave = onsave
    inst.OnLoad = onload
	
    return inst
end

return Prefab( "creatures/ghostrat", fn, assets) 