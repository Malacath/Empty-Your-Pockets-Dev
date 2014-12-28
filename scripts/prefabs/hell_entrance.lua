local BigPopupDialogScreen = require "screens/popupdialog"

local assets=
{
	Asset("ANIM", "anim/hell_entrance.zip"),
}

local function GetVerb(inst)
	return "Enter"
end

local function OnActivate(inst)
	SetPause(true, "hell_entrance")
	
	local function enter()
		local function onsaved()
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end
		TheFrontEnd:PopScreen()
		SetPause(false)
		GetPlayer().sg:GoToState("teleportato_teleport")
		GetPlayer():DoTaskInTime(5, function() SaveGameIndex:EnterArena(onsaved, "HELL") end)
	end

	local function reject()
		TheFrontEnd:PopScreen()
		SetPause(false) 
		inst.components.activatable.inactive = true
	end

	TheFrontEnd:PushScreen(BigPopupDialogScreen(STRINGS.HELL_ENTRANCE.TITLE, STRINGS.HELL_ENTRANCE.TEASER,
			{{text=STRINGS.HELL_ENTRANCE.ENTER, cb = enter},
			 {text=STRINGS.HELL_ENTRANCE.REJECT, cb = reject} }))
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 1)

    anim:SetBank("hell_entrance")
    anim:SetBuild("hell_entrance")
    anim:PlayAnimation("idle")
    anim:SetScale(1.3, 1.3, 1.3)

	inst:AddComponent("activatable")
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivate

	inst:AddComponent("inspectable")

    return inst
end

return Prefab( "common/hell_entrance", fn, assets)
