-- Core.lua
-- Main addon logic, Auto Race Detection (Skyborne & standard races), Phrase Manager with Edit Mode & Localization

local currentRace = "Tauren"
local buttonTexts = {}

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
        for catName, catData in pairs(categories) do
            if not RandomDialogRP_CustomDB[raceName][catName] or not RandomDialogRP_CustomDB[raceName][catName].phrases then
                RandomDialogRP_CustomDB[raceName][catName] = {
                    phrases = {},
                    emote = catData.emote
                }
                for _, phrase in ipairs(catData.frases) do
                    table.insert(RandomDialogRP_CustomDB[raceName][catName].phrases, phrase)
                end
            else
                for _, defaultPhrase in ipairs(catData.frases) do
                    local exists = false
                    for _, savedPhrase in ipairs(RandomDialogRP_CustomDB[raceName][catName].phrases) do
                        if savedPhrase == defaultPhrase then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        table.insert(RandomDialogRP_CustomDB[raceName][catName].phrases, defaultPhrase)
                    end
                end
            end
        end
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
    local basePhrase = raceData.phrases[index]
    local target = GetTargetName()
    local formattedPhrase = string.format(basePhrase, target)
    
    SendChatMessage(formattedPhrase, "SAY")
    if raceData.emote then
        DoEmote(raceData.emote)
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

local raceOrder = {
    -- Alliance
    "Human",
    "Dwarf",
    "NightElf",
    "Gnome",
    -- Horde
    "Orc",
    "Troll",
    "Tauren",
    "Undead",
    -- Neutral
    "Skyborne"
}

local function DropDown_Initialize(self, level)
    for _, raceName in ipairs(raceOrder) do
        -- Garante que só exibe se a raça existir no banco de dados
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
local function CreateActionButton(textKey, category, posY)
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(170, 24)
    btn:SetPoint("TOP", frame, "TOP", 0, posY)
    
    local buttonText = btn:GetFontString()
    buttonTexts[category] = { btn = btn, key = textKey }
    btn:SetText(L(textKey))
    
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("LEFT", btn, "LEFT", 6, 0)
    icon:SetTexture(RandomDialogRP_Icons[category] or "Interface\\Icons\\INV_Misc_QuestionMark")
    
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

CreateActionButton("greetings", "greetings", -60)
CreateActionButton("thanks", "thanks", -90)
CreateActionButton("battle", "battle", -120)

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
managerFrame:SetSize(380, 360)
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

-- Category Dropdown
local catDropDown = CreateFrame("Frame", "RandomDialogRPCatDropDown", managerFrame, "UIDropDownMenuTemplate")
catDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 10, -35)
UIDropDownMenu_SetWidth(catDropDown, 120)

local function CatDropDown_OnClick(self)
    selectedCategory = self.value
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, L(selectedCategory))
    editingIndex = nil
    RefreshManagerUI()
end

local function CatDropDown_Initialize(self, level)
    local categories = { "greetings", "thanks", "battle" }
    for _, cat in ipairs(categories) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = L(cat)
        info.value = cat
        info.func = CatDropDown_OnClick
        info.checked = (selectedCategory == cat)
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_Initialize(catDropDown, CatDropDown_Initialize)

-- Language Dropdown (Defaults to English)
local langDropDown = CreateFrame("Frame", "RandomDialogRPLangDropDown", managerFrame, "UIDropDownMenuTemplate")
langDropDown:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 185, -35)
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
editBox:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 18, -80)
editBox:SetAutoFocus(false)

local actionBtn = CreateFrame("Button", nil, managerFrame, "UIPanelButtonTemplate")
actionBtn:SetSize(75, 22)
actionBtn:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
actionBtn:SetText(L("addBtn"))

