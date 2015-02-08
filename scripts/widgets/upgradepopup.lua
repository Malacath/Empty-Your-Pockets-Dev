require "class"

local TileBG = require "widgets/tilebg"
local InventorySlot = require "widgets/invslot"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TabGroup = require "widgets/tabgroup"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local IngredientUI = require "widgets/ingredientui"

require "widgets/widgetutil"

function DoUpgradeClick(owner, upgrade)
    
    if upgrade and owner and owner.components.upgradeable_eyp then
        local can_buy = owner.components.upgradeable_eyp:CanBuy(upgrade) 

        if can_buy then
            --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            owner.components.upgradeable_eyp:ApplyUpgrade(upgrade)

            return true
        else
            return false
        end        
    end
end

local UpgradePopup = Class(Widget, function(self, horizontal)
    Widget._ctor(self, "Upgrade Popup")
    
    local hud_atlas = resolvefilepath( "images/hud.xml" )

    self.bg = self:AddChild(Image())
    local img = horizontal and "craftingsubmenu_fullvertical.tex" or "craftingsubmenu_fullhorizontal.tex"
    
    if horizontal then
		self.bg:SetPosition(240,40,0)
    else
		self.bg:SetPosition(210,16,0)
    end
    self.bg:SetTexture(hud_atlas, img)
    
    --
    
    self.contents = self:AddChild(Widget(""))
    self.contents:SetPosition(-75,0,0)
    
    self.name = self.contents:AddChild(Text(UIFONT, 45))
    self.name:SetPosition(327, 142, 0)

    self.desc = self.contents:AddChild(Text(UIFONT, 30))
    self.desc:SetPosition(325, -5, 0)
    self.desc:SetRegionSize(64*3+30,70)
    self.desc:EnableWordWrap(true)
    
    self.ing = {}
    
    self.button = self.contents:AddChild(ImageButton(UI_ATLAS, "button.tex", "button_over.tex", "button_disabled.tex"))
    self.button:SetScale(.7,.7,.7)
    self.button:SetOnClick(function() if DoUpgradeClick(self.owner, self.upgrade) then
            self.parent.parent.parent:UpdateUpgrades()
        end
    end)
    
    self.upgradecost = self.contents:AddChild(Text(NUMBERFONT, 40))
    self.upgradecost:SetHAlign(ANCHOR_LEFT)
    self.upgradecost:SetRegionSize(80,50)
    self.upgradecost:SetPosition(420,-115,0)
    self.upgradecost:SetColour(255/255, 234/255,0/255, 1)
    
    self.teaser = self.contents:AddChild(Text(UIFONT, 30))
    self.teaser:SetPosition(325, -100, 0)
    self.teaser:SetRegionSize(64*3+20,70)
    self.teaser:EnableWordWrap(true)
    self.teaser:Hide()
    self:MoveToFront()
    
	local devices = TheInput:GetInputDevices()
	self.controller_id = devices[#devices].data
    
end)

function UpgradePopup:SetUpgrade(upgrade, owner)
    self.upgrade = upgrade
    self.owner = owner

    local can_buy = owner.components.upgradeable_eyp:CanBuy(upgrade)
    local has = owner.components.upgradeable_eyp:HasUpgrade(upgrade)
    if has then
        can_buy = false
    end
    
    self.teaser:Hide()
    self.upgradecost:Hide()
    
    if TheInput:ControllerAttached() then
		self.button:Hide()
		self.teaser:Show()
		if can_buy then
            self.teaser:SetString(TheInput:GetLocalizedControl(self.controller_id, CONTROL_ACCEPT).." "..STRINGS.UI.UPGRADES.BUY)
        else
            self.teaser:SetString(STRINGS.UI.UPGRADES.NEEDSTUFF)
        end
	else
		self.button:Show()
		self.button:SetPosition(320, -105, 0)
		self.button:SetScale(1,1,1)
           
		self.button:SetText(STRINGS.UI.UPGRADES.BUY)
		if can_buy then
			self.button:Enable()
		else
			self.button:Disable()
		end
    end

    self.name:SetString(self.upgrade.name)
    self.desc:SetString(self.upgrade.desc)
        
    for k,v in pairs(self.ing) do
         v:Kill()
    end
    self.ing = {}

    local center = 330
    local num = 0
    for k,v in pairs(upgrade.cost) do num = num + 1 end
    local w = 64
    local div = 10
        
    local offset = center
    if num > 1 then 
        offset = offset - (w/2 + div)*(num-1)
    end
    
    for k,v in pairs(upgrade.cost) do
    
        local has, num_found = owner.components.inventory:Has(k, v)
        if k == "silver" then
            num_found = owner.components.upgradeable_eyp.money
            has = (num_found >= v)
        end

        local newing = Ingredient(k, v)
        local ing
        if k == "silver" then
            ing = self.contents:AddChild(IngredientUI("images/inventoryimages/silver_onecoin.xml", "silver_onecoin.tex", newing.amount, num_found, has, STRINGS.NAMES[string.upper(newing.type)], owner))
        else
            ing = self.contents:AddChild(IngredientUI(newing.atlas, newing.type..".tex", newing.amount, num_found, has, STRINGS.NAMES[string.upper(newing.type)], owner))
        end
        ing:SetPosition(Vector3(offset, 80, 0))
        offset = offset + (w+ div)
        self.ing[k] = ing
    end

    self:MoveToFront()
end

return UpgradePopup