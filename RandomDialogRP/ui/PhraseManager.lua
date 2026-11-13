-- Phrase manager UI.
catDropDown = CreateFrame("Frame", "RandomDialogRPCatDropDown", managerFrame, "UIDropDownMenuTemplate")
catDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -85)
UIDropDownMenu_SetWidth(catDropDown, 120)

phrasePersonalityLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phrasePersonalityLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -75)

phrasePersonalityDropDown = CreateFrame("Frame", "RandomDialogRPPhrasePersonalityDropDown", managerFrame, "UIDropDownMenuTemplate")
phrasePersonalityDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -85)
UIDropDownMenu_SetWidth(phrasePersonalityDropDown, 110)
UIDropDownMenu_Initialize(phrasePersonalityDropDown, PersonalityDropDown_Initialize)

categorySectionLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
categorySectionLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -75)

selectedPhraseRace = currentRace
selectedPhraseClass = "NONE"

phraseRaceLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseRaceLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -111)

phraseRaceDropDown = CreateFrame("Frame", "RandomDialogRPPhraseRaceDropDown", managerFrame, "UIDropDownMenuTemplate")
phraseRaceDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -121)
UIDropDownMenu_SetWidth(phraseRaceDropDown, 110)

function PhraseRaceDropDown_OnClick(self)
    selectedPhraseRace = self.value
    editingIndex = nil
    editBox:SetText("")
    EnsureSelectedCategory()
    RefreshPhraseClassDropDown()
    RefreshManagerUI()
end

function PhraseRaceDropDown_Initialize(self, level)
    for _, raceName in ipairs(raceOrder) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = raceName
        info.value = raceName
        info.func = PhraseRaceDropDown_OnClick
        info.checked = selectedPhraseRace == raceName
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_Initialize(phraseRaceDropDown, PhraseRaceDropDown_Initialize)

phraseClassLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseClassLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 150, -111)

phraseClassDropDown = CreateFrame("Frame", "RandomDialogRPPhraseClassDropDown", managerFrame, "UIDropDownMenuTemplate")
phraseClassDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 140, -121)
UIDropDownMenu_SetWidth(phraseClassDropDown, 120)

function RefreshPhraseClassDropDown()
    local availableClasses = phraseRaceClasses[selectedPhraseRace]
    if selectedPhraseClass ~= "NONE" and availableClasses and not availableClasses[selectedPhraseClass] then
        selectedPhraseClass = "NONE"
        editingIndex = nil
        editBox:SetText("")
    end

    UIDropDownMenu_SetSelectedValue(phraseClassDropDown, selectedPhraseClass)
    UIDropDownMenu_SetText(
        phraseClassDropDown,
        selectedPhraseClass == "NONE" and L("noneClass") or GetPhraseClassName(selectedPhraseClass)
    )
end

function PhraseClassDropDown_OnClick(self)
    selectedPhraseClass = self.value
    editingIndex = nil
    editBox:SetText("")
    UIDropDownMenu_SetSelectedValue(phraseClassDropDown, selectedPhraseClass)
    UIDropDownMenu_SetText(
        phraseClassDropDown,
        selectedPhraseClass == "NONE" and L("noneClass") or GetPhraseClassName(selectedPhraseClass)
    )
    RefreshManagerUI()
end

function PhraseClassDropDown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = L("noneClass")
    info.value = "NONE"
    info.func = PhraseClassDropDown_OnClick
    info.checked = selectedPhraseClass == "NONE"
    UIDropDownMenu_AddButton(info, level)

    local availableClasses = phraseRaceClasses[selectedPhraseRace]
    for _, classToken in ipairs(phraseClassOrder) do
        if not availableClasses or availableClasses[classToken] then
            info = UIDropDownMenu_CreateInfo()
            info.text = GetPhraseClassName(classToken)
            info.value = classToken
            info.func = PhraseClassDropDown_OnClick
            info.checked = selectedPhraseClass == classToken
            UIDropDownMenu_AddButton(info, level)
        end
    end
end
UIDropDownMenu_Initialize(phraseClassDropDown, PhraseClassDropDown_Initialize)

phraseSearchLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseSearchLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 188, -75)

phraseSearchBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
phraseSearchBox:SetSize(210, 20)
phraseSearchBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 186, -85)
phraseSearchBox:SetAutoFocus(false)

categoryNameFieldLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
categoryNameFieldLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -119)

function CatDropDown_OnClick(self)
    selectedCategory = self.value
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory, selectedPhraseRace))
    RefreshPhraseClassDropDown()
    editingIndex = nil
    editBox:SetText("")
    RefreshManagerUI()
end

function CatDropDown_Initialize(self, level)
    for _, cat in ipairs(GetCategories(selectedPhraseRace)) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = GetCategoryLabel(cat, selectedPhraseRace)
        info.value = cat
        info.func = CatDropDown_OnClick
        info.checked = (selectedCategory == cat)
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_Initialize(catDropDown, CatDropDown_Initialize)

categoryNameBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
categoryNameBox:SetSize(150, 20)
categoryNameBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -133)
categoryNameBox:SetAutoFocus(false)

addCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
addCategoryBtn:SetSize(65, 22)
addCategoryBtn:SetPoint("LEFT", categoryNameBox, "RIGHT", 6, 0)

renameCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
renameCategoryBtn:SetSize(70, 22)
renameCategoryBtn:SetPoint("LEFT", addCategoryBtn, "RIGHT", 4, 0)

deleteCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
deleteCategoryBtn:SetSize(60, 22)
deleteCategoryBtn:SetPoint("LEFT", renameCategoryBtn, "RIGHT", 4, 0)

categoryIconBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
categoryIconBtn:SetSize(24, 24)
categoryIconBtn:SetPoint("LEFT", deleteCategoryBtn, "RIGHT", 8, 0)

categoryIcon = categoryIconBtn:CreateTexture(nil, "ARTWORK")
categoryIcon:SetSize(18, 18)
categoryIcon:SetPoint("CENTER")

languageSectionLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
languageSectionLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -75)

langDropDown = CreateFrame("Frame", "RandomDialogRPLangDropDown", managerFrame, "UIDropDownMenuTemplate")
langDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 8, -85)
UIDropDownMenu_SetWidth(langDropDown, 80)

function LangDropDown_OnClick(self)
    RandomDialogRPDB.language = self.value
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    RefreshMainPanelLabels()
    RefreshChatChannelDropDown()
    RefreshManagerUI()
    if RefreshProfileUI then RefreshProfileUI() end
    if RefreshPersonalityUI then RefreshPersonalityUI() end
end

function LangDropDown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "English"
    info.value = "enUS"
    info.func = LangDropDown_OnClick
    info.checked = (RandomDialogRPDB.language == "enUS")
    UIDropDownMenu_AddButton(info, level)

    info = UIDropDownMenu_CreateInfo()
    info.text = "Português"
    info.value = "ptBR"
    info.func = LangDropDown_OnClick
    info.checked = (RandomDialogRPDB.language == "ptBR")
    UIDropDownMenu_AddButton(info, level)
end
UIDropDownMenu_Initialize(langDropDown, LangDropDown_Initialize)

-- Input EditBox
editBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
editBox:SetSize(300, 20)
editBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -165)
editBox:SetAutoFocus(false)

phraseEntryLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseEntryLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -154)

actionBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
actionBtn:SetSize(75, 22)
actionBtn:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
actionBtn:SetText(L("addBtn"))
RandomDialogRP_UI.StyleButton(actionBtn)

cancelEditBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
cancelEditBtn:SetSize(70, 22)
cancelEditBtn:SetPoint("LEFT", actionBtn, "RIGHT", 4, 0)
cancelEditBtn:SetText(L("cancelBtn"))
RandomDialogRP_UI.StyleButton(cancelEditBtn)
cancelEditBtn:Hide()

-- Scrollable List
scrollFrame = CreateFrame("ScrollFrame", "RandomDialogRPScrollFrame", managerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(520, 230)
scrollFrame:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 15, -197)

local phraseListBackground = scrollFrame:CreateTexture(nil, "BACKGROUND")
phraseListBackground:SetAllPoints(scrollFrame)
phraseListBackground:SetColorTexture(0.025, 0.023, 0.018, 0.9)

scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(500, 230)
scrollFrame:SetScrollChild(scrollContent)

phraseListStatus = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
phraseListStatus:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 10, -12)
phraseListStatus:SetWidth(470)
phraseListStatus:SetJustifyH("CENTER")
phraseListStatus:Hide()

phraseRows = {}

local function CreateManagerTab()
    local tab = CreateFrame("Button", nil, managerFrame)
    tab:SetSize(95, 28)

    tab.background = tab:CreateTexture(nil, "BACKGROUND")
    tab.background:SetAllPoints()

    local highlight = tab:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetColorTexture(0.34, 0.29, 0.06, 0.22)
    highlight:SetBlendMode("ADD")

    tab.label = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    tab.label:SetPoint("CENTER", tab, "CENTER", 0, 1)

    return tab
end

phraseTab = CreateManagerTab()
phraseTab:SetSize(108, 28)

settingsTab = CreateManagerTab()
settingsTab:SetSize(108, 28)

managerSectionDivider = managerFrame:CreateTexture(nil, "ARTWORK")
managerSectionDivider:SetColorTexture(0.36, 0.32, 0.17, 0.75)
managerSectionDivider:SetHeight(1)
managerSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 16, -61)
managerSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -61)

local managerSidebar = managerFrame:CreateTexture(nil, "BACKGROUND")
managerSidebar:SetColorTexture(0.035, 0.032, 0.025, 0.96)
managerSidebar:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 4, -62)
managerSidebar:SetPoint("BOTTOMLEFT", managerFrame, "BOTTOMLEFT", 4, 4)
managerSidebar:SetWidth(118)

local managerSidebarDivider = managerFrame:CreateTexture(nil, "ARTWORK")
managerSidebarDivider:SetColorTexture(0.24, 0.21, 0.12, 0.85)
managerSidebarDivider:SetPoint("TOPLEFT", managerSidebar, "TOPRIGHT", 0, 0)
managerSidebarDivider:SetPoint("BOTTOMLEFT", managerSidebar, "BOTTOMRIGHT", 0, 0)
managerSidebarDivider:SetWidth(1)

