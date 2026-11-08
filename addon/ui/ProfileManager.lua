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
RefreshManagerUI = nil
resetDataBtn = nil
profileFrame = nil
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

profileFrame = CreateFrame("Frame", "RandomDialogRPProfiles", UIParent, "BackdropTemplate")
profileFrame:SetSize(380, 260)
profileFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
profileFrame:SetMovable(true)
profileFrame:EnableMouse(true)
profileFrame:SetClampedToScreen(true)
profileFrame:Hide()
profileFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
profileFrame:SetBackdropColor(0, 0, 0, 0.75)
profileFrame:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)
profileFrame:RegisterForDrag("LeftButton")
profileFrame:SetScript("OnDragStart", profileFrame.StartMoving)
profileFrame:SetScript("OnDragStop", profileFrame.StopMovingOrSizing)

profileTitle = profileFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
profileTitle:SetPoint("TOP", profileFrame, "TOP", 0, -10)

currentProfileText = profileFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
currentProfileText:SetPoint("TOPLEFT", profileFrame, "TOPLEFT", 20, -45)

profileDropDown = CreateFrame("Frame", "RandomDialogRPProfileDropDown", profileFrame, "UIDropDownMenuTemplate")
profileDropDown:SetPoint("TOPLEFT", profileFrame, "TOPLEFT", 12, -65)
UIDropDownMenu_SetWidth(profileDropDown, 210)

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

profileNameBox = CreateFrame("EditBox", nil, profileFrame, "InputBoxTemplate")
profileNameBox:SetSize(210, 22)
profileNameBox:SetPoint("TOPLEFT", profileFrame, "TOPLEFT", 20, -115)
profileNameBox:SetAutoFocus(false)

profileHelpText = profileFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
profileHelpText:SetPoint("TOPLEFT", profileNameBox, "BOTTOMLEFT", 0, -4)
profileHelpText:SetText("")

createProfileBtn = CreateFrame("Button", nil, profileFrame, "UIPanelButtonTemplate")
createProfileBtn:SetSize(75, 24)
createProfileBtn:SetPoint("TOPLEFT", profileFrame, "TOPLEFT", 20, -155)

saveProfileBtn = CreateFrame("Button", nil, profileFrame, "UIPanelButtonTemplate")
saveProfileBtn:SetSize(75, 24)
saveProfileBtn:SetPoint("LEFT", createProfileBtn, "RIGHT", 6, 0)

loadProfileBtn = CreateFrame("Button", nil, profileFrame, "UIPanelButtonTemplate")
loadProfileBtn:SetSize(75, 24)
loadProfileBtn:SetPoint("LEFT", saveProfileBtn, "RIGHT", 6, 0)

renameProfileBtn = CreateFrame("Button", nil, profileFrame, "UIPanelButtonTemplate")
renameProfileBtn:SetSize(75, 24)
renameProfileBtn:SetPoint("TOPLEFT", profileFrame, "TOPLEFT", 20, -190)

deleteProfileBtn = CreateFrame("Button", nil, profileFrame, "UIPanelButtonTemplate")
deleteProfileBtn:SetSize(75, 24)
deleteProfileBtn:SetPoint("LEFT", renameProfileBtn, "RIGHT", 6, 0)

RefreshProfileUI = function()
    RandomDialogRP_Profiles.EnsureStore()
    selectedProfileName = selectedProfileName or RandomDialogRPDB.activeProfile or "Default"
    if not RandomDialogRPDB.profiles[selectedProfileName] then
        selectedProfileName = RandomDialogRPDB.activeProfile or "Default"
    end
    profileTitle:SetText(L("profileTitle"))
    currentProfileText:SetText(L("currentProfile") .. " " .. (RandomDialogRPDB.activeProfile or "Default"))
    UIDropDownMenu_SetSelectedValue(profileDropDown, selectedProfileName)
    UIDropDownMenu_SetText(profileDropDown, selectedProfileName)
    profileNameBox:SetText(UnitName("player") or "Profile")
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
    RandomDialogRPDB.profiles[name] = nil
    if RandomDialogRPDB.activeProfile == name then
        RandomDialogRP_Profiles.Activate("Default")
        RefreshAfterProfileChange()
    end
    selectedProfileName = "Default"
    RefreshProfileUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("profileDeleted"))
end)

profileCloseBtn = CreateFrame("Button", nil, profileFrame, "UIPanelCloseButton")
profileCloseBtn:SetPoint("TOPRIGHT", profileFrame, "TOPRIGHT", -2, -2)
profileBtn:SetScript("OnClick", function()
    if profileFrame:IsShown() then
        profileFrame:Hide()
    else
        RefreshProfileUI()
        profileFrame:Show()
    end
end)

-- Category Dropdown
