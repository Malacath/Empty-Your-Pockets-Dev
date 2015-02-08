local MakePlayerCharacter = require "prefabs/player_common"


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

local function SanityFn(inst)
        local delta = TUNING.SANITYAURA_TINY
        delta = delta * inst.components.upgradeable_eyp.money / 100
        return delta
end

local fn = function(inst)
        --inst.MiniMapEntity:SetIcon( "wilson.png" )
	inst.soundsname = "merchant"

        inst.components.health:SetMaxHealth(TUNING.WILL_HEALTH)
        inst.components.sanity:SetMax(TUNING.WILL_SANITY)
        inst.components.sanity.custom_rate_fn = SanityFn
        inst.components.hunger:SetMax(TUNING.WILL_HUNGER)
        inst.components.hunger:SetRate(TUNING.WILL_HUNGER_RATE)
        inst.components.combat.damagemultiplier = TUNING.WILL_DAMAGE_MULT

        inst:AddComponent("upgradeable_eyp")
        inst.components.upgradeable_eyp:SetDiscount(TUNING.WILL_DISCOUNT)
        inst.components.upgradeable_eyp:MoneyDelta(66)

        local oldAddFollower = inst.components.leader.AddFollower
        inst.components.leader.AddFollower = function(self, follower)
                oldAddFollower(self, follower)
                if self.followers[follower] == nil and follower.components.follower then
                        self.inst:DoTaskInTime(0, function()
                                follower.components.follower:AddLoyaltyTime(TUNING.WILL_LOYALTY_BONUS)
                        end)
                end
        end
end



return MakePlayerCharacter("will", prefabs, assets, fn)