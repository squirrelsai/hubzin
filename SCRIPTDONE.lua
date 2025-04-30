local HttpService = game:GetService("HttpService")

-- Substitua pelo link do seu Pastebin contendo as chaves válidas
local pastebinURL = "https://pastebin.com/t6XaYbhW"

-- Função para verificar se a chave está na lista
local function verificarChave(chaveInserida)
    local sucesso, resposta = pcall(function()
        return HttpService:GetAsync(pastebinURL)
    end)

    if sucesso then
        local chaves = string.split(resposta, "\n")
        for _, chave in pairs(chaves) do
            if chaveInserida == chave then
                return true
            end
        end
    end
    return false
end

-- Carregar o Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Criar a janela principal
local Janela = Rayfield:CreateWindow({
    Name = "Sistema de Key",
    LoadingTitle = "Verificando...",
    LoadingSubtitle = "Aguardando chave válida",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Rayfield",
        FileName = "Config"
    },
})

-- Criar a aba de ativação
local Aba = Janela:CreateTab("Ativação")

-- Campo de texto para inserção da chave
local entradaChave = Aba:CreateTextbox({
    Name = "Digite sua chave",
    PlaceholderText = "Ex: ABC123",
    TextDisappear = true,
})

-- Botão para validar a chave
Aba:CreateButton({
    Name = "Validar Chave",
    Callback = function()
        local chave = entradaChave.Text
        if verificarChave(chave) then
            Rayfield:Notify("Sucesso", "Chave válida! Carregando script premium...", 3)
            
            -- SOMENTE AQUI carregamos o script premium!
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/refs/heads/main/BlockSpin%20Premium"))()
        else
            Rayfield:Notify("Erro", "Chave inválida!", 3)
        end
    end,
})
