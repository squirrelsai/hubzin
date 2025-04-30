local HttpService = game:GetService("HttpService")

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/refs/heads/main/BlockSpin%20Premium"))()

-- Substitua pelo link do seu pastebin
local pastebinURL = "https://pastebin.com/t6XaYbhW"

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

-- Interface com Rayfield
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
			Rayfield:Notify("Sucesso", "Chave válida! Acesso liberado.", 3)
			-- Aqui você pode carregar o conteúdo premium
		else
			Rayfield:Notify("Erro", "Chave inválida!", 3)
		end
	end,
})