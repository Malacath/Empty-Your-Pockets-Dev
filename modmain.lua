local function TableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                TableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

_G = GLOBAL

PrefabFiles = {
    "simplextest",
	"merchant",
	"silver",
    "will",
    "willmob",
    "surgery_bed",
    "item_shop",
    "bomb_suicide",
    "bomb_retribution",
    "anti_grue",
    "chester_be_safe",
    "life_vacuum",
    "orbofconfusion",
    "mindshaker",
    "pancake_hammer",
    "hell_entrance",
    "underworld_entrance",
    "lava_light",
    "lava_light_spawner",
    "underworld_light",
    "underworld_spawner",
    "mourning_helm",
    "pocket_jumper",
}

Assets = {
	Asset("SOUNDPACKAGE", "sound/merchant.fev"),
    Asset("SOUND", "sound/merchant.fsb"),

    Asset("IMAGE", "images/hud_money.tex"),
    Asset("ATLAS", "images/hud_money.xml"),

    Asset("IMAGE", "images/money_bad.tex"),
    Asset("ATLAS", "images/money_bad.xml"),

    Asset("IMAGE", "images/money_good.tex"),
    Asset("ATLAS", "images/money_good.xml"),

    Asset("IMAGE", "images/money_new.tex"),
    Asset("ATLAS", "images/money_new.xml"),

    Asset("IMAGE", "images/inventoryimages/attack.tex"),
    Asset("ATLAS", "images/inventoryimages/attack.xml"),

    Asset("IMAGE", "images/inventoryimages/attack_s.tex"),
    Asset("ATLAS", "images/inventoryimages/attack_s.xml"),

    Asset("IMAGE", "images/inventoryimages/coldresistance.tex"),
    Asset("ATLAS", "images/inventoryimages/coldresistance.xml"),

    Asset("IMAGE", "images/inventoryimages/coldresistance_s.tex"),
    Asset("ATLAS", "images/inventoryimages/coldresistance_s.xml"),

    Asset("IMAGE", "images/inventoryimages/speed.tex"),
    Asset("ATLAS", "images/inventoryimages/speed.xml"),

    Asset("IMAGE", "images/inventoryimages/speed_s.tex"),
    Asset("ATLAS", "images/inventoryimages/speed_s.xml"),

    Asset( "IMAGE", "images/saveslot_portraits/will.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/will.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/will.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/will.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/will_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/will_silho.xml" ),

    Asset( "IMAGE", "bigportraits/will.tex" ),
    Asset( "ATLAS", "bigportraits/will.xml" ),

    Asset("IMAGE", "images/lava.tex"),

    Asset( "IMAGE", "images/colour_cubes/hell_cc.tex" ),
    Asset( "IMAGE", "images/colour_cubes/underworld_cc.tex" ),

    Asset( "ANIM", "anim/willnpc.zip"),
}

--Add new sounds ---------------------------------------------------------------------------------------

RemapSoundEvent( "dontstarve/characters/merchant/death_voice", "merchant/characters/merchant/death_voice" )
RemapSoundEvent( "dontstarve/characters/merchant/hurt", "merchant/characters/merchant/hurt" )
RemapSoundEvent( "dontstarve/characters/merchant/talk_LP", "merchant/characters/merchant/talk_LP" )

--Add William ---------------------------------------------------------------------------------------

AddModCharacter("will")

--Add new Strings ---------------------------------------------------------------------------------------

_G.STRINGS.SHOPKEEPER = _G.require("speech_shopkeeper")
_G.STRINGS.CHARACTERS.WILL = _G.require("speech_will")
_G.STRINGS = TableMerge(_G.STRINGS, _G.require("strings_eyp"))

--Add new Tuning ---------------------------------------------------------------------------------------

TUNING = TableMerge(TUNING, _G.require("tuning_eyp"))

--Add new Actions ---------------------------------------------------------------------------------------

local TradeAction_eyp = _G.Action(3)
TradeAction_eyp.str = "Trade with"
TradeAction_eyp.id = "TRADE_EYP"
TradeAction_eyp.distance = 2
TradeAction_eyp.fn = function(act)
    if  (act.target.components.shopkeeper and act.target.components.shopkeeper.doestrade)
        or (act.target.components.shopsection and act.target.components.shopsection.doestrade) then

        local section = nil
        if act.target.components.shopsection then
            section = act.target
        end
        local shop = act.target.components.shopkeeper or act.target.components.shopsection.parent.components.shopkeeper
        shop:InitiateTrade(act.doer, section)
    end
    return true