local managerContentBackground = managerFrame:CreateTexture(nil, "BACKGROUND", nil, 1)
managerContentBackground:SetColorTexture(0.085, 0.075, 0.05, 0.38)
managerContentBackground:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 127, -62)
managerContentBackground:SetPoint("BOTTOMRIGHT", managerFrame, "BOTTOMRIGHT", -4, 4)

local function ShiftManagerContentRight()
    local function shiftRegion(region)
        if region == managerTitle then return end

        local points = {}
        for index = 1, region:GetNumPoints() do
            local point, relativeTo, relativePoint, x, y = region:GetPoint(index)
            points[index] = {
                point = point,
                relativeTo = relativeTo,
                relativePoint = relativePoint,
                x = x,
                y = y,
            }
        end

        if #points == 0 then return end
        region:ClearAllPoints()
        for _, point in ipairs(points) do
            local x = point.x
            if point.relativeTo == managerFrame and string.find(point.point, "LEFT") then
                x = x + 130
            end
            region:SetPoint(point.point, point.relativeTo, point.relativePoint, x, point.y)
        end
    end

    for _, child in ipairs({ managerFrame:GetChildren() }) do
        if child ~= phraseTab and child ~= settingsTab then
            shiftRegion(child)
        end
    end
    for _, region in ipairs({ managerFrame:GetRegions() }) do
        if region:GetObjectType() == "FontString" then
            shiftRegion(region)
        end
    end
end

ShiftManagerContentRight()
managerSectionDivider:ClearAllPoints()
managerSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 136, -61)
managerSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -61)
profileSectionDivider:ClearAllPoints()
profileSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 136, -130)
profileSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -130)
phraseTab:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 9, -76)
settingsTab:SetPoint("TOPLEFT", phraseTab, "BOTTOMLEFT", 0, -7)

personalityLabel:ClearAllPoints()
personalityLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 145, -365)
personalityDropDown:ClearAllPoints()
personalityDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 135, -375)
UIDropDownMenu_SetWidth(personalityDropDown, 110)
personalityNameLabel:ClearAllPoints()
personalityNameLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 310, -365)
personalityNameBox:ClearAllPoints()
personalityNameBox:SetSize(135, 22)
personalityNameBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 305, -375)
createPersonalityBtn:ClearAllPoints()
createPersonalityBtn:SetSize(70, 24)
createPersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 445, -375)
renamePersonalityBtn:ClearAllPoints()
renamePersonalityBtn:SetSize(70, 24)
renamePersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 519, -375)
deletePersonalityBtn:ClearAllPoints()
deletePersonalityBtn:SetSize(60, 24)
deletePersonalityBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 593, -375)

categorySettingsTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
categorySettingsTitle:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 145, -351)
categorySettingsTitle:SetText(L("categorySettingsTitle"))

categorySettingsDivider = managerFrame:CreateTexture(nil, "ARTWORK")
categorySettingsDivider:SetColorTexture(0.36, 0.32, 0.17, 0.75)
categorySettingsDivider:SetHeight(1)
categorySettingsDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 136, -342)
categorySettingsDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -342)

local function PlaceManagerControl(control, x, y)
    control:ClearAllPoints()
    control:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", x, y)
end

