local namedFrames = {}
local function newFrame()
    local frame = { scripts = {} }
    return setmetatable(frame, {
        __index = function(self, key)
            if key == "SetScript" or key == "HookScript" then
                return function(_, event, handler) self.scripts[event] = handler end
            elseif key == "SetText" then
                return function(_, text) self.text = text end
            elseif key == "GetText" then
                return function() return rawget(self, "text") or "" end
            elseif key == "CreateFontString" then
                return function()
                    local region = newFrame()
                    self.regions = rawget(self, "regions") or {}
                    table.insert(self.regions, region)
                    return region
                end
            elseif key == "CreateTexture" or key == "GetFontString" then
                return function() return newFrame() end
            elseif key == "CreateMaskTexture" then
                return function() return newFrame() end
            elseif key == "SetTexture" then
                return function(_, texture) self.texture = texture end
            elseif key == "SetColorTexture" then
                return function(_, red, green, blue, alpha)
                    self.color = { red, green, blue, alpha }
                end
            elseif key == "AddMaskTexture" then
                return function(_, mask) self.mask = mask end
            elseif key == "EnableMouse" then
                return function(_, enabled) self.mouseEnabled = enabled end
            elseif key == "SetSize" then
                return function(_, width, height) self.width, self.height = width, height end
            elseif key == "SetPoint" then
                return function(_, ...) self.point = { ... } end
            elseif key == "GetPoint" then
                return function() return unpack(self.point) end
            elseif key == "GetCenter" then
                return function() return unpack(self.center or { 0, 0 }) end
            elseif key == "GetEffectiveScale" then
                return function() return rawget(self, "scale") or 1 end
            elseif key == "RegisterForDrag" then
                return function(_, button) self.dragButton = button end
            elseif key == "StartMoving" then
                return function() self.moving = true end
            elseif key == "StopMovingOrSizing" then
                return function() self.moving = false end
            elseif key == "SetUserPlaced" then
                return function(_, placed) self.userPlaced = placed end
            elseif key == "SetHeight" then
                return function(_, height) self.height = height end
            elseif key == "SetScrollChild" then
                return function(_, child) self.scrollChild = child end
            elseif key == "SetVerticalScroll" then
                return function(_, value) self.verticalScroll = value end
            elseif key == "GetVerticalScroll" then
                return function() return rawget(self, "verticalScroll") or 0 end
            elseif key == "GetVerticalScrollRange" then
                return function() return 200 end
            elseif key == "GetWidth" or key == "GetHeight" then
                return function() return 500 end
            elseif key == "GetFrameLevel" then
                return function() return 1 end
            elseif key == "GetStringHeight" then
                return function() return rawget(self, "mockStringHeight") or 12 end
            elseif key == "Show" then
                return function()
                    local wasShown = rawget(self, "shown") ~= false
                    self.shown = true
                    if not wasShown and self.scripts.OnShow then self.scripts.OnShow(self) end
                end
            elseif key == "SetShown" then
                return function(_, shown)
                    if shown then self:Show() else self:Hide() end
                end
            elseif key == "SetEnabled" then
                return function(_, enabled) self.enabled = enabled end
            elseif key == "SetChecked" then
                return function(_, checked) self.checked = checked end
            elseif key == "GetChecked" then
                return function() return rawget(self, "checked") end
            elseif key == "Hide" then
                return function()
                    local wasShown = rawget(self, "shown") ~= false
                    self.shown = false
                    if wasShown and self.scripts.OnHide then self.scripts.OnHide(self) end
                end
            elseif key == "IsShown" then
                return function() return rawget(self, "shown") ~= false end
            elseif key == "IsMouseOver" then
                return function() return rawget(self, "mouseOver") == true end
            elseif key == "RegisterEvent" then
                return function(_, event)
                    self.events = rawget(self, "events") or {}
                    self.events[event] = true
                end
            elseif key == "UnregisterEvent" then
                return function(_, event) self.events[event] = nil end
            end
            return function() end
        end
    })
end

