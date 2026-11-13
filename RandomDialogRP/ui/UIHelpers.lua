-- Shared UI helpers and phrase data access with Personality hierarchy support.
RandomDialogRP = RandomDialogRP or {}
RandomDialogRP_UI = RandomDialogRP_UI or {}

local responsiveFrames = {}

function RandomDialogRP_UI.RefreshResponsiveFrames()
    local availableWidth = UIParent:GetWidth() - 40
    local availableHeight = UIParent:GetHeight() - 40
    if availableWidth <= 0 or availableHeight <= 0 then return end

    for _, responsiveFrame in ipairs(responsiveFrames) do
        local scale = math.min(
            1,
            availableWidth / responsiveFrame:GetWidth(),
            availableHeight / responsiveFrame:GetHeight()
        )
        responsiveFrame:SetScale(scale)
    end
end

function RegisterResponsiveFrame(frame)
    table.insert(responsiveFrames, frame)
    RandomDialogRP_UI.RefreshResponsiveFrames()
end

function RandomDialogRP_UI.StyleButton(button)
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        normalTexture:SetVertexColor(0.82, 0.76, 0.58, 1)
    end

    local pushedTexture = button:GetPushedTexture()
    if pushedTexture then
        pushedTexture:SetVertexColor(0.9, 0.78, 0.32, 1)
    end

    local highlightTexture = button:GetHighlightTexture()
    if highlightTexture then
        highlightTexture:SetVertexColor(0.95, 0.82, 0.25, 0.5)
        highlightTexture:SetBlendMode("ADD")
    end

    local buttonText = button:GetFontString()
    if buttonText then
        buttonText:SetTextColor(1, 0.84, 0.15)
    end
end

UIParent:HookScript("OnSizeChanged", RandomDialogRP_UI.RefreshResponsiveFrames)

currentRace = "Tauren"
currentClass = RandomDialogRPDB.rpClass
currentPersonality = "Default" -- Variável de controle da personalidade ativa
buttonTexts = {}
editBox = nil
phraseClassOrder = RandomDialogRP_ClassOrder
phraseRaceClasses = RandomDialogRP_RaceClasses

function IsClassAvailableForRace(raceName, classToken)
    local availableClasses = phraseRaceClasses[raceName]
    return availableClasses and availableClasses[classToken] == true or false
end

function GetPhraseClassName(classToken)
    local localizedName = LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[classToken]
    if localizedName then return localizedName end
    local classNames = {
        WARRIOR = "Warrior", PALADIN = "Paladin", HUNTER = "Hunter",
        ROGUE = "Rogue", PRIEST = "Priest", SHAMAN = "Shaman",
        MAGE = "Mage", WARLOCK = "Warlock", DRUID = "Druid"
    }
    return classNames[classToken] or classToken
end

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
recentPhraseSelections = {}
phraseRepeatWindow = 10

chatChannels = {
    { value = "SAY", label = "sayChannel" },
    { value = "YELL", label = "yellChannel" },
    { value = "WHISPER", label = "whisperChannel" }
}

