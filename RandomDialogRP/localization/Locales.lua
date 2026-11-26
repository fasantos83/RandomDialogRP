-- Locales.lua
-- Localization table for English (Default) and Portuguese

RandomDialogRP_Locales = {
    enUS = {
        greetings = "Greetings",
        thanks = "Thanks",
        battle = "Battle Shout",
        farewell = "Farewell",
        warning = "Warning",
        question = "Question",
        agreement = "Agreement",
        disagreement = "Disagreement",
        celebration = "Celebration",
        encouragement = "Encouragement",
        joke = "Joke",
        managerTitle = "RandomDialogRP - Phrase Manager",
        raceLabel = "Race:",
        phraseOrderLabel = "Phrase order:",
        phraseOrderValue = "Personality > Race/Class",
        chatChannelLabel = "Channel:",
        actionSectionTitle = "Quick Actions",
        actionPhraseCount = "Available phrases: %d",
        actionPhraseBreakdown = "Class: %d | Race: %d",
        phrasesTab = "Phrases",
        categoriesTab = "Categories",
        settingsTab = "Settings",
        phraseLabel = "Phrase:",
        phrasePlaceholderTooltip = "Use %s in a phrase as a placeholder for your target's name. With no target, it becomes 'friend'.",
        noEmote = "No emote",
        phraseClassLabel = "Class:",
        noneClass = "None",
        classPhraseFallback = "No class phrases yet; using race phrases.",
        searchLabel = "Search:",
        editingPhrase = "Editing phrase",
        noSearchResults = "No phrases match your search.",
        sayChannel = "Say",
        yellChannel = "Yell",
        whisperChannel = "Whisper",
        whisperTargetRequired = "Select a target before using Whisper.",
        whisperPlayerRequired = "Your target must be a player before using Whisper.",
        categoryLabel = "Category:",
        languageLabel = "Language:",
        addBtn = "Add",
        updateBtn = "Update",
        cancelBtn = "Cancel",
        editBtn = "Edit",
        delBtn = "Del",
        saveReloadBtn = "Save & Reload",
        versionLabel = "Version: %s",
        reloadWarning = "Changes require a UI Reload to apply correctly.",
        panelHidden = "Panel hidden.",
        panelShown = "Panel displayed.",
        minimapToggle = "Show minimap button",
        minimapShown = "Minimap button shown.",
        autoDetected = "Auto-detected race:",
        phraseAdded = "New phrase added!",
        phraseUpdated = "Phrase updated successfully!",
        phraseRemoved = "Phrase removed.",
        noPhrases = "No phrases registered for this category!",
        categoryName = "Name",
        addCategoryBtn = "Add",
        renameCategoryBtn = "Rename",
        deleteCategoryBtn = "Delete",
        categoryAdded = "Category added!",
        categoryUpdated = "Category renamed!",
        categoryRemoved = "Category removed.",
        deleteCategoryConfirm = "Delete the custom category '%s' and all of its phrases? This cannot be undone.",
        categoryExists = "A category with that name already exists.",
        cannotDeleteCategory = "Built-in categories cannot be deleted.",
        emoteLabel = "Emote",
        resetBtn = "Reset All Data",
        resetConfirm = "This will permanently delete all saved phrases, categories, emotes, icons, and settings, then restore the default phrases. Continue?",
        resetDialogUnavailable = "Could not open the reset confirmation. Try /rp reset.",
        personalityLabel = "Personality:",
        personalityName = "Name",
        personalityCreateBtn = "Create",
        personalityRenameBtn = "Rename",
        personalityDeleteBtn = "Delete",
        personalityExists = "A personality with that name already exists.",
        personalityInvalid = "Enter a valid personality name.",
        cannotChangeDefaultPersonality = "The Default personality cannot be renamed or deleted.",
        personalityLoaded = "Personality loaded.",
        personalityCreated = "Personality created from the active personality.",
        personalityRenamed = "Personality renamed.",
        personalityDeleted = "Personality deleted.",
        deletePersonalityConfirm = "Delete the personality '%s' and all its phrases? This cannot be undone.",
        categorySettingsTitle = "Personality & Category Settings",
        tutorialBtn = "Tutorial",
        tutorialTooltip = "Show the welcome tutorial again.",
        tutorialTitle = "Welcome to RandomDialogRP",
        tutorialVersionUnavailable = "Could not read the addon version; major/minor tutorial updates cannot be detected.",
        tutorialBody = "|cffffd100Quick actions|r\n"
            .. "- Choose a personality, race, class, and chat channel on the main panel.\n"
            .. "- Click a category to send a random phrase; nothing is sent automatically. Hover over a button to see its phrase count.\n"
            .. "- Whisper requires a player target. A phrase's selected emote is performed when it is sent.\n\n"
            .. "|cffffd100Race and class combinations|r\n"
            .. "- Example: Default > Greetings > Human > None uses Human race phrases.\n"
            .. "- Default > Greetings > Human > Mage can use Mage class phrases or Human race phrases. When both exist, class phrases are chosen 80% of the time and race phrases 20%.\n"
            .. "- Class phrases are shared across races. If no class phrases exist, race phrases are used instead.\n\n"
            .. "|cffffd100Writing and editing phrases|r\n"
            .. "- Open Settings > Phrases to add, edit, search, or delete phrases for a personality and category. The editor's race and class selections are separate from the main panel.\n"
            .. "- Use %s for the target's name: \"Hello, %s!\" becomes \"Hello, Lysa!\" when targeting Lysa, or \"Hello, friend!\" without a target.\n"
            .. "- Use the emote picker beside a phrase to choose an emote or select No emote.\n\n"
            .. "|cffffd100Settings and profiles|r\n"
            .. "- Manage personalities, categories, icons, language, and profiles in Settings. Each profile has its own personalities and phrase collections.\n"
            .. "- Use the Tutorial button to open this guide again.\n\n"
            .. "|cffffd100Commands|r\n"
            .. "- /rp: show or hide the main panel.\n"
            .. "- /rp config: open the phrase manager.\n"
            .. "- /rp minimap: show the minimap button if hidden in Settings.",
        tutorialCloseBtn = "Got it",
        profileTitle = "Profiles",
        currentProfile = "Current profile:",
        profileSelect = "Select profile to load or manage:",
        profileName = "Profile name",
        createProfileBtn = "Create",
        saveProfileBtn = "Save",
        loadProfileBtn = "Load",
        renameProfileBtn = "Rename",
        deleteProfileBtn = "Delete",
        defaultProfile = "Default",
        profileExists = "A profile with that name already exists.",
        profileInvalid = "Enter a valid profile name.",
        cannotChangeDefault = "The Default profile cannot be renamed or deleted.",
        profileSaved = "Profile saved.",
        profileLoaded = "Profile loaded.",
        profileCreated = "Profile created.",
        profileRenamed = "Profile renamed.",
        profileDeleted = "Profile deleted.",
        deleteProfileConfirm = "Delete the profile '%s'? This cannot be undone."
    },
    ptBR = {
        greetings = "Saudações",
        thanks = "Agradecimento",
        battle = "Grito de Guerra",
        farewell = "Despedida",
        warning = "Aviso",
        question = "Pergunta",
        agreement = "Concordância",
        disagreement = "Discordância",
        celebration = "Comemoração",
        encouragement = "Encorajamento",
        joke = "Piada",
        managerTitle = "RandomDialogRP - Gerenciador de Frases",
        raceLabel = "Raça:",
        phraseOrderLabel = "Ordem das frases:",
        phraseOrderValue = "Personalidade > Raça/Classe",
        chatChannelLabel = "Canal:",
        actionSectionTitle = "Ações Rápidas",
        actionPhraseCount = "Frases disponíveis: %d",
        actionPhraseBreakdown = "Classe: %d | Raça: %d",
        phrasesTab = "Frases",
        categoriesTab = "Categorias",
        settingsTab = "Configurações",
        phraseLabel = "Frase:",
        phrasePlaceholderTooltip = "Use %s na frase como espaço reservado para o nome do alvo. Sem alvo, será substituído por 'friend'.",
        noEmote = "Sem emote",
        phraseClassLabel = "Classe:",
        noneClass = "Nenhuma",
        classPhraseFallback = "Sem frases de classe; usando as frases da raça.",
        searchLabel = "Buscar:",
        editingPhrase = "Editando frase",
        noSearchResults = "Nenhuma frase corresponde à busca.",
        sayChannel = "Dizer",
        yellChannel = "Gritar",
        whisperChannel = "Sussurrar",
        whisperTargetRequired = "Selecione um alvo antes de usar Sussurrar.",
        whisperPlayerRequired = "Seu alvo precisa ser um jogador para usar Sussurrar.",
        categoryLabel = "Categoria:",
        languageLabel = "Idioma:",
        addBtn = "Adicionar",
        updateBtn = "Atualizar",
        cancelBtn = "Cancelar",
        editBtn = "Editar",
        delBtn = "Excluir",
        saveReloadBtn = "Salvar & Recarregar",
        versionLabel = "Versão: %s",
        reloadWarning = "Alterações exigem um Reload da UI para serem aplicadas.",
        panelHidden = "Painel ocultado.",
        panelShown = "Painel exibido.",
        minimapToggle = "Exibir botão do minimapa",
        minimapShown = "Botão do minimapa exibido.",
        autoDetected = "Raça detectada automaticamente:",
        phraseAdded = "Nova frase adicionada!",
        phraseUpdated = "Frase atualizada com sucesso!",
        phraseRemoved = "Frase removida.",
        noPhrases = "Nenhuma frase registrada para esta categoria!",
        categoryName = "Nome",
        addCategoryBtn = "Adicionar",
        renameCategoryBtn = "Renomear",
        deleteCategoryBtn = "Excluir",
        categoryAdded = "Categoria adicionada!",
        categoryUpdated = "Categoria renomeada!",
        categoryRemoved = "Categoria removida.",
        deleteCategoryConfirm = "Excluir a categoria personalizada '%s' e todas as suas frases? Isso não pode ser desfeito.",
        categoryExists = "Já existe uma categoria com esse nome.",
        cannotDeleteCategory = "Categorias padrão não podem ser excluídas.",
        emoteLabel = "Emote",
        resetBtn = "Redefinir Todos os Dados",
        resetConfirm = "Isso excluirá permanentemente todas as frases, categorias, emotes, ícones e configurações salvas, restaurando as frases padrão. Continuar?",
        resetDialogUnavailable = "Não foi possível abrir a confirmação. Tente /rp reset.",
        personalityLabel = "Personalidade:",
        personalityName = "Nome",
        personalityCreateBtn = "Criar",
        personalityRenameBtn = "Renomear",
        personalityDeleteBtn = "Excluir",
        personalityExists = "Já existe uma personalidade com esse nome.",
        personalityInvalid = "Digite um nome de personalidade válido.",
        cannotChangeDefaultPersonality = "A personalidade Padrão não pode ser renomeada ou excluída.",
        personalityLoaded = "Personalidade carregada.",
        personalityCreated = "Personalidade criada a partir da personalidade ativa.",
        personalityRenamed = "Personalidade renomeada.",
        personalityDeleted = "Personalidade excluída.",
        deletePersonalityConfirm = "Excluir a personalidade '%s' e todas as suas frases? Isso não pode ser desfeito.",
        categorySettingsTitle = "Configurações de Personalidade e Categoria",
        tutorialBtn = "Tutorial",
        tutorialTooltip = "Exibe novamente o tutorial de boas-vindas.",
        tutorialTitle = "Bem-vindo ao RandomDialogRP",
        tutorialVersionUnavailable = "Não foi possível ler a versão do addon; atualizações principais do tutorial não podem ser detectadas.",
        tutorialBody = "|cffffd100Ações rápidas|r\n"
            .. "- Escolha personalidade, raça, classe e canal de bate-papo no painel principal.\n"
            .. "- Clique em uma categoria para enviar uma frase aleatória; nada é enviado automaticamente. Passe o mouse sobre o botão para ver a quantidade de frases.\n"
            .. "- Sussurrar requer um jogador como alvo. O emote escolhido para a frase é executado ao enviá-la.\n\n"
            .. "|cffffd100Combinações de raça e classe|r\n"
            .. "- Exemplo: Default > Saudações > Human > Nenhuma usa frases da raça Human.\n"
            .. "- Default > Saudações > Human > Mago pode usar frases de Mago ou de Human. Se houver ambas, a chance é de 80% para classe e 20% para raça.\n"
            .. "- Frases de classe são compartilhadas entre raças. Sem frases de classe, são usadas as frases da raça.\n\n"
            .. "|cffffd100Criar e editar frases|r\n"
            .. "- Abra Configurações > Frases para adicionar, editar, buscar ou excluir frases de uma personalidade e categoria. As seleções de raça e classe do editor são independentes do painel principal.\n"
            .. "- Use %s para o nome do alvo: \"Olá, %s!\" vira \"Olá, Lysa!\" ao selecionar Lysa, ou \"Olá, friend!\" sem alvo.\n"
            .. "- Use o seletor de emote ao lado da frase para escolher um emote ou Sem emote.\n\n"
            .. "|cffffd100Configurações e perfis|r\n"
            .. "- Gerencie personalidades, categorias, ícones, idioma e perfis em Configurações. Cada perfil tem suas próprias personalidades e coleções de frases.\n"
            .. "- Use o botão Tutorial para abrir este guia novamente.\n\n"
            .. "|cffffd100Comandos|r\n"
            .. "- /rp: exibir ou ocultar o painel principal.\n"
            .. "- /rp config: abrir o gerenciador de frases.\n"
            .. "- /rp minimap: exibir o botão do minimapa se estiver oculto nas Configurações.",
        tutorialCloseBtn = "Entendi",
        profileTitle = "Perfis",
        currentProfile = "Perfil atual:",
        profileSelect = "Selecione o perfil para carregar ou gerenciar:",
        profileName = "Nome do perfil",
        createProfileBtn = "Criar",
        saveProfileBtn = "Salvar",
        loadProfileBtn = "Carregar",
        renameProfileBtn = "Renomear",
        deleteProfileBtn = "Excluir",
        defaultProfile = "Padrão",
        profileExists = "Já existe um perfil com esse nome.",
        profileInvalid = "Digite um nome de perfil válido.",
        cannotChangeDefault = "O perfil Padrão não pode ser renomeado ou excluído.",
        profileSaved = "Perfil salvo.",
        profileLoaded = "Perfil carregado.",
        profileCreated = "Perfil criado.",
        profileRenamed = "Perfil renomeado.",
        profileDeleted = "Perfil excluído.",
        deleteProfileConfirm = "Excluir o perfil '%s'? Isso não pode ser desfeito."
    }
}

-- Active locale lookup helper (defaults strictly to enUS)
function L(key)
    local lang = (RandomDialogRPDB and RandomDialogRPDB.language) or "enUS"
    if RandomDialogRP_Locales[lang] and RandomDialogRP_Locales[lang][key] then
        return RandomDialogRP_Locales[lang][key]
    end
    return RandomDialogRP_Locales["enUS"][key] or key
end