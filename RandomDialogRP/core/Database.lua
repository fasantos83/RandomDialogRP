-- Database.lua
-- Default database for WoW Forever (8 Original Races + Skyborne)
-- Hierarchy: Personality -> Category -> Races / Classes -> Phrases

RandomDialogRP_Icons = {
    greetings     = "Interface\\Icons\\Spell_Nature_HealingTouch",
    thanks        = "Interface\\Icons\\Spell_Nature_Regeneration",
    battle        = "Interface\\Icons\\Ability_Racial_BearForm",
    farewell      = "Interface\\Icons\\Ability_Rogue_Sprint",
    warning       = "Interface\\Icons\\Spell_Shadow_DeathCoil",
    question      = "Interface\\Icons\\INV_Misc_Book_09",
    agreement     = "Interface\\Icons\\Spell_Holy_SealOfMight",
    disagreement  = "Interface\\Icons\\Ability_Warrior_Disarm",
    celebration   = "Interface\\Icons\\Spell_Holy_HolyNova",
    encouragement = "Interface\\Icons\\Spell_Holy_HolyProtection",
    joke          = "Interface\\Icons\\INV_Misc_QuestionMark"
}

RandomDialogRP_ClassOrder = {
    "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST",
    "SHAMAN", "MAGE", "WARLOCK", "DRUID"
}

RandomDialogRP_RaceClasses = {
    Human    = { HUNTER = true, MAGE = true, PALADIN = true, PRIEST = true, ROGUE = true, WARLOCK = true, WARRIOR = true },
    Dwarf    = { HUNTER = true, PALADIN = true, PRIEST = true, ROGUE = true, SHAMAN = true, WARRIOR = true },
    NightElf = { DRUID = true, HUNTER = true, PRIEST = true, ROGUE = true, WARRIOR = true },
    Gnome    = { MAGE = true, PRIEST = true, ROGUE = true, WARLOCK = true, WARRIOR = true },
    Orc      = { HUNTER = true, MAGE = true, ROGUE = true, SHAMAN = true, WARLOCK = true, WARRIOR = true },
    Undead   = { MAGE = true, PALADIN = true, PRIEST = true, ROGUE = true, WARLOCK = true, WARRIOR = true },
    Tauren   = { DRUID = true, HUNTER = true, SHAMAN = true, WARRIOR = true },
    Troll    = { HUNTER = true, MAGE = true, PRIEST = true, ROGUE = true, SHAMAN = true, WARLOCK = true, WARRIOR = true },
    Skyborne = { DRUID = true, HUNTER = true, MAGE = true, ROGUE = true, SHAMAN = true, WARRIOR = true }
}