local function MigrateLegacyCustomDB()
    local personalityData = RandomDialogRP_CustomDB[currentPersonality]
    if type(personalityData) ~= "table" then
        personalityData = { categoryOrder = {} }
    end
    personalityData.categoryOrder = personalityData.categoryOrder or {}
    local foundLegacyData = false
    local function getCategoryData(category)
        local categoryData = personalityData[category]
        if not categoryData then
            categoryData = { races = {}, classes = {} }
            personalityData[category] = categoryData
        else
            categoryData.races = categoryData.races or {}
            categoryData.classes = categoryData.classes or {}
        end
        return categoryData
    end
    local function addCategory(category)
        local found = false
        for _, savedCategory in ipairs(personalityData.categoryOrder) do
            if savedCategory == category then
                found = true
                break
            end
        end
        if not found then table.insert(personalityData.categoryOrder, category) end
        getCategoryData(category)
    end
    local function isLegacyRaceData(raceData)
        if type(raceData) ~= "table" then return false end
        if type(raceData.classPhrases) == "table" then return true end
        for category, categoryData in pairs(raceData) do
            if category ~= "categoryOrder"
                and type(categoryData) == "table" and type(categoryData.phrases) == "table" then
                return true
            end
        end
        return false
    end

    for _, raceName in ipairs(raceOrder) do
        local raceData = RandomDialogRP_CustomDB[raceName]
        if isLegacyRaceData(raceData) then
            foundLegacyData = true
            for _, category in ipairs(raceData.categoryOrder or {}) do
                if type(raceData[category]) == "table" then
                    addCategory(category)
                end
            end
            for category, categoryData in pairs(raceData) do
                if category ~= "categoryOrder" and category ~= "classPhrases"
                    and type(categoryData) == "table" and type(categoryData.phrases) == "table" then
                    addCategory(category)
                    local node = getCategoryData(category)
                    node.icon = node.icon or categoryData.icon
                    node.label = node.label or categoryData.label
                    node.races[raceName] = node.races[raceName] or categoryData
                end
            end

            for classToken, categories in pairs(raceData.classPhrases or {}) do
                for category, classData in pairs(categories) do
                    if type(classData) == "table" and type(classData.phrases) == "table" then
                        addCategory(category)
                        local classNode = getCategoryData(category).classes[classToken]
                        if not classNode then
                            classNode = { phrases = {} }
                            getCategoryData(category).classes[classToken] = classNode
                        end
                        for _, phrase in ipairs(classData.phrases) do
                            local phraseText = type(phrase) == "table" and phrase.text or phrase
                            local exists = false
                            for _, savedPhrase in ipairs(classNode.phrases) do
                                local savedText = type(savedPhrase) == "table" and savedPhrase.text or savedPhrase
                                if savedText == phraseText then
                                    exists = true
                                    break
                                end
                            end
                            if not exists then table.insert(classNode.phrases, phrase) end
                        end
                    end
                end
            end
        end
    end

    if foundLegacyData then
        RandomDialogRP_CustomDB[currentPersonality] = personalityData
        for _, raceName in ipairs(raceOrder) do
            if isLegacyRaceData(RandomDialogRP_CustomDB[raceName]) then
                RandomDialogRP_CustomDB[raceName] = nil
            end
        end
    end
end

-- Inicialização do Banco de Dados com suporte a Personalidades e Categorias completas
function InitCustomDB()
    RandomDialogRP_CustomDB = RandomDialogRP_CustomDB or {}

    currentPersonality = RandomDialogRPDB.activePersonality or "Default"
    MigrateLegacyCustomDB()
    RandomDialogRP_CustomDB[currentPersonality] = RandomDialogRP_CustomDB[currentPersonality] or {}
    local personalityData = RandomDialogRP_CustomDB[currentPersonality]

    personalityData.categoryOrder = personalityData.categoryOrder or {}

    for _, category in ipairs(builtinCategories) do
        local found = false
        for _, savedCategory in ipairs(personalityData.categoryOrder) do
            if savedCategory == category then found = true; break end
        end
        if not found then
            table.insert(personalityData.categoryOrder, category)
        end
    end

    local defaultSource = RandomDialogRP_Defaults.Default
    for catName, catData in pairs(defaultSource) do
        personalityData[catName] = personalityData[catName] or {
            icon = catData.icon or RandomDialogRP_Icons[catName],
            races = {},
            classes = {}
        }
        local catNode = personalityData[catName]
        catNode.races = catNode.races or {}
        catNode.classes = catNode.classes or {}

        -- Sincronizar Raças padrão
        if catData.races then
            for raceName, raceInfo in pairs(catData.races) do
                catNode.races[raceName] = catNode.races[raceName] or { phrases = {}, emote = raceInfo.emote }
                local targetPhrases = catNode.races[raceName].phrases

                if #targetPhrases == 0 then
                    for _, p in ipairs(raceInfo.phrases) do table.insert(targetPhrases, p) end
                else
                    for _, defaultPhrase in ipairs(raceInfo.phrases) do
                        local exists = false
                        for _, savedPhrase in ipairs(targetPhrases) do
                            local sText = type(savedPhrase) == "table" and savedPhrase.text or savedPhrase
                            if sText == defaultPhrase then exists = true; break end
                        end
                        if not exists then table.insert(targetPhrases, defaultPhrase) end
                    end
                end
            end
        end

        -- Sincronizar Classes padrão
        if catData.classes then
            for classToken, classInfo in pairs(catData.classes) do
                catNode.classes[classToken] = catNode.classes[classToken] or { phrases = {} }
                local targetPhrases = catNode.classes[classToken].phrases

                if #targetPhrases == 0 then
                    for _, p in ipairs(classInfo.phrases) do table.insert(targetPhrases, p) end
                else
                    for _, defaultPhrase in ipairs(classInfo.phrases) do
                        local exists = false
                        for _, savedPhrase in ipairs(targetPhrases) do
                            local sText = type(savedPhrase) == "table" and savedPhrase.text or savedPhrase
                            if sText == defaultPhrase then exists = true; break end
                        end
                        if not exists then table.insert(targetPhrases, defaultPhrase) end
                    end
                end
            end
        end
    end
