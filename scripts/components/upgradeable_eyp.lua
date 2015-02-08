local Upgradable_Eyp = Class(function(self, inst)
	self.inst = inst
	self.applied = {}
	self.upgradesources = {"standard"}
	self.money = 0
	self.discount = 0
end)

function Upgradable_Eyp:OnSave()
	local data = {}
	data.discount = self.discount
	data.applied = self.applied
end

function Upgradable_Eyp:OnLoad(date)
	if data then
		for _, source in pairs(self.upgradesources) do
			local upgrade_source = require("shop/"..source)
			for _, upgrade_branch in pairs(upgrade_source) do
			    for _, upgrade_in_branch in pairs(upgrade_branch) do
			    	for _, applied_upgrade in pairs(data.applied) do
			    		if applied_upgrade == upgrade_in_branch.name and not upgrade_in_branch.noload then
			    			self:ApplyUpgrade(upgrade_in_branch, true)
			    		end
			    	end
			   	end
			end
		end
		self.discount = data.discount
	end
end

function Upgradable_Eyp:SetDiscount(discount)
	self.discount = discount
	--can also be used to increase prices
end 

function Upgradable_Eyp:MoneyDelta(amount)
	self.money = self.money + amount
	self.inst:PushEvent("moneydelta", {money = self.money})
end

function Upgradable_Eyp:AddSource(source)
	if type(source) == "string" then
		table.insert(self.upgradesources, source)
	end
end

function Upgradable_Eyp:ApplyUpgrade(upgrade, payed)
	upgrade.effectfn(self.inst)
	if not upgrade.multi then
		table.insert(self.applied, upgrade.name)
	end
	if not payed then
		self:RemoveCost(upgrade)
	end
end

function Upgradable_Eyp:HasUpgrade(upgrade)
	for _, applied_upgrade in pairs(self.applied) do
		if applied_upgrade == upgrade.name then
			return true
		end
	end

	return false
end

function Upgradable_Eyp:RemoveCost(upgrade)
    for k, v in pairs(upgrade.cost) do
    	local cost = math.max(1, math.floor(v*(1 - self.discount)))
    	if k ~= "silver" then
        	self.inst.components.inventory:ConsumeByName(k, cost)
        else
        	self:MoneyDelta(-cost)
        end
    end
end

function Upgradable_Eyp:CanBuy(upgrade)
	if true or not upgrade or self.freebuymode then
		return true
	end

    for k, v in pairs(upgrade.cost) do
    	local amt = math.max(1, math.floor(v*(1 - self.discount)))
    	if k ~= "silver" then
	        if not self.inst.components.inventory:Has(k, amt) then
	            return false
	        end
	    else
	    	if self.money < amt then
	    		return false
	    	end
	    end
    end

    if upgrade.nolevels then
    	return true
    end

    for _, source in pairs(self.upgradesources) do
    	local upgrade_source = require("shop/"..source)
    	for _, upgrade_branch in pairs(upgrade_source) do
	    	for level, upgrade_in_branch in pairs(upgrade_branch) do
	    		if upgrade_in_branch.name == upgrade.name  and level ~= 1 then
	    			for _, applied_upgrade in pairs(self.applied) do
	    				if applied_upgrade == upgrade_branch[level-1].name then
	    					return true
	    				end
	    			end
	    		elseif upgrade_in_branch.name == upgrade.name and level == 1 then
	    			return true
	    		end
	    	end
    	end
    end

    return false
end

return Upgradable_Eyp