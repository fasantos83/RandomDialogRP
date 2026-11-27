local editorMode = "categories"
local rowHeight = 28
local lists = {}

RandomDialogRPWheelEditor = CreateFrame("Frame", "RandomDialogRPWheelEditor", managerFrame)
RandomDialogRPWheelEditor:SetAllPoints(managerFrame)
RandomDialogRPWheelEditor:Hide()

local title = RandomDialogRPWheelEditor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOPLEFT", RandomDialogRPWheelEditor, "TOPLEFT", 145, -75)

local help = RandomDialogRPWheelEditor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
help:SetPoint("TOPLEFT", RandomDialogRPWheelEditor, "TOPLEFT", 145, -98)
help:SetWidth(500)
help:SetJustifyH("LEFT")
help:SetWordWrap(true)

local function CreateButton(parent, width, text)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width, 22)
    button:SetText(text)
    RandomDialogRP_UI.StyleButton(button)
    return button
end

local categoryButton = CreateButton(RandomDialogRPWheelEditor, 120, "")
categoryButton:SetPoint("TOPLEFT", RandomDialogRPWheelEditor, "TOPLEFT", 145, -145)
local emoteButton = CreateButton(RandomDialogRPWheelEditor, 120, "")
emoteButton:SetPoint("LEFT", categoryButton, "RIGHT", 8, 0)
RandomDialogRPWheelEditor.categoryButton = categoryButton
RandomDialogRPWheelEditor.emoteButton = emoteButton

local function MakeList(x)
    local label = RandomDialogRPWheelEditor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", RandomDialogRPWheelEditor, "TOPLEFT", x, -185)

    local scroll = CreateFrame("ScrollFrame", nil, RandomDialogRPWheelEditor, "UIPanelScrollFrameTemplate")
    scroll:SetSize(232, 300)
    scroll:SetPoint("TOPLEFT", RandomDialogRPWheelEditor, "TOPLEFT", x, -205)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        self:SetVerticalScroll(math.max(0, math.min(
            self:GetVerticalScrollRange(), self:GetVerticalScroll() - delta * rowHeight
        )))
    end)

    local background = scroll:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(scroll)
    background:SetColorTexture(0.025, 0.023, 0.018, 0.9)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(232, 300)
    scroll:SetScrollChild(content)

    local empty = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    empty:SetPoint("TOPLEFT", content, "TOPLEFT", 8, -8)
    return { label = label, scroll = scroll, content = content, empty = empty, rows = {} }
end

lists.included = MakeList(145)
lists.available = MakeList(405)
RandomDialogRPWheelEditor.lists = lists

local function SetTooltip(button, key)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(L(key), 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function CreateRow(list, index, included)
    local row = CreateFrame("Frame", nil, list.content)
    row:SetSize(232, rowHeight)
    row:SetPoint("TOPLEFT", list.content, "TOPLEFT", 0, -((index - 1) * rowHeight))
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", row, "LEFT", 5, 0)
    row.text:SetJustifyH("LEFT")

    if included then
        row.up = CreateButton(row, 23, "^")
        row.up:SetPoint("RIGHT", row, "RIGHT", -50, 0)
        row.down = CreateButton(row, 23, "v")
        row.down:SetPoint("LEFT", row.up, "RIGHT", 1, 0)
        row.remove = CreateButton(row, 23, "-")
        row.remove:SetPoint("LEFT", row.down, "RIGHT", 1, 0)
        row.text:SetPoint("RIGHT", row.up, "LEFT", -3, 0)
        SetTooltip(row.up, "wheelMoveUp")
        SetTooltip(row.down, "wheelMoveDown")
        SetTooltip(row.remove, "wheelRemove")
        row.up:SetScript("OnClick", function()
            RandomDialogRP_Wheel.Move(editorMode, index, -1)
            RefreshWheelEditor()
            RandomDialogRP_Wheel.Refresh()
        end)
        row.down:SetScript("OnClick", function()
            RandomDialogRP_Wheel.Move(editorMode, index, 1)
            RefreshWheelEditor()
            RandomDialogRP_Wheel.Refresh()
        end)
        row.remove:SetScript("OnClick", function()
            RandomDialogRP_Wheel.Remove(editorMode, index)
            RefreshWheelEditor()
            RandomDialogRP_Wheel.Refresh()
        end)
    else
        row.add = CreateButton(row, 23, "+")
        row.add:SetPoint("RIGHT", row, "RIGHT", -2, 0)
        row.text:SetPoint("RIGHT", row.add, "LEFT", -3, 0)
        SetTooltip(row.add, "wheelAdd")
        row.add:SetScript("OnClick", function()
            RandomDialogRP_Wheel.Add(editorMode, row.value)
            RefreshWheelEditor()
            RandomDialogRP_Wheel.Refresh()
        end)
    end
    return row
end

local function RefreshList(list, values, included)
    list.empty:SetText(L("wheelEmpty"))
    list.empty:SetShown(#values == 0)
    for index, value in ipairs(values) do
        local row = list.rows[index]
        if not row then
            row = CreateRow(list, index, included)
            list.rows[index] = row
        end
        row.value = value
        local label = editorMode == "categories" and GetCategoryLabel(value) or value
        row.text:SetText(included and (index .. ". " .. label) or label)
        if included then
            row.up:SetEnabled(index > 1)
            row.down:SetEnabled(index < #values)
        end
        row:Show()
    end
    for index = #values + 1, #list.rows do list.rows[index]:Hide() end
    list.content:SetHeight(math.max(300, #values * rowHeight))
    list.scroll:SetVerticalScroll(math.min(list.scroll:GetVerticalScroll(), list.scroll:GetVerticalScrollRange()))
end

function RefreshWheelEditor()
    title:SetText(L("wheelEditorTitle"))
    help:SetText(L("wheelEditorHelp"))
    categoryButton:SetText(L("emoteWheelCategories"))
    emoteButton:SetText(L("emoteWheelEmotes"))
    categoryButton:SetEnabled(editorMode ~= "categories")
    emoteButton:SetEnabled(editorMode ~= "emotes")
    lists.included.label:SetText(L("wheelIncluded"))
    lists.available.label:SetText(L("wheelAvailable"))
    RefreshList(lists.included, RandomDialogRP_Wheel.GetEntries(editorMode), true)
    RefreshList(lists.available, RandomDialogRP_Wheel.GetAvailable(editorMode), false)
end

local function ChangeMode(mode)
    editorMode = mode
    lists.included.scroll:SetVerticalScroll(0)
    lists.available.scroll:SetVerticalScroll(0)
    RefreshWheelEditor()
end
categoryButton:SetScript("OnClick", function() ChangeMode("categories") end)
emoteButton:SetScript("OnClick", function() ChangeMode("emotes") end)