function SetManagerTab(tab)
    if tab ~= "settings" then tab = "phrases" end
    selectedManagerTab = tab
    local showPhrases = tab == "phrases"
    local showSettings = tab == "settings"

    if showPhrases then
        PlaceManagerControl(phrasePersonalityLabel, 145, -75)
        PlaceManagerControl(phrasePersonalityDropDown, 135, -85)
        UIDropDownMenu_SetWidth(phrasePersonalityDropDown, 110)
        PlaceManagerControl(categorySectionLabel, 300, -75)
        PlaceManagerControl(catDropDown, 290, -85)
        UIDropDownMenu_SetWidth(catDropDown, 110)
        PlaceManagerControl(phraseRaceLabel, 145, -125)
        PlaceManagerControl(phraseRaceDropDown, 135, -135)
        UIDropDownMenu_SetWidth(phraseRaceDropDown, 110)
        PlaceManagerControl(phraseClassLabel, 300, -125)
        PlaceManagerControl(phraseClassDropDown, 290, -135)
        UIDropDownMenu_SetWidth(phraseClassDropDown, 110)
        PlaceManagerControl(phraseSearchLabel, 450, -75)
        PlaceManagerControl(phraseSearchBox, 440, -85)
        phraseSearchBox:SetSize(220, 20)
        PlaceManagerControl(phraseEntryLabel, 145, -179)
        PlaceManagerControl(editBox, 135, -190)
        editBox:SetSize(300, 20)
        PlaceManagerControl(scrollFrame, 135, -222)
        scrollFrame:SetSize(520, 230)
    else
        PlaceManagerControl(languageSectionLabel, 145, -75)
        PlaceManagerControl(langDropDown, 135, -85)
        PlaceManagerControl(personalityLabel, 145, -380)
        PlaceManagerControl(personalityDropDown, 135, -390)
        UIDropDownMenu_SetWidth(personalityDropDown, 110)
        PlaceManagerControl(personalityNameLabel, 310, -380)
        PlaceManagerControl(personalityNameBox, 305, -390)
        personalityNameBox:SetSize(135, 22)
        PlaceManagerControl(createPersonalityBtn, 445, -390)
        PlaceManagerControl(renamePersonalityBtn, 519, -390)
        PlaceManagerControl(deletePersonalityBtn, 593, -390)
        PlaceManagerControl(categorySectionLabel, 145, -435)
        PlaceManagerControl(catDropDown, 135, -445)
        UIDropDownMenu_SetWidth(catDropDown, 110)
        PlaceManagerControl(categoryNameFieldLabel, 310, -435)
        PlaceManagerControl(categoryNameBox, 305, -445)
        categoryNameBox:SetSize(135, 22)
    end

    phrasePersonalityLabel:SetShown(showPhrases)
    phrasePersonalityDropDown:SetShown(showPhrases)
    categorySectionLabel:SetShown(true)
    catDropDown:SetShown(true)
    phraseRaceLabel:SetShown(showPhrases)
    phraseRaceDropDown:SetShown(showPhrases)
    phraseClassLabel:SetShown(showPhrases)
    phraseClassDropDown:SetShown(showPhrases)
    phraseSearchLabel:SetShown(showPhrases)
    phraseSearchBox:SetShown(showPhrases)
    phraseEntryLabel:SetShown(showPhrases)
    editBox:SetShown(showPhrases)
    actionBtn:SetShown(showPhrases)
    cancelEditBtn:SetShown(showPhrases and editingIndex ~= nil)
    scrollFrame:SetShown(showPhrases)
    categorySettingsTitle:SetShown(showSettings)
    categorySettingsDivider:SetShown(showSettings)
    categoryNameFieldLabel:SetShown(showSettings)
    categoryNameBox:SetShown(showSettings)
    addCategoryBtn:SetShown(showSettings)
    renameCategoryBtn:SetShown(showSettings)
    deleteCategoryBtn:SetShown(showSettings)
    categoryIconBtn:SetShown(showSettings)
    languageSectionLabel:SetShown(showSettings)
    langDropDown:SetShown(showSettings)
    personalityLabel:SetShown(showSettings)
    personalityDropDown:SetShown(showSettings)
    personalityNameLabel:SetShown(showSettings)
    personalityNameBox:SetShown(showSettings)
    createPersonalityBtn:SetShown(showSettings)
    renamePersonalityBtn:SetShown(showSettings)
    deletePersonalityBtn:SetShown(showSettings)
    profileSectionDivider:SetShown(showSettings)
    profileTitle:SetShown(showSettings)
    currentProfileText:SetShown(showSettings)
    profileSelectText:SetShown(showSettings)
    profileDropDown:SetShown(showSettings)
    profileNameBox:SetShown(showSettings)
    profileNameLabel:SetShown(showSettings)
    createProfileBtn:SetShown(showSettings)
    saveProfileBtn:SetShown(showSettings)
    loadProfileBtn:SetShown(showSettings)
    renameProfileBtn:SetShown(showSettings)
    deleteProfileBtn:SetShown(showSettings)
    if resetDataBtn then resetDataBtn:SetShown(showSettings) end
    if saveReloadBtn then saveReloadBtn:SetShown(showSettings) end
    if tutorialBtn then tutorialBtn:SetShown(showSettings) end
    managerVersionText:SetShown(showSettings)
    if warningText then warningText:SetShown(showSettings) end

    for _, tabButton in ipairs({ phraseTab, settingsTab }) do
        local selected = (tabButton == phraseTab and showPhrases)
            or (tabButton == settingsTab and showSettings)
        tabButton.background:SetColorTexture(
            selected and 0.29 or 0.055,
            selected and 0.27 or 0.05,
            selected and 0.035 or 0.04,
            selected and 0.95 or 0.65
        )
        tabButton.label:SetFontObject(GameFontNormalSmall)
        tabButton.label:SetTextColor(1, selected and 0.84 or 0.74, selected and 0.12 or 0.48)
    end

    if RefreshPersonalityUI then RefreshPersonalityUI() end
    if showSettings and RefreshProfileUI then RefreshProfileUI() end
end

local tutorialFrame = CreateFrame("Frame", "RandomDialogRPTutorialFrame", UIParent, "BackdropTemplate")
tutorialFrame:SetSize(520, 365)
tutorialFrame:SetFrameStrata("DIALOG")
tutorialFrame:SetToplevel(true)
tutorialFrame:SetClampedToScreen(true)
tutorialFrame:EnableMouse(true)
tutorialFrame:SetPoint("CENTER")
tutorialFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
tutorialFrame:SetBackdropColor(0.045, 0.04, 0.028, 1)
tutorialFrame:SetBackdropBorderColor(0.36, 0.32, 0.17, 1)
tutorialFrame:HookScript("OnShow", function(self) self:Raise() end)
tutorialFrame:Hide()

local tutorialTitle = tutorialFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
tutorialTitle:SetPoint("TOPLEFT", tutorialFrame, "TOPLEFT", 28, -24)
tutorialTitle:SetWidth(450)
tutorialTitle:SetJustifyH("LEFT")

