RandomDialogRPDB = { emoteWheelMode = "emotes" }
RandomDialogRP_CustomDB = {}
RandomDialogRP_Profiles = nil

dofile("RandomDialogRP\\core\\Profiles.lua")

assert(RandomDialogRP_Profiles.ActivateCurrent())
assert(RandomDialogRPDB.emoteWheelMode == "emotes")
assert(RandomDialogRPDB.profiles.Default.settings.emoteWheelMode == "emotes")

RandomDialogRPDB.emoteWheelMode = "categories"
RandomDialogRP_Profiles.SaveActive()
RandomDialogRPDB.profiles.Second = {
    settings = { emoteWheelMode = "categories" },
    custom = {}
}

assert(RandomDialogRP_Profiles.Activate("Second"))
assert(RandomDialogRPDB.emoteWheelMode == "categories")
RandomDialogRPDB.emoteWheelMode = "emotes"
RandomDialogRP_Profiles.SaveActive()
assert(RandomDialogRPDB.profiles.Second.settings.emoteWheelMode == "emotes")
RandomDialogRPDB.emoteWheel.emotes = { "WAVE" }
RandomDialogRPDB.emoteWheel.categories.Default = { "greetings" }
RandomDialogRPDB.emoteWheel.position = { point = "TOP", relativePoint = "TOP", xOfs = 12, yOfs = -34 }
RandomDialogRPDB.emoteWheel.rememberPage = true
RandomDialogRPDB.emoteWheel.lastPages = { categories = 2, emotes = 3 }
RandomDialogRP_Profiles.SaveActive()

assert(RandomDialogRP_Profiles.Activate("Default"))
assert(RandomDialogRPDB.emoteWheelMode == "categories")
assert(RandomDialogRPDB.emoteWheel.emotes == nil)
assert(RandomDialogRPDB.emoteWheel.categories.Default == nil)
assert(RandomDialogRPDB.emoteWheel.position == nil)
assert(RandomDialogRPDB.emoteWheel.rememberPage == nil and RandomDialogRPDB.emoteWheel.lastPages == nil)
assert(RandomDialogRP_Profiles.Activate("Second"))
assert(RandomDialogRPDB.emoteWheelMode == "emotes")
assert(RandomDialogRPDB.emoteWheel.emotes[1] == "WAVE")
assert(RandomDialogRPDB.emoteWheel.categories.Default[1] == "greetings")
assert(RandomDialogRPDB.emoteWheel.position.xOfs == 12 and RandomDialogRPDB.emoteWheel.position.yOfs == -34)
assert(RandomDialogRPDB.emoteWheel.rememberPage and RandomDialogRPDB.emoteWheel.lastPages.emotes == 3)

RandomDialogRPDB.profiles.Invalid = {
    settings = { emoteWheelMode = "invalid" },
    custom = {}
}
assert(RandomDialogRP_Profiles.Activate("Invalid"))
assert(RandomDialogRPDB.emoteWheelMode == "categories")

print("profile emote wheel setting tests passed")
