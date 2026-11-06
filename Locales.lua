-- Locales.lua
-- Localization table for English (Default) and Portuguese

RandomDialogRP_Locales = {
    enUS = {
        greetings = "Greetings",
        thanks = "Thanks",
        battle = "Battle Shout",
        managerTitle = "RandomDialogRP - Phrase Manager",
        raceLabel = "Race:",
        categoryLabel = "Category:",
        languageLabel = "Language:",
        addBtn = "Add",
        editBtn = "Edit",
        delBtn = "Del",
        saveReloadBtn = "Save & Reload",
        reloadWarning = "Changes require a UI Reload to apply correctly.",
        panelHidden = "Panel hidden.",
        panelShown = "Panel displayed.",
        autoDetected = "Auto-detected race:",
        phraseAdded = "New phrase added!",
        phraseUpdated = "Phrase updated successfully!",
        phraseRemoved = "Phrase removed.",
        noPhrases = "No phrases registered for this category!"
    },
    ptBR = {
        greetings = "Saudações",
        thanks = "Agradecimento",
        battle = "Grito de Guerra",
        managerTitle = "RandomDialogRP - Gerenciador de Frases",
        raceLabel = "Raça:",
        categoryLabel = "Categoria:",
        languageLabel = "Idioma:",
        addBtn = "Adicionar",
        editBtn = "Editar",
        delBtn = "Excluir",
        saveReloadBtn = "Salvar & Recarregar",
        reloadWarning = "Alterações exigem um Reload da UI para serem aplicadas.",
        panelHidden = "Painel ocultado.",
        panelShown = "Painel exibido.",
        autoDetected = "Raça detectada automaticamente:",
        phraseAdded = "Nova frase adicionada!",
        phraseUpdated = "Frase atualizada com sucesso!",
        phraseRemoved = "Frase removida.",
        noPhrases = "Nenhuma frase registrada para esta categoria!"
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