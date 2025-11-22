-- Yall-Menu v2.2 - Toggle Button + Draggable + Everything Fixed
-- Press "RightShift" to open/close the menu anytime

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Variables
local infJump = false
local jumpPower = 50
local speedHack = false
local walkSpeed = 16
local noclipping = false
local flying = false
local flySpeed = 100
local menuOpen = true

local connections = {}

-- === MAIN GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YallMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true  -- DRAGGABLE
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Shadow
local shadow = Instance.new("ImageLabel", MainFrame)
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = -1

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,55)
Title.BackgroundTransparency = 1
Title.Text = "Yall-Menu"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26

local Sub = Instance.new("TextLabel", MainFrame)
Sub.Position = UDim2.new(0,0,0,50)
Sub.Size = UDim2.new(1,0,0,20)
Sub.BackgroundTransparency = 1
Sub.Text = "v2.2 - Toggle: RightShift"
Sub.TextColor3 = Color3.fromRGB(100,255,255)
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 14

-- === TOGGLE BUTTON (Always visible) ===
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Text = ">>"
ToggleBtn.TextColor3 = Color3.new(0,0,0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Draggable = true

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)

-- === ALL BUTTONS (Same layout as before) ===
local JumpToggle = Instance.new("TextButton", MainFrame)
JumpToggle.Size = UDim2.new(0,140,0,45); JumpToggle.Position = UDim2.new(0,15,0,80)
JumpToggle.Text = "INF JUMP: OFF"; JumpToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", JumpToggle).CornerRadius = UDim.new(0,10)

local JumpBox = Instance.new("TextBox", MainFrame)
JumpBox.Size = UDim2.new(0,140,0,35); JumpBox.Position = UDim2.new(0,15,0,135)
JumpBox.Text = "50"; JumpBox.PlaceholderText = "Jump Power"
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0,8)

local SpeedToggle = Instance.new("TextButton", MainFrame)
SpeedToggle.Size = UDim2.new(0,140,0,45); SpeedToggle.Position = UDim2.new(0,165,0,80)
SpeedToggle.Text = "SPEED: OFF"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(0,10)

local SpeedBox = Instance.new("TextBox", MainFrame)
SpeedBox.Size = UDim2.new(0,140,0,35); SpeedBox.Position = UDim2.new(0,165,0,135)
SpeedBox.Text = "16"; SpeedBox.PlaceholderText = "Walk Speed"
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,8)

local NoclipToggle = Instance.new("TextButton", MainFrame)
NoclipToggle.Size = UDim2.new(0,290,0,50); NoclipToggle.Position = UDim2.new(0,15,0,190)
NoclipToggle.Text = "NOCLIP (Walls Only): OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0,12)

local FlyToggle = Instance.new("TextButton", MainFrame)
FlyToggle.Size = UDim2.new(0,140,0,45); FlyToggle.Position = UDim2.new(0,15,0,255)
FlyToggle.Text = "FLY: OFF"; FlyToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0,10)

local FlyBox = Instance.new("TextBox", MainFrame)
FlyBox.Size = UDim2.new(0,140,0,35); FlyBox.Position = UDim2.new(0,165,0,255)
FlyBox.Text = "100"; FlyBox.PlaceholderText = "Fly Speed"
Instance.new("UICorner", FlyBox).CornerRadius = UDim.new(0,8)

-- Close X
local CloseX = Instance.new("TextButton", MainFrame)
CloseX.Size = UDim2.new(0,35,0,35); CloseX.Position = UDim2.new(1,-45,0,10)
CloseX.BackgroundTransparency = 1; CloseX.Text = "X"; CloseX.TextColor3 = Color3.fromRGB(255,80,80)
CloseX.Font = Enum.Font.GothamBold; CloseX.TextSize = 20

-- === TOGGLE LOGIC ===
local function toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    ToggleBtn.Text = menuOpen and "<<" or ">>"
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
CloseX.MouseButton1Click:Connect(function() MainFrame.Visible = false; ToggleBtn.Text = ">>"; menuOpen = false end)

-- RightShift to toggle (backup key)
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- === FEATURES (Same working code as v2.1) ===
-- (Inf Jump, Speed, Noclip, Fly - all fully functional, copy-paste from previous fixed version)

-- Helper
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

-- Inf Jump
JumpToggle.MouseButton1Click:Connect(function()
    infJump = not infJump
    if infJump then
        connections.jump = UserInputService.JumpRequest:Connect(function()
            local h = getHum(); if h then h:ChangeState("Jumping") end
        end)
        connections.jumpSet = RunService.Heartbeat:Connect(function()
            local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = jumpPower end
        end)
        JumpToggle.Text = "INF JUMP: ON"; JumpToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.jump then connections.jump:Disconnect() end
        if connections.jumpSet then connections.jumpSet:Disconnect() end
        JumpToggle.Text = "INF JUMP: OFF"; JumpToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
JumpBox.FocusLost:Connect(function() local n = tonumber(JumpBox.Text); if n and n >= 0 and n <= 300 then jumpPower = n end JumpBox.Text = jumpPower end)

-- Speed
SpeedToggle.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    if speedHack then
        connections.speed = RunService.Heartbeat:Connect(function()
            local h = getHum(); if h then h.WalkSpeed = walkSpeed end
        end)
        SpeedToggle.Text = "SPEED: ON"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.speed then connections.speed:Disconnect() end
        SpeedToggle.Text = "SPEED: OFF"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
SpeedBox.FocusLost:Connect(function() local n = tonumber(SpeedBox.Text); if n and n >= 0 and n <= 200 then walkSpeed = n end SpeedBox.Text = walkSpeed end)

-- Noclip
NoclipToggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    if noclipping then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(getChar():GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
            local root = getRoot(); local hum = getHum()
            if root and hum and hum.FloorMaterial ~= Enum.Material.Air then root.CanCollide = true end
        end)
        NoclipToggle.Text = "NOCLIP (Walls Only): ON"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.noclip then connections.noclip:Disconnect() end
        NoclipToggle.Text = "NOCLIP (Walls Only): OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)

-- Fly
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        local root = getRoot()
        local att0 = Instance.new("Attachment", root)
        local att1 = Instance.new("Attachment", root)

        local ap = Instance.new("AlignPosition", root); ap.Attachment0 = att0; ap.Attachment1 = att1; ap.MaxForce = 99999; ap.MaxVelocity = flySpeed; ap.Responsiveness = 200
        local ao = Instance.new("AlignOrientation", root); ao.Attachment0 = att0; ao.Attachment1 = att1; ao.MaxTorque = 99999; ao.Responsiveness = 200

        connections.fly = RunService.Heartbeat:Connect(function()
            ao.CFrame = camera.CFrame
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
            att1.Position = move.Unit * (flySpeed/10)
        end)
        FlyToggle.Text = "FLY: ON"; FlyToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        for _, obj in pairs(getRoot():GetChildren()) do
            if obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") or obj:IsA("Attachment") then obj:Destroy() end
        end
        if connections.fly then connections.fly:Disconnect() end
        FlyToggle.Text = "FLY: OFF"; FlyToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
FlyBox.FocusLost:Connect(function() local n = tonumber(FlyBox.Text); if n and n > 0 and n <= 500 then flySpeed = n end FlyBox.Text = flySpeed end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu v2.2 Loaded";
    Text = "Toggle: RightShift or cyan button • Drag anywhere • We never left";
    Duration = 7;
})

print("Yall-Menu v2.2 with Toggle Button & Draggable - READY")
