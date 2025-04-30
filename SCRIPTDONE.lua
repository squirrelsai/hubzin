local HttpService = game:GetService("HttpService")

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/refs/heads/main/BlockSpin%20Premium"))()

local pastebinURL = "https://pastebin.com/raw/SEU_CODIGO" -- Substitua aqui com seu raw link

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
			
			-- SOMENTE AQUI carregamos o script premium!
			loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/refs/heads/main/BlockSpin%20Premium"))()
		else
			Rayfield:Notify("Erro", "Chave inválida!", 3)
		end
	end,
})
