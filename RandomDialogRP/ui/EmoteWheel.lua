local OPTION_COUNT = 10
local WHEEL_RADIUS = 130
local BACKGROUND_RADIUS = 220
local wheelPage = 1
local visibleOptions = {}
local optionButtons = {}
local displayedMode, displayedConfig

RandomDialogRP_Wheel = {}

local function GetWheelConfig()
    RandomDialogRPDB.emoteWheel = RandomDialogRPDB.emoteWheel or { categories = {} }
    RandomDialogRPDB.emoteWheel.categories = RandomDialogRPDB.emoteWheel.categories or {}
    return RandomDialogRPDB.emoteWheel
end

local function GetSource(mode)
    if mode == "categories" then return GetCategories() end
    if mode == "emotes" then return emoteOptions end
    error("Unknown wheel mode: " .. tostring(mode))
end

local function GetSavedEntries(mode)
    local config = GetWheelConfig()
    if mode == "categories" then return config.categories[currentPersonality] end
    if mode == "emotes" then return config.emotes end
    error("Unknown wheel mode: " .. tostring(mode))
end

local function GetStartingPage(mode)
    local config = GetWheelConfig()
    local page = config.rememberPage and config.lastPages and config.lastPages[mode]
    if type(page) == "number" and page >= 1 then return math.floor(page) end
    return 1
end

function RandomDialogRP_Wheel.SetRememberPage(enabled)
    GetWheelConfig().rememberPage = enabled
    RandomDialogRP_Profiles.SaveActive()
end

function RandomDialogRP_Wheel.GetEntries(mode)
    local source = GetSource(mode)
    local saved = GetSavedEntries(mode)
    local allowed, seen, result = {}, {}, {}
    for _, value in ipairs(source) do allowed[value] = true end
    for _, value in ipairs(saved or source) do
        if mode == "emotes" then value = RandomDialogRP_UI.ResolveEmote(value) end
        local supported = allowed[value] or (mode == "emotes" and MAXEMOTEINDEX
            and RandomDialogRP_UI.IsSupportedEmote(value))
        if supported and not seen[value] then
            table.insert(result, value)
            seen[value] = true
        end
    end
    return result
end

function RandomDialogRP_Wheel.GetAvailable(mode)
    local included, available = {}, {}
    for _, value in ipairs(RandomDialogRP_Wheel.GetEntries(mode)) do included[value] = true end
    for _, value in ipairs(GetSource(mode)) do
        if not included[value] then table.insert(available, value) end
    end
    return available
end

local function SaveEntries(mode, entries)
    local config = GetWheelConfig()
    if mode == "categories" then
        config.categories[currentPersonality] = entries
    else
        config.emotes = entries
    end
    RandomDialogRP_Profiles.SaveActive()
end

function RandomDialogRP_Wheel.Add(mode, value)
    local available = RandomDialogRP_Wheel.GetAvailable(mode)
    for _, candidate in ipairs(available) do
        if candidate == value then
            local entries = RandomDialogRP_Wheel.GetEntries(mode)
            table.insert(entries, value)
            SaveEntries(mode, entries)
            return
        end
    end
    error("Wheel item is not available: " .. tostring(value))
end

function RandomDialogRP_Wheel.Remove(mode, index)
    local entries = RandomDialogRP_Wheel.GetEntries(mode)
    assert(entries[index], "Wheel item index is invalid")
    table.remove(entries, index)
    SaveEntries(mode, entries)
end

function RandomDialogRP_Wheel.Move(mode, index, direction)
    local entries = RandomDialogRP_Wheel.GetEntries(mode)
    local target = index + direction
    assert((direction == -1 or direction == 1) and entries[index] and entries[target],
        "Wheel item move is invalid")
    entries[index], entries[target] = entries[target], entries[index]
    SaveEntries(mode, entries)
end

function RandomDialogRP_Wheel.AddNewCategory(category)
    local entries = GetSavedEntries("categories")
    if entries then
        table.insert(entries, category)
        RandomDialogRP_Profiles.SaveActive()
    end
