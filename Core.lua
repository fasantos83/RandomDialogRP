-- Core.lua
-- Main addon logic, Auto Race Detection, Phrase Manager with Edit Mode & Localization

local currentRace = "Tauren"
local buttonTexts = {}
local builtinCategories = { "greetings", "thanks", "battle" }
local emoteOptions = {
    "AGREE", "AMAZE", "ANGRY", "APPLAUD", "ATTACKMYTARGET", "BARK", "BECKON",
    "BOW", "BYE", "CACKLE", "CHEER", "CHEST", "CHICKEN", "CHUCKLE", "CLAP", "COWER", "CRY",
    "DANCE", "DRINK", "EAT", "FLEE", "FLEX", "GLOAT", "GREET", "GROWL",
    "GUFFAW", "HAIL", "KISS", "KNEEL", "LAUGH", "LAYDOWN", "LOL", "MOON",
    "NO", "POINT",     "ROAR", "RUDE", "SALUTE", "SHOUT", "SHRUG", "SIGH", "SIT",
    "SLEEP", "SMILE", "SORRY", "STARE", "SURPRISED", "TALK", "THANK",
    "THREATEN", "WAVE", "WELCOME", "WHISTLE", "WINK", "WORK", "YAWN", "YES"
}
local iconOptions = (GetMacroIcons and GetMacroIcons()) or {}
if #iconOptions == 0 then
    iconOptions = { "Interface\\Icons\\INV_Misc_QuestionMark" }
end

-- SavedVariables Initializers (Enforces English 'enUS' as default)
RandomDialogRPDB = RandomDialogRPDB or {}
RandomDialogRPDB.panel = RandomDialogRPDB.panel or { point = "CENTER", relativePoint = "CENTER", xOfs = 0, yOfs = -100 }
RandomDialogRPDB.minimap = RandomDialogRPDB.minimap or { angle = 45 }
RandomDialogRPDB.language = RandomDialogRPDB.language or "enUS"

RandomDialogRP_CustomDB = RandomDialogRP_CustomDB or {}

-- Initialize Custom DB and guarantee defaults are always present
local function InitCustomDB()
    RandomDialogRP_CustomDB = RandomDialogRP_CustomDB or {}
    
    for raceName, categories in pairs(RandomDialogRP_Defaults) do
        RandomDialogRP_CustomDB[raceName] = RandomDialogRP_CustomDB[raceName] or {}
        local raceData = RandomDialogRP_CustomDB[raceName]
        raceData.categoryOrder = raceData.categoryOrder or {}
        for _, category in ipairs(builtinCategories) do
            local found = false
            for _, savedCategory in ipairs(raceData.categoryOrder) do
                if savedCategory == category then found = true; break end
            end
            if not found and categories[category] then
                table.insert(raceData.categoryOrder, category)
            end
        end
        for catName, catData in pairs(categories) do
            if not raceData[catName] or not raceData[catName].phrases then
                raceData[catName] = {
                    phrases = {},
                    emote = catData.emote,
                    icon = RandomDialogRP_Icons[catName]
                }
                for _, phrase in ipairs(catData.frases) do
                    table.insert(raceData[catName].phrases, phrase)
                end
            else
                raceData[catName].icon = raceData[catName].icon or RandomDialogRP_Icons[catName]
                for _, defaultPhrase in ipairs(catData.frases) do
                    local exists = false
                    for _, savedPhrase in ipairs(raceData[catName].phrases) do
                        local savedText = type(savedPhrase) == "table" and savedPhrase.text or savedPhrase
                        if savedText == defaultPhrase then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        table.insert(raceData[catName].phrases, defaultPhrase)
                    end
                end
            end
        end
        for category in pairs(raceData) do
            if category ~= "categoryOrder" then
                local found = false
                for _, savedCategory in ipairs(raceData.categoryOrder) do
                    if savedCategory == category then found = true; break end
                end
                if not found then table.insert(raceData.categoryOrder, category) end
            end
        end
    end
end

local function GetCategories(raceName)
    local raceData = RandomDialogRP_CustomDB[raceName] or {}
    return raceData.categoryOrder or builtinCategories
end

local function IsBuiltinCategory(category)
    for _, builtin in ipairs(builtinCategories) do
        if category == builtin then return true end
    end
    return false
end

local function GetCategoryLabel(category)
    local raceData = RandomDialogRP_CustomDB[currentRace]
    local categoryData = raceData and raceData[category]
    return (categoryData and categoryData.label) or L(category)
end

