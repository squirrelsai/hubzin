local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Toggles
local ESPEnabled = true
local showName = true
local showDistance = true
local showTracers = true
local showBox = true

-- UI Setup
local gui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
gui.Name = "OrionESPUI"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0, 10, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ESP MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Function to create toggle buttons
local function createToggle(name, yPos, defaultState, callback)
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(1, -20, 0, 30)
	button.Position = UDim2.new(0, 10, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextScaled = true

	local state = defaultState
	button.Text = name .. ": ON"

	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = name .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)

	return state
end

-- Create toggles
createToggle("ESP Geral", 40, true, function(state) ESPEnabled = state end)
createToggle("Nome", 80, true, function(state) showName = state end)
createToggle("Distância", 120, true, function(state) showDistance = state end)
createToggle("Tracers", 160, true, function(state) showTracers = state end)
createToggle("Box", 200, true, function(state) showBox = state end)

-- ESP elements
local function createESP(player)
	if player == localPlayer then return end

	local function onCharacterAdded(character)
		local head = character:WaitForChild("Head")
		local root = character:WaitForChild("HumanoidRootPart")

		-- BillboardGui
		local espGui = Instance.new("BillboardGui")
		espGui.Name = "ESPDisplay"
		espGui.Adornee = head
		espGui.Size = UDim2.new(0, 100, 0, 40)
		espGui.StudsOffset = Vector3.new(0, 2, 0)
		espGui.AlwaysOnTop = true
		espGui.Parent = head

		local nameLabel = Instance.new("TextLabel", espGui)
		nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.SourceSansBold

		local distLabel = nameLabel:Clone()
		distLabel.Position = UDim2.new(0, 0, 0.5, 0)
		distLabel.Text = ""
		distLabel.Parent = espGui

		-- Box ESP
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = root
		box.Size = Vector3.new(4, 6, 2)
		box.Color3 = Color3.fromRGB(255, 0, 0)
		box.Transparency = 0.5
		box.AlwaysOnTop = true
		box.ZIndex = 0
		box.Name = "ESPBox"
		box.Parent = game:GetService("CoreGui")

		-- Tracer
		local tracerLine = Instance.new("Frame", gui)
		tracerLine.Size = UDim2.new(0, 2, 0, 200)
		tracerLine.BackgroundColor3 = Color3.new(1, 0, 0)
		tracerLine.BorderSizePixel = 0
		tracerLine.Visible = false
		tracerLine.AnchorPoint = Vector2.new(0.5, 0)

		RunService.RenderStepped:Connect(function()
			if not character or not character.Parent then return end

			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			-- Labels
			nameLabel.Visible = ESPEnabled and showName and onScreen
			distLabel.Visible = ESPEnabled and showDistance and onScreen
			box.Visible = ESPEnabled and showBox

			if showDistance then
				local dist = (root.Position - Camera.CFrame.Position).Magnitude
				distLabel.Text = string.format("%.1f studs", dist)
			end

			-- Tracer logic
			if ESPEnabled and showTracers and onScreen then
				tracerLine.Visible = true
				tracerLine.Position = UDim2.new(0, Camera.ViewportSize.X / 2, 0, Camera.ViewportSize.Y - 10)
				local height = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 10)).Magnitude
				tracerLine.Size = UDim2.new(0, 2, 0, height)
				tracerLine.Rotation = math.deg(math.atan2(pos.Y - (Camera.ViewportSize.Y - 10), pos.X - (Camera.ViewportSize.X / 2)))
			else
				tracerLine.Visible = false
			end
		end)
	end

	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end

-- Aplicar para todos os jogadores
for _, p in ipairs(Players:GetPlayers()) do
	createESP(p)
end
Players.PlayerAdded:Connect(createESP)
