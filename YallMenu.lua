-- Yall-Menu v3.0 - Free Tier: Fly/ESP/TPs + Premium Key Hook
-- Load via: loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/Yall-Menu/main/YallMenu.lua"))()
-- Toggle: RightShift | Premium: Aimbot/Godmode via GitHub Keys

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- Variables
local infJump = false; local jumpPower = 50
local speedHack = false; local walkSpeed = 16
local noclipping = false
local flying = false; local flySpeed = 100
local espEnabled = false
local premiumUnlocked = false
local menuOpen = true
local currentTab = "Exploits"

local connections = {}
local espObjects = {}

-- Helper functions
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

-- Teleport helpers (from earlier)
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
            if dist < minDist then minDist = dist; closest = other end
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
    if #others > 0 then tpToPlayer(others[math.random(#others)]) end
end

-- === GUI SETUP ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YallMenu"; ScreenGui.Parent = CoreGui; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true; MainFrame.Draggable = true
MainFrame.Visible = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

-- Shadow
local shadow = Instance.new("ImageLabel", MainFrame)
shadow.Size = UDim2.new(1,24,1,24); shadow.Position = UDim2.new(0,-12,0,-12)
shadow.BackgroundTransparency = 1; shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.new(0,0,0); shadow.ImageTransparency = 0.5; shadow.ZIndex = -1

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,55); Title.BackgroundTransparency = 1
Title.Text = "Yall-Menu v3.0"; Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = 26

local Sub = Instance.new("TextLabel", MainFrame)
Sub.Position = UDim2.new(0,0,0,50); Sub.Size = UDim2.new(1,0,0,20)
Sub.BackgroundTransparency = 1; Sub.Text = "Free Tier Loaded • Premium: Unlock via index.html"
Sub.TextColor3 = Color3.fromRGB(100,255,255); Sub.Font = Enum.Font.Gotham; Sub.TextSize = 14

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50); ToggleBtn.Position = UDim2.new(0,10,0.5,-25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,255,255); ToggleBtn.Text = ">>"
ToggleBtn.TextColor3 = Color3.new(0,0,0); ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20; ToggleBtn.Parent = ScreenGui; ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,12)

-- Tabs Frame (Sidebar)
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(0,100,1,-55); TabsFrame.Position = UDim2.new(0,0,0,55)
TabsFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)

local ExploitsTab = Instance.new("TextButton", TabsFrame)
ExploitsTab.Size = UDim2.new(1,0,0,50); ExploitsTab.Text = "Exploits"
ExploitsTab.BackgroundColor3 = Color3.fromRGB(0,200,200); ExploitsTab.TextColor3 = Color3.new(1,1,1)
ExploitsTab.Font = Enum.Font.GothamBold; ExploitsTab.TextSize = 16
Instance.new("UICorner", ExploitsTab).CornerRadius = UDim.new(0,8)

local HelpTab = Instance.new("TextButton", TabsFrame)
HelpTab.Size = UDim2.new(1,0,0,50); HelpTab.Position = UDim2.new(0,0,0,50)
HelpTab.Text = "Help"; HelpTab.BackgroundColor3 = Color3.fromRGB(30,30,35)
HelpTab.TextColor3 = Color3.new(1,1,1); HelpTab.Font = Enum.Font.GothamBold; HelpTab.TextSize = 16
Instance.new("UICorner", HelpTab).CornerRadius = UDim.new(0,8)

-- Content Frame
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1,-100,1,-55); ContentFrame.Position = UDim2.new(0,100,0,55)
ContentFrame.BackgroundTransparency = 1

-- Exploits Content (Visible by default)
local ExploitsContent = Instance.new("ScrollingFrame", ContentFrame)
ExploitsContent.Size = UDim2.new(1,0,1,0); ExploitsContent.BackgroundTransparency = 1
ExploitsContent.CanvasSize = UDim2.new(0,0,0,400); ExploitsContent.ScrollBarThickness = 8

