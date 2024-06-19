-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

-- Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.167168677, 0, 0.421836227, 0)
Frame.Size = UDim2.new(0, 442, 0, 370)
Frame.Active = true
Frame.Draggable = true
UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.27375567, 0, 0.400000006, 0)
TextButton.Rotation = -0.040
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Start Clover Farm"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

UICorner_2.Parent = TextButton

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.27375567, 0, 0.202702701, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Clover Farm"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true


local f = "clova"
local tf = game.Workspace:FindFirstChild(f)
local isTeleporting = false

local function teleportModelToPlayer(model)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        local primaryPart = model.PrimaryPart
        if primaryPart then
            model:SetPrimaryPartCFrame(humanoidRootPart.CFrame + Vector3.new(0, 0, 0))
        end
    end
end

local function tp()
    while isTeleporting and tf do
        for _, model in pairs(tf:GetChildren()) do
            if not isTeleporting then break end
            if model:IsA("Model") and model.PrimaryPart then
                teleportModelToPlayer(model)
                wait()
            end
        end
    end
end


local function onButtonClicked()
    if isTeleporting then
        isTeleporting = false
        TextButton.Text = "Start Clover Farm"
    else
        isTeleporting = true
        TextButton.Text = "Stop Clover Farm"
        coroutine.wrap(tp)()
    end
end

TextButton.MouseButton1Click:Connect(onButtonClicked)
