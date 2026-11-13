-- Main panel UI.
frame = CreateFrame("Frame", "RandomDialogRPFrame", UIParent, "BackdropTemplate")
frame:SetSize(390, 240)
frame:SetFrameStrata("MEDIUM")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:SetClampedToScreen(true)
RegisterResponsiveFrame(frame)
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(0.045, 0.04, 0.028, 1)
frame:SetBackdropBorderColor(0.36, 0.32, 0.17, 1)

local titleBar = frame:CreateTexture(nil, "BACKGROUND")
titleBar:SetColorTexture(0.035, 0.032, 0.025, 0.96)
titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
titleBar:SetHeight(28)

local dropdownArea = frame:CreateTexture(nil, "BACKGROUND")
dropdownArea:SetColorTexture(0.09, 0.08, 0.055, 0.45)
dropdownArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -30)
dropdownArea:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -133)

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

title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -12)
title:SetText("RandomDialogRP")
title:SetTextColor(1, 0.82, 0)

mainPersonalityLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
mainPersonalityLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -32)
mainPersonalityLabel:SetText(L("personalityLabel"))
mainPersonalityLabel:SetTextColor(1, 0.84, 0.15)

mainPersonalityDropDown = CreateFrame("Frame", "RandomDialogRPMainPersonalityDropDown", frame, "UIDropDownMenuTemplate")
mainPersonalityDropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -42)
UIDropDownMenu_SetWidth(mainPersonalityDropDown, 125)

phraseOrderLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseOrderLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 170, -32)
phraseOrderLabel:SetText(L("phraseOrderLabel"))
phraseOrderLabel:SetTextColor(0.9, 0.78, 0.35)

phraseOrderValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
phraseOrderValue:SetPoint("TOPLEFT", frame, "TOPLEFT", 170, -47)
phraseOrderValue:SetWidth(210)
phraseOrderValue:SetText(L("phraseOrderValue"))
phraseOrderValue:SetTextColor(1, 0.84, 0.15)

raceLabelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
raceLabelText:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -85)
raceLabelText:SetText(L("raceLabel"))
raceLabelText:SetTextColor(1, 0.84, 0.15)

dropDown = CreateFrame("Frame", "RandomDialogRPRaceDropDown", frame, "UIDropDownMenuTemplate")
dropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -95)
UIDropDownMenu_SetWidth(dropDown, 85)

classLabelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
classLabelText:SetPoint("TOPLEFT", frame, "TOPLEFT", 145, -85)
classLabelText:SetText(L("phraseClassLabel"))
classLabelText:SetTextColor(1, 0.84, 0.15)

classDropDown = CreateFrame("Frame", "RandomDialogRPClassDropDown", frame, "UIDropDownMenuTemplate")
classDropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 135, -95)
UIDropDownMenu_SetWidth(classDropDown, 85)

chatChannelLabelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
chatChannelLabelText:SetPoint("TOPLEFT", frame, "TOPLEFT", 270, -85)
chatChannelLabelText:SetText(L("chatChannelLabel"))
chatChannelLabelText:SetTextColor(1, 0.84, 0.15)

chatChannelDropDown = CreateFrame("Frame", "RandomDialogRPChatChannelDropDown", frame, "UIDropDownMenuTemplate")
chatChannelDropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 260, -95)
UIDropDownMenu_SetWidth(chatChannelDropDown, 85)

function MainClassDropDown_OnClick(self)
    currentClass = self.value
    RandomDialogRPDB.rpClass = currentClass
    UIDropDownMenu_SetSelectedValue(classDropDown, currentClass)
    UIDropDownMenu_SetText(
        classDropDown,
        currentClass == "NONE" and L("noneClass") or GetPhraseClassName(currentClass)
    )
    RandomDialogRP_Profiles.SaveActive()
end