local function GetCategoryIcon(category)
    local raceData = RandomDialogRP_CustomDB[currentRace]
    local categoryData = raceData and raceData[category]
    return (categoryData and categoryData.icon) or RandomDialogRP_Icons[category] or "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function GetPhraseText(phrase)
    return type(phrase) == "table" and phrase.text or phrase
end

local function GetPhraseEmote(phrase, categoryData)
    return (type(phrase) == "table" and phrase.emote) or (categoryData and categoryData.emote)
end

local function SetPhraseEmote(categoryData, index, emote)
    local phrase = categoryData.phrases[index]
    if type(phrase) == "table" then
        phrase.emote = emote
    else
        categoryData.phrases[index] = { text = phrase, emote = emote }
    end
end

local function GetTargetName()
    local targetName = UnitName("target")
    return (targetName and targetName ~= "") and targetName or "friend"
end

local function ExecuteRP(category)
    local raceData = RandomDialogRP_CustomDB[currentRace] and RandomDialogRP_CustomDB[currentRace][category]
    if not raceData or #raceData.phrases == 0 then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("noPhrases"))
        return
    end
    
    local index = math.random(1, #raceData.phrases)
    local phrase = raceData.phrases[index]
    local basePhrase = GetPhraseText(phrase)
    local target = GetTargetName()
    local formattedPhrase = string.format(basePhrase, target)
    
    SendChatMessage(formattedPhrase, "SAY")
    local emote = GetPhraseEmote(phrase, raceData)
    if emote then
        DoEmote(emote)
    end
end

-- ============================================================================
-- 1. MAIN FRAME PANEL
-- ============================================================================
local frame = CreateFrame("Frame", "RandomDialogRPFrame", UIParent, "BackdropTemplate")
frame:SetSize(190, 175)
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

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
title:SetPoint("TOP", frame, "TOP", 0, -8)
title:SetText("RandomDialogRP")

-- Race Dropdown
local dropDown = CreateFrame("Frame", "RandomDialogRPRaceDropDown", frame, "UIDropDownMenuTemplate")
dropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, -28)
UIDropDownMenu_SetWidth(dropDown, 120)

local DropDown_OnClick

-- Ordem exata: Aliança, Horda e Skyborne no fim
local raceOrder = {
    "Human", "Dwarf", "NightElf", "Gnome",
    "Orc", "Troll", "Tauren", "Undead",
    "Skyborne"
}

local function DropDown_Initialize(self, level)
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
local function CreateActionButton(category, posY)
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(170, 24)
    btn:SetPoint("TOP", frame, "TOP", 0, posY)
    
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

local function RefreshActionButtons()
    for _, data in pairs(buttonTexts) do data.btn:Hide() end
    buttonTexts = {}
    local categories = GetCategories(currentRace)
    frame:SetHeight(math.max(175, 85 + (#categories * 30)))
    for index, category in ipairs(categories) do
        local button = CreateActionButton(category, -60 - ((index - 1) * 30))
        button:Show()
    end
end

-- Config/Settings Gear Button
local configBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
configBtn:SetSize(24, 24)
configBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
configBtn:SetText("")

local configIcon = configBtn:CreateTexture(nil, "ARTWORK")
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
-- ============================================================================
local managerFrame = CreateFrame("Frame", "RandomDialogRPManager", UIParent, "BackdropTemplate")
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

managerFrame:RegisterForDrag("LeftButton")
managerFrame:SetScript("OnDragStart", managerFrame.StartMoving)
managerFrame:SetScript("OnDragStop", managerFrame.StopMovingOrSizing)

local managerTitle = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
managerTitle:SetPoint("TOP", managerFrame, "TOP", 0, -10)
managerTitle:SetText(L("managerTitle"))

local selectedCategory = "greetings"
local editingIndex = nil
local RefreshManagerUI

local function EnsureSelectedCategory()
    local categories = GetCategories(currentRace)
    for _, category in ipairs(categories) do
        if category == selectedCategory then return end
    end
    selectedCategory = categories[1]
    editingIndex = nil
end

-- Category Dropdown
local catDropDown = CreateFrame("Frame", "RandomDialogRPCatDropDown", managerFrame, "UIDropDownMenuTemplate")
catDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -35)
UIDropDownMenu_SetWidth(catDropDown, 120)

local function CatDropDown_OnClick(self)
    selectedCategory = self.value
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory))
    editingIndex = nil
    RefreshManagerUI()
end

local function CatDropDown_Initialize(self, level)
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

local categoryNameBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
categoryNameBox:SetSize(150, 20)
categoryNameBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -80)
categoryNameBox:SetAutoFocus(false)

local addCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
addCategoryBtn:SetSize(65, 22)
addCategoryBtn:SetPoint("LEFT", catDropDown, "RIGHT", 0, 0)

local renameCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
renameCategoryBtn:SetSize(70, 22)
renameCategoryBtn:SetPoint("LEFT", categoryNameBox, "RIGHT", 6, 0)

local deleteCategoryBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
deleteCategoryBtn:SetSize(60, 22)
deleteCategoryBtn:SetPoint("LEFT", renameCategoryBtn, "RIGHT", 4, 0)

local categoryIconBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
categoryIconBtn:SetSize(24, 24)
categoryIconBtn:SetPoint("LEFT", deleteCategoryBtn, "RIGHT", 8, 0)

local categoryIcon = categoryIconBtn:CreateTexture(nil, "ARTWORK")
categoryIcon:SetSize(18, 18)
categoryIcon:SetPoint("CENTER")

-- Language Dropdown (Defaults to English)
local langDropDown = CreateFrame("Frame", "RandomDialogRPLangDropDown", managerFrame, "UIDropDownMenuTemplate")
langDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 400, -35)
UIDropDownMenu_SetWidth(langDropDown, 110)

local function LangDropDown_OnClick(self)
    RandomDialogRPDB.language = self.value
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    RefreshManagerUI()
end

local function LangDropDown_Initialize(self, level)
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
local editBox = CreateFrame("EditBox", nil, managerFrame, "InputBoxTemplate")
editBox:SetSize(250, 20)
editBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -110)
editBox:SetAutoFocus(false)

local actionBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
actionBtn:SetSize(75, 22)
actionBtn:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
actionBtn:SetText(L("addBtn"))

-- Scrollable List
local scrollFrame = CreateFrame("ScrollFrame", "RandomDialogRPScrollFrame", managerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(500, 220)
scrollFrame:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 15, -145)

local scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(500, 220)
scrollFrame:SetScrollChild(scrollContent)

local phraseRows = {}

local function CreateEmoteSelector(parent, categoryData, phrases, phraseIndex)
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

local function CreateIconSelector()
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

RefreshManagerUI = function()
    managerTitle:SetText(L("managerTitle"))
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, GetCategoryLabel(selectedCategory))
    
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    
    actionBtn:SetText(editingIndex and L("editBtn") or L("addBtn"))
    categoryNameBox:SetText(GetCategoryLabel(selectedCategory))
    categoryIcon:SetTexture(GetCategoryIcon(selectedCategory))
    addCategoryBtn:SetText(L("addCategoryBtn"))
    renameCategoryBtn:SetText(L("renameCategoryBtn"))
    deleteCategoryBtn:SetText(L("deleteCategoryBtn"))
    
    for cat, data in pairs(buttonTexts) do
        data.btn:SetText(GetCategoryLabel(cat))
    end

    for _, row in ipairs(phraseRows) do row:Hide() end
    phraseRows = {}
    
    local phrases = RandomDialogRP_CustomDB[currentRace] and RandomDialogRP_CustomDB[currentRace][selectedCategory] and RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases or {}
    
    local yOffset = 0
    local categoryData = RandomDialogRP_CustomDB[currentRace] and RandomDialogRP_CustomDB[currentRace][selectedCategory]
    for idx, phrase in ipairs(phrases) do
        local phraseText = GetPhraseText(phrase)
        local row = CreateFrame("Frame", nil, scrollContent)
        row:SetSize(500, 30)
        row:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, yOffset)
        
        local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        txt:SetPoint("LEFT", row, "LEFT", 0, 0)
        txt:SetSize(260, 26)
        txt:SetJustifyH("LEFT")
        txt:SetText(idx .. ". " .. phraseText)

        local emoteDropDown = CreateEmoteSelector(row, categoryData, phrases, idx)
        emoteDropDown:SetPoint("LEFT", row, "LEFT", 270, 0)
        
        local editRowBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        editRowBtn:SetSize(40, 18)
        editRowBtn:SetPoint("RIGHT", row, "RIGHT", -85, 0)
        editRowBtn:SetText(L("editBtn"))
        
        editRowBtn:SetScript("OnClick", function()
            editingIndex = idx
            editBox:SetText(phraseText)
            editBox:SetFocus()
            RefreshManagerUI()
        end)
        
        local delBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        delBtn:SetSize(40, 18)
        delBtn:SetPoint("RIGHT", row, "RIGHT", -40, 0)
        delBtn:SetText(L("delBtn"))
        
        delBtn:SetScript("OnClick", function()
            table.remove(RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases, idx)
            if editingIndex == idx then editingIndex = nil; editBox:SetText("") end
            RefreshManagerUI()
            print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseRemoved"))
        end)
        
        table.insert(phraseRows, row)
        yOffset = yOffset - 32
    end
    scrollContent:SetHeight(math.max(160, math.abs(yOffset)))
