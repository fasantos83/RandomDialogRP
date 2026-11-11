-- Phrase manager UI.
catDropDown = CreateFrame("Frame", "RandomDialogRPCatDropDown", managerFrame, "UIDropDownMenuTemplate")
catDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -85)
UIDropDownMenu_SetWidth(catDropDown, 120)

categorySectionLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
categorySectionLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -75)

phraseSearchLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseSearchLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 188, -75)

phraseSearchBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
phraseSearchBox:SetSize(300, 20)
phraseSearchBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 186, -85)
phraseSearchBox:SetAutoFocus(false)

categoryNameFieldLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
categoryNameFieldLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -119)

function CatDropDown_OnClick(self)
    selectedCategory = self.value
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory))
    editingIndex = nil
    editBox:SetText("")
    RefreshManagerUI()
end

function CatDropDown_Initialize(self, level)
    for _, cat in ipairs(GetCategories(currentRace)) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = GetCategoryLabel(cat)
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
langDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -85)
UIDropDownMenu_SetWidth(langDropDown, 110)

function LangDropDown_OnClick(self)
    RandomDialogRPDB.language = self.value
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    RefreshMainPanelLabels()
    RefreshChatChannelDropDown()
    RefreshManagerUI()
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
editBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -130)
editBox:SetAutoFocus(false)

phraseEntryLabel = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
phraseEntryLabel:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 20, -119)

actionBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
actionBtn:SetSize(75, 22)
actionBtn:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
actionBtn:SetText(L("addBtn"))

cancelEditBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
cancelEditBtn:SetSize(70, 22)
cancelEditBtn:SetPoint("LEFT", actionBtn, "RIGHT", 4, 0)
cancelEditBtn:SetText(L("cancelBtn"))
cancelEditBtn:Hide()

-- Scrollable List
scrollFrame = CreateFrame("ScrollFrame", "RandomDialogRPScrollFrame", managerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(500, 220)
scrollFrame:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 15, -165)

scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(500, 220)
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
    highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlight:SetBlendMode("ADD")

    tab.label = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    tab.label:SetPoint("CENTER", tab, "CENTER", 0, 1)

    return tab
end

phraseTab = CreateManagerTab()
phraseTab:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -30)

categoryTab = CreateManagerTab()
categoryTab:SetPoint("LEFT", phraseTab, "RIGHT", 4, 0)

settingsTab = CreateManagerTab()
settingsTab:SetPoint("LEFT", categoryTab, "RIGHT", 4, 0)

managerSectionDivider = managerFrame:CreateTexture(nil, "ARTWORK")
managerSectionDivider:SetColorTexture(0.65, 0.65, 0.65, 0.55)
managerSectionDivider:SetHeight(1)
managerSectionDivider:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 16, -61)
managerSectionDivider:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -16, -61)

function SetManagerTab(tab)
    selectedManagerTab = tab
    local showPhrases = tab == "phrases"
    local showCategories = tab == "categories"
    local showSettings = tab == "settings"

    categorySectionLabel:SetShown(showPhrases or showCategories)
    catDropDown:SetShown(showPhrases or showCategories)
    phraseSearchLabel:SetShown(showPhrases)
    phraseSearchBox:SetShown(showPhrases)
    categoryNameFieldLabel:SetShown(showCategories)
    editBox:SetShown(showPhrases)
    phraseEntryLabel:SetShown(showPhrases)
    actionBtn:SetShown(showPhrases)
    cancelEditBtn:SetShown(showPhrases and editingIndex ~= nil)
    scrollFrame:SetShown(showPhrases)
    categoryNameBox:SetShown(showCategories)
    addCategoryBtn:SetShown(showCategories)
    renameCategoryBtn:SetShown(showCategories)
    deleteCategoryBtn:SetShown(showCategories)
    categoryIconBtn:SetShown(showCategories)
    languageSectionLabel:SetShown(showSettings)
    langDropDown:SetShown(showSettings)

    for _, tab in ipairs({ phraseTab, categoryTab, settingsTab }) do
        local selected = tab == phraseTab and showPhrases
            or tab == categoryTab and showCategories
            or tab == settingsTab and showSettings
        tab.background:SetTexture(selected
            and "Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab"
            or "Interface\\OptionsFrame\\UI-OptionsFrame-InactiveTab")
        tab.label:SetFontObject(selected and GameFontNormalSmall or GameFontDisableSmall)
    end