local tutorialBody = tutorialFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tutorialBody:SetPoint("TOPLEFT", tutorialTitle, "BOTTOMLEFT", 0, -18)
tutorialBody:SetSize(464, 255)
tutorialBody:SetJustifyH("LEFT")
tutorialBody:SetJustifyV("TOP")
tutorialBody:SetWordWrap(true)
tutorialBody:SetSpacing(3)

local tutorialCloseBtn = CreateFrame("Button", nil, tutorialFrame, "UIPanelButtonTemplate")
tutorialCloseBtn:SetSize(120, 26)
tutorialCloseBtn:SetPoint("BOTTOM", tutorialFrame, "BOTTOM", 0, 20)
tutorialCloseBtn:SetScript("OnClick", function() tutorialFrame:Hide() end)
RandomDialogRP_UI.StyleButton(tutorialCloseBtn)

local function ShowTutorial()
    tutorialTitle:SetText(L("tutorialTitle"))
    tutorialBody:SetText(L("tutorialBody"))
    tutorialCloseBtn:SetText(L("tutorialCloseBtn"))
    tutorialFrame:Show()
    tutorialFrame:Raise()
end

local function MaybeShowTutorial()
    local seenVersion = tonumber(RandomDialogRPDB and RandomDialogRPDB.tutorialVersion) or 0
    if seenVersion >= 1 then return end

    RandomDialogRPDB.tutorialVersion = 1
    ShowTutorial()
end

table.insert(UISpecialFrames, "RandomDialogRPTutorialFrame")

phraseTab.label:SetText(L("phrasesTab"))
settingsTab.label:SetText(L("settingsTab"))
phraseTab:SetScript("OnClick", function() SetManagerTab("phrases") end)
settingsTab:SetScript("OnClick", function() SetManagerTab("settings") end)
SetManagerTab(selectedManagerTab)

function CreateEmoteSelector(parent, categoryData, phrases, phraseIndex)
    local selector = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    selector:SetSize(78, 20)
    selector:SetText(GetPhraseEmote(phrases[phraseIndex], categoryData) or L("emoteLabel"))
    RandomDialogRP_UI.StyleButton(selector)

    local popup = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    popup:SetSize(125, 165)
    popup:SetFrameStrata("DIALOG")
    popup:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    popup:SetBackdropColor(0, 0, 0, 0.75)
    popup:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)
    popup:Hide()

    local scroll = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", popup, "TOPLEFT", 5, -5)
    scroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -25, 5)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(90, #emoteOptions * 18)
    scroll:SetScrollChild(content)
    local selectedMarkers = {}

    local function RefreshSelection(selectedEmote)
        for emote, marker in pairs(selectedMarkers) do
            marker:SetText(emote == selectedEmote and "|cFFFFFF00>|r " or "  ")
        end
    end

    for optionIndex, emote in ipairs(emoteOptions) do
        local option = CreateFrame("Button", nil, content)
        option:SetSize(90, 18)
        option:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -((optionIndex - 1) * 18))
        option:SetHighlightFontObject(GameFontHighlight)

        local text = option:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", option, "LEFT", 12, 0)
        text:SetPoint("RIGHT", option, "RIGHT", 0, 0)
        text:SetText(emote)
        local marker = option:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        marker:SetPoint("LEFT", option, "LEFT", 0, 0)
        marker:SetSize(12, 18)
        selectedMarkers[emote] = marker

        option:SetScript("OnClick", function()
            SetPhraseEmote(categoryData, phraseIndex, emote)
            selector:SetText(emote)
            RefreshSelection(emote)
            popup:Hide()
        end)
    end
    RefreshSelection(GetPhraseEmote(phrases[phraseIndex], categoryData))

    selector:SetScript("OnClick", function()
        if popup:IsShown() then
            popup:Hide()
        else
            popup:ClearAllPoints()
            popup:SetPoint("BOTTOMLEFT", selector, "TOPLEFT", 0, 2)
            popup:Show()
        end
    end)

    parent:SetScript("OnHide", function()
        popup:Hide()
    end)

    return selector
end