UIParent = newFrame()
RandomDialogRPDB = { language = "enUS", chatChannel = "SAY" }
RandomDialogRP_CustomDB = {
    Default = {
        greeting = {
            classes = { MAGE = { phrases = { "Class one", "Class two" } } },
            races = { Human = { phrases = { "Race one" } } }
        },
        empty = { classes = {}, races = {} }
    }
}
RandomDialogRP_ClassOrder = { "MAGE" }
RandomDialogRP_RaceClasses = { Human = { MAGE = true } }
RandomDialogRP_Icons = {}
local profileSaveCount = 0
RandomDialogRP_Profiles = { SaveActive = function() profileSaveCount = profileSaveCount + 1 end }
local createdFrames = {}
CreateFrame = function(_, name)
    local frame = newFrame()
    table.insert(createdFrames, frame)
    if name then namedFrames[name] = frame end
    return frame
end
StaticPopupDialogs = {}
UISpecialFrames = {}
UIDropDownMenu_SetWidth = function() end
UIDropDownMenu_Initialize = function() end
UIDropDownMenu_SetSelectedValue = function(dropDown, value) dropDown.selectedValue = value end
UIDropDownMenu_SetText = function(dropDown, text) dropDown.text = text end
UnitExists = function() return false end
GetTime = function() return 1 end
local cursorX, cursorY = 0, 0
GetCursorPosition = function() return cursorX, cursorY end
local sent = {}
SendChatMessage = function(message) table.insert(sent, message) end
local performedEmotes = {}
DoEmote = function(emote) table.insert(performedEmotes, emote) end

GameTooltip = { lines = {} }
function GameTooltip:SetOwner() self.lines = {} end
function GameTooltip:SetText(text) table.insert(self.lines, text) end
function GameTooltip:AddLine(text) table.insert(self.lines, text) end
function GameTooltip:Show() self.shown = true end
function GameTooltip:Hide() self.shown = false end

dofile("RandomDialogRP\\localization\\Locales.lua")
dofile("RandomDialogRP\\ui\\UIHelpers.lua")
dofile("RandomDialogRP\\ui\\MainPanel.lua")
dofile("RandomDialogRP\\ui\\EmoteWheel.lua")

currentRace = "Human"
currentClass = "MAGE"
currentPersonality = "Default"

