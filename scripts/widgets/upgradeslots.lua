require "class"

local TileBG = require "widgets/tilebg"
local InventorySlot = require "widgets/invslot"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TabGroup = require "widgets/tabgroup"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local UpgradeSlot = require "widgets/upgradeslot"

local UpgradeSlots = Class(Widget, function(self, num, owner)
    Widget._ctor(self, "UpgradeSlots")
    
    self.slots = {}
    for k = 1, num do
        local slot = UpgradeSlot(HUD_ATLAS, "craft_slot.tex", owner)
        self.slots[k] = slot
        self:AddChild(slot)
    end
end)

function UpgradeSlots:EnablePopups()
    for k,v in ipairs(self.slots) do
        v:EnablePopup()
    end
end

function UpgradeSlots:Open(idx)
	if idx > 0 and idx <= #self.slots then	
		self.slots[idx]:Open()
	end
end

function UpgradeSlots:LockOpen(idx)
	if idx > 0 and idx <= #self.slots then	
		self.slots[idx]:LockOpen()
	end
end

function UpgradeSlots:Clear()
    for k,v in ipairs(self.slots) do
        v:Clear()
    end
end

function UpgradeSlots:CloseAll()
    for k,v in ipairs(self.slots) do
        v:Close()
    end
end


return UpgradeSlots
