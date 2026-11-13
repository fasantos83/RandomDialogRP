-- Profile manager UI.
managerFrame = CreateFrame("Frame", "RandomDialogRPManager", UIParent, "BackdropTemplate")
managerFrame:SetSize(700, 560)
managerFrame:SetFrameStrata("DIALOG")
managerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
managerFrame:SetMovable(true)
managerFrame:EnableMouse(true)
managerFrame:SetClampedToScreen(true)
managerFrame:Hide()

managerFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
managerFrame:SetBackdropColor(0.045, 0.04, 0.028, 1)
managerFrame:SetBackdropBorderColor(0.36, 0.32, 0.17, 1)

managerFrame:RegisterForDrag("LeftButton")
managerFrame:SetScript("OnDragStart", managerFrame.StartMoving)
managerFrame:SetScript("OnDragStop", managerFrame.StopMovingOrSizing)
managerFrame:HookScript("OnShow", function(self) self:Raise() end)

managerTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
managerTitle:SetPoint("TOP", managerFrame, "TOP", 0, -10)
managerTitle:SetText(L("managerTitle"))

local getAddonMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
addonVersion = getAddonMetadata and getAddonMetadata("RandomDialogRP", "Version") or "Unknown"
managerVersionText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
managerVersionText:SetPoint("BOTTOMRIGHT", managerFrame, "BOTTOMRIGHT", -24, 22)
managerVersionText:SetJustifyH("RIGHT")
managerVersionText:SetTextColor(0.82, 0.74, 0.48)
managerVersionText:SetText(string.format(L("versionLabel"), addonVersion))

selectedCategory = "greetings"
editingIndex = nil
selectedManagerTab = "phrases"
RefreshManagerUI = nil
resetDataBtn = nil
profileDropDown = nil
profileNameBox = nil
selectedProfileName = nil
RefreshProfileUI = nil
personalityDropDown = nil
personalityNameBox = nil
selectedPersonalityName = nil
RefreshPersonalityUI = nil

function EnsureSelectedCategory()
    local categories = GetCategories(selectedPhraseRace or currentRace)
    for _, category in ipairs(categories) do
        if category == selectedCategory then return end
    end
    selectedCategory = categories[1]
    editingIndex = nil
end

RegisterResponsiveFrame(managerFrame)

personalityLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
personalityLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 130, -75)

personalityDropDown = CreateFrame("Frame", "RandomDialogRPPersonalityDropDown", managerFrame, "UIDropDownMenuTemplate")
personalityDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 120, -85)
UIDropDownMenu_SetWidth(personalityDropDown, 90)

local function GetPersonalityNames()
    local names = {}
    for name, data in pairs(RandomDialogRP_CustomDB) do
        if type(data) == "table" and type(data.categoryOrder) == "table" then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

local function RefreshAfterPersonalityChange()
    InitCustomDB()
    RandomDialogRP_Profiles.SaveActive()
    selectedCategory = "greetings"
    editingIndex = nil
    if editBox then editBox:SetText("") end
    EnsureSelectedCategory()
    RefreshActionButtons()
    RefreshManagerUI()
    RefreshPersonalityUI()
end

function PersonalityDropDown_OnClick(self)
    selectedPersonalityName = self.value
    if selectedPersonalityName == RandomDialogRPDB.activePersonality then
        RefreshPersonalityUI()
        return
    end
    if type(RandomDialogRP_CustomDB[selectedPersonalityName]) ~= "table" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityInvalid"))
        RefreshPersonalityUI()
        return
    end

    RandomDialogRPDB.activePersonality = selectedPersonalityName
    currentPersonality = selectedPersonalityName
    RefreshAfterPersonalityChange()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("personalityLoaded"))
end

function PersonalityDropDown_Initialize(self, level)
    for _, name in ipairs(GetPersonalityNames()) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = name
        info.value = name
        info.func = PersonalityDropDown_OnClick
        info.checked = name == RandomDialogRPDB.activePersonality
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_Initialize(personalityDropDown, PersonalityDropDown_Initialize)
UIDropDownMenu_Initialize(mainPersonalityDropDown, PersonalityDropDown_Initialize)

personalityNameLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
personalityNameLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 260, -75)

personalityNameBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
personalityNameBox:SetSize(90, 22)
personalityNameBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 255, -85)
personalityNameBox:SetAutoFocus(false)

createPersonalityBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
createPersonalityBtn:SetSize(58, 24)
createPersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 350, -85)

renamePersonalityBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
renamePersonalityBtn:SetSize(70, 24)
renamePersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 412, -85)

deletePersonalityBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
deletePersonalityBtn:SetSize(58, 24)
deletePersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 488, -85)

RefreshPersonalityUI = function()
    selectedPersonalityName = RandomDialogRPDB.activePersonality or "Default"
    personalityLabel:SetText(L("personalityLabel"))
    personalityNameLabel:SetText(L("personalityName"))
    UIDropDownMenu_SetSelectedValue(personalityDropDown, selectedPersonalityName)
    UIDropDownMenu_SetText(personalityDropDown, selectedPersonalityName)
    RefreshMainPersonalityDropDown()
    if phrasePersonalityDropDown then
        UIDropDownMenu_SetSelectedValue(phrasePersonalityDropDown, selectedPersonalityName)
        UIDropDownMenu_SetText(phrasePersonalityDropDown, selectedPersonalityName)
    end
    createPersonalityBtn:SetText(L("personalityCreateBtn"))
    renamePersonalityBtn:SetText(L("personalityRenameBtn"))
    deletePersonalityBtn:SetText(L("personalityDeleteBtn"))
end

createPersonalityBtn:SetScript("OnClick", function()
    local name = string.gsub(personalityNameBox:GetText() or "", "^%s*(.-)%s*$", "%1")
    if name == "" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityInvalid"))
        return
    end
    if RandomDialogRP_CustomDB[name] then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityExists"))
        return
    end

    local activeData = RandomDialogRP_CustomDB[currentPersonality]
    if type(activeData) ~= "table" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityInvalid"))
        return
    end
    RandomDialogRP_CustomDB[name] = RandomDialogRP_Profiles.Copy(activeData)
    RandomDialogRPDB.activePersonality = name
    currentPersonality = name
    personalityNameBox:SetText("")
    RefreshAfterPersonalityChange()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("personalityCreated"))
end)

renamePersonalityBtn:SetScript("OnClick", function()
    local oldName = RandomDialogRPDB.activePersonality
    local name = string.gsub(personalityNameBox:GetText() or "", "^%s*(.-)%s*$", "%1")
    if oldName == "Default" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotChangeDefaultPersonality"))
        return
    end
    if name == "" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityInvalid"))
        return
    end
    if name == oldName then return end
    if RandomDialogRP_CustomDB[name] then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("personalityExists"))
        return
    end

    RandomDialogRP_CustomDB[name] = RandomDialogRP_CustomDB[oldName]
    RandomDialogRP_CustomDB[oldName] = nil
    RandomDialogRPDB.activePersonality = name
    currentPersonality = name
    RandomDialogRP_Profiles.SaveActive()
    RefreshPersonalityUI()
    RefreshActionButtons()
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("personalityRenamed"))
end)

deletePersonalityBtn:SetScript("OnClick", function()
    local name = RandomDialogRPDB.activePersonality
    if name == "Default" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotChangeDefaultPersonality"))
        return
    end
    StaticPopup_Show("RANDOMDIALOGRP_DELETE_PERSONALITY_CONFIRM", nil, nil, name)
end)

StaticPopupDialogs["RANDOMDIALOGRP_DELETE_PERSONALITY_CONFIRM"] = {
    text = "",
    button1 = YES,
    button2 = NO,
    hideOnEscape = true,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,
    OnShow = function(dialog)
        dialog.Text:SetFormattedText(L("deletePersonalityConfirm"), dialog.data)
    end,
    OnAccept = function(_, name)
        if name == "Default" or not RandomDialogRP_CustomDB[name] then return end
        local wasActive = RandomDialogRPDB.activePersonality == name
        RandomDialogRP_CustomDB[name] = nil
        if wasActive then
            RandomDialogRPDB.activePersonality = "Default"
            currentPersonality = "Default"
            RefreshAfterPersonalityChange()
        else
            RefreshPersonalityUI()
        end
        print("|cFF00FF00[RandomDialogRP]|r " .. L("personalityDeleted"))
    end
}

profileTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
profileTitle:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -141)

profileSectionDivider = managerFrame:CreateTexture(nil, "ARTWORK")
profileSectionDivider:SetColorTexture(0.65, 0.65, 0.65, 0.55)
profileSectionDivider:SetHeight(1)
profileSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 16, -130)
profileSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -130)

currentProfileText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
currentProfileText:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -160)

profileDropDown = CreateFrame("Frame", "RandomDialogRPProfileDropDown", managerFrame, "UIDropDownMenuTemplate")
profileSelectText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
profileSelectText:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -178)
profileSelectText:SetWidth(300)
profileSelectText:SetJustifyH("LEFT")

profileDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -202)
UIDropDownMenu_SetWidth(profileDropDown, 240)

function ProfileDropDown_OnClick(self)
    selectedProfileName = self.value
    UIDropDownMenu_SetSelectedValue(profileDropDown, selectedProfileName)
    UIDropDownMenu_SetText(profileDropDown, selectedProfileName)
end

function ProfileDropDown_Initialize(self, level)
    for _, name in ipairs(RandomDialogRP_Profiles.Names()) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = name
        info.value = name
        info.func = ProfileDropDown_OnClick
        info.checked = (selectedProfileName == name)
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_Initialize(profileDropDown, ProfileDropDown_Initialize)

profileNameBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
profileNameBox:SetSize(300, 22)
profileNameBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -242)
profileNameBox:SetAutoFocus(false)

profileNameLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
profileNameLabel:SetPoint("BOTTOMLEFT", profileNameBox, "TOPLEFT", 0, 3)

createProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
createProfileBtn:SetSize(96, 24)
createProfileBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -278)

saveProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
saveProfileBtn:SetSize(96, 24)
saveProfileBtn:SetPoint("LEFT", createProfileBtn, "RIGHT", 8, 0)

loadProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
loadProfileBtn:SetSize(96, 24)
loadProfileBtn:SetPoint("LEFT", saveProfileBtn, "RIGHT", 8, 0)

renameProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
renameProfileBtn:SetSize(96, 24)
renameProfileBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -310)

deleteProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
deleteProfileBtn:SetSize(96, 24)
deleteProfileBtn:SetPoint("LEFT", renameProfileBtn, "RIGHT", 8, 0)

RefreshProfileUI = function()
    RandomDialogRP_Profiles.EnsureStore()
    selectedProfileName = selectedProfileName or RandomDialogRPDB.activeProfile or "Default"
    if not RandomDialogRPDB.profiles[selectedProfileName] then
        selectedProfileName = RandomDialogRPDB.activeProfile or "Default"
    end
    profileTitle:SetText(L("profileTitle"))
    currentProfileText:SetText(L("currentProfile") .. " " .. (RandomDialogRPDB.activeProfile or "Default"))
    profileSelectText:SetText(L("profileSelect"))
    UIDropDownMenu_SetSelectedValue(profileDropDown, selectedProfileName)
    UIDropDownMenu_SetText(profileDropDown, selectedProfileName)
    profileNameBox:SetText(UnitName("player") or "Profile")
    profileNameLabel:SetText(L("profileName"))
    createProfileBtn:SetText(L("createProfileBtn"))
    saveProfileBtn:SetText(L("saveProfileBtn"))
    loadProfileBtn:SetText(L("loadProfileBtn"))
    renameProfileBtn:SetText(L("renameProfileBtn"))
    deleteProfileBtn:SetText(L("deleteProfileBtn"))
end

function GetEnteredProfileName()
    local name = profileNameBox:GetText() or ""
    return string.gsub(name, "^%s*(.-)%s*$", "%1")