end

function RandomDialogRP_Wheel.RenameCategory(oldName, newName)
    local entries = GetSavedEntries("categories")
    if entries then
        for index, value in ipairs(entries) do
            if value == oldName then entries[index] = newName; break end
        end
    end
end

function RandomDialogRP_Wheel.DeleteCategory(category)
    local entries = GetSavedEntries("categories")
    if entries then
        for index, value in ipairs(entries) do
            if value == category then table.remove(entries, index); break end
        end
    end
end

function RandomDialogRP_Wheel.CopyPersonality(oldName, newName)
    local categories = GetWheelConfig().categories
    if categories[oldName] then
        categories[newName] = RandomDialogRP_Profiles.Copy(categories[oldName])
    end
end

function RandomDialogRP_Wheel.RenamePersonality(oldName, newName)
    local categories = GetWheelConfig().categories
    categories[newName] = categories[oldName]
    categories[oldName] = nil
end

function RandomDialogRP_Wheel.DeletePersonality(name)
    GetWheelConfig().categories[name] = nil
end

local wheelFrame = CreateFrame("Frame", "RandomDialogRPEmoteWheelFrame", UIParent)
wheelFrame:SetSize(460, 460)
wheelFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
wheelFrame:SetFrameStrata("DIALOG")
wheelFrame:SetMovable(true)
wheelFrame:SetClampedToScreen(true)
wheelFrame:EnableMouse(false)
wheelFrame:Hide()

function RandomDialogRP_Wheel.RestorePosition()
    local position = GetWheelConfig().position
    wheelFrame:ClearAllPoints()
    if position then
        wheelFrame:SetPoint(position.point, UIParent, position.relativePoint, position.xOfs, position.yOfs)
    else
        wheelFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

local wheelBody = CreateFrame("Frame", "RandomDialogRPEmoteWheelBody", wheelFrame)
wheelBody:SetSize(460, 460)
wheelBody:SetPoint("CENTER", wheelFrame, "CENTER", 0, 0)
RegisterResponsiveFrame(wheelBody)

local circleBackground = wheelBody:CreateTexture(nil, "BACKGROUND")
circleBackground:SetSize(BACKGROUND_RADIUS * 2, BACKGROUND_RADIUS * 2)
circleBackground:SetPoint("CENTER", wheelBody, "CENTER", 0, 0)
circleBackground:SetColorTexture(0, 0, 0, 0.75)
local circleMask = wheelBody:CreateMaskTexture()
circleMask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
circleMask:SetAllPoints(circleBackground)
circleBackground:AddMaskTexture(circleMask)
wheelFrame.backgroundCircle = circleBackground

local title = wheelBody:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", wheelBody, "TOP", 0, -12)
title:SetText(L("emoteWheelTitle"))
title:SetTextColor(1, 0.82, 0)

local dragHandle = CreateFrame("Frame", "RandomDialogRPEmoteWheelDragHandle", wheelBody)
dragHandle:SetSize(170, 42)
dragHandle:SetPoint("TOP", wheelBody, "TOP", 0, -6)
dragHandle:EnableMouse(true)
dragHandle:RegisterForDrag("LeftButton")
local dragging = false
dragHandle:SetScript("OnDragStart", function()
    dragging = true
    wheelFrame:StartMoving()
end)
local function StopDragging()
    if not dragging then return end
    dragging = false
    wheelFrame:StopMovingOrSizing()
    local point, _, relativePoint, xOfs, yOfs = wheelFrame:GetPoint()
    GetWheelConfig().position = {
        point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs
    }
    wheelFrame:SetUserPlaced(false)
    RandomDialogRP_Profiles.SaveActive()
