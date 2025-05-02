-- LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Toggle
local showESP = false

-- Guardar adornos por jogador
local espBoxes = {}

-- Criar caixa ESP para o jogador
local function createESPBox(player)
    if player == localPlayer then return end

    local function onCharacterAdded(character)
        local root = character:WaitForChild("HumanoidRootPart")

        -- Verifica se já tem um Box existente e remove
        if espBoxes[player] then
            espBoxes[player]:Destroy()
        end

        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = root
        box.Size = Vector3.new(4, 6, 2)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 0
        box.Visible = showESP
        box.Parent = game:GetService("CoreGui") -- Para garantir que fique visível

        espBoxes[player] = box
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Atualização constante da visibilidade
RunService.RenderStepped:Connect(function()
    for player, box in pairs(espBoxes) do
        if box and box.Parent then
            box.Visible = showESP
        end
    end
end)

-- Criar caixas para todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    createESPBox(player)
end

Players.PlayerAdded:Connect(createESPBox)

-- Toggle com tecla E
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then
        showESP = not showESP
        print("Caixa ESP:", showESP and "Ligado" or "Desligado")
    end
end)
