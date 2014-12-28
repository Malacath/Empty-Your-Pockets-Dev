local Shopkeeper = Class(function(self, inst)
	self.inst = inst
	self.upgrades = "standard"
	self.shop_sections = {}
	self.speech = STRINGS.SHOPKEEPER.DEFAULT
	self.doestrade = true
end)

function Shopkeeper:OnSave(data)
	data = {}
	data.doestrade = self.doestrade
	data.shop_sections = self.shop_sections
	data.upgrades = self.upgrades
end

function Shopkeeper:OnLoad(data)
	self.doestrade = data.doestrade
	self.shop_sections = data.shop_sections
	self.upgrades = data.upgrades
end

function Shopkeeper:AddSection(section)
	if section.components.shopsection then
		self.shop_sections[section.prefab] = section
		section.components.shopsection:LinkWithShop(self.inst)
	end
end

function Shopkeeper:SetUpgrades(upgrades)
	self.upgrades = upgrades
end

function Shopkeeper:SetSpeech(speech)
	self.speech = speech
end

function Shopkeeper:CollectSceneActions(doer, actions)
	if doer == GetPlayer() and self.upgrades then 
		table.insert(actions, ACTIONS.TRADE_EYP)
	end
end

function Shopkeeper:OnNear()
	self.inst.components.talker:Say(self.speech.INTRO)
end

function Shopkeeper:OnFar()
	self.inst.components.talker:Say(self.speech.GOODBYE)
end

function Shopkeeper:OnAttack(data)
	--[[self.inst:DoTaskInTime(0.5, function() self.inst.components.talker:Say(self.speech.ATTACK) end)
	for k = 1, 3 do
		local spider = SpawnPrefab("spider_warrior")
		spider:SetPosition(data.attacker:GetPostion():Get())
		spider.components.combat:SuggestTarget(data.attacker)
	end]]
end

function Shopkeeper:InitiateTrade(trader, section)
	self.inst.sg:GoToState("trade", {trader = trader, section = section})
end

function Shopkeeper:OpenShop(trader, section)
	local ShopScreen = require "screens/shopdialog"
	local Upgrades = require("shop/"..self.upgrades)
	if section then
		Upgrades = require("shop/"..section.components.shopsection.upgrades)
	end
	if Upgrades then
		TheFrontEnd:PushScreen(
			ShopScreen(
				"Trove of Treasures",
				Upgrades
			)
		)
	end
end

function Shopkeeper:Initialize()
	self.inst:AddComponent("playerprox")
	self.inst.components.playerprox:SetDist(10, 13)
	self.inst.components.playerprox:SetOnPlayerNear(function(inst) self:OnNear() end)
	self.inst.components.playerprox:SetOnPlayerFar(function(inst) self:OnFar() end)

	self.inst:ListenForEvent("attacked", function(inst, data) self:OnAttack(data) end)
end

return Shopkeeper