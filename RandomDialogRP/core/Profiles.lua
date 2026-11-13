-- Account-wide named profile storage and migration with personality support.

RandomDialogRPDB = RandomDialogRPDB or {}
RandomDialogRP_CustomDB = RandomDialogRP_CustomDB or {}
RandomDialogRP_Profiles = RandomDialogRP_Profiles or {}

local function GetProfileKey()
    local characterName = UnitName("player") or "UnknownCharacter"
    local realmName = GetRealmName() or "UnknownRealm"
    if realmName == "" then realmName = "UnknownRealm" end
    return realmName .. "-" .. characterName
end

local function CopyTable(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for key, item in pairs(value) do
        copy[key] = CopyTable(item)
    end
    return copy
end

function RandomDialogRP_Profiles.EnsureStore()
    RandomDialogRPDB.activePersonality = RandomDialogRPDB.activePersonality or "Default"
    if type(RandomDialogRPDB.profiles) ~= "table" then
        local legacySettings = {
            panel = RandomDialogRPDB.panel,
            minimap = RandomDialogRPDB.minimap,
            language = RandomDialogRPDB.language,
            chatChannel = RandomDialogRPDB.chatChannel,
            rpClass = RandomDialogRPDB.rpClass,
            activePersonality = RandomDialogRPDB.activePersonality
        }
        RandomDialogRPDB.profiles = {
            Default = {
                settings = legacySettings,
                custom = RandomDialogRP_CustomDB
            }
        }
        RandomDialogRPDB.activeProfile = "Default"
        RandomDialogRPDB.profileSchemaVersion = 2
    elseif not RandomDialogRPDB.profileSchemaVersion then
        local oldProfiles = RandomDialogRPDB.profiles
        local namedProfiles = {}
        local profileKey = GetProfileKey()
        local currentProfile = oldProfiles[profileKey]
        if currentProfile then
            namedProfiles.Default = currentProfile
        end
        for key, profile in pairs(oldProfiles) do
            if key ~= profileKey and type(profile) == "table" and profile.custom then
                local name = profile.character or key
                if namedProfiles[name] then name = key end
                namedProfiles[name] = profile
            end
        end
        namedProfiles.Default = namedProfiles.Default or {
            settings = {},
            custom = RandomDialogRP_CustomDB
        }
        RandomDialogRPDB.profiles = namedProfiles
        RandomDialogRPDB.activeProfile = "Default"
        RandomDialogRPDB.profileSchemaVersion = 2
    elseif not RandomDialogRPDB.profiles.Default then
        RandomDialogRPDB.profiles.Default = {
            settings = {},
            custom = RandomDialogRP_CustomDB
        }
    end
end

function RandomDialogRP_Profiles.Activate(profileName)
    RandomDialogRP_Profiles.EnsureStore()
    local profile = RandomDialogRPDB.profiles[profileName]
    if not profile then return false end
    profile.settings = profile.settings or {}
    profile.settings.panel = profile.settings.panel or { point = "CENTER", relativePoint = "CENTER", xOfs = 0, yOfs = -100 }
    profile.settings.minimap = profile.settings.minimap or { angle = 45 }
    profile.settings.language = profile.settings.language or "enUS"
    profile.settings.chatChannel = profile.settings.chatChannel or "SAY"
    profile.settings.activePersonality = profile.settings.activePersonality or "Default"

    profile.custom = profile.custom or {}
    profile.name = profile.name or profileName

    RandomDialogRPDB.activeProfile = profileName
    RandomDialogRPDB.panel = profile.settings.panel
    RandomDialogRPDB.minimap = profile.settings.minimap
    RandomDialogRPDB.language = profile.settings.language
    RandomDialogRPDB.chatChannel = profile.settings.chatChannel
    RandomDialogRPDB.rpClass = profile.settings.rpClass
    RandomDialogRPDB.activePersonality = profile.settings.activePersonality

    currentClass = profile.settings.rpClass
    currentPersonality = profile.settings.activePersonality
    RandomDialogRP_CustomDB = profile.custom
    return true
end

function RandomDialogRP_Profiles.ActivateCurrent()
    RandomDialogRP_Profiles.EnsureStore()
    local profileName = RandomDialogRPDB.activeProfile or "Default"
    if not RandomDialogRPDB.profiles[profileName] then profileName = "Default" end
    return RandomDialogRP_Profiles.Activate(profileName)
end

function RandomDialogRP_Profiles.Names()
    RandomDialogRP_Profiles.EnsureStore()
    local names = {}
    for name in pairs(RandomDialogRPDB.profiles) do table.insert(names, name) end
    table.sort(names)
    return names
end

function RandomDialogRP_Profiles.SaveActive()
    local profile = RandomDialogRPDB.profiles[RandomDialogRPDB.activeProfile]
    if profile then
        profile.settings.panel = RandomDialogRPDB.panel
        profile.settings.minimap = RandomDialogRPDB.minimap
        profile.settings.language = RandomDialogRPDB.language
        profile.settings.chatChannel = RandomDialogRPDB.chatChannel
        profile.settings.rpClass = RandomDialogRPDB.rpClass
        profile.settings.activePersonality = RandomDialogRPDB.activePersonality
        profile.custom = RandomDialogRP_CustomDB
    end
end

function RandomDialogRP_Profiles.Copy(value)
    return CopyTable(value)
end