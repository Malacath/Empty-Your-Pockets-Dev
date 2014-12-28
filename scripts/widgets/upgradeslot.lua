require "class"

local TileBG = require "widgets/tilebg"
local InventorySlot = require "widgets/invslot"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TabGroup = require "widgets/tabgroup"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local RecipeTile = require "widgets/recipetile"
local UpgradePopup = require "widgets/upgradepopup"

function DoUpgradeClick(owner, upgrade)
    
    if upgrade and owner and owner.components.builder then
        local can_buy = owner.components.upgradeable:CanBuy(upgrade)
        local has = owner.components.upgradeable:HasUpgrade(upgrade)

        if can_buy and not has then
            --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            owner.components.upgradeable:ApplyUpgrade(upgrade)
            return true
        else
            return false
        end        
    end
end

require "widgets/widgetutil"

local UpgradeSlot = Class(Widget, function(self, atlas, bgim, owner)
    Widget._ctor(self, "Upgradeslot")
    self.owner = owner
    
    self.atlas = atlas
    self.bgimage = self:AddChild(Image(atlas, bgim))
    
    self.tile = self:AddChild(RecipeTile(nil))
    self.fgimage = self:AddChild(Image("images/hud.xml", "craft_slot_locked.tex"))
    self.fgimage:Hide()
end)

function UpgradeSlot:EnablePopup()
    if not self.upgradepopup then
        self.upgradepopup = self:AddChild(UpgradePopup())
        self.upgradepopup:SetPosition(0,-20,0)
        self.upgradepopup:Hide()
        local s = 1.25
        self.upgradepopup:SetScale(s,s,s)
    end
end

function UpgradeSlot:OnGainFocus()
    UpgradeSlot._base.OnGainFocus(self)
    self:Open()
end

function UpgradeSlot:OnControl(control, down)
    if UpgradeSlot._base.OnControl(self, control, down) then return true end

    if not down and control == CONTROL_ACCEPT then
        if self.owner and self.upgrade then
            if self.upgradepopup and not self.upgradepopup.focus then 
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                if DoUpgradeClick(self.owner, self.upgrade) then
                    self:Close()
                    self.parent.parent:UpdateUpgrades()
                end
                return true
            end
        end
    end
end


function UpgradeSlot:OnLoseFocus()
    UpgradeSlot._base.OnLoseFocus(self)
    self:Close()
end


function UpgradeSlot:Clear()
    self.upgradename = nil
    self.upgrade = nil
    
    if self.tile then
        self.tile:Hide()
    end
end

function UpgradeSlot:LockOpen()
	self:Open()
	self.locked = true
    if self.upgradepopup then
	    self.upgradepopup:SetPosition(-300,-300,0)
    end
end

function UpgradeSlot:Open()
    if self.upgradepopup then
        self.upgradepopup:SetPosition(0,-20,0)
    end
    self.open = true
    self:ShowUpgrade()
    self.owner.SoundEmitter:PlaySound("dontstarve/HUD/click_mouseover")
end

function UpgradeSlot:Close()
    self.open = false
    self.locked = false
    self:HideUpgrade()
end

function UpgradeSlot:ShowUpgrade()
    if self.upgrade and self.upgradepopup then
        self:MoveToFront()
        self.upgradepopup:Show()
        self.upgradepopup:SetUpgrade(self.upgrade, self.owner)
    end
end

function UpgradeSlot:HideUpgrade()
    if self.upgradepopup then
        self.upgradepopup:Hide()
    end
end


function UpgradeSlot:SetUpgrade(upgrade)
    if not upgrade then
        self.fgimage:Hide()
        return
    end

    self:Show()
    local canbuy = self.owner.components.upgradeable:CanBuy(upgrade)
    local has = self.owner.components.upgradeable:HasUpgrade(upgrade)
    
    self.upgrade = upgrade
    if self.upgrade and type(self.upgrade) == "table" then
        self.canbuy = canbuy
        --self.tile:SetRecipe({atlas = "images/"..self.upgrade.image..".xml", image = self.upgrade.image})
        self.tile:SetRecipe({atlas = "images/inventoryimages/"..self.upgrade.image..".xml", image = self.upgrade.image..".tex"})
        --self.tile:SetRecipe({atlas = "inventoryimages.xml", image = "axe.tex"})
        self.tile:Show()

        if self.fgimage then
            self.tile:SetCanBuild(true)
            if canbuy and not has then
                self.fgimage:Hide()
            elseif has then
                self.fgimage:Hide()
                self.tile:SetCanBuild(false)
            else
                local hud_atlas = resolvefilepath( "images/hud.xml" )
                
                if not canbuy then
                    self.fgimage:SetTexture(hud_atlas, "upgrade_slot_locked.tex")
                end
                
                self.fgimage:Show()
            end
        end

        if self.upgradepopup then
            self.upgradepopup:SetUpgrade(self.upgrade, self.owner)
        end
        
        --self:HideUpgrade()
    end
end


return UpgradeSlot
