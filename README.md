# RandomDialogRP

RandomDialogRP is a lightweight roleplay addon for World of Warcraft that helps bring your character to life with themed dialogue and emotes.

Use the movable panel to quickly send race-themed dialogue or any custom phrases you create.

## Features

- Automatically detects your character's race.
- Includes themed phrases for the original races and Skyborne.
- Includes default categories for Greetings, Thanks, Battle Shout, Farewell, Warning, Question, Agreement, Disagreement, Celebration, Encouragement, and Joke.
- Provides four starting phrases in every default category for every supported race.
- Sends phrases through `/say`.
- Automatically inserts your target's name with the `%s` placeholder.
- The `%s` placeholder uses the target's first name only.
- Uses `friend` when no target is selected.
- Choose whether phrases are sent with `/say`, `/yell`, or `/whisper`.
- Whisper phrases are sent to your current target.
- Assigns a different emote to every phrase.
- Avoids immediately repeating a phrase in the same category for a short period when alternatives exist.
- Create, rename, and delete custom categories.
- Add, edit, and remove phrases in-game.
- Choose category icons from Blizzard's macro icon collection.
- Movable main panel and draggable minimap button.
- Saves phrases, categories, icons, emotes, language, and positions.
- Supports account-wide named profiles that can be created, loaded, renamed, and deleted.
- English and Brazilian Portuguese localization.

## Opening the Addon

- Click the RandomDialogRP button around the minimap.
- Use `/rp` to show or hide the main panel.
- Use `/rp config` or `/rp edit` to open the phrase manager.

## Using the Main Panel

1. Select the race or character theme from the race dropdown.
2. Click a category button.
3. RandomDialogRP selects one of that category's phrases.
4. The phrase is sent through `/say`.
5. The phrase's selected emote is performed automatically.

## Managing Categories

Open the phrase manager with `/rp config`.

- Use the category dropdown to choose a category.
- Click **Add** beside the category dropdown to create a category.
- Enter a name and click **Rename** to rename the selected category.
- Click **Delete** to remove a custom category.
- Built-in categories cannot be deleted.
- New categories start with an empty phrase list.
- Click the category icon button to select an icon from Blizzard's available macro icons.

## Managing Phrases

1. Select a category.
2. Enter a phrase in the text field.
3. Click **Add**.
4. Use **Edit** or **Del** beside an existing phrase to change or remove it.
5. Use the emote picker beside each phrase to choose its emote.

Existing phrases remain compatible when updating from an older version. They continue using their category emote until a different emote is selected.

## Target Names

Use `%s` anywhere in a phrase to insert the name of your current target:

```text
Greetings, %s!
```

If you do not have a target, `%s` becomes `friend`.

## Saving Changes

Changes are stored in World of Warcraft's SavedVariables. Use **Save & Reload** in the phrase manager when prompted so all interface changes are refreshed.

## Localization

The interface is available in:

- English
- Brazilian Portuguese

Select the language from the phrase manager.

## Installation

1. Download or copy the `RandomDialogRP` folder.
2. Place it in:

   ```text
   World of Warcraft\_classic_\Interface\AddOns\
   ```

3. Enable **RandomDialogRP** from the character selection AddOns menu.

The exact World of Warcraft folder may differ depending on the client installation.

## Slash Commands

| Command | Action |
| --- | --- |
| `/rp` | Show or hide the main panel |
| `/rp config` | Open the phrase manager |
| `/rp edit` | Open the phrase manager |

## Automated Releases

Pushing a version tag such as `3.1.22` runs the GitHub Actions release workflow.
It packages the addon from the `addon` directory, uploads it to the Wago project
identified by `X-Wago-ID` in the TOC, and creates a GitHub release. The root
`.pkgmeta` configures the packager to place the addon files at the archive root.

Before the first release, add a Wago API token as the repository Actions secret
`WAGO_API_TOKEN` under **Settings > Secrets and variables > Actions**. The
workflow uses GitHub's automatically provided token to create the release; its
permissions are declared in the workflow.

For each release, update `## Version` in `addon/RandomDialogRP.toc`, commit the
change, then create and push an annotated tag with the exact same version. For
example:

```powershell
git tag -a 3.1.22 -m "3.1.22"
git push origin 3.1.22
```

The workflow needs the full Git history to generate release changelogs.

## Optional CurseForge Publishing MCP

This workspace includes an optional local MCP server for publishing releases to CurseForge.

1. Revoke any API token that was shared in chat or committed anywhere.
2. Create a replacement CurseForge API token.
3. Store it as a Windows user environment variable:

   ```powershell
   [Environment]::SetEnvironmentVariable("CURSEFORGE_API_TOKEN", "YOUR_TOKEN", "User")
   ```

4. Install the MCP dependency:

   ```powershell
   python -m pip install -r requirements-mcp.txt
   ```

5. Restart VS Code and enable the `curseforge-publisher` MCP server.

The addon source files are in the `addon` folder, organized into these modules:

- `localization/Locales.lua`
- `core/Database.lua`, `core/Profiles.lua`, and `core/Init.lua`
- `ui/UIHelpers.lua`, `ui/MainPanel.lua`, `ui/PhraseManager.lua`,
  `ui/ProfileManager.lua`, and `ui/Minimap.lua`

The UI modules share the initialized addon state, while profile persistence is
owned exclusively by `core/Profiles.lua`. The MCP publisher is in
`tools/curseforge_mcp.py`. Use the `publish_curseforge_release` tool with the
CurseForge project ID, addon path, version, changelog, release type, and
optional game-version IDs. The server creates the ZIP locally and never writes
the API token to disk.
