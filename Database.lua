-- Database.lua
-- Default database for WoW Forever (8 Original Races + Skyborne)
-- Minimum of 4 phrases per category per race.

RandomDialogRP_Icons = {
    greetings = "Interface\\Icons\\Spell_Nature_HealingTouch",
    thanks    = "Interface\\Icons\\Spell_Nature_Regeneration",
    battle    = "Interface\\Icons\\Ability_Racial_BearForm"
}

RandomDialogRP_Defaults = {
    -- ============================================================================
    -- HORDE RACES
    -- ============================================================================
    Tauren = {
        greetings = {
            frases = {
                "May the Earthmother guide our steps on this journey, %s.",
                "Walk with the earth, %s.",
                "Ah, greetings %s. May your path be free of thorns.",
                "Peace be upon your dwelling, %s."
            },
            emote = "WAVE"
        },
        thanks = {
            frases = {
                "The Earthmother smiles upon your generosity, %s.",
                "I am deeply grateful for your assistance, %s.",
                "Your kindness echoes through the plains, %s.",
                "My thanks to you, %s. May the winds be ever at your back."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "The deep roots of the forest do not fear the storm!",
                "Even the calmest bear knows when to show its claws to %s!",
                "For Kalimdor! Let the earth shatter beneath our hooves!",
                "You face the unyielding strength of the plains!"
            },
            emote = "ROAR"
        }
    },
    Orc = {
        greetings = {
            frases = {
                "Lok'tar ogar, %s! Victory or death.",
                "Strength and honor, %s.",
                "Speak truth, %s, or speak not at all.",
                "Well met, %s. What brings you to our camp?"
            },
            emote = "SALUTE"
        },
        thanks = {
            frases = {
                "Your aid is noted and appreciated, %s.",
                "For the Horde! Thank you, %s!",
                "A worthy deed from a reliable ally.",
                "I won't forget this debt, %s."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "Blood and thunder! Prepare yourself, %s!",
                "For the Horde! Lok-narosh!",
                "Your skull will make a fine trophy!",
                "No mercy for the enemies of the Horde!"
            },
            emote = "CHEER"
        }
    },
    Troll = {
        greetings = {
            frases = {
                "Stay away from da voodoo, mon.",
                "Whatcha need, %s? Da spirits are listenin'.",
                "Peace, mon. May your hunt be fruitful.",
                "Well met in da shadows, %s."
            },
            emote = "WAVE"
        },
        thanks = {
            frases = {
                "Much tanks to ya, mon. Da loa smile on ya.",
                "You got a good heart, %s. I won't forget dis.",
                "Dat was a big help, mon!",
                "May da spirits watch over ya for dis, %s."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "Da dark spear bite true! Taste dis, %s!",
                "Here come da pain, mon!",
                "For da Darkspear tribe! Taz'dingo!",
                "You gonna bleed for dat, %s!"
            },
            emote = "ROAR"
        }
    },
    Undead = {
        greetings = {
            frases = {
                "Watch your back, living... or dead.",
                "Darkness beckons, %s. What do you seek?",
                "The Dark Lady watches over us all.",
                "Speak quickly, my patience rots away."
            },
            emote = "BOW"
        },
        thanks = {
            frases = {
                "A rare display of competence, %s. My thanks.",
                "I suppose even the dead can feel gratitude. Thank you.",
                "Your assistance preserves our dark designs.",
                "Death holds no gratitude, but I do, %s."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "Victory for Sylvanas! Feel the chill of the grave, %s!",
                "Join us in eternal slumber!",
                "Your flesh will rot just like the rest!",
                "The plague take you, %s!"
            },
            emote = "CACKLE"
        }
    },

    -- ============================================================================
    -- ALLIANCE RACES
    -- ============================================================================
    Human = {
        greetings = {
            frases = {
                "Greetings, traveler. Stay safe out there.",
                "Light be with you, %s.",
                "Well met! What brings you to these lands?",
                "Keep your chin up, %s. Better days are ahead."
            },
            emote = "WAVE"
        },
        thanks = {
            frases = {
                "The Alliance is in your debt, %s. Thank you.",
                "Much obliged for your help, %s.",
                "I won't forget this kindness.",
                "A fine display of heroism. My thanks to you!"
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "For the Alliance! Have at you, %s!",
                "For the King and the Lion!",
                "Show no fear! Strike true!",
                "Your resistance ends here, %s!"
            },
            emote = "ROAR"
        }
    },
    Dwarf = {
        greetings = {
            frases = {
                "Top o' the mornin' to ye, %s!",
                "Keep yer feet on the ground!",
                "Well met, %s! Care for a pint after this?",
                "Aye, what can old Ironforge do for ye today?"
            },
            emote = "DRINK"
        },
        thanks = {
            frases = {
                "By the beard of the Titans, I appreciate that!",
                "Thanks, %s! Drinks are on me at the tavern tonight.",
                "That's a proper favor among friends right there.",
                "Much obliged! Ye're a stout ally."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "Khaz Modan! Taste my hammer, %s!",
                "For Ironforge! Have at 'em, lads!",
                "Yer armor won't save ye from this blow!",
                "Eat lead and steel, %s!"
            },
            emote = "CHEST"
        }
    },
    NightElf = {
        greetings = {
            frases = {
                "Elune light your path, %s.",
                "May the shadows embrace you.",
                "Be wary of the wilds, traveler.",
                "Greetings. Speak your mind or pass on."
            },
            emote = "BOW"
        },
        thanks = {
            frases = {
                "Elune's blessing upon you for your aid, %s.",
                "Your assistance is deeply appreciated.",
                "Nature remembers kindness, as do I.",
                "Thank you, %s. May the boughs protect you."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "For Kalimdor! For the Sentinel!",
                "By Elune's light, fall before me, %s!",
                "The shadows shall consume you!",
                "You trespass where you do not belong!"
            },
            emote = "ROAR"
        }
    },
    Gnome = {
        greetings = {
            frases = {
                "Hi there! Did you know gnomish engineering is 42% more efficient?",
                "Greetings, %s! Watch out for my latest prototype down there.",
                "A pleasure! Always good to meet a curious mind.",
                "Ready for action! Well, as ready as my boots allow."
            },
            emote = "FLEX"
        },
        thanks = {
            frases = {
                "Oh, thanks a bunch, %s! You just saved me five calculations!",
                "Much appreciated! I owe you a gadget.",
                "That was brilliant help! Thank you!",
                "Wahoo! Couldn't have calculated a better outcome!"
            },
            emote = "CHEER"
        },
        battle = {
            frases = {
                "Gnomish ingenuity at work! Eat death-ray, %s!",
                "For Gnomeregan! Let's short-circuit 'em!",
                "Size doesn't matter when you have explosives!",
                "Initiating combat protocol: total annihilation!"
            },
            emote = "RUDE"
        }
    },

    -- ============================================================================
    -- CUSTOM WOW FOREVER RACE (BOTH FACTIONS)
    -- ============================================================================
    Skyborne = {
        greetings = {
            frases = {
                "May the eternal winds carry your grace, %s.",
                "Greetings from the high crests, traveler.",
                "Keep your wings open and your gaze upon the horizon.",
                "The skies are peaceful today, %s. What brings you to us?"
            },
            emote = "SALUTE"
        },
        thanks = {
            frases = {
                "The heavens themselves sing of your generosity, %s.",
                "A light gesture with a heavy impact. You have my gratitude.",
                "May the highest breezes guide your steps for this kindness.",
                "My gratitude lifts as high as the clouds, %s."
            },
            emote = "THANK"
        },
        battle = {
            frases = {
                "Feel the gale force of the heavens, %s!",
                "From above, justice strikes swift and true!",
                "The winds of war shall sweep you away!",
                "You cannot outrun the storm, %s!"
            },
            emote = "ROAR"
        }
    }

}

    RandomDialogRP_Icons.farewell = "Interface\\Icons\\Ability_Rogue_Sprint"
    RandomDialogRP_Icons.warning = "Interface\\Icons\\Spell_Shadow_DeathCoil"
    RandomDialogRP_Icons.question = "Interface\\Icons\\INV_Misc_Book_09"
    RandomDialogRP_Icons.agreement = "Interface\\Icons\\Spell_Holy_SealOfMight"
    RandomDialogRP_Icons.disagreement = "Interface\\Icons\\Ability_Warrior_Disarm"
    RandomDialogRP_Icons.celebration = "Interface\\Icons\\Spell_Holy_HolyNova"
    RandomDialogRP_Icons.encouragement = "Interface\\Icons\\Spell_Holy_HolyProtection"
    RandomDialogRP_Icons.joke = "Interface\\Icons\\INV_Misc_QuestionMark"

    local extraCategoryData = {
        farewell = {
            emote = "BYE",
            phrases = {
                "The road calls, %s. May the %s spirit guide you.",
                "Until our paths cross again, %s.",
                "Go well, traveler. The %s watch over your journey.",
                "Farewell for now. Keep your courage close, %s."
            }
        },
        warning = {
            emote = "POINT",
            phrases = {
                "Take care, %s. The %s lands are dangerous tonight.",
                "Keep your guard up, %s. Something is not right.",
                "That path carries danger. Turn back while you can.",
                "You have been warned, %s. Do not ignore the signs."
            }
        },
        question = {
            emote = "TALK",
            phrases = {
                "Tell me, %s, what brings you to the %s?",
                "What is your purpose here, traveler?",
                "Have you heard news from the %s front, %s?",
                "Which path would you take in my place, %s?"
            }
        },
        agreement = {
            emote = "YES",
            phrases = {
                "I agree, %s. That is the %s way.",
                "A sound plan. You have my support.",
                "Your words ring true, %s.",
                "Then it is settled. We move as one."
            }
        },
        disagreement = {
            emote = "NO",
            phrases = {
                "No, %s. That is not how the %s would act.",
                "I cannot support that course.",
                "You are mistaken, traveler. Think again.",
                "Not while I still stand, %s."
            }
        },
        celebration = {
            emote = "CHEER",
            phrases = {
                "A glorious victory for the %s, %s!",
                "Raise your voice! Today we celebrate!",
                "Well done, %s. Your deed will be remembered.",
                "Let the whole %s know of this triumph!"
            }
        },
        encouragement = {
            emote = "CHEER",
            phrases = {
                "Stand tall, %s. The %s do not yield.",
                "You have more strength than you know. Keep going.",
                "Courage, friend. We face this together.",
                "The next step is yours, %s. Make it count."
            }
        },
        joke = {
            emote = "LAUGH",
            phrases = {
                "I would explain the %s joke, but we have places to be.",
                "Even a %s can appreciate a little humor, %s.",
                "That plan was almost as clever as a %s trying to whisper.",
                "Laugh while you can, %s. Tomorrow may be serious."
            }
        }
    }

    local extraRaceFlavors = {
        Human = "human",
        Dwarf = "dwarven",
        NightElf = "night elven",
        Gnome = "gnomish",
        Orc = "orcish",
        Troll = "troll",
        Tauren = "Tauren",
        Undead = "Forsaken",
        Skyborne = "Skyborne"
    }

    for raceName, flavor in pairs(extraRaceFlavors) do
        for categoryName, categoryData in pairs(extraCategoryData) do
            RandomDialogRP_Defaults[raceName][categoryName] = {
                frases = {},
                emote = categoryData.emote
            }
            for _, phrase in ipairs(categoryData.phrases) do
                table.insert(RandomDialogRP_Defaults[raceName][categoryName].frases, string.format(phrase, "%s", flavor))
            end
        end
    end
