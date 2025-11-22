-- Yall-Menu V1.0 - The Only Menu You Need in 2025
-- Inf Jump + WalkSpeed + Grounded Noclip (Walls Only)
-- Toggle GUI: Insert | Made for Delta / loadstring / GitHub

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Vars
local infJump = false
local jumpPower = 50
local speedHack = false
local walkSpeed = 16
local noclipping = false

local jumpConnection, jumpSetConnection
local walkSetConnection
local noclipConnection

-- Yall-Menu GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YallMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 24, 1, 24)
Shadow.Position = UDim2.new(0, -12, 0, -12)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "Yall-Menu"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "the only menu you'll ever need"
SubTitle.TextColor3 = Color3.fromRGB(100, 255, 255)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14
SubTitle.Parent = MainFrame

-- Inf Jump
local JumpToggle = Instance.new("TextButton")
JumpToggle.Size = UDim2.new(0, 140, 0, 45)
JumpToggle.Position = UDim2.new(0, 15, 0, 80)
JumpToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
JumpToggle.Text = "INF JUMP: OFF"
JumpToggle.TextColor3 = Color3.new(1,1,1)
JumpToggle.Font = Enum.Font.GothamBold
JumpToggle.TextSize = 14
JumpToggle.Parent = MainFrame
Instance.new("UICorner", JumpToggle).CornerRadius = UDim.new(0, 10)

local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.new(0, 140, 0, 35)
JumpBox.Position = UDim2.new(0, 15, 0, 135)
JumpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
JumpBox.Text = "50"
JumpBox.TextColor3 = Color3.new(1,1,1)
JumpBox.Font = Enum.Font.Gotham
JumpBox.PlaceholderText = "Jump Power"
JumpBox.Parent = MainFrame
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0, 8)

-- WalkSpeed
local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 140, 0, 45)
SpeedToggle.Position = UDim2.new(0, 165, 0, 80)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SpeedToggle.Text = "SPEED: OFF"
SpeedToggle.TextColor3 = Color3.new(1,1,1)
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.TextSize = 14
SpeedToggle.Parent = MainFrame
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(0, 10)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 140, 0, 35)
SpeedBox.Position = UDim2.new(0, 165, 0, 135)
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedBox.Text = "16"
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.PlaceholderText = "Walk Speed"
SpeedBox.Parent = MainFrame
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 8)

-- Noclip (Walls Only)
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0, 290, 0, 50)
NoclipToggle.Position = UDim2.new(0, 15, 0, 190)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
NoclipToggle.Text = "NOCLIP (Walls Only): OFF"
NoclipToggle.TextColor3 = Color3.new(1,1,1)
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 15
NoclipToggle.Parent = MainFrame
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0, 12)

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.Parent = MainFrame

-- Core Functions
local function getHum() 
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function applyJump()
    local h = getHum()
    if h then h.UseJumpPower = true h.JumpPower = jumpPower end
end

local function applySpeed()
    local h = getHum()
    if h then h.WalkSpeed = walkSpeed end
end

-- Inf Jump
JumpToggle.MouseButton1Click:Connect(function()
    infJump = not infJump
    if infJump then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local h = getHum()
            if h then h:ChangeState("Jumping") end
        end)
        jumpSetConnection = RunService.Heartbeat:Connect(applyJump)
        applyJump()
        JumpToggle.Text = "INF JUMP: ON"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    else
        if jumpConnection then jumpConnection:Disconnect() end
        if jumpSetConnection then jumpSetConnection:Disconnect() end
        JumpToggle.Text = "INF JUMP: OFF"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

JumpBox.FocusLost:Connect(function()
    local n = tonumber(JumpBox.Text)
    if n and n >= 0 and n <= 300 then
        jumpPower = n
        JumpBox.Text = tostring(n)
    else
        JumpBox.Text = tostring(jumpPower)
    end
end)

-- Speed
SpeedToggle.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    if speedHack then
        walkSetConnection = RunService.Heartbeat:Connect(applySpeed)
        applySpeed()
        SpeedToggle.Text = "SPEED: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    else
        if walkSetConnection then walkSetConnection:Disconnect() end
        SpeedToggle.Text = "SPEED: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

SpeedBox.FocusLost:Connect(function()
    local n = tonumber(SpeedBox.Text)
    if n and n >= 0 and n <= 200 then
        walkSpeed = n
        SpeedBox.Text = tostring(n)
    else
        SpeedBox.Text = tostring(walkSpeed)
    end
end)

-- Noclip (Walls Only - No Fall)
NoclipToggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    if noclipping then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            local root = getRoot()
            local hum = getHum()
            if root and hum and hum.FloorMaterial ~= Enum.Material.Air then
                root.CanCollide = true
            end
        end)
        NoclipToggle.Text = "NOCLIP (Walls Only): ON"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        NoclipToggle.Text = "NOCLIP (Walls Only): OFF"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- GUI Hide/Show
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

player.CharacterAdded:Connect(function() task.wait(1.5) end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu Loaded";
    Text = "Press Insert to toggle • Go crazy king";
    Duration = 6;
})

print("Yall-Menu V1.0 Loaded - we back baby")
