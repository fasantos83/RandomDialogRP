-- Shared UI helpers and phrase data access.
RandomDialogRP = RandomDialogRP or {}
RandomDialogRP_UI = RandomDialogRP_UI or {}
currentRace = "Tauren"
buttonTexts = {}
editBox = nil
builtinCategories = {
    "greetings", "thanks", "battle", "farewell", "warning", "question",
    "agreement", "disagreement", "celebration", "encouragement", "joke"
}
emoteOptions = {
    "AGREE", "AMAZE", "ANGRY", "APPLAUD", "ATTACKMYTARGET", "BARK", "BECKON",
    "BOW", "BYE", "CACKLE", "CHEER", "CHEST", "CHICKEN", "CHUCKLE", "CLAP", "COWER", "CRY",
    "DANCE", "DRINK", "EAT", "FLEE", "FLEX", "GLOAT", "GREET", "GROWL",
    "GUFFAW", "HAIL", "KISS", "KNEEL", "LAUGH", "LAYDOWN", "LOL", "MOON",
    "NO", "POINT", "ROAR", "RUDE", "SALUTE", "SHOUT", "SHRUG", "SIGH", "SIT",
    "SLEEP", "SMILE", "SORRY", "STARE", "SURPRISED", "TALK", "THANK",
    "THREATEN", "WAVE", "WELCOME", "WHISTLE", "WINK", "WORK", "YAWN", "YES"
}
iconOptions = (GetMacroIcons and GetMacroIcons()) or {}
if #iconOptions == 0 then iconOptions = { "Interface\\Icons\\INV_Misc_QuestionMark" } end

chatChannels = {
    { value = "SAY", label = "sayChannel" },
    { value = "YELL", label = "yellChannel" },
    { value = "WHISPER", label = "whisperChannel" }
}

function InitCustomDB()
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

function GetCategories(raceName)
    local raceData = RandomDialogRP_CustomDB[raceName] or {}
    return raceData.categoryOrder or builtinCategories
end

function IsBuiltinCategory(category)
    for _, builtin in ipairs(builtinCategories) do
        if category == builtin then return true end
    end
    return false
end

function GetCategoryLabel(category)
    local raceData = RandomDialogRP_CustomDB[currentRace]
    local categoryData = raceData and raceData[category]
    return (categoryData and categoryData.label) or L(category)
end

function GetCategoryIcon(category)
    local raceData = RandomDialogRP_CustomDB[currentRace]
    local categoryData = raceData and raceData[category]
    return (categoryData and categoryData.icon) or RandomDialogRP_Icons[category] or "Interface\\Icons\\INV_Misc_QuestionMark"
end

function GetPhraseText(phrase)
    return type(phrase) == "table" and phrase.text or phrase
end

function GetPhraseEmote(phrase, categoryData)
    return (type(phrase) == "table" and phrase.emote) or (categoryData and categoryData.emote)
end

function SetPhraseEmote(categoryData, index, emote)
    local phrase = categoryData.phrases[index]
    if type(phrase) == "table" then
        phrase.emote = emote
    else
        categoryData.phrases[index] = { text = phrase, emote = emote }
    end
end

function GetTargetName()
    if not UnitExists("target") then return "friend" end

    if UnitFullName then
        local name = UnitFullName("target")
        if name and name ~= "" then return name end
    end

    local targetName = UnitName("target")
    if not targetName or targetName == "" then return "friend" end
    return string.match(targetName, "^[^-]+") or targetName
end

function GetWhisperTarget()
    if not UnitExists("target") then return nil end
    if UnitIsPlayer and not UnitIsPlayer("target") then return nil end

    if UnitFullName then
        local name, realm = UnitFullName("target")
        if name and name ~= "" then
            return realm and realm ~= "" and name .. "-" .. realm or name
        end
    end

    return UnitName("target")
end

function ExecuteRP(category)
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
    
    local channel = RandomDialogRPDB.chatChannel or "SAY"
    if channel == "WHISPER" then
        local targetName = GetWhisperTarget()
        if not targetName or targetName == "" then
            if UnitExists("target") then
                print("|cFFFF0000[RandomDialogRP]|r " .. L("whisperPlayerRequired"))
            else
                print("|cFFFF0000[RandomDialogRP]|r " .. L("whisperTargetRequired"))
            end
            return
        end
        SendChatMessage(formattedPhrase, "WHISPER", nil, targetName)
    else
        SendChatMessage(formattedPhrase, channel)
    end
    local emote = GetPhraseEmote(phrase, raceData)
    if emote then
        DoEmote(emote)
    end
end
