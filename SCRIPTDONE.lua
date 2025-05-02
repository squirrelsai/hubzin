local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

-- Configurações de visibilidade
local showName = true
local showDistance = true
local showTracer = true

-- Criação do menu
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ESPMenu"

local function createToggleButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = position
    button.Text = name .. ": ON"
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Parent = screenGui

    local state = true
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- Criação dos botões
createToggleButton("Nome", UDim2.new(0, 10, 0, 10), function(state)
    showName = state
end)

createToggleButton("Distância", UDim2.new(0, 10, 0, 60), function(state)
    showDistance = state
end)

createToggleButton("Tracer", UDim2.new(0, 10, 0, 110), function(state)
    showTracer = state
end)

-- ESP
local function createESP(player)
    if player == localPlayer then return end

    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head")
        local root = character:WaitForChild("HumanoidRootPart")

        local espGui = Instance.new("BillboardGui")
        espGui.Name = "ESP"
        espGui.Adornee = head
        espGui.Size = UDim2.new(0, 100, 0, 40)
        espGui.StudsOffset = Vector3.new(0, 2, 0)
        espGui.AlwaysOnTop = true
        espGui.Parent = head

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextScaled = true
        nameLabel.Parent = espGui

        local distanceLabel = nameLabel:Clone()
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.Text = ""
        distanceLabel.Parent = espGui

        -- Tracer (UI)
        local tracer = Instance.new("Frame")
        tracer.Size = UDim2.new(0, 2, 0, 200)
        tracer.AnchorPoint = Vector2.new(0.5, 0)
        tracer.BackgroundColor3 = Color3.new(1, 0, 0)
        tracer.BorderSizePixel = 0
        tracer.Visible = false
        tracer.Parent = screenGui

        RunService.RenderStepped:Connect(function()
            if not root or not root:IsDescendantOf(workspace) then return end

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                if showName then
                    nameLabel.Visible = true
                else
                    nameLabel.Visible = false
                end

                if showDistance then
                    distanceLabel.Visible = true
                    local dist = (root.Position - Camera.CFrame.Position).Magnitude
                    distanceLabel.Text = string.format("%.1f studs", dist)
                else
                    distanceLabel.Visible = false
                end

                if showTracer then
                    tracer.Visible = true
                    tracer.Position = UDim2.new(0, Camera.ViewportSize.X / 2, 0, Camera.ViewportSize.Y - 5)
                    local tracerHeight = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 5)).Magnitude
                    tracer.Size = UDim2.new(0, 2, 0, tracerHeight)
                    tracer.Rotation = math.deg(math.atan2((pos.Y - (Camera.ViewportSize.Y - 5)), (pos.X - (Camera.ViewportSize.X / 2))))
                else
                    tracer.Visible = false
                end
            else
                nameLabel.Visible = false
                distanceLabel.Visible = false
                tracer.Visible = false
            end
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Aplicar ESP a todos os jogadores
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

-- Novos jogadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)