-- Banco de dados completo sob a raiz de Personalidade ("Default")
RandomDialogRP_Defaults = {
    Default = {
        greetings = {
            icon = RandomDialogRP_Icons.greetings,
            races = {
                Tauren = { phrases = { "May the Earthmother guide your steps, %s.", "Walk with the earth, %s. Good to see you.", "Well met, %s. May your path stay clear of thorns.", "Peace be upon you and your herd, %s." }, emote = "WAVE" },
                Orc = { phrases = { "Lok'tar ogar, %s! Victory or death.", "Strength and honor, %s.", "Speak plainly, %s. What brings you here?", "Well met, %s. Good to see a capable warrior." }, emote = "SALUTE" },
                Troll = { phrases = { "Stay away from da voodoo, %s.", "Whatcha need, %s? Da spirits be listenin'.", "Peace, %s. May your hunt bring good fortune.", "Well met in da shadows, %s." }, emote = "WAVE" },
                Undead = { phrases = { "Watch your back, %s... the living rarely last long.", "Darkness beckons, %s. What do you require?", "The Dark Lady watches over us all, %s.", "Speak quickly, %s. My patience rots by the second." }, emote = "BOW" },
                Human = { phrases = { "Well met, %s. Safe travels on these roads.", "Light be with you, %s.", "Good to see a friendly face, %s. What brings you here?", "Keep your spirits high, %s. Better days lie ahead." }, emote = "WAVE" },
                Dwarf = { phrases = { "Well met, %s! Keep yer feet on the ground!", "Good to see ye, %s! Fancy a pint when we're done?", "Aye, %s! What brings ye down from the hills?", "Blessings of Ironforge upon ye, %s!" }, emote = "DRINK" },
                NightElf = { phrases = { "Elune light your path, %s.", "May the shadows shelter you, %s.", "Tread carefully in these woods, %s.", "Ishnu-alah, %s. What brings you beneath the boughs?" }, emote = "BOW" },
                Gnome = { phrases = { "Oh, hello %s! Watch your step—my latest spring-coil is calibrating!", "Greetings, %s! Always wonderful to meet an inquisitive mind!", "Well met, %s! Need anything calibrated, magnetized, or slightly exploded?", "Ready for action, %s! Well, as ready as my boots permit." }, emote = "FLEX" },
                Skyborne = { phrases = { "May the high winds carry you safely, %s.", "Greetings from the upper crests, %s.", "Keep your eyes on the horizon and the wind at your side, %s.", "The skies are clear today, %s. What brings you here?" }, emote = "SALUTE" }
            },
            classes = {
                WARRIOR = { phrases = { "Well met, %s. My blade and shield are ready.", "Good to see you, %s. How holds the front line?", "Stand tall, %s. Ready for whatever comes our way.", "Greetings, %s. Always good to have another fighter nearby." } },
                PALADIN = { phrases = { "The Light's blessings upon you, %s.", "Well met, %s. May justice guide our path.", "Greetings, %s. Stand strong in the Light.", "Good to see you, %s. How may I be of service?" } },
                HUNTER = { phrases = { "Well met, %s. The trail has been quiet—until now.", "Greetings, %s. Good eyes spotting me out here.", "Stay downwind, %s. Good to have you along.", "Welcome, %s. Ready for the hunt?" } },
                ROGUE = { phrases = { "Didn't hear me coming, did you, %s?", "Keep your voice down, %s. Good to see you.", "Well met, %s. Watching your pockets, I hope?", "Greetings, %s. What's the job?" } },
                PRIEST = { phrases = { "Peace and blessings upon you, %s.", "Well met, %s. May your spirit remain unburdened.", "Greetings, %s. How fares your soul today?", "Good to see you, %s. I am here if you need aid." } },
                SHAMAN = { phrases = { "May the elements guide you, %s.", "Well met, %s. The winds spoke of your arrival.", "Greetings, %s. Walk in harmony with the spirits.", "Good to see you, %s. What do the elements ask of us?" } },
                MAGE = { phrases = { "Greetings, %s. Fascinating arcane currents today, wouldn't you say?", "Well met, %s. Mind the residual frost—or fire.", "Ah, %s! Always a pleasure to converse with an astute mind.", "Good day, %s. What mysteries shall we unravel?" } },
                WARLOCK = { phrases = { "Greetings, %s. Don't mind the whispers—they're harmless. Mostly.", "Well met, %s. Seeking power, or merely survival?", "Ah, %s. Good to see someone who isn't afraid of the dark.", "Speak, %s. What bargain brings you here?" } },
                DRUID = { phrases = { "Nature's peace be with you, %s.", "Well met, %s. The wilds welcome a friend.", "Greetings, %s. May root and branch shelter your path.", "Good to see you, %s. How fares the balance?" } }
            }
        },

        thanks = {
            icon = RandomDialogRP_Icons.thanks,
            races = {
                Tauren = { phrases = { "The Earthmother smiles upon such kindness, %s.", "You have my gratitude, %s. That meant a great deal.", "Your generosity won't be forgotten out on the plains, %s.", "Thank you, %s. May the warm winds always stay at your back." }, emote = "THANK" },
                Orc = { phrases = { "Your aid won't be forgotten, %s.", "For the Horde! You have my thanks, %s.", "A worthy deed from a reliable ally, %s.", "I owe you a debt of honor, %s." }, emote = "THANK" },
                Troll = { phrases = { "Much thanks to ya, %s. Da loa smile on ya today.", "Ya got a good spirit, %s. I won't forget dis.", "Dat was a mighty big help, %s!", "May da loa watch over ya for dis, %s." }, emote = "THANK" },
                Undead = { phrases = { "A rare display of competence, %s. You have my thanks.", "Even the dead remember a useful ally, %s.", "Your help serves our dark designs well, %s.", "Gratitude is a fleeting thing, yet you have earned mine, %s." }, emote = "THANK" },
                Human = { phrases = { "You have my sincere thanks, %s.", "Much obliged for stepping in, %s.", "I won't forget your kindness, %s.", "A fine display of courage. Thank you, %s!" }, emote = "THANK" },
                Dwarf = { phrases = { "By the beard of the Titans, I owe ye one, %s!", "Thanks, %s! First round at the tavern is on me.", "Now that's a proper favor between friends, %s.", "Much obliged, %s! Ye're solid as mountain stone." }, emote = "THANK" },
                NightElf = { phrases = { "Elune's grace upon you for your aid, %s.", "Your help is deeply appreciated, %s.", "The wilds remember kindness, as do I, %s.", "Thank you, %s. May the stars watch over you." }, emote = "THANK" },
                Gnome = { phrases = { "Thanks a ton, %s! You just saved me hours of recalibration!", "Much appreciated, %s! I owe you a custom-built trinket.", "Brilliant work, %s! Truly top-notch execution!", "Aha! Couldn't have engineered a better outcome myself, %s!" }, emote = "CHEER" },
                Skyborne = { phrases = { "Even the open skies seem brighter for your kindness, %s.", "A swift gesture with lasting weight—thank you, %s.", "May steady currents guide every step you take, %s.", "You have my deepest gratitude, %s." }, emote = "THANK" }
            },
            classes = {
                WARRIOR = { phrases = { "Much obliged, %s. You've got a warrior's gratitude.", "That helped turn the tide, %s. Thank you.", "I won't forget who stood beside me, %s.", "Good looking out, %s. I owe you one." } },
                PALADIN = { phrases = { "May the Light reward your generosity, %s.", "You have my heartfelt thanks, %s.", "A noble deed, %s. I am grateful.", "Thank you, %s. Together we uphold what is right." } },
                HUNTER = { phrases = { "Appreciate the assist, %s. Clean work.", "Thanks, %s. I'll remember that out in the wilds.", "Good looking out, %s—saved me an arrow.", "You've got my thanks, %s." } },
                ROGUE = { phrases = { "Much appreciated, %s. I owe you a favor.", "Smooth work, %s. Thanks.", "You're alright, %s. Won't forget this.", "Thanks, %s—keep that between us." } },
                PRIEST = { phrases = { "Bless you for your kindness, %s.", "You have my deepest gratitude, %s.", "Your compassion brings hope, %s. Thank you.", "May peace return to you tenfold, %s." } },
                SHAMAN = { phrases = { "The spirits smile upon your aid, %s.", "You have my gratitude, %s.", "May earth and sky reward your kindness, %s.", "Thank you, %s. Your help restored balance." } },
                MAGE = { phrases = { "My sincere thanks, %s. Most efficient.", "Brilliant assistance, %s. I am in your debt.", "Thank you, %s—you saved me a considerable amount of mana.", "You have my gratitude, %s." } },
                WARLOCK = { phrases = { "Useful... very useful, %s. You have my thanks.", "I won't forget your aid, %s. Your soul is safe—for now.", "A solid favor, %s. Consider yourself owed.", "My gratitude, %s. You proved most resourceful." } },
                DRUID = { phrases = { "Nature's remembers your kindness, %s. Thank you.", "You have my gratitude, %s.", "May the wilds bless you for your aid, %s.", "Thank you, %s. Together we protect the grove." } }
            }
        },

        battle = {
            icon = RandomDialogRP_Icons.battle,
            races = {
                Tauren = { phrases = { "The deep roots do not bend to the storm!", "Even a calm bull knows when to lower his horns, %s!", "For Kalimdor! Let the earth shake beneath our hooves!", "You stand against the unyielding strength of Mulgore!" }, emote = "ROAR" },
                Orc = { phrases = { "Blood and thunder! Come and face me, %s!", "For the Horde! Lok-narosh!", "Your skull will make a fine trophy, %s!", "No quarter for enemies of the Horde!" }, emote = "CHEER" },
                Troll = { phrases = { "Da dark spear strikes true! Taste dis, %s!", "Here comes da pain, %s!", "For da Darkspear! Taz'dingo!", "Ya gonna bleed for dat mistake, %s!" }, emote = "ROAR" },
                Undead = { phrases = { "Victory for Sylvanas! Feel the chill of the grave, %s!", "Join us in eternal torment, %s!", "Your flesh will rot just like the rest!", "The blight take you, %s!" }, emote = "CACKLE" },
                Human = { phrases = { "For the Alliance! Stand and fight, %s!", "For the King and the Lion!", "Hold the line! Strike true!", "Your advance ends right here, %s!" }, emote = "ROAR" },
                Dwarf = { phrases = { "Khaz Modan! Taste steel, %s!", "For Ironforge! Let's break their ranks!", "Yer armor won't save ye from this hammer, %s!", "Eat iron and thunder, %s!" }, emote = "CHEST" },
                NightElf = { phrases = { "For Kalimdor and the Sentinels!", "By Elune's wrath, fall before me, %s!", "The shadows will claim you, %s!", "You trespass on sacred ground!" }, emote = "ROAR" },
                Gnome = { phrases = { "Gnomish ingenuity in action! Eat sparks, %s!", "For Gnomeregan! Let's short-circuit their plans!", "Size means nothing when you've got high-yield explosives!", "Engaging combat protocol: maximum voltage, %s!" }, emote = "RUDE" },
                Skyborne = { phrases = { "Feel the fury of the gale, %s!", "From above, judgment strikes swift and true!", "The storm winds will scatter you, %s!", "You cannot outrun the tempest, %s!" }, emote = "ROAR" }
            },
            classes = {
                WARRIOR = { phrases = { "Charge! Hold the line beside me, %s!", "Steel and fury! Come and test my shield, %s!", "No retreat! Strike hard, %s!", "Face me if you dare, %s!" } },
                PALADIN = { phrases = { "By the Light, be purged, %s!", "Justice comes swiftly! Stand back, %s!", "The Light shields us—strike without fear, %s!", "Your darkness ends here, %s!" } },
                HUNTER = { phrases = { "Steady aim... fire! You're in my sights, %s!", "Nowhere to hide now, %s!", "Release the beast! Take them down, %s!", "My arrows never miss their mark, %s!" } },
                ROGUE = { phrases = { "Nothing personal, %s... well, maybe a little!", "From the shadows! Watch your back, %s!", "Too slow, %s!", "Let's make this quick and quiet, %s!" } },
                PRIEST = { phrases = { "Light—or shadow—claim you now, %s!", "You will not harm those under my care, %s!", "Feel the weight of judgment, %s!", "Stand back, %s! My faith is my shield!" } },
                SHAMAN = { phrases = { "Storm, earth, and fire—heed my call against %s!", "Feel the fury of the elements, %s!", "Thunder strikes without mercy, %s!", "The spirits demand your defeat, %s!" } },
                MAGE = { phrases = { "By arcane fire and frost, fall before me, %s!", "Let's see how well you handle raw magic, %s!", "Prepare to be polymorph—er, defeated, %s!", "Your spellcraft is no match for mine, %s!" } },
                WARLOCK = { phrases = { "Suffer in shadow and flame, %s!", "Your soul will fuel my power, %s!", "Despair, %s—the abyss answers my call!", "Burn in fel fire, %s!" } },
                DRUID = { phrases = { "Feel the wrath of the untamed wilds, %s!", "Claw, fang, and storm—nature strikes back, %s!", "You threaten the balance, %s! Prepare to fall!", "The forest itself rises against you, %s!" } }
            }
        },

        farewell = {
            icon = RandomDialogRP_Icons.farewell,
            races = {
                Human = { phrases = { "Safe travels on the king's roads, %s.", "Until our paths cross again, %s.", "Go with the Light, %s. Take care out there.", "Farewell for now, %s. Keep your blade sharp." }, emote = "BYE" },
                Dwarf = { phrases = { "Safe travels, %s! Don't be a stranger!", "Off ye go then, %s. Watch yer step in the passes!", "Until next time, %s! Keep yer beard dry!", "Farewell, %s! May yer mug never run empty!" }, emote = "BYE" },
                NightElf = { phrases = { "Walk in Elune's light, %s.", "Until the stars bring us together again, %s.", "May the forest shelter your path, %s.", "Go safely, %s. The wilds are ever watching." }, emote = "BYE" },
                Gnome = { phrases = { "Catch you later, %s! Don't touch any glowing buttons!", "Off I go, %s! Time and gears wait for no one!", "Safe travels, %s! Keep all your limbs intact!", "See you soon, %s! I have schematics to test!" }, emote = "BYE" },
                Orc = { phrases = { "Strength and honor on the road ahead, %s.", "Until we meet in battle again, %s.", "Go with fury and purpose, %s.", "Farewell, %s. Bring glory to the Horde." }, emote = "BYE" },
                Troll = { phrases = { "Later, %s. Keep ya head down out dere.", "Walk easy, %s. May da loa guide ya.", "Until next time, %s!", "Stay sharp on da trail, %s." }, emote = "BYE" },
                Tauren = { phrases = { "Walk gently upon the earth, %s.", "Until our trails meet again, %s.", "May the Earthmother watch over your journey, %s.", "Farewell, %s. Travel in peace." }, emote = "BYE" },
                Undead = { phrases = { "Try not to get yourself killed, %s... unless you want company.", "Until death—or business—brings us together again, %s.", "Darkness guide your steps, %s.", "Farewell, %s. Do try to survive." }, emote = "BYE" },
                Skyborne = { phrases = { "May favorable winds carry you home, %s.", "Until our paths cross beneath open skies again, %s.", "Fly swift and travel safe, %s.", "Farewell, %s. Keep your eyes on the horizon." }, emote = "BYE" }
            },
            classes = {
                WARRIOR = { phrases = { "Stay sharp out there, %s. Keep your guard up.", "Until the next battle, %s.", "Safe roads to you, %s. Keep your steel clean.", "Farewell, %s. Don't let them catch you off guard." } },
                PALADIN = { phrases = { "Walk in the Light, %s.", "May grace protect you on your journey, %s.", "Farewell, %s. Until duty calls us together again.", "Go in peace, %s." } },
                HUNTER = { phrases = { "Good hunting out there, %s.", "Watch your tracks, %s. Until next time.", "May the wind stay at your back, %s.", "Safe trails to you, %s." } },
                ROGUE = { phrases = { "Stay out of sight, %s.", "If anyone asks, %s, you never saw me.", "Watch your coin purse out there, %s.", "Until next time, %s." } },
                PRIEST = { phrases = { "Go in peace, %s.", "May grace watch over you until we meet again, %s.", "Take care of yourself, %s.", "Farewell, %s. My prayers go with you." } },
                SHAMAN = { phrases = { "May the winds carry you safely, %s.", "Walk with the ancestors, %s.", "Until the elements cross our paths again, %s.", "Farewell, %s. Stay grounded." } },
                MAGE = { phrases = { "Safe travels, %s—and do avoid unstable portals.", "Until our studies cross again, %s.", "Farewell, %s. May your mind stay sharp.", "Off I go, %s. Conjured refreshments don't make themselves!" } },
                WARLOCK = { phrases = { "Try not to lose your soul before we meet again, %s.", "Until darkness draws us together once more, %s.", "Farewell, %s. Tread carefully in the shadows.", "Go well, %s—and watch what you summon." } },
                DRUID = { phrases = { "Walk gently upon the earth, %s.", "May the moon and stars light your trail, %s.", "Farewell, %s. Until the wilds bring us together again.", "Go in harmony, %s." } }
            }
        },

        warning = {
            icon = RandomDialogRP_Icons.warning,
            races = {
                Human = { phrases = { "Stay sharp, %s. Trouble has been brewing nearby.", "Keep your guard up, %s. Something feels off.", "I wouldn't take that road unguarded, %s.", "Watch your step ahead, %s—bandits and worse prowl these parts." }, emote = "POINT" },
                Dwarf = { phrases = { "Hold up, %s! Smells like trouble just ahead.", "Keep yer axe handy, %s. Something's lurking nearby.", "I wouldn't wander down there alone, %s.", "Mark my words, %s—that path is nothing but bad news." }, emote = "POINT" },
                NightElf = { phrases = { "Tread lightly, %s. Corruption stirs in these shadows.", "Be on your guard, %s. The trees have gone unusually quiet.", "Danger lingers ahead, %s. Proceed with caution.", "Heed my warning, %s—do not stray from the path." }, emote = "POINT" },
                Gnome = { phrases = { "Whoa there, %s! My danger-meter is ticking off the charts!", "Careful, %s! That area looks highly unstable!", "Hold everything, %s—something isn't adding up ahead.", "Watch your step, %s! Even without my traps, that looks hazardous!" }, emote = "POINT" },
                Orc = { phrases = { "Keep your weapon ready, %s. Enemies prowl nearby.", "Stay alert, %s. I smell an ambush.", "That ground ahead is treacherous, %s.", "Do not let your guard drop, %s." }, emote = "POINT" },
                Troll = { phrases = { "Watch ya step, %s. Bad mojo hangin' round dis place.", "Keep ya eyes peeled, %s—somethin' sneakin' close.", "Dat path look like a trap to me, %s.", "Careful now, %s. Da shadows got teeth tonight." }, emote = "POINT" },
                Tauren = { phrases = { "Tread carefully, %s. The wind carries an ill omen.", "Stay alert, %s. Something disturbs the land ahead.", "Danger waits beyond that ridge, %s.", "Keep your guard up, %s—the wilds are restless." }, emote = "POINT" },
                Undead = { phrases = { "Careful, %s. Something foul lurks ahead—and for once it isn't me.", "Keep your wits about you, %s. Ambushers love this terrain.", "Step carefully, %s. That path reeks of a trap.", "Don't get careless now, %s." }, emote = "POINT" },
                Skyborne = { phrases = { "Watch the skies and the ridges, %s—a storm is gathering.", "Stay alert, %s. Danger circles closer than it seems.", "The winds carry warning from ahead, %s.", "Tread carefully, %s. Something hunts in these currents." }, emote = "POINT" }
            },
            classes = {
                WARRIOR = { phrases = { "Shields up, %s! Trouble's incoming!", "Watch your flanks, %s—this looks like an ambush.", "Stay close, %s. We're walking into heavy resistance.", "Keep your weapon drawn, %s." } },
                PALADIN = { phrases = { "Be vigilant, %s. Darkness gathers ahead.", "Keep your faith strong, %s—evil lurks nearby.", "Tread carefully, %s. Corruption taints this ground.", "Stay behind my shield if trouble strikes, %s." } },
                HUNTER = { phrases = { "Hold up, %s—fresh tracks right ahead.", "Keep low, %s. Something's stalking us.", "Watch your step, %s—traps or worse could be hidden here.", "Eyes sharp, %s. We're not alone." } },
                ROGUE = { phrases = { "Eyes open, %s. Someone's tailing us.", "Careful, %s—this whole setup smells like a double-cross.", "Check your step, %s. Tripwires are bad for your health.", "Keep quiet, %s. We've got company." } },
                PRIEST = { phrases = { "Be mindful, %s. A heavy darkness hangs over this place.", "Guard your mind and body, %s.", "Take caution ahead, %s—danger is near.", "Stay close, %s, so I can mend any wounds." } },
                SHAMAN = { phrases = { "Listen, %s—the earth trembles with warning.", "Be careful, %s. The spirits are uneasy here.", "A storm gathers ahead, %s. Prepare yourself.", "Tread lightly, %s—this ground is volatile." } },
                MAGE = { phrases = { "Caution, %s—I detect volatile magic ahead.", "Stay alert, %s. Something arcane is distorting the air.", "Watch your step, %s. That looks like a warded trap.", "Keep your distance if things spark, %s." } },
                WARLOCK = { phrases = { "Careful, %s. Even my demon is nervous about what's ahead.", "Dark forces stir nearby, %s. Stay alert.", "Watch your step, %s—curses linger in places like this.", "Keep your guard up, %s. Something wicked awaits." } },
                DRUID = { phrases = { "Be careful, %s—the animals have fled this area.", "Something unnatural taints the land ahead, %s.", "Stay alert, %s. Predators are close.", "Tread lightly, %s—danger hides beneath the canopy." } }
            }
        },

        question = {
            icon = RandomDialogRP_Icons.question,
            races = {
                Human = { phrases = { "Tell me, %s, what news do you bring from the road?", "Where are you headed next, %s?", "Have you heard any word from Stormwind lately, %s?", "What's your take on our situation here, %s?" }, emote = "TALK" },
                Dwarf = { phrases = { "So tell me, %s, what brings ye out this way?", "Got any news from the road, %s?", "Where're ye headed after this, %s?", "What do ye make of all this commotion, %s?" }, emote = "TALK" },
                NightElf = { phrases = { "What tidings do you bring from afar, %s?", "What draws you into these ancient lands, %s?", "Have you noticed any disturbance along the trail, %s?", "Which course do you believe is wisest, %s?" }, emote = "TALK" },
                Gnome = { phrases = { "Say, %s, what's the latest data from out in the field?", "Where are you off to next, %s?", "Have you ever seen anything quite like this, %s?", "What's our statistical probability of success here, %s?" }, emote = "TALK" },
                Orc = { phrases = { "Speak, %s—what word comes from the front?", "Where do you march next, %s?", "What business brings you here, %s?", "How do you plan to strike, %s?" }, emote = "TALK" },
                Troll = { phrases = { "So what's da word on da road, %s?", "Where ya headed off to, %s?", "Whatcha makin' of all dis, %s?", "Got any good stories from ya hunt, %s?" }, emote = "TALK" },
                Tauren = { phrases = { "What news do you carry from afar, %s?", "Where does your journey lead next, %s?", "What weighs upon your mind, %s?", "Which trail do you think we should follow, %s?" }, emote = "TALK" },
                Undead = { phrases = { "What grim tidings do you bring, %s?", "Where are you creeping off to next, %s?", "What's your angle here, %s?", "Tell me, %s—how do you intend to handle this?" }, emote = "TALK" },
                Skyborne = { phrases = { "What news rides the wind from your travels, %s?", "Where do the currents carry you next, %s?", "What brings you down from the high trails, %s?", "Which course looks clearest to you, %s?" }, emote = "TALK" }
            },
            classes = {
                WARRIOR = { phrases = { "What's the tactical situation ahead, %s?", "Where do we strike next, %s?", "How many are we facing out there, %s?", "Ready to push forward, %s?" } },
                PALADIN = { phrases = { "How may we best aid those in need here, %s?", "What news do you bring from the realm, %s?", "Where does our duty call us next, %s?", "Do you sense anything amiss ahead, %s?" } },
                HUNTER = { phrases = { "Picked up any trail or rumor lately, %s?", "Which direction are we tracking next, %s?", "See anything moving up ahead, %s?", "Ready to spring the trap, %s?" } },
                ROGUE = { phrases = { "What's the angle here, %s?", "Got any inside info on what's ahead, %s?", "How quiet do we need to keep this, %s?", "What's the payout looking like, %s?" } },
                PRIEST = { phrases = { "How are you holding up, %s?", "Where are we needed most right now, %s?", "What troubles you, %s?", "Shall we press onward, %s?" } },
                SHAMAN = { phrases = { "What do you sense on the wind, %s?", "Where do the spirits lead us next, %s?", "How shall we approach what lies ahead, %s?", "Are you ready for the storm, %s?" } },
                MAGE = { phrases = { "What is your hypothesis on what awaits us, %s?", "Where shall we teleport—or walk—next, %s?", "Have you encountered anything unusual here, %s?", "Do you require water, food, or arcane intellect, %s?" } },
                WARLOCK = { phrases = { "What price are you willing to pay to succeed here, %s?", "Where do we strike next, %s?", "Have you sensed any demonic presence nearby, %s?", "How shall we dismantle them, %s?" } },
                DRUID = { phrases = { "What signs have you noticed along the trail, %s?", "Where does nature call us next, %s?", "How can we restore balance here, %s?", "Are you ready to move swiftly, %s?" } }
            }
        },

        agreement = {
            icon = RandomDialogRP_Icons.agreement,
            races = {
                Human = { phrases = { "Agreed, %s. That's the sensible choice.", "A sound plan, %s. You have my support.", "You speak wisely, %s. Let's do it.", "Then it's settled, %s. Lead the way." }, emote = "YES" },
                Dwarf = { phrases = { "Aye, %s! Now ye're talking sense!", "Solid plan, %s. Count me in!", "Couldn't have put it better myself, %s.", "Right ye are, %s! Let's get to work!" }, emote = "YES" },
                NightElf = { phrases = { "Your counsel is wise, %s. I will follow.", "I stand with you, %s.", "Truth rings in your words, %s.", "So be it, %s. Let us move swiftly." }, emote = "YES" },
                Gnome = { phrases = { "Precisely, %s! The math checks out!", "Brilliant deduction, %s! Let's execute!", "I concur wholeheartedly, %s!", "Full steam ahead, %s!" }, emote = "YES" },
                Orc = { phrases = { "Well spoken, %s. I stand with you.", "A warrior's plan, %s. Let us strike.", "Agreed, %s. No hesitation.", "Then it is decided, %s." }, emote = "YES" },
                Troll = { phrases = { "Ya mon, %s! Dat sound right to me.", "Good plan, %s. I got ya back.", "Smart thinkin', %s. Let's roll.", "I'm wit ya on dat one, %s." }, emote = "YES" },
                Tauren = { phrases = { "Your words carry wisdom, %s. I agree.", "A steady and honorable path, %s.", "I will walk beside you in this, %s.", "It is decided then, %s." }, emote = "YES" },
                Undead = { phrases = { "A calculated choice, %s. I approve.", "Very well, %s. Let us proceed.", "You make a compelling point, %s.", "Agreed, %s. Let's get it over with." }, emote = "YES" },
                Skyborne = { phrases = { "A clear course, %s. I will fly with you.", "Well reasoned, %s. You have my support.", "The wind favors this plan, %s.", "Agreed, %s. Let us move as one." }, emote = "YES" }
            },
            classes = {
                WARRIOR = { phrases = { "Solid plan, %s. I'll take point.", "Agreed, %s. Let's hit them head-on.", "You've got my blade on it, %s.", "Good call, %s. Moving out." } },
                PALADIN = { phrases = { "A righteous course, %s. I stand with you.", "Agreed, %s. May the Light guide our efforts.", "Your words ring with honor, %s.", "So be it, %s. Let us act with purpose." } },
                HUNTER = { phrases = { "Good instinct, %s. Let's move.", "Agreed, %s. I'll cover from range.", "Smart call, %s. On your mark.", "Works for me, %s." } },
                ROGUE = { phrases = { "Clever, %s. I like your style.", "Agreed, %s. I'll handle the locks.", "Sounds clean, %s. Let's move.", "You've got a deal, %s." } },
                PRIEST = { phrases = { "A wise and compassionate choice, %s.", "I agree, %s. I will keep you standing.", "Your words bring clarity, %s.", "Let us proceed together, %s." } },
                SHAMAN = { phrases = { "The elements align with your words, %s.", "A balanced plan, %s. I agree.", "I will place my totems beside you, %s.", "So let it be, %s." } },
                MAGE = { phrases = { "A logical conclusion, %s. I concur.", "Sound reasoning, %s. Let us proceed.", "Precisely what I was calculating, %s.", "Agreed, %s. A brilliant strategy." } },
                WARLOCK = { phrases = { "Ruthless and effective, %s. I like it.", "Agreed, %s. Let us unleash hell.", "A pragmatic choice, %s.", "Consider it done, %s." } },
                DRUID = { phrases = { "A natural and wise course, %s. I agree.", "I stand with you, %s.", "Your instincts are true, %s.", "Let us move as one with the wild, %s." } }
            }
        },

        disagreement = {
            icon = RandomDialogRP_Icons.disagreement,
            races = {
                Human = { phrases = { "I can't agree to that, %s. It's too reckless.", "No, %s. There has to be a better way.", "Think again, %s—that path leads straight into trouble.", "I won't stand behind that plan, %s." }, emote = "NO" },
                Dwarf = { phrases = { "Not a chance, %s! That's asking for a cave-in.", "Nay, %s. I'm not putting my neck on that line.", "Think twice about that one, %s.", "Ye've got a hard head, %s, but I'm saying no." }, emote = "NO" },
                NightElf = { phrases = { "No, %s. That invites needless ruin.", "I cannot consent to that, %s.", "You act in haste, %s. Reconsider before it is too late.", "Our paths diverge on this matter, %s." }, emote = "NO" },
                Gnome = { phrases = { "Negative, %s! That violates at least three safety protocols!", "No, no, no, %s—the variables are all wrong!", "I strongly advise against that, %s!", "Back to the drawing board, %s—that won't hold together!" }, emote = "NO" },
                Orc = { phrases = { "No, %s. That is a coward's path.", "I will not follow a foolish plan, %s.", "You speak without thinking, %s.", "Not while I draw breath, %s." }, emote = "NO" },
                Troll = { phrases = { "Nah, %s. Dat's askin' for trouble.", "Bad idea, %s. Da spirits say no.", "I ain't walkin' into dat mess, %s.", "Think again, %s—dere's a smarter way." }, emote = "NO" },
                Tauren = { phrases = { "No, %s. That path brings only needless harm.", "I cannot walk that road with you, %s.", "Pause and reconsider, %s—there is a wiser choice.", "My spirit tells me otherwise, %s." }, emote = "NO" },
                Undead = { phrases = { "No, %s. Even I am not reckless enough for that.", "A dreadful idea, %s. Try again.", "I'll pass on that plan, %s.", "You're welcome to try it alone, %s." }, emote = "NO" },
                Skyborne = { phrases = { "No, %s. That course leads straight into a tempest.", "I cannot follow that path, %s.", "Think again, %s—the risk outweighs the reward.", "We see different skies on this matter, %s." }, emote = "NO" }
            },
            classes = {
                WARRIOR = { phrases = { "Bad position, %s. We'll get flanked.", "No, %s—charging in blind will get us killed.", "Hold up, %s. Rethink that approach.", "I'm not throwing lives away on that plan, %s." } },
                PALADIN = { phrases = { "I cannot condone that path, %s.", "No, %s—honor demands a better way.", "Think carefully before acting, %s.", "That violates the oath I swore, %s." } },
                HUNTER = { phrases = { "Bad angle, %s. They'll spot us a mile away.", "No, %s—we're walking straight into their snare.", "Hold off, %s. Wait for a cleaner shot.", "That's not how you hunt smart, %s." } },
                ROGUE = { phrases = { "Too noisy, %s. We'll bring the whole camp down on us.", "Pass, %s. Find a smarter way in.", "No chance, %s—that's a suicide run.", "Think with your head, %s, not your boots." } },
                PRIEST = { phrases = { "I fear that path brings only suffering, %s.", "No, %s—there must be a gentler way.", "Reconsider this course, %s.", "I cannot lend my blessing to that, %s." } },
                SHAMAN = { phrases = { "No, %s—that invites chaos we cannot control.", "The spirits warn against that path, %s.", "We must seek harmony, not recklessness, %s.", "I cannot support that course, %s." } },
                MAGE = { phrases = { "Flawed premise, %s. That will backfire spectacularly.", "No, %s—the arcane risks are far too high.", "I must object on purely logical grounds, %s.", "Reconsider, %s, before we're both turned to ash." } },
                WARLOCK = { phrases = { "Foolish, %s. Even I know when a pact isn't worth the cost.", "No, %s—that will get us consumed.", "Think twice, %s. There's a darker, smarter play.", "Count me out of that blunder, %s." } },
                DRUID = { phrases = { "No, %s—that path scars the land needlessly.", "I cannot support that course, %s.", "Pause and listen to reason, %s.", "Nature warns against such haste, %s." } }
            }
        },

        celebration = {
            icon = RandomDialogRP_Icons.celebration,
            races = {
                Human = { phrases = { "A hard-earned victory, %s! Well fought!", "Raise a glass! Today belongs to us, %s!", "Fine work out there, %s. That's one for the bards!", "For the Alliance! What a triumph, %s!" }, emote = "CHEER" },
                Dwarf = { phrases = { "Ha! Now THAT'S how dwarves get it done, %s!", "Break out the ale, %s! We earned it today!", "Fine fighting, %s! Ironforge would be proud!", "To victory, %s! Drink up!" }, emote = "CHEER" },
                NightElf = { phrases = { "A noble triumph, %s! Elune smiles upon us.", "The wilds breathe easier tonight thanks to you, %s.", "Well fought, %s. Your courage honors Kalimdor.", "Victory is ours, %s!" }, emote = "CHEER" },
                Gnome = { phrases = { "Wahoo! Flawless execution, %s!", "Success! Write that down in the logbook, %s!", "Amazing job, %s! High fives—well, knee-level fives!", "Another triumph for brains over brawn, %s!" }, emote = "CHEER" },
                Orc = { phrases = { "A glorious victory, %s! For the Horde!", "Let our war cries echo across the valley, %s!", "You fought like a true champion, %s!", "Blood and thunder! Well earned, %s!" }, emote = "CHEER" },
                Troll = { phrases = { "Taz'dingo! Now dat's what I call a fight, %s!", "Big win today, %s! Da loa gonna love dis!", "Ya showed 'em good, %s!", "Let's celebrate, %s—we earned our rest!" }, emote = "CHEER" },
                Tauren = { phrases = { "A great victory, %s! The plains will remember this day.", "Well fought, %s! Peace returns to this land.", "May songs be sung of your courage, %s!", "We have triumphed together, %s!" }, emote = "CHEER" },
                Undead = { phrases = { "Magnificent carnage, %s! Simply delightful.", "Another victory for the Forsaken, %s!", "Well executed, %s—pun entirely intended.", "They never stood a chance, %s." }, emote = "CHEER" },
                Skyborne = { phrases = { "A soaring victory, %s! Well fought!", "The winds themselves celebrate this triumph, %s!", "Magnificent work, %s! Today we rule the skies!", "Raise your voice, %s—we have conquered the storm!" }, emote = "CHEER" }
            },
            classes = {
                WARRIOR = { phrases = { "Ha! What a clash, %s! Well fought!", "Victory! None could stand before us, %s!", "That's how you hold a line, %s!", "Raise your weapons, %s! The field is ours!" } },
                PALADIN = { phrases = { "The Light prevails once more, %s!", "A righteous victory, %s! Well done!", "Justice has been served today, %s!", "Give thanks for this triumph, %s!" } },
                HUNTER = { phrases = { "Clean kill, %s! Couldn't have shot it better myself!", "What a hunt, %s! Worthy of a trophy!", "Bagged and tagged, %s! Great work!", "The wilds belong to us today, %s!" } },
                ROGUE = { phrases = { "Cleanest job all week, %s!", "They never even saw us coming, %s!", "Drinks are on the loot tonight, %s!", "Flawless execution, %s!" } },
                PRIEST = { phrases = { "Praise be! We came through unscathed, %s!", "A wonderful triumph, %s!", "Hope shines brighter today because of you, %s!", "Well done, %s! Let us rest and recover." } },
                SHAMAN = { phrases = { "The elements roar in triumph, %s!", "Balance is restored! Well fought, %s!", "A glorious storm of victory, %s!", "The ancestors would be proud today, %s!" } },
                MAGE = { phrases = { "A textbook victory, %s! Simply magnificent!", "Brilliantly executed, %s!", "Intellect triumphs over brute force once again, %s!", "Splendid work, %s!" } },
                WARLOCK = { phrases = { "Delicious victory, %s! Look at the chaos we wrought!", "Magnificent work, %s! None could withstand us!", "Another soul-crushing triumph, %s!", "Well done, %s. Power favors the bold." } },
                DRUID = { phrases = { "The wilds rejoice with us today, %s!", "A splendid victory, %s! Balance endures!", "Well fought, %s! Nature smiles upon our triumph!", "We stood strong together, %s!" } }
            }
        },

        encouragement = {
            icon = RandomDialogRP_Icons.encouragement,
            races = {
                Human = { phrases = { "Hold firm, %s. We've survived worse than this.", "Keep pushing forward, %s—we're right behind you.", "Don't lose heart now, %s. Victory is within reach.", "Stand tall, %s. Make every strike count!" }, emote = "CHEER" },
                Dwarf = { phrases = { "Dig yer heels in, %s! We don't back down!", "Keep swinging, %s—they're starting to crack!", "Ye're tougher than granite, %s! Keep at it!", "Steady now, %s! One good push and we've got 'em!" }, emote = "CHEER" },
                NightElf = { phrases = { "Stand resolute, %s. The night is darkest before dawn.", "Draw strength from the earth beneath you, %s.", "Do not falter now, %s—we endure together.", "Trust your instincts, %s. You are stronger than you know." }, emote = "CHEER" },
                Gnome = { phrases = { "Keep going, %s! You're operating at peak efficiency!", "Don't give up now, %s—we're almost at the breakthrough!", "Stay focused, %s! You've got all the right parts for this!", "Chin up, %s! Big results come in small packages!" }, emote = "CHEER" },
                Orc = { phrases = { "Stand strong, %s! Pain is temporary, honor is forever!", "Push forward, %s! Break their line!", "Show them the true might of the Horde, %s!", "Never yield, %s! Fight until the last!" }, emote = "CHEER" },
                Troll = { phrases = { "Keep movin', %s! Ya got plenty of fight left in ya!", "Don't slow down now, %s—we got 'em on da run!", "Stay strong, %s! Da spirits got ya back!", "Hit 'em hard, %s! Make it count!" }, emote = "CHEER" },
                Tauren = { phrases = { "Stand firm like the ancient oaks, %s.", "Take heart, %s—we carry this burden together.", "Your strength is greater than the storm, %s.", "Keep steady, %s. The horizon draws near." }, emote = "CHEER" },
                Undead = { phrases = { "Keep fighting, %s—you're not dead yet!", "Press the attack, %s! Show them no mercy.", "Endure, %s. Pain is merely a reminder you're still moving.", "Finish them off, %s!" }, emote = "CHEER" },
                Skyborne = { phrases = { "Ride the wind, %s! Never yield!", "Keep climbing, %s—the peak is within sight!", "Hold steady against the gale, %s! We stand with you!", "Strike swift and true, %s!" }, emote = "CHEER" }
            },
            classes = {
                WARRIOR = { phrases = { "Hold your ground, %s! Don't give them an inch!", "Keep swinging, %s! They're weakening!", "On your feet, %s! The fight isn't over!", "Push through, %s! Victory is right ahead!" } },
                PALADIN = { phrases = { "Courage, %s! The Light has not abandoned us!", "Stand fast, %s—righteousness will endure!", "Rise up, %s! Together we cannot fail!", "Hold on to hope, %s. Dawn is coming." } },
                HUNTER = { phrases = { "Steady your breath, %s—you've got this!", "Keep pressing, %s! Our quarry is tiring!", "Stay sharp, %s! One more push!", "Trust your instincts, %s!" } },
                ROGUE = { phrases = { "Stay quick on your feet, %s—we're almost clear!", "Keep pressing, %s! They're losing their balance!", "Don't slip now, %s—finish the job!", "You've got the upper hand, %s!" } },
                PRIEST = { phrases = { "Keep faith, %s! I won't let you fall!", "You are stronger than you believe, %s!", "Press on, %s—healing and hope are with you!", "Stand firm, %s! We will overcome this!" } },
                SHAMAN = { phrases = { "Stand strong like stone, %s!", "Let the wind lift your spirit, %s—keep going!", "The elements stand with us, %s! Push forward!", "Do not falter, %s—the storm is almost ours!" } },
                MAGE = { phrases = { "Keep focus, %s! Victory is within our grasp!", "Press the advantage, %s—their defenses are crumbling!", "Stay sharp, %s! We have them outmatched!", "One final surge, %s!" } },
                WARLOCK = { phrases = { "Feed on their fear, %s—push forward!", "Don't back down now, %s! Break their will!", "Keep pressing, %s—they're already doomed!", "Unleash everything you've got, %s!" } },
                DRUID = { phrases = { "Stand tall like the ancient trees, %s!", "Keep moving, %s—nature's strength flows through you!", "Don't yield, %s! We weather this storm together!", "Trust your instincts, %s! Victory is near!" } }
            }
        },

        joke = {
            icon = RandomDialogRP_Icons.joke,
            races = {
                Human = { phrases = { "I told a Stormwind guard to relax once, %s. He asked for my paperwork.", "Careful with that plan, %s—last time someone tried it, Westfall ran out of turnips.", "You call that stealthy, %s? Even a Kobold heard you coming!", "Laugh while we can, %s—the tavern tab comes later." }, emote = "LAUGH" },
                Dwarf = { phrases = { "Why don't dwarves ever get lost, %s? Because every road leads to a tavern!", "I once met an elf who tried to outdrink me, %s. He's still napping.", "That plan has more holes than a gnome's boiler, %s!", "If things go sideways, %s, at least we brought plenty of ale." }, emote = "LAUGH" },
                NightElf = { phrases = { "I spent a century meditating on patience, %s—then I met a gnome.", "You move through the brush like a startled kodo, %s.", "Even the owls are laughing at that idea, %s.", "Perhaps we should stick to fighting rather than comedy, %s." }, emote = "LAUGH" },
                Gnome = { phrases = { "Good news, %s! The explosion was only 12% larger than projected!", "Why did the gnome bring a ladder to the tavern, %s? Because the drinks were on the house!", "Don't worry, %s, it only smokes when it's working properly!", "I tried to build a silent alarm once, %s. It hasn't stopped beeping since Tuesday." }, emote = "LAUGH" },
                Orc = { phrases = { "A peon once told me 'work is da poop,' %s. I promoted him to scout.", "That plan is almost as subtle as a charging kodo, %s!", "If they don't surrender, %s, we'll just hit them harder.", "Laugh before the fight, %s—it confuses the enemy." }, emote = "LAUGH" },
                Troll = { phrases = { "I asked a witch doctor for a love potion once, %s. Ended up married to a raptor.", "Dat sneak attack was louder than a drum circle, %s!", "If dat plan works, %s, I'll eat my own tusks.", "Better to laugh now than cry later, %s!" }, emote = "LAUGH" },
                Tauren = { phrases = { "Why do tauren never play hide-and-seek, %s? Even the trees give us away.", "A goblin tried to sell me 'compact armor' once, %s. It barely fit my horn.", "That plan moved slower than a sleepy kodo, %s!", "Even the Earthmother appreciates a good laugh now and then, %s." }, emote = "LAUGH" },
                Undead = { phrases = { "I'd lend you a hand, %s, but I'm still stitching it back on.", "Don't worry about dying, %s—it really grows on you.", "That plan was dead on arrival, %s.", "I'd smile, %s, but my jaw might come loose." }, emote = "LAUGH" },
                Skyborne = { phrases = { "From up high, %s, your plan looked a lot smaller.", "Careful not to get carried away, %s—the wind doesn't always bring you back!", "Even the mountain hawks stared at that maneuver, %s.", "At least if we fall, %s, we'll have a great view on the way down." }, emote = "LAUGH" }
            },
            classes = {
                WARRIOR = { phrases = { "My strategy is simple, %s: hit it until it stops moving.", "Who needs magic when you have a really heavy axe, %s?", "I tried diplomacy once, %s. Brought the wrong hammer.", "At least my armor catches all the arrows, %s!" } },
                PALADIN = { phrases = { "Yes, %s, the plate armor IS heavy—especially on stairs.", "I tried sneaking once, %s. Gleaming gold isn't very subtle.", "Even a paladin needs a break from serious speeches, %s.", "If all else fails, %s, I'll just blind them with my shoulderpads." } },
                HUNTER = { phrases = { "Don't worry, %s, my pet only bites people who look like snacks.", "Yes, %s, I meant to pull that extra pack. Totally calculated.", "Why walk when you can aspect-of-the-cheetah into a daze, %s?", "Rule one of hunting, %s: never let the pet name itself." } },
                ROGUE = { phrases = { "I found your missing wallet, %s. Good thing I was holding onto it for safekeeping.", "Stealth is 90% skill and 10% hoping nobody turns around, %s.", "I only pick pockets on days ending in 'y', %s.", "Relax, %s, the poison on my blades is strictly decorative. Mostly." } },
                PRIEST = { phrases = { "Yes, %s, I CAN heal stupid—it just costs extra mana.", "Stop standing in the fire, %s, my mana bar is weeping.", "Sometimes I dabble in Shadow just to keep things interesting, %s.", "Consider that heal a divine miracle, %s—because you barely survived." } },
                SHAMAN = { phrases = { "I asked the wind for advice once, %s. It blew my hat off.", "Careful around my totems, %s—the fire one has a temper.", "Why carry a map when you can just ask a very confused spirit, %s?", "If lightning strikes twice, %s, it wasn't an accident." } },
                MAGE = { phrases = { "I'm a master of the arcane arts, %s, not a vending machine—though yes, here's your bread.", "Blink into a wall once, %s, and nobody ever lets you live it down.", "Technically, turning them into a sheep IS crowd control, %s.", "My robe is 100% fireproof, %s. My eyebrows, less so." } },
                WARLOCK = { phrases = { "Relax, %s, the imp only complains when he's awake.", "Need a summon, %s? Just sign this tiny, completely standard blood contract.", "I life-tapped again, %s—healers love me for keeping them busy!", "Green fire isn't a phase, %s, it's a lifestyle." } },
                DRUID = { phrases = { "Yes, %s, I can turn into a bear—no, you cannot ride me into town.", "Sorry for the fur on your cloak, %s. Shedding season.", "Why take the road when you can travel-form straight off a cliff, %s?", "I'm a tree, a cat, a bear, and an owl, %s—pick whichever one helps most." } }
            }
        }
    }
}