end
dragHandle:SetScript("OnDragStop", StopDragging)
wheelFrame:HookScript("OnShow", function(self)
    self:RegisterEvent("GLOBAL_MOUSE_DOWN")
end)
wheelFrame:HookScript("OnHide", function(self)
    self:UnregisterEvent("GLOBAL_MOUSE_DOWN")
    StopDragging()
end)
dragHandle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText(L("emoteWheelDragTooltip"), 1, 1, 1)
    GameTooltip:Show()
end)
dragHandle:SetScript("OnLeave", function() GameTooltip:Hide() end)

local pageLabel = wheelBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
pageLabel:SetPoint("TOP", title, "BOTTOM", 0, -4)

local function CreateWheelButton(name, width, height, point, relativeFrame, relativePoint, x, y, text)
    local button = CreateFrame("Button", name, wheelBody, "UIPanelButtonTemplate")
    button:SetSize(width, height)
    button:SetPoint(point, relativeFrame, relativePoint, x, y)
    button:SetText(text)
    RandomDialogRP_UI.StyleButton(button)
    return button
end

local centerButton = CreateWheelButton(
    "RandomDialogRPEmoteWheelModeButton", 120, 48,
    "CENTER", wheelBody, "CENTER", 0, 0, ""
)
centerButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText(L("emoteWheelToggleTooltip"), 1, 1, 1)
    GameTooltip:Show()
end)
centerButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

local previousButton = CreateWheelButton(
    "RandomDialogRPEmoteWheelPreviousButton", 32, 32,
    "CENTER", wheelBody, "CENTER", -200, 0, "<"
)
local nextButton = CreateWheelButton(
    "RandomDialogRPEmoteWheelNextButton", 32, 32,
    "CENTER", wheelBody, "CENTER", 200, 0, ">"
)

wheelFrame:SetScript("OnEvent", function(self)
    if dragHandle:IsMouseOver() or centerButton:IsMouseOver()
        or (previousButton:IsShown() and previousButton:IsMouseOver())
        or (nextButton:IsShown() and nextButton:IsMouseOver()) then
        return
    end
    for _, button in ipairs(optionButtons) do
        if button:IsShown() and button:IsMouseOver() then return end
    end

    local centerX, centerY = wheelBody:GetCenter()
    if not centerX or not centerY then return end
    local cursorX, cursorY = GetCursorPosition()
    local scale = wheelBody:GetEffectiveScale()
    local x, y = cursorX / scale - centerX, cursorY / scale - centerY
    if x * x + y * y > BACKGROUND_RADIUS * BACKGROUND_RADIUS then
        self:Hide()
    end
end)

local function GetWheelOptions(mode)
    local options = {}
    if mode == "emotes" then
        for _, emote in ipairs(RandomDialogRP_Wheel.GetEntries("emotes")) do
            table.insert(options, { value = emote, label = emote })
        end
    else
        for _, category in ipairs(RandomDialogRP_Wheel.GetEntries("categories")) do
            table.insert(options, { value = category, label = GetCategoryLabel(category) })
        end
    end
    return options
end

