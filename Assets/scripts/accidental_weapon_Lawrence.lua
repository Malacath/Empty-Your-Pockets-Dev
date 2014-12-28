--I was working on this item, the idea was to create a musket that would damage mobs in a range , 
--but I accidentally created a musket that make mobs attacking themselves, in a range... lol
--I hope it can be useful!  
-- Lawrence Caustic Sorrow

local assets =
{	
	--Asset("ANIM", "anim/gun.zip"), --to change, of course
	--Asset("ANIM", "anim/swap_gun.zip"),
	--Asset ("ATLAS", "images/inventoryimages/gun.xml"),
	--Asset ("IMAGE", "images/inventoryimages/gun.tex"),
}

local prefabs = 
{
	"explode_small",
}


local function onfinished(inst)
	inst:Remove()
end

local function onequip(inst, owner)
    --owner.AnimState:OverrideSymbol("swap_object", "swap_gun", "swap_gun")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function shoot(inst, attacker, target)

local range = 2
local damage = 50
local pos = Vector3(target.Transform:GetWorldPosition())
local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, range)

for k,v in pairs(ents) do
        
            if v.components.combat and v ~= GetPlayer() then
                v.components.combat:GetAttacked(target, damage, nil) --that's the useful error :D
            end
        
    end

inst:DoTaskInTime(0.25, function()
attacker.AnimState:PlayAnimation("hit") --recoil!

local light = inst.entity:AddLight()
light:Enable(true)

        inst.Light:SetRadius(2.5)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(255/128,0/0,0/255)
		
		inst:DoTaskInTime(0.40, function()
		light:Enable(false)
		end)
end)
				--Smoke to make it look like an old musket' shot
		--[[  --This one is bad, need a better thing, not working with non-lateral targets
inst.smoke = SpawnPrefab( "small_puff" )
inst.smoke2 = SpawnPrefab( "small_puff" )
local follower = inst.smoke.entity:AddFollower()
	local follower2 = inst.smoke2.entity:AddFollower()
	
	inst.smoke.AnimState:SetScale(2,2,2) 
	inst.smoke.AnimState:SetMultColour(.2,.2,.2,1)
	
	inst.smoke2.AnimState:SetScale(2.2,2.2,2.2)
	inst.smoke2.AnimState:SetMultColour(.2,.2,.2,0.99)
	
    follower:FollowSymbol( attacker.GUID, attacker.components.combat.hiteffectsymbol, 100, -40, 1 )
	follower2:FollowSymbol( attacker.GUID, attacker.components.combat.hiteffectsymbol, 250, -40, 1 )
	
	local explode = SpawnPrefab("explode_small")
    local pos = target:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)
	--]]
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
        if target.sg and target.sg.sg.states.hit then
            target.sg:GoToState("hit")
        end
    end

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()	
    MakeInventoryPhysics(inst)
    
    anim:SetBank("gun")
    anim:SetBuild("gun")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(shoot)

	--inst.components.weapon:SetProjectile("fire_projectile")

	---
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(50)
    inst.components.finiteuses:SetUses(50)
    inst.components.finiteuses:SetOnFinished(onfinished)
	    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.atlasname = "images/inventoryimages/gun.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
	
	
    return inst
end

return Prefab( "common/inventory/gun", fn, assets)