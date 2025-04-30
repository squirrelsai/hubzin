-- Serviços
local HttpService = game:GetService("HttpService")

-- Link do Pastebin com chaves válidas (sem raw)
local pastebinURL = "https://pastebin.com/raw/t6XaYbhW"

-- OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Verificar chave
local function verificarChave(chave)
	local sucesso, resposta = pcall(function()
		return HttpService:GetAsync(pastebinURL)
	end)
	
	if sucesso then
		local chaves = string.split(resposta, "\n")
		for _, v in ipairs(chaves) do
			if chave == v then
				return true
			end
		end
	end
	
	return false
end

-- Janela principal
local Window = OrionLib:MakeWindow({Name = "Sistema de Key", HidePremium = false, SaveConfig = false, IntroText = "Verificação de Chave"})

-- Aba
local Tab = Window:MakeTab({
	Name = "Ativação",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variável para armazenar o input
local chaveDigitada = ""

-- Caixa de texto
Tab:AddTextbox({
	Name = "Digite sua chave",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chaveDigitada = Value
	end	  
})

-- Botão de validação
Tab:AddButton({
	Name = "Validar Chave",
	Callback = function()
		if verificarChave(chaveDigitada) then
			OrionLib:MakeNotification({
				Name = "Sucesso",
				Content = "Chave válida! Carregando script premium...",
				Time = 3
			})
			loadstring(game:HttpGet("https://raw.githubusercontent.com/NeymarScripts/BlockSpin-Script-Premium-/main/BlockSpin%20Premium"))()
		else
			OrionLib:MakeNotification({
				Name = "Erro",
				Content = "Chave inválida!",
				Time = 3
			})
		end
	end
})