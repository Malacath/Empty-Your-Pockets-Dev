
--[[I used the common makehat function.

The Mourning Helm:
the wearer loses sanity,
but more sanity is lost, more the damage absorption will be.

It also induces sad sayings ..

Lawrence Caustic Sorrow

--]]
    local SADNESS = {
        "*Sigh*",
        "It's useless...",
        "Life... Sucks...",
        "Please...",
        "Dust to dust...",
        "*Sob*",
        "I want to go home...",
        "I'm going to die.",
        "Why... Why?",
        "I feel awful.",
    }
    local assets=
    {
        Asset("ANIM", "anim/hat_bee.zip"),
        --Asset("IMAGE", texture),
    }
    
	local function makesad(inst, owner)

		local sanity = owner.components.sanity:GetPercent()
	
		if owner.components.sanity:GetPercent() >= .1 then
			owner.components.sanity:DoDelta(-0.25, true)
		end
	
		local absorption = (0.9-sanity)
	
		if absorption >= 1 then --prevents too much or too small protection
			absorption = 0.9
		elseif absorption <= 0.09 then --with this, the protection goes > 0.1 when sanity.percent is less than .8
			absorption = 0.1
		end
	
		inst.components.armor:SetAbsorption(absorption)
	
		--print("absorption=", absorption)
	
	end
	
	local function RandomTalk(sayings) 
		return sayings[math.random(#sayings)]
	end
	
	local function Iwannadie(inst, owner)

		if owner.components.talker then
			owner.components.talker:Say(RandomTalk(SADNESS))
		end
	
	end
	
	local function mourning_onunequip(inst, owner)
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAIR")
        end

        if inst.task then inst.task:Cancel() inst.task = nil end
		if inst.sorrow then inst.sorrow:Cancel() inst.sorrow = nil end

    end
	
	local function mourning_onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_hat", "hat_bee", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
        
        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAIR")
        end
		
		inst.task = inst:DoPeriodicTask(1, function() makesad(inst, owner) end)
		inst.sorrow = inst:DoPeriodicTask(math.random(10,20), function() Iwannadie(inst, owner) end)
		
    end
	
	local function fn()
		local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("beehat")
        inst.AnimState:SetBuild("hat_bee")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

        inst:AddComponent("armor")
        inst:AddTag("metal")
        inst.components.armor:InitCondition(430, 0.1)

        inst.components.equippable:SetOnEquip(mourning_onequip)
        inst.components.equippable:SetOnUnequip(mourning_onunequip)

        return inst
	end

return  Prefab( "common/inventory/hat_mourning", fn, assets, prefabs)