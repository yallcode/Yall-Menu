-- Yall-Menu v2.3 - Fixed Fly + Teleport Features + Respawn Handling
-- Press "RightShift" to open/close the menu anytime

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

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

-- Helper functions
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

-- Teleport helpers
local function tpToPlayer(target)
    local root = getRoot()
    if not root or not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
end

local function getClosestPlayer()
    local root = getRoot()
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - other.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = other
            end
        end
    end
    return closest
end

local function tpRandomPlayer()
    local others = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(others, p)
        end
    end
    if #others > 0 then
        tpToPlayer(others[math.random(#others)])
    end
end

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
MainFrame.Draggable = true
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
Sub.Text = "v2.3 - Toggle: RightShift • Fly Fixed + Teleports"
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

-- === BUTTONS ===
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
NoclipToggle.Text = "NOCLIP: OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0,12)

local FlyToggle = Instance.new("TextButton", MainFrame)
FlyToggle.Size = UDim2.new(0,140,0,45); FlyToggle.Position = UDim2.new(0,15,0,255)
FlyToggle.Text = "FLY: OFF"; FlyToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0,10)

local FlyBox = Instance.new("TextBox", MainFrame)
FlyBox.Size = UDim2.new(0,140,0,35); FlyBox.Position = UDim2.new(0,165,0,255)
FlyBox.Text = "100"; FlyBox.PlaceholderText = "Fly Speed"
Instance.new("UICorner", FlyBox).CornerRadius = UDim.new(0,8)

-- Teleport Buttons
local TPMouseBtn = Instance.new("TextButton", MainFrame)
TPMouseBtn.Size = UDim2.new(0,140,0,45); TPMouseBtn.Position = UDim2.new(0,15,0,310)
TPMouseBtn.Text = "TP MOUSE"; TPMouseBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
TPMouseBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPMouseBtn.Font = Enum.Font.GothamBold
TPMouseBtn.TextSize = 14
Instance.new("UICorner", TPMouseBtn).CornerRadius = UDim.new(0,10)

local TPNearestBtn = Instance.new("TextButton", MainFrame)
TPNearestBtn.Size = UDim2.new(0,140,0,45); TPNearestBtn.Position = UDim2.new(0,165,0,310)
TPNearestBtn.Text = "TP NEAREST"; TPNearestBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
TPNearestBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPNearestBtn.Font = Enum.Font.GothamBold
TPNearestBtn.TextSize = 14
Instance.new("UICorner", TPNearestBtn).CornerRadius = UDim.new(0,10)

local TPRandomBtn = Instance.new("TextButton", MainFrame)
TPRandomBtn.Size = UDim2.new(0,290,0,45); TPRandomBtn.Position = UDim2.new(0,15,0,365)
TPRandomBtn.Text = "TP RANDOM"; TPRandomBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
TPRandomBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPRandomBtn.Font = Enum.Font.GothamBold
TPRandomBtn.TextSize = 16
Instance.new("UICorner", TPRandomBtn).CornerRadius = UDim.new(0,10)

-- Close X
local CloseX = Instance.new("TextButton", MainFrame)
CloseX.Size = UDim2.new(0,35,0,35); CloseX.Position = UDim2.new(1,-45,0,10)
CloseX.BackgroundTransparency = 1; CloseX.Text = "X"; CloseX.TextColor3 = Color3.fromRGB(255,80,80)
CloseX.Font = Enum.Font.GothamBold; CloseX.TextSize = 20

-- === TOGGLE MENU ===
local function toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    ToggleBtn.Text = menuOpen and "<<" or ">>"
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
CloseX.MouseButton1Click:Connect(function() MainFrame.Visible = false; ToggleBtn.Text = ">>"; menuOpen = false end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- === FEATURES ===

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
JumpBox.FocusLost:Connect(function() local n = tonumber(JumpBox.Text); if n and n >= 0 and n <= 300 then jumpPower = n end JumpBox.Text = tostring(jumpPower) end)

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
SpeedBox.FocusLost:Connect(function() local n = tonumber(SpeedBox.Text); if n and n >= 0 and n <= 200 then walkSpeed = n end SpeedBox.Text = tostring(walkSpeed) end)

-- Noclip (Fixed: Walls only, no floor fall)
NoclipToggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    if noclipping then
        connections.noclip = RunService.Stepped:Connect(function()
            local char = getChar()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part ~= getRoot() then
                        part.CanCollide = false
                    end
                end
            end
        end)
        NoclipToggle.Text = "NOCLIP: ON"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.noclip then connections.noclip:Disconnect() end
        NoclipToggle.Text = "NOCLIP: OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)

-- Fly (Fully fixed + respawn support)
local function enableFly()
    local root = getRoot()
    if not root then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(90000, 90000, 90000)
    bv.P = 1250
    bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.P = 20000
    bg.MaxTorque = Vector3.new(90000, 90000, 90000)
    bg.CFrame = root.CFrame
    bg.Parent = root
    local hum = getHum()
    if hum then hum.PlatformStand = true end
    connections.fly = RunService.Heartbeat:Connect(function()
        if not root.Parent then return end
        local hum = getHum()
        if hum then hum.PlatformStand = true end
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        bv.Velocity = moveDir * flySpeed
        bg.CFrame = camera.CFrame
    end)
end

local function disableFly()
    if connections.fly then
        connections.fly:Disconnect()
        connections.fly = nil
    end
    local root = getRoot()
    if root then
        for _, obj in pairs(root:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                obj:Destroy()
            end
        end
        local hum = getHum()
        if hum then hum.PlatformStand = false end
    end
end

FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        enableFly()
        FlyToggle.Text = "FLY: ON"; FlyToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        disableFly()
        FlyToggle.Text = "FLY: OFF"; FlyToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
FlyBox.FocusLost:Connect(function() local n = tonumber(FlyBox.Text); if n and n > 0 and n <= 500 then flySpeed = n end FlyBox.Text = tostring(flySpeed) end)

-- Teleports
TPMouseBtn.MouseButton1Click:Connect(function()
    if mouse.Hit.Position then
        local root = getRoot()
        if root then
            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

TPNearestBtn.MouseButton1Click:Connect(function()
    local closest = getClosestPlayer()
    if closest then
        tpToPlayer(closest)
    end
end)

TPRandomBtn.MouseButton1Click:Connect(tpRandomPlayer)

-- Respawn handling
player.CharacterRemoving:Connect(function()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    connections = {}
    disableFly()
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flying then
        enableFly()
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu v2.3 Loaded";
    Text = "Fly fixed • Teleports added • Toggle: RightShift";
    Duration = 7;
})

print("Yall-Menu v2.3 - Full Featured & Fixed - READY 🔥")
