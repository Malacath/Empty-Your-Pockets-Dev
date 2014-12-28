local data = {
    anti_grue = {
        "idle",
        "idle_on",
    },
    chester_be_safe = {
        "idle",
    },
    bomb_suicide = {
        "idle",
        "nearexplode",
        "explode",
    },
    itemshop = {
        "idle",
    },
    itemshop = {
        "idle",
    }
}
 
 
local assets = {}
for b in pairs(data) do
    table.insert(assets, Asset("ANIM", "anim/"..b..".zip"))
end
 
 
local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
     
    inst:AddComponent("talker")
    local Say = function(...) return inst.components.talker:Say(...) end
 
    inst:StartThread(function()
        for b, v in pairs(data) do
            anim:SetBank(b)
            anim:SetBuild(b)
 
            for _, a in ipairs(v) do
                Say(b.."\n"..a)
                anim:PlayAnimation(a, true)
                Sleep(3)
            end
        end
    end)
     
    return inst
end
 
return Prefab( "common/inventory/simplextest", fn, assets)