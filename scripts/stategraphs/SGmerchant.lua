require("stategraphs/commonstates")
local FollowText = require "widgets/followtext"

local function GetShopString(strings, trader, section)
    if type(strings) == "string" then
        return strings
    end

    if trader and strings[string.upper(trader.prefab)] then
        return strings[string.upper(trader.prefab)]
    else
        return strings.GENERIC
    end

    print("String not found--"..tostring(section.prefab))
    return nil
end

local actionhandlers = {
}


local events=
{
    EventHandler("ontalk", function(inst, data)
        if inst.sg:HasStateTag("idle") then
            inst.sg:GoToState("talk", data.noanim)
        end
        
    end),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle"},
        onenter = function(inst)            
            inst.AnimState:PushAnimation("idle", true)            
            inst.sg:SetTimeout(math.random()*4+2)
        end,
        
        ontimeout= function(inst)
            inst.sg:GoToState("funnyidle")
        end,
    },

    State{
        name = "funnyidle",
        tags = {"idle"},
        onenter = function(inst)            
            inst.AnimState:PushAnimation("talk_test")
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "talk",
        tags = {"idle", "talking"},
        
        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            if not noanim then
                inst.AnimState:PlayAnimation("talk_test", true)
            end

            inst.SoundEmitter:PlaySound("dontstarve/characters/merchant/talk_LP", "talk")

            inst.sg:SetTimeout(1.5 + math.random()*.5)
        end,
        
        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("talk")
            inst.sg:GoToState("idle")
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
        
        events=
        {
            EventHandler("donetalking", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "trade",
        tags = {"idle", "talking"},
        
        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("talk_new_test", true)

            inst.SoundEmitter:PlaySound("dontstarve/characters/merchant/talk_LP", "talk")

            if not inst.components.talker.widget then
                inst.components.talker.widget = GetPlayer().HUD:AddChild(FollowText("talkingfont", inst.components.talker.fontsize or 35))
            end
            inst.components.talker.widget.symbol = inst.components.talker.symbol
            inst.components.talker.widget:SetOffset(inst.components.talker.offset)
            inst.components.talker.widget:SetTarget(inst)
            local string = GetShopString(inst.components.shopkeeper.speech.INTRODUCE_SHOP, data.trader, inst) or string
            --[[if data.section then
                string = GetShopString(inst.components.shopkeeper.speech.INTRODUCE_SHOP[data.section.prefab], data.trader, data.section)
            end]]
            inst.components.talker.widget.text:SetString(string)

            inst.sg:SetTimeout(2)

            inst.trader = data.trader
            inst.section = data.section
        end,
        
        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("talk")
            inst.sg:GoToState("idle")
            if inst.components.talker.widget then
                inst.components.talker.widget:Kill()    
                inst.components.talker.widget = nil
            end
            inst.components.shopkeeper:OpenShop(inst.trader, inst.section)
            inst.trader = nil
            inst.section = nil
        end,
    },
}

return StateGraph("merchant", states, events, "idle", actionhandlers)