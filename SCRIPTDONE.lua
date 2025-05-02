local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

-- === Variáveis de controle ===
local ESPEnabled = true
local showName = true
local showDistance = true
local showTracers = true
local showBox = true
local rainbowMode = false
local colorByTeam = true

local function getRainbowColor(offset)
	local hue = (tick() * 0.5 + offset) % 1
	return Color3.fromHSV(hue, 1, 1)
end

local function createWireBox(player, root)
	local corners = {
		Vector3.new(2, 3, 1),   Vector3.new(-2, 3, 1),
		Vector3.new(2, -3, 1),  Vector3.new(-2, -3, 1),
		Vector3.new(2, 3, -1),  Vector3.new(-2, 3, -1),
		Vector3.new(2, -3, -1), Vector3.new(-2, -3, -1)
	}
	local edges = {
		{1, 2}, {1, 3}, {2, 4}, {3, 4},
		{5, 6}, {5, 7}, {6, 8}, {7, 8},
		{1, 5}, {2, 6}, {3, 7}, {4, 8}
	}
	local attachments = {}
	for i, offset in ipairs(corners) do
		local a = Instance.new("Attachment")
		a.Position = offset
		a.Name = "WirePoint"
		a.Parent = root
		attachments[i] = a
	end
	for i, pair in ipairs(edges) do
		local line = Instance.new("LineHandleAdornment")
		line.Attachment0 = attachments[pair[1]]
		line.Attachment1 = attachments[pair[2]]
		line.Thickness = 0.1
		line.Transparency = 0
		line.AlwaysOnTop = true
		line.ZIndex = 1
		line.Name = "ESPWire"
		line.Parent = game:GetService("CoreGui")

		if rainbowMode then
			RunService.RenderStepped:Connect(function()
				if line and line.Parent then
					line.Color3 = getRainbowColor(i)
				end
			end)
		elseif colorByTeam and player.Team then
			line.Color3 = player.TeamColor.Color
		else
			line.Color3 = Color3.fromRGB(255, 0, 0)
		end
	end
end

local function createESP(player)
	player.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
		char:WaitForChild("Humanoid")

		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		if showBox then createWireBox(player, root) end
	end)
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= localPlayer then
		createESP(p)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= localPlayer then
		createESP(p)
	end
end)

-- === GUI estilo Orion ===
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ESPMenu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 330)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Abas
local visualTabBtn = Instance.new("TextButton", mainFrame)
visualTabBtn.Size = UDim2.new(0.5, 0, 0, 25)
visualTabBtn.Position = UDim2.new(0, 0, 0, 30)
visualTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
visualTabBtn.Text = "Visual"
visualTabBtn.TextColor3 = Color3.new(1, 1, 1)
visualTabBtn.Font = Enum.Font.SourceSans
visualTabBtn.TextScaled = true

local miscTabBtn = visualTabBtn:Clone()
miscTabBtn.Text = "Misc"
miscTabBtn.Position = UDim2.new(0.5, 0, 0, 30)
miscTabBtn.Parent = mainFrame

-- Conteúdo das abas
local visualTab = Instance.new("Frame", mainFrame)
visualTab.Size = UDim2.new(1, 0, 1, -60)
visualTab.Position = UDim2.new(0, 0, 0, 60)
visualTab.BackgroundTransparency = 1

local miscTab = visualTab:Clone()
miscTab.Visible = false
miscTab.Parent = mainFrame

visualTabBtn.MouseButton1Click:Connect(function()
	visualTab.Visible = true
	miscTab.Visible = false
end)
miscTabBtn.MouseButton1Click:Connect(function()
	visualTab.Visible = false
	miscTab.Visible = true
end)

-- === Criador de toggles simples ===
local function createToggle(name, yPos, defaultState, callback, parent)
	local state = defaultState
	local button = Instance.new("TextButton", parent)
	button.Size = UDim2.new(1, -20, 0, 30)
	button.Position = UDim2.new(0, 10, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextScaled = true
	button.Text = name .. ": " .. (state and "ON" or "OFF")

	callback(state)

	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = name .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

-- === Visual Toggles ===
createToggle("ESP Geral",     0,   true,  function(v) ESPEnabled = v end, visualTab)
createToggle("Nome",          40,  true,  function(v) showName = v end, visualTab)
createToggle("Distância",     80,  true,  function(v) showDistance = v end, visualTab)
createToggle("Tracers",       120, true,  function(v) showTracers = v end, visualTab)
createToggle("Box",           160, true,  function(v) showBox = v end, visualTab)
createToggle("Modo Arco-Íris",200, false, function(v) rainbowMode = v end, visualTab)
createToggle("Cor por Time",  240, true,  function(v) colorByTeam = v end, visualTab)

-- === Misc Toggle ===
createToggle("Exemplo OFF", 0, false, function(v) print("Misc OFF", v) end, miscTab)
