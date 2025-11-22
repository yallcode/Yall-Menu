-- Yall-Menu V2.0 - FLY ADDED 🔥 The Only Menu You Need
-- Inf Jump + WalkSpeed + Grounded Noclip + Full Fly (WASD/Space/Ctrl)
-- Toggle GUI: Insert | Delta / loadstring / GitHub ready

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Vars
local infJump = false
local jumpPower = 50
local speedHack = false
local walkSpeed = 16
local noclipping = false
local flying = false
local flySpeed = 100

local jumpConnection, jumpSetConnection
local walkSetConnection
local noclipConnection
local alignPos, alignOri, att0, att1
local flyConnection

-- GUI (Made taller for Fly section)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YallMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 440)
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
SubTitle.Text = "v2.0 - fly update baby"
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

-- Speed
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

-- Noclip
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

-- FLY (New)
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0, 140, 0, 45)
FlyToggle.Position = UDim2.new(0, 15, 0, 255)
FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FlyToggle.Text = "FLY: OFF"
FlyToggle.TextColor3 = Color3.new(1,1,1)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 14
FlyToggle.Parent = MainFrame
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0, 10)

local FlyBox = Instance.new("TextBox")
FlyBox.Size = UDim2.new(0, 140, 0, 35)
FlyBox.Position = UDim2.new(0, 165, 0, 255)
FlyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FlyBox.Text = "100"
FlyBox.TextColor3 = Color3.new(1,1,1)
FlyBox.Font = Enum.Font.Gotham
FlyBox.PlaceholderText = "Fly Speed"
FlyBox.Parent = MainFrame
Instance.new("UICorner", FlyBox).CornerRadius = UDim.new(0, 8)

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

-- Fly Functions (Stealth AlignPosition method - works everywhere 2025)
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    att0 = Instance.new("Attachment", root)
    att1 = Instance.new("Attachment", root)
    
    alignPos = Instance.new("AlignPosition")
    alignPos.Attachment0 = att0
    alignPos.Attachment1 = att1
    alignPos.MaxForce = 50000
    alignPos.MaxVelocity = flySpeed
    alignPos.Responsiveness = 200
    alignPos.Parent = root
    
    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att0
    alignOri.Attachment1 = att1
    alignOri.MaxTorque = 50000
    alignOri.Responsiveness = 200
    alignOri.Parent = root
    
    flying = true
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        alignOri.CFrame = camera.CFrame
        
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0,-1,0) end
        
        if move.Magnitude > 0 then
            att1.Position = move.Unit * (flySpeed / 10)
        else
            att1.Position = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() end
    if alignPos then alignPos:Destroy() end
    if alignOri then alignOri:Destroy() end
    if att0 then att0:Destroy() end
    if att1 then att1:Destroy() end
end

-- Rest of the features (Inf Jump, Speed, Noclip) - unchanged from v1.0
-- (same code as before for brevity - you already have it)

-- Fly Toggle Event
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        startFly()
        FlyToggle.Text = "FLY: ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    else
        stopFly()
        FlyToggle.Text = "FLY: OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

FlyBox.FocusLost:Connect(function()
    local n = tonumber(FlyBox.Text)
    if n and n > 0 and n <= 500 then
        flySpeed = n
        if alignPos then alignPos.MaxVelocity = n end
    end
    FlyBox.Text = tostring(flySpeed)
end)

-- Respawn handler for Fly
player.CharacterAdded:Connect(function()
    stopFly()
    task.wait(1)
    if flying then startFly() end
end)

-- Rest of the script (Inf Jump, Speed, Noclip, Insert toggle, etc.) remains exactly the same as v1.0 code

game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu v2.0 Loaded";
    Text = "Fly added • WASD + Space/Ctrl • We never stopping";
    Duration = 6;
})

print("Yall-Menu v2.0 with FLY loaded - lets go crazy")