function CreateIconSelector()
    local selector = categoryIconBtn
    local popup = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    popup:SetSize(300, 235)
    popup:SetFrameStrata("DIALOG")
    popup:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    popup:SetBackdropColor(0, 0, 0, 0.75)
    popup:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)
    popup:Hide()

    local scroll = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", popup, "TOPLEFT", 5, -5)
    scroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -25, 5)
    local columns = 6
    local iconSize = 38
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(columns * iconSize, math.ceil(#iconOptions / columns) * iconSize)
    scroll:SetScrollChild(content)

    for index, texturePath in ipairs(iconOptions) do
        local iconButton = CreateFrame("Button", nil, content)
        iconButton:SetSize(34, 34)
        local column = (index - 1) % columns
        local row = math.floor((index - 1) / columns)
        iconButton:SetPoint("TOPLEFT", content, "TOPLEFT", column * iconSize, -row * iconSize)
        local texture = iconButton:CreateTexture(nil, "ARTWORK")
        texture:SetAllPoints()
        texture:SetTexture(texturePath)
        iconButton:SetScript("OnClick", function()
            local categoryData = GetPhraseCategoryData(currentPersonality, selectedCategory, nil, nil, false)
            categoryData.icon = texturePath
            categoryIcon:SetTexture(texturePath)
            popup:Hide()
            if selectedPhraseRace == currentRace then RefreshActionButtons() end
        end)
    end

    selector:SetScript("OnClick", function()
        if popup:IsShown() then
            popup:Hide()
        else
            popup:ClearAllPoints()
            popup:SetPoint("TOPLEFT", selector, "BOTTOMLEFT", 0, -2)
            popup:Show()
        end
    end)
    managerFrame:HookScript("OnHide", function()
        popup:Hide()
    end)
end

CreateIconSelector()

function RefreshPhraseRows()
    for _, row in ipairs(phraseRows) do row:Hide() end
    phraseRows = {}

    local categoryData = GetPhraseCategoryData(
        currentPersonality,
        selectedCategory,
        selectedPhraseClass,
        selectedPhraseRace,
        false
    )
    local baseCategoryData = GetPhraseCategoryData(
        currentPersonality,
        selectedCategory,
        "NONE",
        selectedPhraseRace,
        false
    )
    categoryData = categoryData or {
        phrases = {},
        emote = baseCategoryData and baseCategoryData.emote or "WAVE"
    }
    local phrases = categoryData and categoryData.phrases or {}
    local query = string.lower(phraseSearchBox:GetText() or "")
    local yOffset = 0
    local visibleCount = 0

    for index, phrase in ipairs(phrases) do
        local phraseText = GetPhraseText(phrase)
        if query == "" or string.find(string.lower(phraseText), query, 1, true) then
            local phraseIndex = index
            local row = CreateFrame("Frame", nil, scrollContent)
            row:SetWidth(500)
            row:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, yOffset)

            local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            text:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -3)
            text:SetWidth(295)
            text:SetWordWrap(true)
            text:SetJustifyH("LEFT")
            text:SetJustifyV("MIDDLE")
            text:SetText(phraseIndex .. ". " .. phraseText)
            text:SetTextColor(0.94, 0.88, 0.7)

            local rowBackground = row:CreateTexture(nil, "BACKGROUND")
            rowBackground:SetAllPoints()
            rowBackground:SetColorTexture(0.12, 0.105, 0.07, phraseIndex % 2 == 0 and 0.6 or 0.35)

            local rowHeight = math.max(30, text:GetStringHeight() + 8)
            row:SetHeight(rowHeight)
            text:SetHeight(rowHeight - 6)

            local emoteSelector = CreateEmoteSelector(row, categoryData, phrases, phraseIndex)
            emoteSelector:SetPoint("LEFT", row, "LEFT", 310, 0)

            local editRowBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            editRowBtn:SetSize(40, 18)
            editRowBtn:SetPoint("RIGHT", row, "RIGHT", -60, 0)
            editRowBtn:SetText(L("editBtn"))
            RandomDialogRP_UI.StyleButton(editRowBtn)
            editRowBtn:SetScript("OnClick", function()
                editingIndex = phraseIndex
                editBox:SetText(phraseText)
                RefreshManagerUI()
                editBox:SetFocus()
            end)

            local delBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            delBtn:SetSize(40, 18)
            delBtn:SetPoint("RIGHT", row, "RIGHT", -10, 0)
            delBtn:SetText(L("delBtn"))
            RandomDialogRP_UI.StyleButton(delBtn)
            delBtn:SetScript("OnClick", function()
                table.remove(phrases, phraseIndex)
                if editingIndex == phraseIndex then
                    editingIndex = nil
                    editBox:SetText("")
                elseif editingIndex and editingIndex > phraseIndex then
                    editingIndex = editingIndex - 1
                end
                RefreshManagerUI()
                print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseRemoved"))
            end)

            table.insert(phraseRows, row)
            visibleCount = visibleCount + 1
            yOffset = yOffset - rowHeight - 4
        end
    end

    if visibleCount == 0 then
        local statusText = #phrases == 0 and L("noPhrases") or L("noSearchResults")
        if #phrases == 0 and selectedPhraseClass ~= "NONE" then
            statusText = L("classPhraseFallback")
        end
        phraseListStatus:SetText(statusText)
        phraseListStatus:Show()
    else
        phraseListStatus:Hide()
    end
    scrollContent:SetHeight(math.max(160, math.abs(yOffset)))
    scrollFrame:SetVerticalScroll(0)
end

phraseSearchBox:SetScript("OnTextChanged", RefreshPhraseRows)

