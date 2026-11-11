# RandomDialogRP

RandomDialogRP is a World of Warcraft roleplay addon for sending race-themed or
custom dialogue with a chosen emote.

## Features

- Detects your character's race and includes themed phrases for supported races.
- Lets you send phrases through Say, Yell, or Whisper.
- Replaces `%s` in a phrase with your target's first name, or `friend` if you
  have no target.
- Chooses a phrase at random and avoids immediate repeats when alternatives
  exist.
- Supports custom phrases, categories, category icons, and per-phrase emotes.
- Includes searchable phrases and multi-line previews for longer text.
- Organizes phrase, category, language, and profile controls in the phrase
  manager's tabs.
- Supports named profiles for saving different phrase collections and settings.
- Includes English and Brazilian Portuguese localization.
- Provides a movable main panel and draggable minimap button.

## Opening the Addon

- Click the RandomDialogRP button around the minimap.
- Use `/rp` to show or hide the main panel.
- Use `/rp config` or `/rp edit` to open the phrase manager.

## Sending Dialogue

1. Select the race or character theme from the main panel.
2. Choose Say, Yell, or Whisper as the chat channel.
3. Click a category button to send a random phrase from that category.

Whisper sends the phrase to your current player target. If a phrase contains
`%s`, the addon's target name is inserted; without a target, it uses `friend`.
The phrase's assigned emote is performed automatically.

## Managing Phrases and Categories

Open the phrase manager with `/rp config`.

- In **Phrases**, choose a category, search its phrases, and add, edit, or
  remove phrases. Use the emote picker beside a phrase to change its emote.
- In **Categories**, add, rename, delete, or choose an icon for a category.
  Built-in categories cannot be deleted. Deleting a custom category also
  deletes its phrases and requires confirmation.
- Longer phrases wrap in the list preview. When editing, use **Update** to save
  or **Cancel** to discard the edit.

## Profiles and Settings

In the **Settings** tab, choose English or Brazilian Portuguese and manage
profiles. Profiles can be created, saved, loaded, renamed, and deleted.
Deleting a profile requires confirmation; the Default profile cannot be deleted.

## Resetting Saved Data

Click **Reset All Data** at the bottom of the phrase manager and confirm the
prompt to restore default phrases and settings. You can also open the
confirmation with:

```text
/rp reset
```

Use **Save & Reload** to reload the interface after making changes.

## Installation

Download or copy the `RandomDialogRP` folder into your World of Warcraft
installation's `Interface\AddOns\` directory, then enable **RandomDialogRP**
from the character selection AddOns menu. The exact game folder depends on
your installation.