-- Buttons in Exploits Tab (Positioned with padding)
local JumpToggle = Instance.new("TextButton", ExploitsContent)
JumpToggle.Size = UDim2.new(0,140,0,45); JumpToggle.Position = UDim2.new(0,15,0,10)
JumpToggle.Text = "INF JUMP: OFF"; JumpToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", JumpToggle).CornerRadius = UDim.new(0,10)

local JumpBox = Instance.new("TextBox", ExploitsContent)
JumpBox.Size = UDim2.new(0,140,0,35); JumpBox.Position = UDim2.new(0,15,0,60)
JumpBox.Text = "50"; JumpBox.PlaceholderText = "Jump Power"
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0,8)

local SpeedToggle = Instance.new("TextButton", ExploitsContent)
SpeedToggle.Size = UDim2.new(0,140,0,45); SpeedToggle.Position = UDim2.new(0,165,0,10)
SpeedToggle.Text = "SPEED: OFF"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(0,10)

local SpeedBox = Instance.new("TextBox", ExploitsContent)
SpeedBox.Size = UDim2.new(0,140,0,35); SpeedBox.Position = UDim2.new(0,165,0,60)
SpeedBox.Text = "16"; SpeedBox.PlaceholderText = "Walk Speed"
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,8)

local NoclipToggle = Instance.new("TextButton", ExploitsContent)
NoclipToggle.Size = UDim2.new(0,290,0,50); NoclipToggle.Position = UDim2.new(0,15,0,110)
NoclipToggle.Text = "NOCLIP: OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0,12)

local FlyToggle = Instance.new("TextButton", ExploitsContent)
FlyToggle.Size = UDim2.new(0,140,0,45); FlyToggle.Position = UDim2.new(0,15,0,180)
FlyToggle.Text = "FLY: OFF"; FlyToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0,10)

local FlyBox = Instance.new("TextBox", ExploitsContent)
FlyBox.Size = UDim2.new(0,140,0,35); FlyBox.Position = UDim2.new(0,165,0,185)
FlyBox.Text = "100"; FlyBox.PlaceholderText = "Fly Speed"
Instance.new("UICorner", FlyBox).CornerRadius = UDim.new(0,8)

local ESPToggle = Instance.new("TextButton", ExploitsContent)
ESPToggle.Size = UDim2.new(0,290,0,45); ESPToggle.Position = UDim2.new(0,15,0,240)
ESPToggle.Text = "ESP: OFF"; ESPToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", ESPToggle).CornerRadius = UDim.new(0,10)

local TPMouseBtn = Instance.new("TextButton", ExploitsContent)
TPMouseBtn.Size = UDim2.new(0,140,0,45); TPMouseBtn.Position = UDim2.new(0,15,0,300)
TPMouseBtn.Text = "TP MOUSE"; TPMouseBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
Instance.new("UICorner", TPMouseBtn).CornerRadius = UDim.new(0,10)

local TPNearestBtn = Instance.new("TextButton", ExploitsContent)
TPNearestBtn.Size = UDim2.new(0,140,0,45); TPNearestBtn.Position = UDim2.new(0,165,0,300)
TPNearestBtn.Text = "TP NEAREST"; TPNearestBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
Instance.new("UICorner", TPNearestBtn).CornerRadius = UDim.new(0,10)

-- Help Content (Hidden initially)
local HelpContent = Instance.new("Frame", ContentFrame)
HelpContent.Size = UDim2.new(1,0,1,0); HelpContent.BackgroundTransparency = 1
HelpContent.Visible = false

local HelpText = Instance.new("TextLabel", HelpContent)
HelpText.Size = UDim2.new(1,0,1,0); HelpText.BackgroundTransparency = 1
HelpText.Text = "Yall-Menu v3.0 Help\n\n• RightShift: Toggle Menu\n• Fly: WASD + Space/Ctrl (Shift for boost)\n• ESP: Shows player boxes/names\n• Teleports: Mouse/Nearest/Random\n\nPremium: Visit https://yallcode.github.io/Yall-Menu/ for key\n\nKeys managed at github.com/yallcode/yall-keys\n\nNothing serious. 🔥"
HelpText.TextColor3 = Color3.fromRGB(0,255,255); HelpText.Font = Enum.Font.Gotham; HelpText.TextSize = 16
HelpText.TextWrapped = true; HelpText.Position = UDim2.new(0,10,0,0)