-- Scrollable List
local scrollFrame = CreateFrame("ScrollFrame", "RandomDialogRPScrollFrame", managerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(320, 160)
scrollFrame:SetPoint("TOPLEFT", managerFrame, "TOPLEFT", 15, -115)

local scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(320, 160)
scrollFrame:SetScrollChild(scrollContent)

local phraseRows = {}

RefreshManagerUI = function()
    managerTitle:SetText(L("managerTitle"))
    UIDropDownMenu_SetSelectedValue(catDropDown, selectedCategory)
    UIDropDownMenu_SetText(catDropDown, L(selectedCategory))
    
    UIDropDownMenu_SetSelectedValue(langDropDown, RandomDialogRPDB.language)
    UIDropDownMenu_SetText(langDropDown, RandomDialogRPDB.language == "ptBR" and "Português" or "English")
    
    actionBtn:SetText(editingIndex and L("editBtn") or L("addBtn"))
    
    for cat, data in pairs(buttonTexts) do
        data.btn:SetText(L(data.key))
    end

    for _, row in ipairs(phraseRows) do row:Hide() end
    phraseRows = {}
    
    local phrases = RandomDialogRP_CustomDB[currentRace] and RandomDialogRP_CustomDB[currentRace][selectedCategory] and RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases or {}
    
    local yOffset = 0
    for idx, fraseText in ipairs(phrases) do
        local row = CreateFrame("Frame", nil, scrollContent)
        row:SetSize(305, 24)
        row:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, yOffset)
        
        local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        txt:SetPoint("LEFT", row, "LEFT", 0, 0)
        txt:SetSize(210, 20)
        txt:SetJustifyH("LEFT")
        txt:SetText(idx .. ". " .. fraseText)
        
        local editRowBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        editRowBtn:SetSize(40, 18)
        editRowBtn:SetPoint("RIGHT", row, "RIGHT", -45, 0)
        editRowBtn:SetText(L("editBtn"))
        
        editRowBtn:SetScript("OnClick", function()
            editingIndex = idx
            editBox:SetText(fraseText)
            editBox:SetFocus()
            RefreshManagerUI()
        end)
        
        local delBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        delBtn:SetSize(40, 18)
        delBtn:SetPoint("RIGHT", row, "RIGHT", 0, 0)
        delBtn:SetText(L("delBtn"))
        
        delBtn:SetScript("OnClick", function()
            table.remove(RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases, idx)
            if editingIndex == idx then editingIndex = nil; editBox:SetText("") end
            RefreshManagerUI()
            print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseRemoved"))
        end)
        
        table.insert(phraseRows, row)
        yOffset = yOffset - 26
    end
    scrollContent:SetHeight(math.max(160, math.abs(yOffset)))
end

actionBtn:SetScript("OnClick", function()
    local text = editBox:GetText()
    if text and text ~= "" then
        RandomDialogRP_CustomDB[currentRace] = RandomDialogRP_CustomDB[currentRace] or {}
        RandomDialogRP_CustomDB[currentRace][selectedCategory] = RandomDialogRP_CustomDB[currentRace][selectedCategory] or { phrases = {}, emote = "WAVE" }
        
        if editingIndex then
            RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases[editingIndex] = text
            print("|cFF00FF00[RandomDialogRP]|r " .. L("phraseUpdated"))
            editingIndex = nil
        else
            table.insert(RandomDialogRP_CustomDB[currentRace][selectedCategory].phrases, text)
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
    UIDropDownMenu_SetSelectedValue(dropDown, currentRace)
    UIDropDownMenu_SetText(dropDown, currentRace)
    if managerFrame:IsShown() then RefreshManagerUI() end
end
UIDropDownMenu_Initialize(dropDown, DropDown_Initialize)

local closeBtn = CreateFrame("Button", nil, managerFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", managerFrame, "TOPRIGHT", -2, -2)

-- ============================================================================
-- 3. MINIMAP BUTTON
-- ============================================================================
local minimapButton = CreateFrame("Button", "RandomDialogRPMiniButton", Minimap)
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
-- 4. EVENT LISTENER & SLASH COMMANDS (WITH SKYBORNE DETECTION)
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