local button = CreateActionButton("greeting", 0, 0)
button.scripts.OnEnter(button)
assert(GameTooltip.lines[2] == "Available phrases: 3")
assert(GameTooltip.lines[3] == "Class: 2 | Race: 1")
assert(#sent == 0)

local originalRandom = math.random
math.random = function(minimum) return minimum or 0.1 end
button.scripts.OnClick(button)
math.random = originalRandom
assert(#sent == 1 and sent[1] == "Class one")

currentClass = "NONE"
button.scripts.OnEnter(button)
assert(GameTooltip.lines[2] == "Available phrases: 1")
assert(GameTooltip.lines[3] == "Class: 0 | Race: 1")
button.scripts.OnClick(button)
assert(#sent == 2 and sent[2] == "Race one")

table.insert(RandomDialogRP_CustomDB.Default.greeting.races.Human.phrases, "Race two")
button.scripts.OnEnter(button)
assert(GameTooltip.lines[2] == "Available phrases: 2")

local empty = CreateActionButton("empty", 0, 0)
empty.scripts.OnEnter(empty)
assert(GameTooltip.lines[2] == "Available phrases: 0")
assert(GameTooltip.lines[4] == L("noPhrases"))
assert(next(RandomDialogRP_CustomDB.Default.empty.races) == nil)
assert(next(RandomDialogRP_CustomDB.Default.empty.classes) == nil)

RandomDialogRPDB.activePersonality = "Default"
RandomDialogRP_CustomDB.Default.categoryOrder = { "greeting", "empty" }
dofile("RandomDialogRP\\ui\\ProfileManager.lua")
dofile("RandomDialogRP\\ui\\PhraseManager.lua")
selectedCategory = "greeting"
RandomDialogRPDB.emoteWheelMode = "categories"
RefreshManagerUI()
assert(emoteWheelSettingsTitle:GetText() == L("emoteWheelSettingsTitle"))
assert(emoteWheelModeDropDown.text == L("emoteWheelCategories"))
EmoteWheelModeDropDown_OnClick({ value = "emotes" })
assert(RandomDialogRPDB.emoteWheelMode == "emotes")
assert(emoteWheelModeDropDown.text == L("emoteWheelEmotes"))
EmoteWheelModeDropDown_OnClick({ value = "categories" })
categoryNameBox:SetText("greeting")
local original = RandomDialogRP_CustomDB.Default.greeting
local originalPrint = print
local messages = {}
print = function(message) table.insert(messages, message) end
renameCategoryBtn.scripts.OnClick()
print = originalPrint
assert(RandomDialogRP_CustomDB.Default.greeting == original)
assert(RandomDialogRP_CustomDB.Default.categoryOrder[1] == "greeting")
assert(#messages == 0)
assert(#sent == 2)

categoryNameBox:SetText("renamed")
print = function(message) table.insert(messages, message) end
renameCategoryBtn.scripts.OnClick()
print = originalPrint
assert(RandomDialogRP_CustomDB.Default.renamed == original)
assert(RandomDialogRP_CustomDB.Default.greeting == nil)
assert(RandomDialogRP_CustomDB.Default.categoryOrder[1] == "renamed")
assert(#messages == 1 and string.find(messages[1], L("categoryUpdated"), 1, true))
assert(#sent == 2)

local data = { phrases = { "First", "Second" }, emote = "WAVE" }
local firstRow, secondRow = newFrame(), newFrame()
local firstStart = #createdFrames
local first = CreateEmoteSelector(firstRow, data, data.phrases, 1)
local firstPopup = createdFrames[firstStart + 2]
local noneOption = createdFrames[firstStart + 5]
local secondStart = #createdFrames
local second = CreateEmoteSelector(secondRow, data, data.phrases, 2)
local secondPopup = createdFrames[secondStart + 2]

first.scripts.OnClick()
assert(firstPopup:IsShown())
local listener
for _, candidate in ipairs(createdFrames) do
    local events = rawget(candidate, "events")
    if events and events.GLOBAL_MOUSE_DOWN then listener = candidate end
end
assert(listener)
firstPopup.mouseOver = true
listener.scripts.OnEvent()
assert(firstPopup:IsShown())
firstPopup.mouseOver = false
first.mouseOver = true
listener.scripts.OnEvent()
assert(firstPopup:IsShown())
first.mouseOver = false
first.scripts.OnClick()
assert(not firstPopup:IsShown() and not listener.events.GLOBAL_MOUSE_DOWN)
first.scripts.OnClick()
second.scripts.OnClick()
assert(not firstPopup:IsShown() and secondPopup:IsShown())
listener.scripts.OnEvent()
assert(not secondPopup:IsShown() and not listener.events.GLOBAL_MOUSE_DOWN)

first.scripts.OnClick()
noneOption.scripts.OnClick()
assert(not firstPopup:IsShown() and data.phrases[1].emote == false)
assert(not listener.events.GLOBAL_MOUSE_DOWN)
first.scripts.OnClick()
firstRow:Hide()
assert(not firstPopup:IsShown() and not listener.events.GLOBAL_MOUSE_DOWN)

local tutorial = namedFrames.RandomDialogRPTutorialFrame
local tutorialScroll = namedFrames.RandomDialogRPTutorialScrollFrame
tutorialScroll.scrollChild.regions[1].mockStringHeight = 600
tutorialBtn.scripts.OnClick()
assert(tutorial:IsShown() and tutorial.width == 520 and tutorial.height == 480)
assert(tutorialScroll.scrollChild.height == 608)
assert(tutorialScroll.verticalScroll == 0)
assert(string.find(tutorialScroll.scrollChild.regions[1]:GetText(), "Hello, %s!", 1, true))
assert(string.find(tutorialScroll.scrollChild.regions[1]:GetText(), "Open the Wheel tab", 1, true))
assert(string.find(tutorialScroll.scrollChild.regions[1]:GetText(), "shared within the profile", 1, true))
tutorialScroll.scripts.OnMouseWheel(tutorialScroll, -1)
assert(tutorialScroll.verticalScroll == 32)
tutorialScroll.scripts.OnMouseWheel(tutorialScroll, -10)
assert(tutorialScroll.verticalScroll == 200)
tutorialScroll.scrollChild.regions[1].mockStringHeight = 700
RandomDialogRPDB.language = "ptBR"
tutorialBtn.scripts.OnClick()
assert(tutorialScroll.verticalScroll == 0)
assert(tutorialScroll.scrollChild.height == 708)
assert(string.find(tutorialScroll.scrollChild.regions[1]:GetText(), "Olá, %s!", 1, true))
assert(string.find(tutorialScroll.scrollChild.regions[1]:GetText(), "Abra a aba Roda", 1, true))

local function automaticTutorial(version)
    addonVersion = version
    tutorial:Hide()
    frame.scripts.OnShow(frame)
    return tutorial:IsShown()
end

RandomDialogRPDB.language = "enUS"
RandomDialogRPDB.tutorialVersion = nil
RandomDialogRPDB.tutorialReleaseMajor = nil
RandomDialogRPDB.tutorialReleaseMinor = nil
assert(automaticTutorial("4.0.1"))
assert(not automaticTutorial("4.0.2"))
assert(automaticTutorial("4.1.0"))
assert(not automaticTutorial("4.1.7"))
assert(automaticTutorial("4.10.0"))
assert(not automaticTutorial("4.9.9"))
assert(RandomDialogRPDB.tutorialReleaseMajor == 4 and RandomDialogRPDB.tutorialReleaseMinor == 10)
assert(automaticTutorial("5.0.0"))
assert(not automaticTutorial("5.0.1"))

RandomDialogRPDB.tutorialVersion = 5
assert(automaticTutorial("5.0.1"))
assert(RandomDialogRPDB.tutorialVersion == 6)
assert(not automaticTutorial("5.0.2"))

RandomDialogRPDB.tutorialVersion = 1
assert(automaticTutorial("5.0.1"))
assert(not automaticTutorial("5.0.2"))
RandomDialogRPDB.tutorialVersion = 1
RandomDialogRPDB.tutorialReleaseMajor = nil
RandomDialogRPDB.tutorialReleaseMinor = nil
assert(automaticTutorial("4.0.1"))
assert(not automaticTutorial("4.0.2"))

messages = {}
print = function(message) table.insert(messages, message) end
assert(not automaticTutorial("Unknown"))
assert(not automaticTutorial("Unknown"))
print = originalPrint
assert(#messages == 1 and string.find(messages[1], L("tutorialVersionUnavailable"), 1, true))
assert(RandomDialogRPDB.tutorialReleaseMajor == 4 and RandomDialogRPDB.tutorialReleaseMinor == 0)

RandomDialogRP_CustomDB.Default.categoryOrder = { "renamed", "empty" }
RandomDialogRP_CustomDB.Default.renamed.icon = "Interface\\Icons\\INV_Misc_QuestionMark"
RandomDialogRPDB.emoteWheelMode = "categories"
RandomDialogRP_ToggleEmoteWheel()
local wheel = namedFrames.RandomDialogRPEmoteWheelFrame
local wheelModeButton = namedFrames.RandomDialogRPEmoteWheelModeButton
local firstWheelOption = namedFrames.RandomDialogRPEmoteWheelOption1
assert(wheel:IsShown())
assert(firstWheelOption:GetText() == "renamed")
assert(wheel.mouseEnabled == false)
assert(wheel.width == 460 and wheel.height == 460)
assert(wheel.events.GLOBAL_MOUSE_DOWN)
local wheelBody = namedFrames.RandomDialogRPEmoteWheelBody
wheelBody.center, wheelBody.scale = { 500, 300 }, 0.5
cursorX, cursorY = 360, 150
wheel.scripts.OnEvent(wheel, "GLOBAL_MOUSE_DOWN", "LeftButton")
assert(wheel:IsShown())
cursorX, cursorY = 361, 150
local wheelDragHandle = namedFrames.RandomDialogRPEmoteWheelDragHandle
wheelDragHandle.mouseOver = true
wheel.scripts.OnEvent(wheel, "GLOBAL_MOUSE_DOWN", "LeftButton")
assert(wheel:IsShown())
wheelDragHandle.mouseOver = false
firstWheelOption.mouseOver = true
wheel.scripts.OnEvent(wheel, "GLOBAL_MOUSE_DOWN", "LeftButton")
assert(wheel:IsShown())
firstWheelOption.mouseOver = false
wheel.scripts.OnEvent(wheel, "GLOBAL_MOUSE_DOWN", "RightButton")
assert(not wheel:IsShown() and not wheel.events.GLOBAL_MOUSE_DOWN)
RandomDialogRP_ToggleEmoteWheel()
assert(wheel.events.GLOBAL_MOUSE_DOWN)
cursorX, cursorY = 330, 230
wheel.scripts.OnEvent(wheel, "GLOBAL_MOUSE_DOWN", "LeftButton")
assert(not wheel:IsShown() and not wheel.events.GLOBAL_MOUSE_DOWN)
RandomDialogRP_ToggleEmoteWheel()
cursorX, cursorY = 0, 0
local dragHandle = namedFrames.RandomDialogRPEmoteWheelDragHandle
assert(dragHandle.mouseEnabled and dragHandle.dragButton == "LeftButton")
dragHandle.scripts.OnEnter(dragHandle)
assert(GameTooltip.lines[1] == L("emoteWheelDragTooltip"))
dragHandle.scripts.OnLeave(dragHandle)
local savesBeforeDrag = profileSaveCount
dragHandle.scripts.OnDragStart()
assert(wheel.moving)
wheel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 120, -80)
dragHandle.scripts.OnDragStop()
assert(not wheel.moving and wheel.userPlaced == false)
assert(profileSaveCount == savesBeforeDrag + 1)
local wheelPosition = RandomDialogRPDB.emoteWheel.position
assert(wheelPosition.point == "TOPLEFT" and wheelPosition.relativePoint == "TOPLEFT")
assert(wheelPosition.xOfs == 120 and wheelPosition.yOfs == -80)
wheel:Hide()
assert(profileSaveCount == savesBeforeDrag + 1)
RandomDialogRP_ToggleEmoteWheel()
assert(wheel.point[1] == "TOPLEFT" and wheel.point[4] == 120 and wheel.point[5] == -80)
local originalWheelConfig = RandomDialogRPDB.emoteWheel
RandomDialogRPDB.emoteWheel = { categories = {} }
RandomDialogRP_Wheel.RestorePosition()
assert(wheel.point[1] == "CENTER" and wheel.point[4] == 0 and wheel.point[5] == 0)
RandomDialogRPDB.emoteWheel = originalWheelConfig
RandomDialogRP_Wheel.RestorePosition()
assert(wheel.point[1] == "TOPLEFT" and wheel.point[4] == 120)
dragHandle.scripts.OnDragStart()
wheel:SetPoint("BOTTOM", UIParent, "BOTTOM", 30, 40)
wheel:Hide()
assert(not wheel.moving and RandomDialogRPDB.emoteWheel.position.point == "BOTTOM")
assert(profileSaveCount == savesBeforeDrag + 2)
RandomDialogRP_ToggleEmoteWheel()
assert(wheel.point[1] == "BOTTOM" and wheel.point[4] == 30 and wheel.point[5] == 40)
assert(wheel.backgroundCircle.color[4] == 0.75)
assert(wheel.backgroundCircle.mask.texture == "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
assert(firstWheelOption.icon.texture == RandomDialogRP_CustomDB.Default.renamed.icon)
assert(wheelModeButton:GetText() == L("emoteWheelCategories"))
RandomDialogRP_CustomDB.Default.renamed.label = "A category name too long for the wheel button"
RandomDialogRP_Wheel.Refresh()
firstWheelOption.scripts.OnEnter(firstWheelOption)
assert(GameTooltip.shown and GameTooltip.lines[1] == "A category name too long for the wheel button")
firstWheelOption.scripts.OnLeave(firstWheelOption)
assert(not GameTooltip.shown)
RandomDialogRP_CustomDB.Default.renamed.label = "renamed"
RandomDialogRP_Wheel.Refresh()
local sentBeforeWheelAction = #sent
firstWheelOption.scripts.OnClick(firstWheelOption)
assert(#sent == sentBeforeWheelAction + 1)
assert(not wheel:IsShown() and not wheel.events.GLOBAL_MOUSE_DOWN)

RandomDialogRP_ToggleEmoteWheel()
wheelModeButton.scripts.OnClick(wheelModeButton)
assert(RandomDialogRPDB.emoteWheelMode == "emotes")
assert(wheelModeButton:GetText() == L("emoteWheelEmotes"))
assert(firstWheelOption:GetText() == "AGREE")
assert(namedFrames.RandomDialogRPEmoteWheelOption10:GetText() == "CACKLE")
local topY = firstWheelOption.point[5]
local bottomY = namedFrames.RandomDialogRPEmoteWheelOption6.point[5]
assert(topY - namedFrames.RandomDialogRPEmoteWheelOption2.point[5] >= 40)
assert(topY - namedFrames.RandomDialogRPEmoteWheelOption10.point[5] >= 40)
assert(namedFrames.RandomDialogRPEmoteWheelOption5.point[5] - bottomY >= 40)
assert(namedFrames.RandomDialogRPEmoteWheelOption7.point[5] - bottomY >= 40)
assert(not firstWheelOption.icon:IsShown())
local sentBeforeEmoteAction = #sent
firstWheelOption.scripts.OnClick(firstWheelOption)
assert(performedEmotes[#performedEmotes] == "AGREE")
assert(#sent == sentBeforeEmoteAction)
assert(not wheel:IsShown())

RandomDialogRP_ToggleEmoteWheel()
local nextWheelPage = namedFrames.RandomDialogRPEmoteWheelNextButton
assert(nextWheelPage:IsShown())
nextWheelPage.scripts.OnClick(nextWheelPage)
assert(firstWheelOption:GetText() == "CHEER")
firstWheelOption.scripts.OnEnter(firstWheelOption)
assert(GameTooltip.shown and GameTooltip.lines[1] == "CHEER")
firstWheelOption.scripts.OnLeave(firstWheelOption)

RandomDialogRP_ToggleEmoteWheel()
dofile("RandomDialogRP\\ui\\WheelEditor.lua")
wheelTab.scripts.OnClick()
local editor = RandomDialogRPWheelEditor
assert(selectedManagerTab == "wheel" and editor:IsShown())
assert(not categorySectionLabel:IsShown())
local included = editor.lists.included
local available = editor.lists.available
assert(included.rows[1].value == "renamed" and included.rows[2].value == "empty")
included.rows[2].up.scripts.OnClick()
assert(included.rows[1].value == "empty" and included.rows[2].value == "renamed")
included.rows[2].remove.scripts.OnClick()
assert(available.rows[1].value == "renamed")
assert(RandomDialogRP_CustomDB.Default.renamed == original)
RandomDialogRPDB.emoteWheelMode = "categories"
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "empty")
assert(not namedFrames.RandomDialogRPEmoteWheelOption2:IsShown())
RandomDialogRP_ToggleEmoteWheel()
available.rows[1].add.scripts.OnClick()
assert(included.rows[2].value == "renamed")

categoryNameBox:SetText("extra")
print = function() end
addCategoryBtn.scripts.OnClick()
print = originalPrint
assert(included.rows[3].value == "extra")
categoryNameBox:SetText("new name")
print = function() end
renameCategoryBtn.scripts.OnClick()
print = originalPrint
assert(RandomDialogRP_Wheel.GetEntries("categories")[3] == "new name")
print = function() end
StaticPopupDialogs.RANDOMDIALOGRP_DELETE_CATEGORY_CONFIRM.OnAccept(nil, { category = "new name" })
print = originalPrint
assert(#RandomDialogRP_Wheel.GetEntries("categories") == 2)

RandomDialogRP_CustomDB.Other = { categoryOrder = { "renamed", "empty" } }
currentPersonality = "Other"
assert(RandomDialogRP_Wheel.GetEntries("categories")[1] == "renamed")
currentPersonality = "Default"
assert(RandomDialogRP_Wheel.GetEntries("categories")[1] == "empty")

editor.emoteButton.scripts.OnClick()
assert(included.rows[1].value == "AGREE")
included.rows[1].remove.scripts.OnClick()
assert(available.rows[1].value == "AGREE")
assert(RandomDialogRP_Wheel.GetEntries("emotes")[1] == "AMAZE")
RandomDialogRPDB.emoteWheelMode = "emotes"
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "AMAZE")
local beforeSelectedEmote = #sent
firstWheelOption.scripts.OnClick()
assert(performedEmotes[#performedEmotes] == "AMAZE" and #sent == beforeSelectedEmote)
currentPersonality = "Other"
assert(RandomDialogRP_Wheel.GetEntries("emotes")[1] == "AMAZE")
currentPersonality = "Default"
available.rows[1].add.scripts.OnClick()
assert(RandomDialogRP_Wheel.GetEntries("emotes")[#emoteOptions] == "AGREE")
editor.categoryButton.scripts.OnClick()
included.rows[1].remove.scripts.OnClick()
included.rows[1].remove.scripts.OnClick()
assert(#RandomDialogRP_Wheel.GetEntries("categories") == 0)
RandomDialogRPDB.emoteWheelMode = "categories"
RandomDialogRP_ToggleEmoteWheel()
assert(not firstWheelOption:IsShown())
RandomDialogRP_ToggleEmoteWheel()
available.rows[1].add.scripts.OnClick()
assert(#RandomDialogRP_Wheel.GetEntries("categories") == 1)
RandomDialogRP_Profiles.Copy = function(values)
    local copy = {}
    for index, value in ipairs(values) do copy[index] = value end
    return copy
end
RandomDialogRP_Wheel.CopyPersonality("Default", "Other")
assert(RandomDialogRPDB.emoteWheel.categories.Other[1] == RandomDialogRPDB.emoteWheel.categories.Default[1])
assert(RandomDialogRPDB.emoteWheel.categories.Other ~= RandomDialogRPDB.emoteWheel.categories.Default)
RandomDialogRP_Wheel.RenamePersonality("Other", "RenamedPersonality")
assert(RandomDialogRPDB.emoteWheel.categories.Other == nil)
assert(RandomDialogRPDB.emoteWheel.categories.RenamedPersonality[1])
RandomDialogRP_Wheel.DeletePersonality("RenamedPersonality")
assert(RandomDialogRPDB.emoteWheel.categories.RenamedPersonality == nil)
SetManagerTab("phrases")
assert(not editor:IsShown() and categorySectionLabel:IsShown())

local savedWheel = { "YES", "CHEST", "LOL", "LAUGH", "UNKNOWN", "SORRY", "WAVE" }
RandomDialogRPDB.emoteWheel.emotes = savedWheel
local entries = RandomDialogRP_Wheel.GetEntries("emotes")
assert(table.concat(entries, ",") == "NOD,LAUGH,APOLOGIZE,WAVE")
assert(savedWheel[1] == "YES" and savedWheel[4] == "LAUGH")
RandomDialogRPDB.emoteWheelMode = "emotes"
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "NOD")
assert(namedFrames.RandomDialogRPEmoteWheelOption2:GetText() == "LAUGH")
firstWheelOption.scripts.OnClick()
assert(performedEmotes[#performedEmotes] == "NOD")
RandomDialogRP_Wheel.Move("emotes", 2, -1)
assert(table.concat(RandomDialogRP_Wheel.GetEntries("emotes"), ",") == "LAUGH,NOD,APOLOGIZE,WAVE")
RandomDialogRPDB.emoteWheel.emotes = {}
assert(#RandomDialogRP_Wheel.GetEntries("emotes") == 0)

local raceData = RandomDialogRP_CustomDB.Default.renamed.races.Human
local savedPhrases, savedEmote = raceData.phrases, raceData.emote
raceData.phrases, raceData.emote = { "Legacy" }, "YES"
currentClass = "NONE"
ExecuteRP("renamed")
assert(performedEmotes[#performedEmotes] == "NOD")
raceData.phrases[1] = { text = "Legacy", emote = "SORRY" }
ExecuteRP("renamed")
assert(performedEmotes[#performedEmotes] == "APOLOGIZE")
raceData.phrases[1].emote = "LOL"
ExecuteRP("renamed")
assert(performedEmotes[#performedEmotes] == "LAUGH")
raceData.phrases[1].emote = false
local beforeChest = #performedEmotes
ExecuteRP("renamed")
assert(#performedEmotes == beforeChest)
raceData.phrases[1].emote = "CHEST"
messages = {}
print = function(message) table.insert(messages, message) end
ExecuteRP("renamed")
print = originalPrint
assert(#performedEmotes == beforeChest and #messages == 1)
assert(string.find(messages[1], "CHEST", 1, true))
raceData.phrases, raceData.emote = savedPhrases, savedEmote

local apiEmotes = {}
C_ChatInfo = { PerformEmote = function(emote)
    table.insert(apiEmotes, emote)
    return emote == "NOD"
end }
messages = {}
print = function(message) table.insert(messages, message) end
RandomDialogRP_UI.PerformEmote("YES")
RandomDialogRP_UI.PerformEmote("LAUGH")
print = originalPrint
assert(table.concat(apiEmotes, ",") == "NOD,LAUGH")
assert(#messages == 1 and string.find(messages[1], "NOD", 1, true))
C_ChatInfo = nil

MAXEMOTEINDEX = 3
EMOTE1_TOKEN, EMOTE2_TOKEN, EMOTE3_TOKEN = "WAVE", "HUG", "NOD"
RandomDialogRPDB.emoteWheel.emotes = { "CHEST", "HUG", "UNKNOWN", "YES" }
assert(table.concat(RandomDialogRP_Wheel.GetEntries("emotes"), ",") == "HUG,NOD")
messages = {}
print = function(message) table.insert(messages, message) end
RandomDialogRP_UI.PerformEmote("YES")
RandomDialogRP_UI.PerformEmote("UNKNOWN")
print = originalPrint
assert(performedEmotes[#performedEmotes] == "NOD")
assert(#messages == 1 and string.find(messages[1], "UNKNOWN", 1, true))
MAXEMOTEINDEX, EMOTE1_TOKEN, EMOTE2_TOKEN, EMOTE3_TOKEN = nil, nil, nil, nil

RandomDialogRPDB.emoteWheel = { categories = {} }
RandomDialogRPDB.emoteWheelMode = "emotes"
local savedRefreshProfileUI = RefreshProfileUI
RefreshProfileUI = function() end
SetManagerTab("settings")
RefreshProfileUI = savedRefreshProfileUI
RefreshEmoteWheelSettingsUI()
assert(emoteWheelRememberPage:IsShown() and emoteWheelRememberPage.label:IsShown())
assert(not emoteWheelRememberPage:GetChecked())
RandomDialogRP_ToggleEmoteWheel()
nextWheelPage.scripts.OnClick()
assert(firstWheelOption:GetText() == "CHEER")
firstWheelOption.scripts.OnClick()
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "AGREE")
RandomDialogRP_ToggleEmoteWheel()

emoteWheelRememberPage:SetChecked(true)
local savesBeforeToggle = profileSaveCount
emoteWheelRememberPage.scripts.OnClick(emoteWheelRememberPage)
assert(RandomDialogRPDB.emoteWheel.rememberPage and profileSaveCount == savesBeforeToggle + 1)
RefreshEmoteWheelSettingsUI()
assert(emoteWheelRememberPage:GetChecked())
RandomDialogRP_ToggleEmoteWheel()
nextWheelPage.scripts.OnClick()
firstWheelOption.scripts.OnClick()
assert(RandomDialogRPDB.emoteWheel.lastPages.emotes == 2)
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "CHEER")
nextWheelPage.scripts.OnClick()
RandomDialogRP_ToggleEmoteWheel()
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "CHEER")

local categoryOrder = {}
for index = 1, 10 do categoryOrder[index] = "test" .. index end
categoryOrder[11] = "renamed"
RandomDialogRP_CustomDB.Default.categoryOrder = categoryOrder
wheelModeButton.scripts.OnClick()
assert(firstWheelOption:GetText() == "test1")
nextWheelPage.scripts.OnClick()
assert(firstWheelOption:GetText() == "renamed")
firstWheelOption.scripts.OnClick()
assert(RandomDialogRPDB.emoteWheel.lastPages.categories == 2)
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "renamed")
wheelModeButton.scripts.OnClick()
assert(firstWheelOption:GetText() == "CHEER")
wheelModeButton.scripts.OnClick()
assert(firstWheelOption:GetText() == "renamed")

RandomDialogRP_CustomDB.Default.categoryOrder = { "renamed" }
RandomDialogRP_Wheel.Refresh()
assert(firstWheelOption:GetText() == "renamed")
firstWheelOption.scripts.OnClick()
assert(RandomDialogRPDB.emoteWheel.lastPages.categories == 1)
RandomDialogRPDB.emoteWheelMode = "emotes"
emoteWheelRememberPage:SetChecked(false)
emoteWheelRememberPage.scripts.OnClick(emoteWheelRememberPage)
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "AGREE")
RandomDialogRP_ToggleEmoteWheel()
emoteWheelRememberPage:SetChecked(true)
emoteWheelRememberPage.scripts.OnClick(emoteWheelRememberPage)
RandomDialogRPDB.emoteWheel.lastPages.categories = 99
RandomDialogRPDB.emoteWheelMode = "categories"
RandomDialogRP_ToggleEmoteWheel()
assert(firstWheelOption:GetText() == "renamed")
firstWheelOption.scripts.OnClick()
assert(RandomDialogRPDB.emoteWheel.lastPages.categories == 1)
SetManagerTab("wheel")
assert(not emoteWheelRememberPage:IsShown() and not emoteWheelRememberPage.label:IsShown())

print("quick action, category, emote picker, and tutorial tests passed")
