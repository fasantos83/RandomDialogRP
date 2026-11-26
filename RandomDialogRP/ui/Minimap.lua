-- Minimap button and positioning.

RandomDialogRPMinimapButton = CreateFrame("Button", "RandomDialogRPMinimapButton", Minimap)
RandomDialogRPMinimapButton:SetSize(31, 31)
RandomDialogRPMinimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
RandomDialogRPMinimapButton:RegisterForClicks("LeftButtonUp")
RandomDialogRPMinimapButton:RegisterForDrag("LeftButton")

function MoveMinimapButton(angle)
    local rad = math.rad(angle)
    local radius = math.min(Minimap:GetWidth(), Minimap:GetHeight()) / 2 + 2
    local x = math.cos(rad) * radius
    local y = math.sin(rad) * radius
    RandomDialogRPMinimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function UpdateMinimapButtonVisibility()
    RandomDialogRPMinimapButton:SetShown(
        not RandomDialogRPDB.minimap or RandomDialogRPDB.minimap.visible ~= false
    )
end

function SetMinimapButtonVisible(visible)
    RandomDialogRPDB.minimap = RandomDialogRPDB.minimap or {}
    RandomDialogRPDB.minimap.visible = not not visible
    RandomDialogRP_Profiles.SaveActive()
    UpdateMinimapButtonVisibility()
    if RandomDialogRPMinimapToggle then
        RandomDialogRPMinimapToggle:SetChecked(visible)
    end
end

local iconTexture = RandomDialogRPMinimapButton:CreateTexture(nil, "BACKGROUND")
iconTexture:SetSize(20, 20)
iconTexture:SetPoint("CENTER", RandomDialogRPMinimapButton, "CENTER", 0, 0)
iconTexture:SetTexture("Interface\\Icons\\Spell_Nature_HealingTouch")

local borderTexture = RandomDialogRPMinimapButton:CreateTexture(nil, "OVERLAY")
borderTexture:SetSize(53, 53)
borderTexture:SetPoint("CENTER", RandomDialogRPMinimapButton, "CENTER", 11, -11)
borderTexture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

RandomDialogRPMinimapButton:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local cx, cy = Minimap:GetCenter()
        local x, y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        x, y = x / scale, y / scale
        local angle = math.deg(math.atan2(y - cy, x - cx))
        MoveMinimapButton(angle)
        RandomDialogRPDB.minimap.angle = angle
    end)
end)

RandomDialogRPMinimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

RandomDialogRPMinimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        local frame = _G.RandomDialogRPFrame
        if frame:IsShown() then frame:Hide() else frame:Show() end
    end
end)

RandomDialogRPMinimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("RandomDialogRP", 1, 1, 1)
    GameTooltip:AddLine("Left-click to toggle main panel.", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Drag to move around minimap.", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

RandomDialogRPMinimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

UpdateMinimapButtonVisibility()