end

function GetCategories()
    local pData = RandomDialogRP_CustomDB[currentPersonality] or {}
    return pData.categoryOrder or builtinCategories
end

function GetPhraseCategoryData(personality, category, classToken, raceName, create)
    local pData = RandomDialogRP_CustomDB[personality]
    if not pData then
        if not create then return nil end
        RandomDialogRP_CustomDB[personality] = {}
        pData = RandomDialogRP_CustomDB[personality]
    end

    local catNode = pData[category]
    if not catNode and create then
        catNode = { icon = RandomDialogRP_Icons[category], races = {}, classes = {} }
        pData[category] = catNode
    end
    if not catNode then return nil end

    if classToken and classToken ~= "NONE" then
        catNode.classes = catNode.classes or {}
        catNode.classes[classToken] = catNode.classes[classToken] or { phrases = {} }
        return catNode.classes[classToken]
    end

    if raceName then
        catNode.races = catNode.races or {}
        catNode.races[raceName] = catNode.races[raceName] or { phrases = {}, emote = "WAVE" }
        return catNode.races[raceName]
    end

    return catNode
end

function IsBuiltinCategory(category)
    for _, builtin in ipairs(builtinCategories) do
        if category == builtin then return true end
    end
    return false
end

function GetCategoryLabel(category)
    local pData = RandomDialogRP_CustomDB[currentPersonality]
    local catNode = pData and pData[category]
    return (catNode and catNode.label) or L(category)
end

function GetCategoryIcon(category)
    local pData = RandomDialogRP_CustomDB[currentPersonality]
    local catNode = pData and pData[category]
    return (catNode and catNode.icon) or RandomDialogRP_Icons[category] or "Interface\\Icons\\INV_Misc_QuestionMark"
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
    local classData = currentClass and currentClass ~= "NONE" and GetPhraseCategoryData(currentPersonality, category, currentClass, nil, false)
    local raceData = GetPhraseCategoryData(currentPersonality, category, nil, currentRace, false)

    local classPhrases = classData and classData.phrases or {}
    local racePhrases = raceData and raceData.phrases or {}
    local phrases = {}
    local activeEmote = "WAVE"

    local useClassPhrases = #classPhrases > 0
        and (#racePhrases == 0 or math.random() < 0.8)
    if useClassPhrases then
        phrases = classPhrases
        activeEmote = classData.emote or "WAVE"
    elseif #racePhrases > 0 then
        phrases = racePhrases
        activeEmote = raceData.emote or "WAVE"
    end

    if not phrases or #phrases == 0 then
        print("|cFFFF0000[RandomDialogRP]|r " .. L("noPhrases"))
        return
    end

    local now = GetTime()
    local selectionKey = currentPersonality .. ":" .. currentRace .. ":" .. (currentClass or "NONE") .. ":" .. category
    local recent = recentPhraseSelections[selectionKey]
    local index
    if #phrases > 1 and recent and now - recent.time <= phraseRepeatWindow then
        repeat
            index = math.random(1, #phrases)
        until index ~= recent.index
    else
        index = math.random(1, #phrases)
    end

    local phrase = phrases[index]
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

    recentPhraseSelections[selectionKey] = { index = index, time = now }
    local emote = GetPhraseEmote(phrase, { emote = activeEmote })
    if emote then
        DoEmote(emote)
    end
end