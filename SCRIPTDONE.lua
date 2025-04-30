local HttpService = game:GetService("HttpService")

-- Carregar Rayfield (interface)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Link do Pastebin com as chaves válidas
local pastebinURL = "https://pastebin.com/t6XaYbhW" -- Substitua aqui

-- Função para verificar a chave
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

-- Criar GUI com Rayfield
local Window = Rayfield:CreateWindow({
	Name = "Sistema de Key",
	LoadingTitle = "Validando...",
	LoadingSubtitle = "Verificação de chave",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Rayfield",
		FileName = "Config"
	},
})

local Tab = Window:CreateTab("Ativação")

local keyInput = Tab:CreateTextbox({
	Name = "Digite sua chave",
	PlaceholderText = "Ex: ABC123",
	TextDisappear = true,
})

Tab:CreateButton({
	Name = "Validar Chave",
	Callback = function()
		local chave = keyInput.Text
		if verificarChave(chave) then
			Rayfield:Notify("Sucesso", "Chave válida! Carregando script premium...", 3)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/main/BlockSpin%20Premium"))()
		else
			Rayfield:Notify("Erro", "Chave inválida!", 3)
		end
	end,
})

-- Forçar a exibição da interface
Window:Render() -- Tente adicionar isso