function MainClassDropDown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = L("noneClass")
    info.value = "NONE"
    info.func = MainClassDropDown_OnClick
    info.checked = currentClass == nil or currentClass == "NONE"
    UIDropDownMenu_AddButton(info, level)

    local availableClasses = phraseRaceClasses[currentRace]
    for _, classToken in ipairs(phraseClassOrder) do
        if availableClasses and availableClasses[classToken] then
            info = UIDropDownMenu_CreateInfo()
            info.text = GetPhraseClassName(classToken)
            info.value = classToken
            info.func = MainClassDropDown_OnClick
            info.checked = currentClass == classToken
            UIDropDownMenu_AddButton(info, level)
        end
    end
end
UIDropDownMenu_Initialize(classDropDown, MainClassDropDown_Initialize)

function RefreshMainClassDropDown()
    if initialized and currentClass == nil then
        local _, playerClass = UnitClass("player")
        currentClass = IsClassAvailableForRace(currentRace, playerClass) and playerClass or "NONE"
        RandomDialogRPDB.rpClass = currentClass
        RandomDialogRP_Profiles.SaveActive()
    end
    if initialized and currentClass and currentClass ~= "NONE"
        and not IsClassAvailableForRace(currentRace, currentClass) then
        currentClass = "NONE"
        RandomDialogRPDB.rpClass = currentClass
    end
    local displayedClass = currentClass or "NONE"
    UIDropDownMenu_SetSelectedValue(classDropDown, displayedClass)
    UIDropDownMenu_SetText(
        classDropDown,
        displayedClass == "NONE" and L("noneClass") or GetPhraseClassName(displayedClass)
    )
end

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

function RefreshMainPersonalityDropDown()
    local personality = RandomDialogRPDB.activePersonality or "Default"
    UIDropDownMenu_SetSelectedValue(mainPersonalityDropDown, personality)
    UIDropDownMenu_SetText(mainPersonalityDropDown, personality)
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
        local info = UIDropDownMenu_CreateInfo()
        info.text = raceName
        info.value = raceName
        info.func = DropDown_OnClick
        info.checked = (currentRace == raceName)
        UIDropDownMenu_AddButton(info, level)
    end
end

actionSectionDivider = frame:CreateTexture(nil, "ARTWORK")
actionSectionDivider:SetColorTexture(0.36, 0.32, 0.17, 0.75)
actionSectionDivider:SetHeight(1)
actionSectionDivider:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -133)
actionSectionDivider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -133)

actionSectionTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
actionSectionTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -141)
actionSectionTitle:SetTextColor(1, 0.84, 0.15)

function RefreshMainPanelLabels()
    mainPersonalityLabel:SetText(L("personalityLabel"))
    phraseOrderLabel:SetText(L("phraseOrderLabel"))
    phraseOrderValue:SetText(L("phraseOrderValue"))
    RefreshMainPersonalityDropDown()
    raceLabelText:SetText(L("raceLabel"))
    classLabelText:SetText(L("phraseClassLabel"))
    chatChannelLabelText:SetText(L("chatChannelLabel"))
    actionSectionTitle:SetText(L("actionSectionTitle"))
    raceLabelText:SetTextColor(1, 0.84, 0.15)
    classLabelText:SetTextColor(1, 0.84, 0.15)
    chatChannelLabelText:SetTextColor(1, 0.84, 0.15)
    actionSectionTitle:SetTextColor(1, 0.84, 0.15)
    if initialized then RefreshMainClassDropDown() end
end

RefreshMainPanelLabels()

-- Action Buttons Helper
function CreateActionButton(category, posX, posY)
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(145, 24)
    btn:SetPoint("TOP", frame, "TOP", posX, posY)

    local buttonText = btn:GetFontString()
    buttonTexts[category] = { btn = btn }
    btn:SetText(GetCategoryLabel(category))
    RandomDialogRP_UI.StyleButton(btn)

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
    frame:SetHeight(math.max(260, 176 + (rowCount * 30)))
    RandomDialogRP_UI.RefreshResponsiveFrames()
    for index, category in ipairs(categories) do
        local column = (index - 1) % 2
        local row = math.floor((index - 1) / 2)
        local posX = column == 0 and -78 or 78
        local button = CreateActionButton(category, posX, -157 - (row * 30))
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
RandomDialogRP_UI.StyleButton(configBtn)

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

-- ============================================================================
-- 2. PHRASE MANAGER UI
