-- Addon initialization and slash commands.
eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
initialized = false

function InitializeAddon()
    if initialized then return end
    initialized = true

    RandomDialogRP_Profiles.ActivateCurrent()
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
    RefreshChatChannelDropDown()
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

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "PLAYER_LOGIN" or addonName == "RandomDialogRP" then
        InitializeAddon()
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