-- Tab Switching
ExploitsTab.MouseButton1Click:Connect(function()
    ExploitsContent.Visible = true; HelpContent.Visible = false
    ExploitsTab.BackgroundColor3 = Color3.fromRGB(0,200,200); HelpTab.BackgroundColor3 = Color3.fromRGB(30,30,35)
    currentTab = "Exploits"
end)

HelpTab.MouseButton1Click:Connect(function()
    ExploitsContent.Visible = false; HelpContent.Visible = true
    HelpTab.BackgroundColor3 = Color3.fromRGB(0,200,200); ExploitsTab.BackgroundColor3 = Color3.fromRGB(30,30,35)
    currentTab = "Help"
end)

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
UserInputService.InputBegan:Connect(function(i,gp) if not gp and i.KeyCode == Enum.KeyCode.RightShift then toggleMenu() end end)

-- === FEATURES ===
-- Inf Jump
JumpToggle.MouseButton1Click:Connect(function()
    infJump = not infJump
    if infJump then
        connections.jump = UserInputService.JumpRequest:Connect(function() local h = getHum(); if h then h:ChangeState("Jumping") end end)
        connections.jumpSet = RunService.Heartbeat:Connect(function() local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = jumpPower end end)
        JumpToggle.Text = "INF JUMP: ON"; JumpToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.jump then connections.jump:Disconnect() end
        if connections.jumpSet then connections.jumpSet:Disconnect() end
        JumpToggle.Text = "INF JUMP: OFF"; JumpToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
JumpBox.FocusLost:Connect(function() local n = tonumber(JumpBox.Text); if n and n >= 0 and n <= 300 then jumpPower = n; JumpBox.Text = tostring(jumpPower) end end)

-- Speed
SpeedToggle.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    if speedHack then
        connections.speed = RunService.Heartbeat:Connect(function() local h = getHum(); if h then h.WalkSpeed = walkSpeed end end)
        SpeedToggle.Text = "SPEED: ON"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.speed then connections.speed:Disconnect() end
        SpeedToggle.Text = "SPEED: OFF"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)
SpeedBox.FocusLost:Connect(function() local n = tonumber(SpeedBox.Text); if n and n >= 0 and n <= 200 then walkSpeed = n; SpeedBox.Text = tostring(walkSpeed) end end)

-- Noclip
NoclipToggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    if noclipping then
        connections.noclip = RunService.Stepped:Connect(function()
            local char = getChar()
            if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") and part ~= getRoot() then part.CanCollide = false end end end
        end)
        NoclipToggle.Text = "NOCLIP: ON"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.noclip then connections.noclip:Disconnect() end
        NoclipToggle.Text = "NOCLIP: OFF"; NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)

-- Fly (Fixed: Movement works with high P/force)
local function enableFly()
    local root = getRoot()
    if not root then return end
    local bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.Velocity = Vector3.new(0,0,0); bv.P = 9000
    local bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bg.P = 20000; bg.CFrame = root.CFrame
    local hum = getHum(); if hum then hum.PlatformStand = true end
    connections.fly = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then return end
        local hum = getHum(); if hum then hum.PlatformStand = true end
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        if move.Magnitude > 0 then move = move.Unit end
        bv.Velocity = move * flySpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2 or 1)
        bg.CFrame = camera.CFrame
    end)
end

local function disableFly()
    if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
    local root = getRoot()
    if root then
        for _, v in pairs(root:GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end
        local hum = getHum(); if hum then hum.PlatformStand = false end
    end
end

FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then enableFly() else disableFly() end
    FlyToggle.Text = flying and "FLY: ON" or "FLY: OFF"
    FlyToggle.BackgroundColor3 = flying and Color3.fromRGB(0,220,0) or Color3.fromRGB(255,50,50)
end)
FlyBox.FocusLost:Connect(function() local n = tonumber(FlyBox.Text); if n and n > 0 and n <= 500 then flySpeed = n; FlyBox.Text = tostring(flySpeed) end end)

