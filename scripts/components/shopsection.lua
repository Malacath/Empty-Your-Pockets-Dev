local Shopsection = Class(function(self, inst)
	self.inst = inst
	self.upgrades = "standard"
	self.doestrade = true
	self.parent = nil
	self.inst:DoTaskInTime(0, function()
		self:FindShopInProximity(45)
	end)
end)

function Shopsection:OnSave(data)
	data = {}
	data.doestrade = self.doestrade
	data.upgrades = self.upgrades
	data.parent = self.parent
end

function Shopsection:OnLoad(data)
	if data then
		self.doestrade = data.doestrade
		self.upgrades = data.upgrades
		self.parent = data.parent
	end
end

function Shopsection:FindShopInProximity(rad)
	if not self.parent then
		local pos = self.inst:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, rad)
		for _, ent in pairs(ents) do
			print(tostring(ent))
			if ent.components.shopkeeper then
				ent.components.shopkeeper:AddSection(self.inst)
				break
			end
		end
	end
end

function Shopsection:SetUpgrades(upgrades)
	self.upgrades = upgrades
end

function Shopsection:CollectSceneActions(doer, actions)
	if doer == GetPlayer() then 
		table.insert(actions, ACTIONS.TRADE_EYP)
	end
end

function Shopsection:LinkWithShop(shop)
	self.parent = shop
end

return Shopsection