end

function RefreshAfterProfileChange()
    InitCustomDB()
    RefreshPersonalityUI()
    RefreshChatChannelDropDown()
    selectedCategory = "greetings"
    editingIndex = nil
    if editBox then editBox:SetText("") end
    EnsureSelectedCategory()
    if frame then
        frame:ClearAllPoints()
        frame:SetPoint(
            RandomDialogRPDB.panel.point,
            UIParent,
            RandomDialogRPDB.panel.relativePoint,
            RandomDialogRPDB.panel.xOfs,
            RandomDialogRPDB.panel.yOfs
        )
    end
    if _G.RandomDialogRPMinimapButton and RandomDialogRPDB.minimap then
        MoveMinimapButton(RandomDialogRPDB.minimap.angle)
    end
    RefreshMainClassDropDown()
    RefreshActionButtons()
    RefreshManagerUI()
    RefreshProfileUI()
end

createProfileBtn:SetScript("OnClick", function()
    local name = GetEnteredProfileName()
    if name == "" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("profileInvalid"))
        return
    end
    RandomDialogRP_Profiles.EnsureStore()
    if RandomDialogRPDB.profiles[name] then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("profileExists"))
        return
    end
    RandomDialogRP_Profiles.SaveActive()
    RandomDialogRPDB.profiles[name] = RandomDialogRP_Profiles.Copy(RandomDialogRPDB.profiles[RandomDialogRPDB.activeProfile])
    RandomDialogRPDB.profiles[name].name = name
    RandomDialogRP_Profiles.Activate(name)
    RefreshAfterProfileChange()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("profileCreated"))
end)

saveProfileBtn:SetScript("OnClick", function()
    RandomDialogRP_Profiles.SaveActive()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("profileSaved"))
end)

loadProfileBtn:SetScript("OnClick", function()
    if not selectedProfileName or not RandomDialogRP_Profiles.Activate(selectedProfileName) then return end
    RefreshAfterProfileChange()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("profileLoaded"))
end)

renameProfileBtn:SetScript("OnClick", function()
    local oldName = selectedProfileName
    local name = GetEnteredProfileName()
    if oldName == "Default" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotChangeDefault"))
        return
    end
    if name == "" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("profileInvalid"))
        return
    end
    if RandomDialogRPDB.profiles[name] then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("profileExists"))
        return
    end
    RandomDialogRPDB.profiles[name] = RandomDialogRPDB.profiles[oldName]
    RandomDialogRPDB.profiles[name].name = name
    RandomDialogRPDB.profiles[oldName] = nil
    if RandomDialogRPDB.activeProfile == oldName then RandomDialogRPDB.activeProfile = name end
    selectedProfileName = name
    RefreshProfileUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("profileRenamed"))
end)

deleteProfileBtn:SetScript("OnClick", function()
    local name = selectedProfileName
    if name == "Default" then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotChangeDefault"))
        return
    end
    StaticPopup_Show("RANDOMDIALOGRP_DELETE_PROFILE_CONFIRM", nil, nil, name)
end)

StaticPopupDialogs["RANDOMDIALOGRP_DELETE_PROFILE_CONFIRM"] = {
    text = "",
    button1 = YES,
    button2 = NO,
    hideOnEscape = true,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,
    OnShow = function(dialog)
        dialog.Text:SetFormattedText(L("deleteProfileConfirm"), dialog.data)
    end,
    OnAccept = function(_, name)
        if name == "Default" or not RandomDialogRPDB.profiles[name] then
            return
        end

        RandomDialogRPDB.profiles[name] = nil
        if selectedProfileName == name then
            selectedProfileName = "Default"
        end
        if RandomDialogRPDB.activeProfile == name then
            RandomDialogRP_Profiles.Activate("Default")
            RefreshAfterProfileChange()
        else
            RefreshProfileUI()
        end
        print("|cFF00FF00[RandomDialogRP]|r " .. L("profileDeleted"))
    end
}

-- Category Dropdown