RefreshManagerUI = function()
    managerTitle:SetText(L("managerTitle"))
    phraseTab.label:SetText(L("phrasesTab"))
    settingsTab.label:SetText(L("settingsTab"))
    phrasePersonalityLabel:SetText(L("personalityLabel"))
    categorySectionLabel:SetText(L("categoryLabel"))
    categorySettingsTitle:SetText(L("categorySettingsTitle"))
    phraseSearchLabel:SetText(L("searchLabel"))
    categoryNameFieldLabel:SetText(L("categoryName"))
    phraseEntryLabel:SetText(L("phraseLabel"))
    phraseRaceLabel:SetText(L("raceLabel"))
    phraseClassLabel:SetText(L("phraseClassLabel"))
    languageSectionLabel:SetText(L("languageLabel"))
    SetManagerTab(selectedManagerTab)

    UIDropDownMenu_SetSelectedValue(phraseRaceDropDown, selectedPhraseRace)
    UIDropDownMenu_SetText(phraseRaceDropDown, selectedPhraseRace)
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory, selectedPhraseRace))
    RefreshPhraseClassDropDown()
    
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    
    phraseEntryLabel:SetText(editingIndex and (L("editingPhrase") .. " " .. editingIndex .. ":") or L("phraseLabel"))
    actionBtn:SetText(editingIndex and L("updateBtn") or L("addBtn"))
    cancelEditBtn:SetText(L("cancelBtn"))
    cancelEditBtn:SetShown(selectedManagerTab == "phrases" and editingIndex ~= nil)
    categoryNameBox:SetText(GetCategoryLabel(selectedCategory, selectedPhraseRace))
    categoryIcon:SetTexture(GetCategoryIcon(selectedCategory, selectedPhraseRace))
    addCategoryBtn:SetText(L("addCategoryBtn"))
    renameCategoryBtn:SetText(L("renameCategoryBtn"))
    deleteCategoryBtn:SetText(L("deleteCategoryBtn"))
    if resetDataBtn then resetDataBtn:SetText(L("resetBtn")) end
    if tutorialBtn then tutorialBtn:SetText(L("tutorialBtn")) end
    managerVersionText:SetText(string.format(
        L("versionLabel"),
        addonVersion
    ))
    
    for cat, data in pairs(buttonTexts) do
        data.btn:SetText(GetCategoryLabel(cat))
    end

    RefreshPhraseRows()
end

function GetEnteredCategoryName()
    local name = categoryNameBox:GetText() or ""
    return string.gsub(name, "^%s*(.-)%s*$", "%1")
end

function CategoryNameExists(name, ignoredCategory)
    local normalizedName = string.lower(name)
    if normalizedName == "classphrases" or normalizedName == "classphrasedefaultsversion" then
        return true
    end
    for _, category in ipairs(GetCategories(selectedPhraseRace)) do
        if category ~= ignoredCategory and string.lower(GetCategoryLabel(category, selectedPhraseRace)) == string.lower(name) then
            return true
        end
    end
    return false
end

addCategoryBtn:SetScript("OnClick", function()
    local name = GetEnteredCategoryName()
    if name == "" or CategoryNameExists(name) then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("categoryExists"))
        return
    end
    local personalityData = RandomDialogRP_CustomDB[currentPersonality]
    personalityData[name] = {
        races = {},
        classes = {},
        label = name,
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    }
    table.insert(personalityData.categoryOrder, name)
    selectedCategory = name
    categoryNameBox:SetText("")
    if selectedPhraseRace == currentRace then RefreshActionButtons() end
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryAdded"))
end)

renameCategoryBtn:SetScript("OnClick", function()
    local name = GetEnteredCategoryName()
    if name == "" or CategoryNameExists(name, selectedCategory) then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("categoryExists"))
        return
    end
    local personalityData = RandomDialogRP_CustomDB[currentPersonality]
    if IsBuiltinCategory(selectedCategory) then
        personalityData[selectedCategory].label = name
    else
        local oldCategory = selectedCategory
        personalityData[name] = personalityData[oldCategory]
        personalityData[name].label = name
        personalityData[oldCategory] = nil
        for index, category in ipairs(personalityData.categoryOrder) do
            if category == oldCategory then personalityData.categoryOrder[index] = name; break end
        end
        selectedCategory = name
    end
    if selectedPhraseRace == currentRace then RefreshActionButtons() end
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryUpdated"))
end)

deleteCategoryBtn:SetScript("OnClick", function()
    if IsBuiltinCategory(selectedCategory) then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotDeleteCategory"))
        return
    end
    StaticPopup_Show("RANDOMDIALOGRP_DELETE_CATEGORY_CONFIRM", nil, nil, {
        race = selectedPhraseRace,
        category = selectedCategory
    })
end)

actionBtn:SetScript("OnClick", function()
    local text = editBox:GetText()
    if text and text ~= "" then
        local categoryData = GetPhraseCategoryData(
            currentPersonality,
            selectedCategory,
            selectedPhraseClass,
            selectedPhraseRace,
            true
        )

        if editingIndex then
            local phrase = categoryData.phrases[editingIndex]
            if type(phrase) == "table" then
                phrase.text = text
            else
                categoryData.phrases[editingIndex] = {
                    text = text,
                    emote = categoryData.emote
                }
            end
            print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseUpdated"))
            editingIndex = nil
        else
            table.insert(categoryData.phrases, {
                text = text,
                emote = categoryData.emote
            })
            print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseAdded"))
        end
        
        editBox:SetText("")
        editBox:ClearFocus()
        RefreshManagerUI()
    end
end)

cancelEditBtn:SetScript("OnClick", function()
    editingIndex = nil
    editBox:SetText("")
    editBox:ClearFocus()
    RefreshManagerUI()
end)

warningText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontRedSmall")
warningText:SetPoint("BOTTOM", managerFrame, "BOTTOM", 0, 45)
warningText:SetText(L("reloadWarning"))

