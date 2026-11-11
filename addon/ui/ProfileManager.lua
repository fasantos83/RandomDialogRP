-- Profile manager UI.
managerFrame = CreateFrame("Frame", "RandomDialogRPManager", UIParent, "BackdropTemplate")
managerFrame:SetSize(560, 420)
managerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
managerFrame:SetMovable(true)
managerFrame:EnableMouse(true)
managerFrame:SetClampedToScreen(true)
managerFrame:Hide()

managerFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
managerFrame:SetBackdropColor(0, 0, 0, 0.75)
managerFrame:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)

managerFrame:RegisterForDrag("LeftButton")
managerFrame:SetScript("OnDragStart", managerFrame.StartMoving)
managerFrame:SetScript("OnDragStop", managerFrame.StopMovingOrSizing)

managerTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
managerTitle:SetPoint("TOP", managerFrame, "TOP", 0, -10)
managerTitle:SetText(L("managerTitle"))

selectedCategory = "greetings"
editingIndex = nil
selectedManagerTab = "phrases"
RefreshManagerUI = nil
resetDataBtn = nil
profileDropDown = nil
profileNameBox = nil
selectedProfileName = nil
RefreshProfileUI = nil

function EnsureSelectedCategory()
    local categories = GetCategories(currentRace)
    for _, category in ipairs(categories) do
        if category == selectedCategory then return end
    end
    selectedCategory = categories[1]
    editingIndex = nil
end

RegisterResponsiveFrame(managerFrame)

profileTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
profileTitle:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -141)

profileSectionDivider = managerFrame:CreateTexture(nil, "ARTWORK")
profileSectionDivider:SetColorTexture(0.65, 0.65, 0.65, 0.55)
profileSectionDivider:SetHeight(1)
profileSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 16, -130)
profileSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -130)

currentProfileText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
currentProfileText:SetPoint("TOP", managerFrame, "TOP", 0, -160)

profileDropDown = CreateFrame("Frame", "RandomDialogRPProfileDropDown", managerFrame, "UIDropDownMenuTemplate")
profileSelectText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
profileSelectText:SetPoint("TOP", managerFrame, "TOP", 0, -178)
profileSelectText:SetWidth(300)
profileSelectText:SetJustifyH("CENTER")

profileDropDown:SetPoint("TOP", managerFrame, "TOP", 0, -202)
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
profileNameBox:SetPoint("TOP", managerFrame, "TOP", 0, -242)
profileNameBox:SetAutoFocus(false)

profileNameLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
profileNameLabel:SetPoint("BOTTOMLEFT", profileNameBox, "TOPLEFT", 0, 3)

createProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
createProfileBtn:SetSize(96, 24)
createProfileBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 128, -278)

saveProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
saveProfileBtn:SetSize(96, 24)
saveProfileBtn:SetPoint("LEFT", createProfileBtn, "RIGHT", 8, 0)

loadProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
loadProfileBtn:SetSize(96, 24)
loadProfileBtn:SetPoint("LEFT", saveProfileBtn, "RIGHT", 8, 0)

renameProfileBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
renameProfileBtn:SetSize(96, 24)
renameProfileBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 180, -310)

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
        dialog.text:SetFormattedText(L("deleteProfileConfirm"), dialog.data)
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
