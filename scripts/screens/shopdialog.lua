local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Menu = require "widgets/menu"
local Shopping = require "widgets/shopping"
local Crafting = require "widgets/crafting"


local ShopDialogScreen = Class(Screen, function(self, title, upgrades)
	Screen._ctor(self, "ShopDialogScreen")

	self.upgrades = upgrades

	--darken everything behind the dialog
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,.75)	
    
	self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

	--throw up the background
    self.bg = self.proot:AddChild(Image("images/globalpanels.xml", "panel_upsell_small.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)	
	self.bg:SetScale(0.9,1.5,1.5)
	self.bg:SetPosition(0, -10, 0)
	
	--title	
    self.title = self.proot:AddChild(Text(TITLEFONT, 50))
    self.title:SetString(title)
    self.title:SetPosition(0, 235, 0)

    local num_upgrades = 0
    for k, v in pairs(upgrades) do num_upgrades = num_upgrades + 1 end
    --self.shopping = self.proot:AddChild(Shopping(num_upgrades, self.upgrades))
    self.shopping = self.proot:AddChild(Shopping(3, self.upgrades))

    local button = self.proot:AddChild(ImageButton())
	button:SetPosition(0, -245, 0)
	button:SetText("Goodbye")
	button.text:SetColour(0,0,0,1)
	button:SetOnClick(function() TheFrontEnd:PopScreen(self) end)
	button:SetFont(BUTTONFONT)
	button:SetTextSize(40)
end)



function ShopDialogScreen:OnUpdate( dt )
	if self.timeout then
		self.timeout.timeout = self.timeout.timeout - dt
		if self.timeout.timeout <= 0 then
			self.timeout.cb()
		end
	end
	return true
end

function ShopDialogScreen:OnControl(control, down)
    if ShopDialogScreen._base.OnControl(self,control, down) then 
        return true 
    end
end

return ShopDialogScreen