-- ESP
local function createESP(plr)
    if plr == player or espObjects[plr] then return end
    local box = Drawing.new("Square")
    box.Thickness = 2; box.Filled = false; box.Color = Color3.fromRGB(0,255,255); box.Transparency = 1
    local name = Drawing.new("Text")
    name.Size = 16; name.Center = true; name.Outline = true; name.Color = Color3.fromRGB(0,255,255); name.Outline = true
    espObjects[plr] = {box = box, name = name}
    local conn = RunService.RenderStepped:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("Head") then box.Visible = false; name.Visible = false; return end
        local head = plr.Character.Head
        local pos, onScreen = camera:WorldToViewportPoint(head.Position)
        if onScreen then
            local size = (camera:WorldToViewportPoint(head.Position + Vector3.new(0,3,0)).Y - camera:WorldToViewportPoint(head.Position - Vector3.new(0,3,0)).Y) * 1.5
            box.Size = Vector2.new(size * 1.8, size * 2.5)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Visible = true
            name.Text = plr.DisplayName .. " (" .. plr.Name .. ")"
            name.Position = Vector2.new(pos.X, pos.Y - size)
            name.Visible = true
        else
            box.Visible = false; name.Visible = false
        end
    end)
    plr.CharacterRemoving:Connect(function()
        if espObjects[plr] then espObjects[plr].box:Remove(); espObjects[plr].name:Remove(); espObjects[plr] = nil end
        if conn then conn:Disconnect() end
    end)
end

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    ESPToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0,220,0) or Color3.fromRGB(255,50,50)
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= player then createESP(p) end end
        Players.PlayerAdded:Connect(function(p) if p ~= player then createESP(p) end end)
    else
        for _, obj in pairs(espObjects) do obj.box:Remove(); obj.name:Remove() end
        espObjects = {}
    end
end)

-- Teleports
TPMouseBtn.MouseButton1Click:Connect(function()
    if mouse.Hit.Position then local root = getRoot(); if root then root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) end end
end)
TPNearestBtn.MouseButton1Click:Connect(function() local closest = getClosestPlayer(); if closest then tpToPlayer(closest) end end)
TPRandomBtn = Instance.new("TextButton", ExploitsContent)  -- Add missing Random TP
TPRandomBtn.Size = UDim2.new(0,290,0,45); TPRandomBtn.Position = UDim2.new(0,15,0,355)
TPRandomBtn.Text = "TP RANDOM"; TPRandomBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
Instance.new("UICorner", TPRandomBtn).CornerRadius = UDim.new(0,10)
TPRandomBtn.MouseButton1Click:Connect(tpRandomPlayer)

-- Premium Hook (In-game key prompt if not unlocked)
if not premiumUnlocked then
    local PremiumPrompt = Instance.new("TextButton", MainFrame)
    PremiumPrompt.Size = UDim2.new(0,200,0,40); PremiumPrompt.Position = UDim2.new(0.5,-100,1,-50)
    PremiumPrompt.Text = "Unlock Premium?"; PremiumPrompt.BackgroundColor3 = Color3.fromRGB(0,200,0)
    PremiumPrompt.MouseButton1Click:Connect(function()
        -- Redirect or prompt key (simple for now)
        game:HttpGet("https://yallcode.github.io/Yall-Menu/")  -- Opens in browser if possible, or notify
        game.StarterGui:SetCore("SendNotification", {Title="Premium"; Text="Visit site for key!"; Duration=5})
    end)
end

-- Respawn/Death Handling
player.CharacterRemoving:Connect(function()
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    connections = {}; disableFly(); espEnabled = false  -- Reset ESP too
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flying then enableFly() end
    if espEnabled then
        task.wait(1)  -- Delay for players
        for _, p in ipairs(Players:GetPlayers()) do if p ~= player then createESP(p) end end
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu v3.0 Loaded",
    Text = "Free features ready! Premium via github.io site. Toggle: RightShift",
    Duration = 8
})

print("Yall-Menu v3.0 Injected - Fly/ESP/TPs Live | Premium Hook Ready")