StaticPopupDialogs["RANDOMDIALOGRP_DELETE_CATEGORY_CONFIRM"] = {
    text = "",
    button1 = YES,
    button2 = NO,
    hideOnEscape = true,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,
    OnShow = function(dialog)
        dialog.Text:SetFormattedText(L("deleteCategoryConfirm"), dialog.data.category)
    end,
    OnAccept = function(_, data)
        local personalityData = RandomDialogRP_CustomDB[currentPersonality]
        if not personalityData or not personalityData[data.category] or IsBuiltinCategory(data.category) then
            return
        end

        personalityData[data.category] = nil
        for index, category in ipairs(personalityData.categoryOrder) do
            if category == data.category then
                table.remove(personalityData.categoryOrder, index)
                break
            end
        end

        selectedCategory = GetCategories()[1]
        editingIndex = nil
        editBox:SetText("")
        if selectedPhraseRace == currentRace then RefreshActionButtons() end
        RefreshManagerUI()
        print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryRemoved"))
    end
}

StaticPopupDialogs["RANDOMDIALOGRP_RESET_CONFIRM"] = {
    text = "",
    button1 = YES,
    button2 = NO,
    hideOnEscape = true,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,
    OnShow = function(dialog)
        dialog.Text:SetText(L("resetConfirm"))
    end,
    OnAccept = function()
        RandomDialogRPDB = {}
        RandomDialogRP_CustomDB = {}
        RandomDialogRP_Profiles.ActivateCurrent()
        InitCustomDB()
        local _, playerClass = UnitClass("player")
        currentClass = IsClassAvailableForRace(currentRace, playerClass) and playerClass or "NONE"
        RandomDialogRPDB.rpClass = currentClass
        RandomDialogRP_Profiles.SaveActive()
        RefreshMainClassDropDown()
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
        MoveMinimapButton(45)
        selectedCategory = "greetings"
        selectedPhraseRace = currentRace
        selectedPhraseClass = "NONE"
        editingIndex = nil
        editBox:SetText("")
        EnsureSelectedCategory()
        RefreshActionButtons()
        RefreshManagerUI()
        RefreshMainPanelLabels()
        RefreshChatChannelDropDown()
        RefreshProfileUI()
        print("|cFF00FF00[RandomDialogRP]|r Default phrases and settings restored.")
    end
}

function ShowResetConfirmation()
    if not StaticPopup_Show("RANDOMDIALOGRP_RESET_CONFIRM") then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("resetDialogUnavailable"))
    end
end

resetDataBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
resetDataBtn:SetSize(140, 24)
resetDataBtn:SetPoint("BOTTOM", managerFrame, "BOTTOM", -80, 15)
resetDataBtn:SetText(L("resetBtn"))
RandomDialogRP_UI.StyleButton(resetDataBtn)
resetDataBtn:SetScript("OnClick", ShowResetConfirmation)

saveReloadBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
saveReloadBtn:SetSize(140, 24)
saveReloadBtn:SetPoint("BOTTOM", managerFrame, "BOTTOM", 80, 15)
saveReloadBtn:SetText(L("saveReloadBtn"))
RandomDialogRP_UI.StyleButton(saveReloadBtn)
saveReloadBtn:SetScript("OnClick", function()
    ReloadUI()
end)

tutorialBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
tutorialBtn:SetSize(140, 24)
tutorialBtn:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 300, -85)
tutorialBtn:SetText(L("tutorialBtn"))
RandomDialogRP_UI.StyleButton(tutorialBtn)
tutorialBtn:SetScript("OnClick", ShowTutorial)
tutorialBtn:SetShown(selectedManagerTab == "settings")

frame:HookScript("OnShow", MaybeShowTutorial)
managerFrame:HookScript("OnShow", MaybeShowTutorial)

configBtn:SetScript("OnClick", function()
    if managerFrame:IsShown() then
        managerFrame:Hide()
    else
        RefreshManagerUI()
        managerFrame:Show()
    end
end)

DropDown_OnClick = function(self)
    currentRace = self.value
    local previousClass = currentClass
    RefreshMainClassDropDown()
    if currentClass ~= previousClass then
        RandomDialogRPDB.rpClass = currentClass
        RandomDialogRP_Profiles.SaveActive()
    end
    UIDropDownMenu_SetSelectedValue(dropDown, currentRace)
    UIDropDownMenu_SetText(dropDown, currentRace)
    RefreshActionButtons()
end
UIDropDownMenu_Initialize(dropDown, DropDown_Initialize)

closeBtn = CreateFrame("Button", nil, managerFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -2, -2)

for _, label in ipairs({ managerFrame:GetRegions() }) do
    if label:GetObjectType() == "FontString" and label ~= warningText then
        label:SetTextColor(1, 0.82, 0.12)
    end
end

for _, button in ipairs({
    addCategoryBtn, renameCategoryBtn, deleteCategoryBtn, categoryIconBtn,
    createPersonalityBtn, renamePersonalityBtn, deletePersonalityBtn,
    createProfileBtn, saveProfileBtn, loadProfileBtn, renameProfileBtn, deleteProfileBtn,
}) do
    RandomDialogRP_UI.StyleButton(button)
end

-- ============================================================================