end

phraseTab.label:SetText(L("phrasesTab"))
categoryTab.label:SetText(L("categoriesTab"))
settingsTab.label:SetText(L("settingsTab"))
phraseTab:SetScript("OnClick", function() SetManagerTab("phrases") end)
categoryTab:SetScript("OnClick", function() SetManagerTab("categories") end)
settingsTab:SetScript("OnClick", function() SetManagerTab("settings") end)
SetManagerTab(selectedManagerTab)

function CreateEmoteSelector(parent, categoryData, phrases, phraseIndex)
    local selector = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    selector:SetSize(78, 20)
    selector:SetText(GetPhraseEmote(phrases[phraseIndex], categoryData) or L("emoteLabel"))

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
            local categoryData = RandomDialogRP_CustomDB[currentRace][selectedCategory]
            categoryData.icon = texturePath
            categoryIcon:SetTexture(texturePath)
            popup:Hide()
            RefreshActionButtons()
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

    local categoryData = RandomDialogRP_CustomDB[currentRace]
        and RandomDialogRP_CustomDB[currentRace][selectedCategory]
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

            local rowHeight = math.max(30, text:GetStringHeight() + 8)
            row:SetHeight(rowHeight)
            text:SetHeight(rowHeight - 6)

            local emoteSelector = CreateEmoteSelector(row, categoryData, phrases, phraseIndex)
            emoteSelector:SetPoint("LEFT", row, "LEFT", 310, 0)

            local editRowBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            editRowBtn:SetSize(40, 18)
            editRowBtn:SetPoint("RIGHT", row, "RIGHT", -60, 0)
            editRowBtn:SetText(L("editBtn"))
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
            delBtn:SetScript("OnClick", function()
                table.remove(RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases, phraseIndex)
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
        phraseListStatus:SetText(#phrases == 0 and L("noPhrases") or L("noSearchResults"))
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
    categoryTab.label:SetText(L("categoriesTab"))
    settingsTab.label:SetText(L("settingsTab"))
    categorySectionLabel:SetText(L("categoryLabel"))
    phraseSearchLabel:SetText(L("searchLabel"))
    categoryNameFieldLabel:SetText(L("categoryName"))
    phraseEntryLabel:SetText(L("phraseLabel"))
    languageSectionLabel:SetText(L("languageLabel"))
    SetManagerTab(selectedManagerTab)

    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory))
    
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    
    phraseEntryLabel:SetText(editingIndex and (L("editingPhrase") .. " " .. editingIndex .. ":") or L("phraseLabel"))
    actionBtn:SetText(editingIndex and L("updateBtn") or L("addBtn"))
    cancelEditBtn:SetText(L("cancelBtn"))
    cancelEditBtn:SetShown(selectedManagerTab == "phrases" and editingIndex ~= nil)
    categoryNameBox:SetText(GetCategoryLabel(selectedCategory))
    categoryIcon:SetTexture(GetCategoryIcon(selectedCategory))
    addCategoryBtn:SetText(L("addCategoryBtn"))
    renameCategoryBtn:SetText(L("renameCategoryBtn"))
    deleteCategoryBtn:SetText(L("deleteCategoryBtn"))
    if resetDataBtn then resetDataBtn:SetText(L("resetBtn")) end
    
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
    for _, category in ipairs(GetCategories(currentRace)) do
        if category ~= ignoredCategory and string.lower(GetCategoryLabel(category)) == string.lower(name) then
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
    local raceData = RandomDialogRP_CustomDB[currentRace]
    raceData[name] = {
        phrases = {},
        emote = "WAVE",
        label = name,
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    }
    table.insert(raceData.categoryOrder, name)
    selectedCategory = name
    categoryNameBox:SetText("")
    RefreshActionButtons()
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryAdded"))
end)

