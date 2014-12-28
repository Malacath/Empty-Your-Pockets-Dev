
local MakePlayerCharacter = require "prefabs/player_common"
require "tuning"

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/will.zip" ),
}

local prefabs = {
}

local start_inv = 
{
}

local fn = function(inst)
        
        local function KeepTarget(inst, target)
                return  false
        end

        local function ReTarget(inst)
                return nil
        end

        local inst = CreateEntity()

        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        local shadow = inst.entity:AddDynamicShadow()
        local minimap = inst.entity:AddMiniMapEntity()
        
        inst.MiniMapEntity:SetIcon( "will.tex" )

        trans:SetFourFaced()

        MakeCharacterPhysics(inst, 75, .5)

        shadow:SetSize( 1.3, .6 )

        anim:SetBank("wilson")
        anim:SetBuild("will")
        anim:PlayAnimation("idle")

        anim:Hide("ARM_carry") 
        anim:Show("ARM_normal") 
        anim:Hide("hat")
        anim:Hide("hat_hair")
        anim:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
        anim:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
        anim:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")

        inst:AddTag("willmob")

        inst:AddComponent("locomotor")
        inst.components.locomotor:SetSlowMultiplier( 0.6 )
        inst.components.locomotor.pathcaps = { ignorecreep = true }
        inst.components.locomotor.fasteronroad = true

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(TUNING.WILLMOB_DAMAGE)
        inst.components.combat.hiteffectsymbol = "torso"
        inst.components.combat:SetKeepTargetFunction(KeepTarget)
        inst.components.combat:SetRetargetFunction(3, ReTarget)

        inst:AddComponent("inventory")
    
        inst:AddComponent("inspectable")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.WILLMOB_HEALTH)

        inst:SetStateGraph("SGwillmob")

        return inst
end

return Prefab("willmob", fn, assets, prefabs)