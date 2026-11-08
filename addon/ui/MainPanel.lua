-- Main panel UI.
frame = CreateFrame("Frame", "RandomDialogRPFrame", UIParent, "BackdropTemplate")
frame:SetSize(390, 215)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:SetClampedToScreen(true)
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(0, 0, 0, 0.75)
frame:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)

frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
    RandomDialogRPDB.panel.point = point
    RandomDialogRPDB.panel.relativePoint = relativePoint
    RandomDialogRPDB.panel.xOfs = xOfs
    RandomDialogRPDB.panel.yOfs = yOfs
end)

title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
title:SetPoint("TOP", frame, "TOP", 0, -8)
title:SetText("RandomDialogRP")

-- Race Dropdown
dropDown = CreateFrame("Frame", "RandomDialogRPRaceDropDown", frame, "UIDropDownMenuTemplate")
dropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 26, -38)
UIDropDownMenu_SetWidth(dropDown, 110)

-- Chat channel dropdown
chatChannelDropDown = CreateFrame("Frame", "RandomDialogRPChatChannelDropDown", frame, "UIDropDownMenuTemplate")
chatChannelDropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 182, -38)
UIDropDownMenu_SetWidth(chatChannelDropDown, 95)

function ChatChannelDropDown_OnClick(self)
    RandomDialogRPDB.chatChannel = self.value
    UIDropDownMenu_SetSelectedValue(chatChannelDropDown, self.value)
    for _, option in ipairs(chatChannels) do
        if option.value == self.value then
            UIDropDownMenu_SetText(chatChannelDropDown, L(option.label))
            break
        end
    end
    RandomDialogRP_Profiles.SaveActive()
end

function ChatChannelDropDown_Initialize(self, level)
    for _, channel in ipairs(chatChannels) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = L(channel.label)
        info.value = channel.value
        info.label = channel.label
        info.func = ChatChannelDropDown_OnClick
        info.checked = (RandomDialogRPDB.chatChannel == channel.value)
        UIDropDownMenu_AddButton(info, level)
    end
end

UIDropDownMenu_Initialize(chatChannelDropDown, ChatChannelDropDown_Initialize)

function RefreshChatChannelDropDown()
    local channel = RandomDialogRPDB.chatChannel or "SAY"
    UIDropDownMenu_SetSelectedValue(chatChannelDropDown, channel)
    for _, option in ipairs(chatChannels) do
        if option.value == channel then
            UIDropDownMenu_SetText(chatChannelDropDown, L(option.label))
            break
        end
    end
end

DropDown_OnClick = nil

-- Ordem exata: Aliança, Horda e Skyborne no fim
raceOrder = {
    "Human", "Dwarf", "NightElf", "Gnome",
    "Orc", "Troll", "Tauren", "Undead",
    "Skyborne"
}

function DropDown_Initialize(self, level)
    for _, raceName in ipairs(raceOrder) do
        if RandomDialogRP_CustomDB[raceName] then
            local info = UIDropDownMenu_CreateInfo()
            info.text = raceName
            info.value = raceName
            info.func = DropDown_OnClick
            info.checked = (currentRace == raceName)
            UIDropDownMenu_AddButton(info, level)
        end
    end
end

-- Action Buttons Helper
function CreateActionButton(category, posX, posY)
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(145, 24)
    btn:SetPoint("TOP", frame, "TOP", posX, posY)
    
    local buttonText = btn:GetFontString()
    buttonTexts[category] = { btn = btn }
    btn:SetText(GetCategoryLabel(category))
    
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("LEFT", btn, "LEFT", 6, 0)
    icon:SetTexture(GetCategoryIcon(category))
    
    if buttonText then
        buttonText:ClearAllPoints()
        buttonText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
        buttonText:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
    end
    
    btn:SetScript("OnClick", function()
        ExecuteRP(category)
    end)
    
    return btn
end

function RefreshActionButtons()
    for _, data in pairs(buttonTexts) do data.btn:Hide() end
    buttonTexts = {}
    local categories = GetCategories(currentRace)
    local rowCount = math.ceil(#categories / 2)
    frame:SetHeight(math.max(215, 85 + (rowCount * 30)))
    for index, category in ipairs(categories) do
        local column = (index - 1) % 2
        local row = math.floor((index - 1) / 2)
        local posX = column == 0 and -78 or 78
        local button = CreateActionButton(category, posX, -70 - (row * 30))
        button:Show()
    end
end

-- Config/Settings Gear Button
closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)

configBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
configBtn:SetSize(24, 24)
configBtn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
configBtn:SetText("")

configIcon = configBtn:CreateTexture(nil, "ARTWORK")
configIcon:SetSize(16, 16)
configIcon:SetPoint("CENTER", configBtn, "CENTER", 0, 0)
configIcon:SetTexture("Interface\\Icons\\Trade_Engineering")

configBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(L("managerTitle"), 1, 1, 1)
    GameTooltip:Show()
end)
configBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

profileBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
profileBtn:SetSize(82, 24)
profileBtn:SetPoint("RIGHT", configBtn, "LEFT", -4, 0)
profileBtn:SetText(L("profileBtn"))
profileBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(L("profileTitle"), 1, 1, 1)
    GameTooltip:Show()
end)
profileBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- ============================================================================
-- 2. PHRASE MANAGER UI