local function RefreshWheel()
    local mode = RandomDialogRPDB.emoteWheelMode == "emotes" and "emotes" or "categories"
    local config = GetWheelConfig()
    if mode ~= displayedMode or config ~= displayedConfig then
        wheelPage = GetStartingPage(mode)
        displayedMode, displayedConfig = mode, config
    end
    local options = GetWheelOptions(mode)
    local pageCount = math.max(1, math.ceil(#options / OPTION_COUNT))
    wheelPage = math.min(wheelPage, pageCount)
    visibleOptions = options

    title:SetText(L("emoteWheelTitle"))
    centerButton:SetText(mode == "emotes" and L("emoteWheelEmotes") or L("emoteWheelCategories"))
    pageLabel:SetText(string.format(L("emoteWheelPage"), wheelPage, pageCount))
    if pageCount > 1 then
        previousButton:Show()
        nextButton:Show()
    else
        previousButton:Hide()
        nextButton:Hide()
    end

    for slot, button in ipairs(optionButtons) do
        local optionIndex = ((wheelPage - 1) * OPTION_COUNT) + slot
        local option = options[optionIndex]
        if option then
            button:SetText(option.label)
            if mode == "categories" then
                button.icon:SetTexture(GetCategoryIcon(option.value))
                button.icon:Show()
                button.label:ClearAllPoints()
                button.label:SetPoint("LEFT", button.icon, "RIGHT", 3, 0)
                button.label:SetPoint("RIGHT", button, "RIGHT", -5, 0)
                button.label:SetJustifyH("LEFT")
            else
                button.icon:Hide()
                button.label:ClearAllPoints()
                button.label:SetPoint("LEFT", button, "LEFT", 5, 0)
                button.label:SetPoint("RIGHT", button, "RIGHT", -5, 0)
                button.label:SetJustifyH("CENTER")
            end
            button:Show()
        else
            button:Hide()
        end
    end
end

function RandomDialogRP_Wheel.Refresh()
    if wheelFrame:IsShown() then RefreshWheel() end
end

for slot = 1, OPTION_COUNT do
    local angle = math.rad(90 - ((slot - 1) * 360 / OPTION_COUNT))
    local y = WHEEL_RADIUS * math.sin(angle)
    if slot == 1 then
        y = y + 20
    elseif slot == 6 then
        y = y - 20
    end
    local button = CreateWheelButton(
        "RandomDialogRPEmoteWheelOption" .. slot, 112, 24,
        "CENTER", wheelBody, "CENTER",
        WHEEL_RADIUS * math.cos(angle), y, ""
    )
    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetSize(16, 16)
    button.icon:SetPoint("LEFT", button, "LEFT", 5, 0)
    button.icon:Hide()
    button.label = button:GetFontString()
    local optionSlot = slot
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(self:GetText(), 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    button:SetScript("OnClick", function()
        local optionIndex = ((wheelPage - 1) * OPTION_COUNT) + optionSlot
        local option = visibleOptions[optionIndex]
        if not option then return end

        local mode = RandomDialogRPDB.emoteWheelMode == "emotes" and "emotes" or "categories"
        local config = GetWheelConfig()
        if config.rememberPage then
            config.lastPages = config.lastPages or {}
            config.lastPages[mode] = wheelPage
            RandomDialogRP_Profiles.SaveActive()
        end
        if mode == "emotes" then
            RandomDialogRP_UI.PerformEmote(option.value)
        else
            ExecuteRP(option.value)
        end
        wheelFrame:Hide()
    end)
    optionButtons[slot] = button
end

local function ChangePage(direction)
    local mode = RandomDialogRPDB.emoteWheelMode == "emotes" and "emotes" or "categories"
    local pageCount = math.max(1, math.ceil(#GetWheelOptions(mode) / OPTION_COUNT))
    wheelPage = ((wheelPage - 1 + direction) % pageCount) + 1
    RefreshWheel()
end

previousButton:SetScript("OnClick", function()
    ChangePage(-1)
end)
nextButton:SetScript("OnClick", function()
    ChangePage(1)
end)

centerButton:SetScript("OnClick", function()
    RandomDialogRPDB.emoteWheelMode =
        RandomDialogRPDB.emoteWheelMode == "emotes" and "categories" or "emotes"
    RandomDialogRP_Profiles.SaveActive()
    if RefreshEmoteWheelSettingsUI then RefreshEmoteWheelSettingsUI() end
    RefreshWheel()
end)

function RandomDialogRP_ToggleEmoteWheel()
    if wheelFrame:IsShown() then
        wheelFrame:Hide()
    else
        local mode = RandomDialogRPDB.emoteWheelMode == "emotes" and "emotes" or "categories"
        wheelPage = GetStartingPage(mode)
        RandomDialogRP_Wheel.RestorePosition()
        RefreshWheel()
        wheelFrame:Show()
    end
end

table.insert(UISpecialFrames, "RandomDialogRPEmoteWheelFrame")
