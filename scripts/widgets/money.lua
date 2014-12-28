local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"


local MoneyBadge = Class(Widget, function(self, owner)
    Widget._ctor(self, "MoneyBadge", owner)

    self.owner = owner

    self.amount = 0

    self.bg = self:AddChild(Image("images/hud_money.xml", "hud_money.tex"))
    self.bg:SetScale(1, 1, 1)
    self.bg:SetPosition(0, 0, 0)
    self.bg:Show()

    self.money_good = self.bg:AddChild(Image("images/money_new.xml", "money_new.tex"))
    self.money_good:SetScale(0.7, 0.7, 0.7)
    self.money_good:SetPosition(-65, 0, 0)
    self.money_good:Show()

    --[[self.money_bad = self.bg:AddChild(Image("images/money_bad.xml", "money_bad.tex"))
    self.money_bad:SetScale(0.9, 0.9, 0.9)
    self.money_bad:SetPosition(-75, 0, 0)
    self.money_bad:Hide()]]

    self.num = self.bg:AddChild(Text(NUMBERFONT, 56))
    self.num:SetHAlign(ANCHOR_LEFT)
    self.num:SetPosition(55, 0, 0)
    self.num:SetScale(1.2, 1.2, 1.2)
    self.num:Show()

    --[[self.numl = self:AddChild(Text(NUMBERFONT, 56))
    self.numl:SetHAlign(ANCHOR_MIDDLE)
    self.numl:SetPosition(11, 0, 0)
    self.numl:SetScale(1.2, 1.2, 1.2)
    self.numl:Show()

    self.numr = self:AddChild(Text(NUMBERFONT, 56))
    self.numr:SetHAlign(ANCHOR_MIDDLE)
    self.numr:SetPosition(-9.1, 0, 0)
    self.numr:SetScale(1.2, 1.2, 1.2)
    self.numr:Show()

    self.numlov = self:AddChild(Text(NUMBERFONT, 56))
    self.numlov:SetHAlign(ANCHOR_MIDDLE)
    self.numlov:SetPosition(10, 0, 0)
    self.numlov:SetScale(1, 1, 1)
    self.numlov:SetColour(0, 0, 0, 1)
    self.numlov:Show()

    self.numrov = self:AddChild(Text(NUMBERFONT, 56))
    self.numrov:SetHAlign(ANCHOR_MIDDLE)
    self.numrov:SetPosition(-10, 0, 0)
    self.numrov:SetScale(1, 1, 1)
    self.numrov:SetColour(0, 0, 0, 1)
    self.numrov:Show()]]
end)

function MoneyBadge:SetAmount(amount)
    local bad = amount < self.amount
    self.amount = amount
    self.num:SetString(tostring(self.amount))
    --[[if bad then
        self.money_good:Hide()
        self.money_bad:Show()
        self.owner:DoTaskInTime(0.4, function()   
            self.money_bad:Hide()
            self.money_good:Show()
        end)
    else
        self.money_good:SetScale(0.9, 0.9, 0.9)
        self.owner:DoTaskInTime(0.4, function()
            self.money_good:SetScale(0.7, 0.7, 0.7)
        end)
    end]]
    if bad then
        self.money_good:SetTint(1,0.2,0.2,1)
    end
    self.money_good:SetScale(0.9, 0.9, 0.9)
    self.owner:DoTaskInTime(0.3, function()
        self.money_good:SetScale(0.7, 0.7, 0.7)
        self.money_good:SetTint(1,1,1,1)
    end)
    --[[local left = tostring(self.amount%10)
    local right = tostring(self.amount-self.amount%10)
    self.numl:SetString(left)
    self.numr:SetString(right)
    self.numlov:SetString(left)
    self.numrov:SetString(right)]]
end

function MoneyBadge:DoDelta(amount)
    amount = math.max(0, self.amount + amount)
    self:SetAmount(amount)
end

return MoneyBadge