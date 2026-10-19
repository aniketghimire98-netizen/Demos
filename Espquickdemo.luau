local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local espObjects = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerESP_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(250, 155)
main.Position = UDim2.new(0.5, -125, 0.5, -77)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 40)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "PLAYER ESP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -37, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -24, 0, 42)
toggle.Position = UDim2.fromOffset(12, 52)
toggle.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
toggle.Text = "ESP: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.Parent = main

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 30)
status.Position = UDim2.fromOffset(12, 103)
status.BackgroundTransparency = 1
status.Text = "ESP is disabled"
status.TextColor3 = Color3.fromRGB(180, 180, 190)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = main

-- ESP functions
local function removeESP(player)
    local objects = espObjects[player]

    if objects then
        for _, object in ipairs(objects) do
            if object and object.Parent then
                object:Destroy()
            end
        end

        espObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer or not espEnabled then
        return
    end

    removeESP(player)

    local character = player.Character
    if not character then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 65, 65)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character

    local head = character:FindFirstChild("Head")
    local billboard

    if head then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESPName"
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(150, 30)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Text = player.DisplayName
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.2
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.Parent = billboard
    end

    espObjects[player] = {highlight}

    if billboard then
        table.insert(espObjects[player], billboard)
    end
end

local function setESP(enabled)
    espEnabled = enabled

    if espEnabled then
        toggle.Text = "ESP: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(40, 150, 85)
        status.Text = "Player highlights enabled"

        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
    else
        toggle.Text = "ESP: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
        status.Text = "ESP is disabled"

        for player in pairs(espObjects) do
            removeESP(player)
        end
    end
end

toggle.Activated:Connect(function()
    setESP(not espEnabled)
end)

close.Activated:Connect(function()
    setESP(false)
    gui:Destroy()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        createESP(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        createESP(player)
    end)
end
