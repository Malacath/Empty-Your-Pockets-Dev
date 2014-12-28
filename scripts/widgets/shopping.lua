require "class"

local TileBG = require "widgets/tilebg"
local InventorySlot = require "widgets/invslot"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TabGroup = require "widgets/tabgroup"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local UpgradeSlots = require "widgets/upgradeslots"

require "widgets/widgetutil"

local Shopping = Class(Widget, function(self, num_slots, upgrades)
    Widget._ctor(self, "Shopping")
    
	self.owner = GetPlayer()

    self.upgrades = upgrades

    self.bg = self:AddChild(TileBG(HUD_ATLAS, "craft_slotbg.tex"))

    --slots
    self.num_slots = num_slots
    num_slots = num_slots * 3
    self.upgradeslots = UpgradeSlots(num_slots, self.owner)
    self:AddChild(self.upgradeslots)

    --buttons
    self.downbutton = self:AddChild(ImageButton(HUD_ATLAS, "craft_end_normal.tex", "craft_end_normal_mouseover.tex", "craft_end_normal_disabled.tex"))
    self.upbutton = self:AddChild(ImageButton(HUD_ATLAS, "craft_end_normal.tex", "craft_end_normal_mouseover.tex", "craft_end_normal_disabled.tex"))
    self.downbutton:SetOnClick(function() self:ScrollDown() end)
    self.upbutton:SetOnClick(function() self:ScrollUp() end)

	-- start slightly scrolled down
    self.idx = -1
    self.scrolldir = true
    self:UpdateUpgrades()
    self:SetOrientation(false)
    self.upgradeslots:EnablePopups()
end)

function Shopping:SetOrientation(horizontal)
    self.horizontal = horizontal
    self.bg.horizontal = horizontal
    if horizontal then
        self.bg.sepim = "craft_sep_h.tex"
    else
        self.bg.sepim = "craft_sep.tex"
    end

    self.bg:SetNumTiles(self.num_slots)
    local slot_w, slot_h = self.bg:GetSlotSize()
    local w, h = self.bg:GetSize()
    local slot_idx = 1
    local slotpos = self.bg:GetSlotPos(1)
    local del_x = slot_w * 1.5
    local del_y = slot_h * 1.25
    
    for k = 1, #self.upgradeslots.slots, 3 do
        for m = -1, 1 do
            self.upgradeslots.slots[k + m + 1]:SetPosition( slotpos.x + m * del_x ,slotpos.y - del_y * (k - 1) / 3, 0 )
        end
    end

    local but_w, but_h = self.downbutton:GetSize()

    if horizontal then
        self.downbutton:SetRotation(90)
        self.downbutton:SetPosition(-self.bg.length/2 - but_w/2 + slot_w/2,0,0)
        self.upbutton:SetRotation(-90)
        self.upbutton:SetPosition(self.bg.length/2 + but_w/2 - slot_w/2,0,0)
    else
        self.upbutton:SetPosition(0, - self.bg.length/2 - but_h/2 + slot_h/2,0)
        self.downbutton:SetScale(Vector3(1, -1, 1))
        self.downbutton:SetPosition(0, self.bg.length/2 + but_h/2 - slot_h/2,0)
    end


end

function Shopping:UpdateUpgrades()
    self.upgradeslots:Clear()
    if self.owner and self.owner.components.upgradeable then
                
        local num = 0

        for k, v in pairs(self.upgrades) do num = num + 1 end

		if self.idx > num - (self.num_slots - 1)  then
			self.idx = num - (self.num_slots - 1)
		end 
        
        if self.idx < -1 then
            self.idx = -1
        end

        for k = 0, num - 1 do
            for m = 1, 3 do
                local upgrade_idx = (self.idx + k)
                local slot = self.upgradeslots.slots[3*k + m]
                
                if self.upgrades[upgrade_idx+1] then
                    local upgrade = self.upgrades[upgrade_idx+1][m]
                    if slot then
                        slot:SetUpgrade(upgrade)
                    end
                else
                    if slot then
                        slot:SetUpgrade()
                    end
                end
            end
        end
        
        if self.idx >= 0 then
    		self.downbutton:Enable()
    	else
    		self.downbutton:Disable()
    	end
    	
    	if num < self.idx + self.num_slots then  
    		self.upbutton:Disable()
        else
    		self.upbutton:Enable()
    	end

    end
end

function Shopping:ScrollUp()
	if not IsPaused() then
        self.idx = self.idx + 1
		self:UpdateUpgrades()
		
		self.owner.SoundEmitter:PlaySound("dontstarve/HUD/craft_up")
	end
end

function Shopping:ScrollDown()
	if not IsPaused() then
		self.idx = self.idx - 1
		self:UpdateUpgrades()
		self.owner.SoundEmitter:PlaySound("dontstarve/HUD/craft_down")
	end
end

return Shopping