end

AddAction(TradeAction_eyp)

AddStategraphActionHandler("wilson", _G.ActionHandler(_G.ACTIONS.TRADE_EYP, "trade"))

--Add/Modify StateGraphs ---------------------------------------------------------------------------------------

local FollowText = _G.require "widgets/followtext"
AddStategraphState("wilson",
    _G.State{
        name = "trade",
        tags = {"trade"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("dial_loop", true)

            if not inst.components.talker.widget then
                inst.components.talker.widget = _G.GetPlayer().HUD:AddChild(FollowText("talkingfont", inst.components.talker.fontsize or 35))
            end
            inst.components.talker.widget.symbol = inst.components.talker.symbol
            inst.components.talker.widget:SetOffset(_G.Vector3(0, -400, 0))
            inst.components.talker.widget:SetTarget(inst)
            inst.components.talker.widget.text:SetString(_G.GetString(inst.prefab, "INTRODUCE_SHOP"))
            
            if inst.components.talker.colour then
                inst.components.talker.widget.text:SetColour(inst.components.talker.colour.x, inst.components.talker.colour.y, inst.components.talker.colour.z, 1)
            end
            if inst.talksoundoverride then
                 inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
            else
                local sound_name = inst.soundsname or inst.prefab
                inst.SoundEmitter:PlaySound("dontstarve/characters/"..sound_name.."/talk_LP", "talk")
            end
            inst.sg:SetTimeout(2)
        end,

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("talk")
            inst.sg:GoToState("idle")
            inst.components.talker.widget:Kill()
            inst.components.talker.widget = nil
            inst:PerformBufferedAction()
        end,
        
        events=
        {
            _G.EventHandler("animover", function(inst)
            	inst.sg:GoToState("idle")
            	inst.SoundEmitter:KillSound("talk")
                if inst.components.talker.widget then
                    inst.components.talker.widget:Kill()    
                    inst.components.talker.widget = nil
                end
                inst:PerformBufferedAction()
            end),
        },
    }
)

--Add a Custom Widget ---------------------------------------------------------------------------------------

AddSimPostInit(function(player)
	local status = player.HUD.controls.status
	local MoneyBadge = _G.require("widgets/money")

	status.money = status:AddChild(MoneyBadge(player))
	--status.money:SetPosition(-50,-475,0)
	status.money:SetPosition(-1200,-580,0)
	status.money:SetScale(0.6,0.6,0.6)
	status.money:SetAmount(status.owner.components.upgradeable_eyp.money)
	status.inst:ListenForEvent("moneydelta", function(inst, data)
		status.money:SetAmount(data.money)
	end, status.owner)

	player.components.upgradeable_eyp:MoneyDelta(289)
end)

--Modify LootDropper to drop some money ---------------------------------------------------------------------------------------

AddComponentPostInit("lootdropper", function(LootDropper)
	local oldGenerateLoot = LootDropper.GenerateLoot
	function LootDropper:GenerateLoot()
		local loots = oldGenerateLoot(LootDropper) or {}

		if LootDropper.inst.components.health then
			for k = 0, LootDropper.inst.components.health.maxhealth, 50 do
				if math.random() < TUNING.MONEY_LOOT_CHANCE then
					table.insert(loots, "silver")
				end
			end
		elseif LootDropper.inst.components.workable then
			table.insert(loots, "silver")
		end
		table.insert(loots, "silver")

		return loots
	end
end)

--Modify Chests to contain some money ---------------------------------------------------------------------------------------

local chests = {"treasurechest", "pandoraschest", "skullchest", "minotaurchest"}
for k, v in pairs(chests) do
	AddPrefabPostInit(v, function(inst)
		inst.newmoney = 0
		for k = 1, math.random(1, 4) do
			local money = _G.SpawnPrefab("silver")
			money.components.stackable.stacksize = math.random(1, 25)
			inst.newmoney = inst.newmoney + money.components.stackable.stacksize
			inst.components.container:GiveItem(money)
		end


		inst:ListenForEvent("onbuilt", function(inst)
			inst.AnimState:PlayAnimation("place")
			inst.AnimState:PushAnimation("closed", false)
			inst.components.container:ConsumeByName("silver", inst.newmoney)
		end)

		inst.OnSave = function(inst)
			data = {}
			return data
		end
		inst.OnLoad = function(inst, data)
			if data then
				inst:DoTaskInTime(0, inst.components.container:ConsumeByName("silver", inst.newmoney))
			end
		end
	end)
end

--Modify PlayerProfile to lock William ---------------------------------------------------------------------------------------

function ModPlayerProfile(PlayerProfile)
    local oldIsCharacterUnlocked = PlayerProfile.IsCharacterUnlocked
    function PlayerProfile:IsCharacterUnlocked(character)
        local oldres = oldIsCharacterUnlocked(self, character)
        if character == "will" and not self.persistdata.unlocked_characters[character] then
            return false
        end
        return oldres
    end
end

--Uncomment here to lock William
--AddGlobalClassPostConstruct("playerprofile", "PlayerProfile", ModPlayerProfile)

--Mod SaveIndex for adding the arena

AddGlobalClassPostConstruct("saveindex", "SaveIndex", function(self)
    
    function self:EnterArena(cb, id)
        local function ongamesaved()
            self.data.slots[self.current_slot].current_mode = string.lower(id)
            self.data.slots[self.current_slot].modes[string.lower(id)] = {}

            local Levels = _G.require("map/levels")
            for i,level in _G.ipairs(Levels.custom_levels) do
                if level.id == id then
                    self.data.slots[self.current_slot].modes[string.lower(id)].options = {
                        level_id = i
                    }
                    break
                end
            end
            self:Save(cb)
        end
        self:SaveCurrent(ongamesaved)
    end

    local oldCanUseExternalResurrector = self.CanUseExternalResurector
    function self:CanUseExternalResurector()
        return self.data.slots[self.current_slot].current_mode ~= "hell" or self.data.slots[self.current_slot].current_mode ~= "underworld"
                and oldCanUseExternalResurrector(self)
    end

end)

--Change the world if we are in the Arena or Wills Head

AddSimPostInit(function(player)
    local mode = _G.SaveGameIndex.data.slots[_G.SaveGameIndex.current_slot].current_mode
    local world = _G.GetWorld()
    if mode == "hell" then
        world.WaveComponent:SetWaveTexture(_G.resolvefilepath("images/lava.tex"))
        world.components.colourcubemanager:SetOverrideColourCube(_G.resolvefilepath("images/colour_cubes/hell_cc.tex"))
        world:RemoveComponent("birdspawner")
        TUNING.CREEPY_EYES = 
        {
            {maxsanity=1, maxeyes=12},
        }
    elseif mode == "underworld" then
        world.components.colourcubemanager:SetOverrideColourCube(_G.resolvefilepath("images/colour_cubes/underworld_cc.tex"))
        world:RemoveComponent("birdspawner")
        TUNING.CREEPY_EYES = 
        {
            {maxsanity=1, maxeyes=24},
        }
    elseif mode == "willshead" then

    end
end)

--Debugging Stuff ---------------------------------------------------------------------------------------

AddSimPostInit(function(player)
    local mode = _G.SaveGameIndex.data.slots[_G.SaveGameIndex.current_slot].current_mode
    local item = _G.SpawnPrefab("bomb_suicide")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("bomb_retribution")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("anti_grue")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("chester_be_safe")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("life_vacuum")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("hat_mourning")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("pocket_jumper")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("orbofconfusion")
    player.components.inventory:GiveItem(item)
    item = _G.SpawnPrefab("mindshaker")
    player.components.inventory:GiveItem(item)
    local hell = _G.SpawnPrefab("hell_entrance")
    hell.Transform:SetPosition((player:GetPosition() + _G.Vector3(5, 0, 5)):Get())
    local underworld = _G.SpawnPrefab("underworld_entrance")
    underworld.Transform:SetPosition((player:GetPosition() - _G.Vector3(5, 0, 5)):Get())
    local merchant = _G.SpawnPrefab("merchant")
    merchant.Transform:SetPosition((player:GetPosition() + _G.Vector3(10, 0, 10)):Get())
    local surgery = _G.SpawnPrefab("surgery_bed")
    surgery.Transform:SetPosition((player:GetPosition() + _G.Vector3(10, 0, 12)):Get())
    local items = _G.SpawnPrefab("item_shop")
    items.Transform:SetPosition((player:GetPosition() + _G.Vector3(10, 0, 8)):Get())
end)

-------------Next portion of code done by simplex@KleiForums-----------------
-- need to add the component in here, otherwise OnSave doesn't work right
AddPrefabPostInit("world", function(inst)
    _G.assert( _G.GetPlayer() == nil )
    local player_prefab = _G.SaveGameIndex:GetSlotCharacter()
 
    -- Unfortunately, we can't add new postinits by now. So we have to do
    -- it the hard way...
 
    _G.TheSim:LoadPrefabs( {player_prefab} )
    local oldfn = _G.Prefabs[player_prefab].fn
    _G.Prefabs[player_prefab].fn = function()
        local inst = oldfn()
 
        -- Add components here.
        if not inst.components.upgradeable_eyp then
            inst:AddComponent("upgradeable_eyp")
        end
 
        return inst
    end
end)
-----------------------------------------------------------------------------

-----------------Next portion of code mainly done by simplex and/or debugman18@KleiForums-----------------
--This gives us custom worldgen screens.    
UIAnim = _G.require("widgets/uianim")

local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
    local mode = _G.SaveGameIndex.data.slots[_G.SaveGameIndex.current_slot].current_mode
    -- The old version only worked for the 1st save slot, because
    -- there's no selected slot in the SaveIndex when this runs.
    if mode == "hell" or mode == "underworld" or mode == "willshead" then       
        --Changes the background during worldgen.
        --[[self.bg:SetTexture("images/bg_gen.xml", "bg_plain.tex")
        self.bg:SetTint(140, 140, 100, 1)
        self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)]]
        
        --The shadow hands can be changed.
        local hand_scale = 1.5
        self.hand1:GetAnimState():SetBuild("willnpc")
        self.hand1:GetAnimState():SetBank("willnpc")
        self.hand1:GetAnimState():SetTime(math.random()*2)
        self.hand1:GetAnimState():PlayAnimation("hurt_front", true)
        self.hand1:SetPosition(400, 0, 0)
        self.hand1:SetScale(hand_scale,hand_scale,hand_scale)   
    
        --self.hand2 = self.bottom_root:AddChild(UIAnim())
        self.hand2:GetAnimState():SetBuild("willnpc")
        self.hand2:GetAnimState():SetBank("willnpc")
        self.hand2:GetAnimState():PlayAnimation("hurt_front", true)
        self.hand2:GetAnimState():SetTime(math.random()*2)
        self.hand2:SetPosition(-425, 0, 0)
        self.hand2:SetScale(-hand_scale,hand_scale,hand_scale)  
    
        --We can replace the worldgen animation and strings.
        self.worldanim:GetAnimState():SetBank("generating_cave")
        self.worldanim:GetAnimState():SetBuild("generating_cave")
        self.worldanim:GetAnimState():PlayAnimation("idle", true)
        
        self.worldgentext:SetString(_G.STRINGS.UI[string.upper(mode).."GEN"].TITLE)   
        self.verbs = _G.shuffleArray(_G.STRINGS.UI[string.upper(mode).."GEN"].VERBS)
        self.nouns = _G.shuffleArray(_G.STRINGS.UI[string.upper(mode).."GEN"].NOUNS)
        
    end
end

AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

--[[
-- This is quite ugly, but we need the ctor parameters.
--]]
--[[do
    local WorldGenScreen = _G.require "screens/worldgenscreen"
    local mt = _G.getmetatable(WorldGenScreen)

    local old_ctor = WorldGenScreen._ctor
    WorldGenScreen._ctor = function(...)
        old_ctor(...)
        UpdateWorldGenScreen(...)
    end
    local old_call = mt.__call
    mt.__call = function(class, ...)
        local self = old_call(class, ...)
        UpdateWorldGenScreen(self, ...)
        return self
    end
end]]