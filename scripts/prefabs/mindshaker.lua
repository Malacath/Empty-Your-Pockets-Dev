local assets=
{
	Asset("ANIM", "anim/mindshaker.zip"),
	Asset("ANIM", "anim/swap_mindshaker.zip"),

	Asset("IMAGE", "images/inventoryimages/mindshaker.tex"),
	Asset("ATLAS", "images/inventoryimages/mindshaker.xml"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_mindshaker", "swap_mindshaker")
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
    MakeInventoryPhysics(inst)

    anim:SetBank("mindshaker")
    anim:SetBuild("mindshaker")
    anim:PlayAnimation("idle")

    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(shoot)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MINDSHAKER_USES)
    inst.components.finiteuses:SetUses(TUNING.MINDSHAKER_USES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

	inst.components.inventoryitem.atlasname = "images/inventoryimages/mindshaker.xml"
	inst.components.inventoryitem.imagename = "mindshaker"



    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    return inst
end

return Prefab( "common/inventory/mindshaker", fn, assets)