renameCategoryBtn:SetScript("OnClick", function()
    local name = GetEnteredCategoryName()
    if name == "" or CategoryNameExists(name, selectedCategory) then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("categoryExists"))
        return
    end
    local raceData = RandomDialogRP_CustomDB[currentRace]
    if IsBuiltinCategory(selectedCategory) then
        raceData[selectedCategory].label = name
    else
        local oldCategory = selectedCategory
        raceData[name] = raceData[oldCategory]
        raceData[name].label = name
        raceData[oldCategory] = nil
        for index, category in ipairs(raceData.categoryOrder) do
            if category == oldCategory then raceData.categoryOrder[index] = name; break end
        end
        selectedCategory = name
    end
    RefreshActionButtons()
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryUpdated"))
end)

deleteCategoryBtn:SetScript("OnClick", function()
    if IsBuiltinCategory(selectedCategory) then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("cannotDeleteCategory"))
        return
    end
    StaticPopup_Show("RANDOMDIALOGRP_DELETE_CATEGORY_CONFIRM", nil, nil, {
        race = currentRace,
        category = selectedCategory
    })
end)

actionBtn:SetScript("OnClick", function()
    local text = editBox:GetText()
    if text and text ~= "" then
        RandomDialogRP_CustomDB[currentRace] = RandomDialogRP_CustomDB[currentRace] or {}
        RandomDialogRP_CustomDB[currentRace][selectedCategory] = RandomDialogRP_CustomDB[currentRace][selectedCategory] or { phrases = {}, emote = "WAVE" }
        
        if editingIndex then
            local categoryData = RandomDialogRP_CustomDB[currentRace][selectedCategory]
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
            local categoryData = RandomDialogRP_CustomDB[currentRace][selectedCategory]
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
        dialog.text:SetFormattedText(L("deleteCategoryConfirm"), dialog.data.category)
    end,
    OnAccept = function(_, data)
        local raceData = RandomDialogRP_CustomDB[data.race]
        if not raceData or not raceData[data.category] or IsBuiltinCategory(data.category) then
            return
        end

        raceData[data.category] = nil
        for index, category in ipairs(raceData.categoryOrder) do
            if category == data.category then
                table.remove(raceData.categoryOrder, index)
                break
            end
        end

        if currentRace == data.race then
            selectedCategory = GetCategories(currentRace)[1]
            editingIndex = nil
            editBox:SetText("")
            RefreshActionButtons()
            RefreshManagerUI()
        end
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
        dialog.text:SetText(L("resetConfirm"))
    end,
    OnAccept = function()
        RandomDialogRPDB = { profiles = {} }
        RandomDialogRP_CustomDB = {}
        RandomDialogRP_Profiles.ActivateCurrent()
        InitCustomDB()
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
        MoveMinimapButton(45)
        selectedCategory = "greetings"
        editingIndex = nil
        editBox:SetText("")
        EnsureSelectedCategory()
        RefreshActionButtons()
        RefreshManagerUI()
        print("|cFF00FF00[RandomDialogRP]|r Default phrases and settings restored.")
    end
}

resetDataBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
resetDataBtn:SetSize(140, 24)
resetDataBtn:SetPoint("BOTTOM", managerFrame, "BOTTOM", -80, 15)
resetDataBtn:SetText(L("resetBtn"))
resetDataBtn:SetScript("OnClick", function()
    StaticPopup_Show("RANDOMDIALOGRP_RESET_CONFIRM")
end)

saveReloadBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
saveReloadBtn:SetSize(140, 24)
saveReloadBtn:SetPoint("BOTTOM", managerFrame, "BOTTOM", 80, 15)
saveReloadBtn:SetText(L("saveReloadBtn"))
saveReloadBtn:SetScript("OnClick", function()
    ReloadUI()
end)

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
    EnsureSelectedCategory()
    UIDropDownMenu_SetSelectedValue(dropDown, currentRace)
    UIDropDownMenu_SetText(dropDown, currentRace)
    RefreshActionButtons()
    if managerFrame:IsShown() then RefreshManagerUI() end
end
UIDropDownMenu_Initialize(dropDown, DropDown_Initialize)

closeBtn = CreateFrame("Button", nil, managerFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -2, -2)

-- ============================================================================
