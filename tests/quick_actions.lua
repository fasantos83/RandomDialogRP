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
            elseif key == "SetSize" then
                return function(_, width, height) self.width, self.height = width, height end
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
                return function() self.shown = true end
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
RandomDialogRP_Profiles = { SaveActive = function() end }
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
UIDropDownMenu_SetSelectedValue = function() end
UIDropDownMenu_SetText = function() end
UnitExists = function() return false end
GetTime = function() return 1 end
local sent = {}
SendChatMessage = function(message) table.insert(sent, message) end
DoEmote = function() end

GameTooltip = { lines = {} }
function GameTooltip:SetOwner() self.lines = {} end
function GameTooltip:SetText(text) table.insert(self.lines, text) end
function GameTooltip:AddLine(text) table.insert(self.lines, text) end
function GameTooltip:Show() end
function GameTooltip:Hide() end

dofile("RandomDialogRP\\localization\\Locales.lua")
dofile("RandomDialogRP\\ui\\UIHelpers.lua")
dofile("RandomDialogRP\\ui\\MainPanel.lua")

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

print("quick action, category, emote picker, and tutorial tests passed")