end

local function GetEnteredCategoryName()
    local name = categoryNameBox:GetText() or ""
    return string.gsub(name, "^%s*(.-)%s*$", "%1")
end

local function CategoryNameExists(name, ignoredCategory)
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
    local raceData = RandomDialogRP_CustomDB[currentRace]
    raceData[selectedCategory] = nil
    for index, category in ipairs(raceData.categoryOrder) do
        if category == selectedCategory then table.remove(raceData.categoryOrder, index); break end
    end
    selectedCategory = GetCategories(currentRace)[1]
    editingIndex = nil
    editBox:SetText("")
    RefreshActionButtons()
    RefreshManagerUI()
    print("|cFF00FF00[RandomDialogRP]|r " .. L("categoryRemoved"))
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

local warningText = managerFrame:CreateFontString(nil, "OVERLAY", "GameFontRedSmall")
warningText:SetPoint("BOTTOM", managerFrame, "BOTTOM", 0, 45)
warningText:SetText(L("reloadWarning"))

local saveReloadBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
saveReloadBtn:SetSize(140, 24)
saveReloadBtn:SetPoint("BOTTOM", managerFrame, "BOTTOM", 0, 15)
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

local closeBtn = CreateFrame("Button", nil, managerFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -2, -2)

-- ============================================================================
-- 3. MINIMAP BUTTON (Aggregator Compatible - MBB)
-- ============================================================================
local minimapButton = CreateFrame("Button", "RandomDialogRPMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
minimapButton:RegisterForClicks("LeftButtonUp")
minimapButton:RegisterForDrag("LeftButton")

local function MoveMinimapButton(angle)
    local rad = math.rad(angle)
    local x = math.cos(rad) * 80
    local y = math.sin(rad) * 80
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local iconTexture = minimapButton:CreateTexture(nil, "BACKGROUND")
iconTexture:SetSize(20, 20)
iconTexture:SetPoint("CENTER", minimapButton, "CENTER", 0, 0)
iconTexture:SetTexture("Interface\\Icons\\Spell_Nature_HealingTouch")

local borderTexture = minimapButton:CreateTexture(nil, "OVERLAY")
borderTexture:SetSize(53, 53)
borderTexture:SetPoint("CENTER", minimapButton, "CENTER", 11, -11)
borderTexture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

minimapButton:SetScript("OnDragStart", function(self)
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

minimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        if frame:IsShown() then frame:Hide() else frame:Show() end
    end
end)

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("RandomDialogRP", 1, 1, 1)
    GameTooltip:AddLine("Left-click to toggle main panel.", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Drag to move around minimap.", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- ============================================================================
-- 4. EVENT LISTENER & SLASH COMMANDS
-- ============================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "RandomDialogRP" then
        InitCustomDB()
        
        local _, playerRaceEnglish = UnitRace("player")
        if playerRaceEnglish then
            local raceUpper = string.upper(playerRaceEnglish)
            if string.find(raceUpper, "SKYBORNE") then
                currentRace = "Skyborne"
                print("|cFF00FF00[RandomDialogRP]|r " .. L("autoDetected") .. " " .. currentRace)
            elseif RandomDialogRP_CustomDB[playerRaceEnglish] then
                currentRace = playerRaceEnglish
                print("|cFF00FF00[RandomDialogRP]|r " .. L("autoDetected") .. " " .. currentRace)
            end
        end
        
        UIDropDownMenu_SetSelectedValue(dropDown, currentRace)
        UIDropDownMenu_SetText(dropDown, currentRace)
        EnsureSelectedCategory()
        RefreshActionButtons()
        
        frame:SetPoint(
            RandomDialogRPDB.panel.point,
            UIParent,
            RandomDialogRPDB.panel.relativePoint,
            RandomDialogRPDB.panel.xOfs,
            RandomDialogRPDB.panel.yOfs
        )
        
        if RandomDialogRPDB.minimap and RandomDialogRPDB.minimap.angle then
            MoveMinimapButton(RandomDialogRPDB.minimap.angle)
        end
    end
end)

-- Slash Commands (/rp)
SLASH_RANDOMDIALOGRP1 = "/rp"
SlashCmdList["RANDOMDIALOGRP"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "config" or msg == "edit" then
        RefreshManagerUI()
        managerFrame:Show()
    elseif frame:IsShown() then
        frame:Hide()
        print("|cFF00FF00[RandomDialogRP]|r " .. L("panelHidden"))
    else
        frame:Show()
        print("|cFF00FF00[RandomDialogRP]|r " .. L("panelShown"))
    end
end