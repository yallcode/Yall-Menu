-- YALL MENU v3.5 - Clean Sidebar + Premium Tab (GitHub Key System)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/Yall-Menu/main/YallMenu.lua"))()

local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local TweenService      = game:GetService("TweenService")

local player            = Players.LocalPlayer
local camera            = workspace.CurrentCamera
local mouse             = player:GetMouse()

-- === VARIABLES ===
local flying = false
local flySpeed = 100
local noclipping = false
local espEnabled = false
local premiumUnlocked = false

local connections = {}
local espObjects = {}

-- === HELPERS ===
local function getChar() return player.Character end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end

-- === PREMIUM CHECK (GitHub keys.txt) ===
local KEYS_URL = "https://raw.githubusercontent.com/yallcode/yall-keys/main/keys.txt"
spawn(function()
    local success, keysText = pcall(function() return game:HttpGet(KEYS_URL) end)
    if success and keysText then
        local validKeys = {}
        for key in keysText:gmatch("[^\r\n]+") do table.insert(validKeys, key:trim()) end
        -- You can add your own key check here later, for now we auto-unlock for demo
        -- Replace with real key input if you want in-game entry
        premiumUnlocked = true  -- REMOVE THIS LINE WHEN YOU WANT REAL KEY CHECK
        if premiumUnlocked then
            game.StarterGui:SetCore("SendNotification", {Title="Yall-Menu", Text="Premium Unlocked!", Duration=6})
        end
    end
end)

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "YallMenuV35"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 560)
Main.Position = UDim2.new(0.5, -230, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

-- Title Bar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 230, 230)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "YALL MENU v3.5"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,80,80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 28
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Sidebar (Tabs)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)

local Tabs = {
    Free = Instance.new("TextButton", Sidebar),
    Premium = Instance.new("TextButton", Sidebar),
    Info = Instance.new("TextButton", Sidebar)
}

Tabs.Free.Size = UDim2.new(1,0,0,60); Tabs.Free.Position = UDim2.new(0,0,0,10)
Tabs.Free.Text = "FREE"
Tabs.Free.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
Tabs.Free.TextColor3 = Color3.new(1,1,1)
Tabs.Free.Font = Enum.Font.GothamBold
Tabs.Free.TextSize = 18

Tabs.Premium.Size = UDim2.new(1,0,0,60); Tabs.Premium.Position = UDim2.new(0,0,0,80)
Tabs.Premium.Text = "PREMIUM"
Tabs.Premium.BackgroundColor3 = premiumUnlocked and Color3.fromRGB(180, 120, 0) or Color3.fromRGB(80,80,80)
Tabs.Premium.TextColor3 = Color3.new(1,1,1)
Tabs.Premium.Font = Enum.Font.GothamBold
Tabs.Premium.TextSize = 18

Tabs.Info.Size = UDim2.new(1,0,0,60); Tabs.Info.Position = UDim2.new(0,0,0,150)
Tabs.Info.Text = "INFO"
Tabs.Info.BackgroundColor3 = Color3.fromRGB(60,60,80)
Tabs.Info.TextColor3 = Color3.new(1,1,1)
Tabs.Info.Font = Enum.Font.GothamBold
Tabs.Info.TextSize = 18

-- Content Area
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -120, 1, -50)
Content.Position = UDim2.new(0, 120, 0, 50)
Content.BackgroundTransparency = 1

local FreePage = Instance.new("ScrollingFrame", Content)
local PremiumPage = Instance.new("ScrollingFrame", Content)
local InfoPage = Instance.new("Frame", Content)

for _, page in pairs({FreePage, PremiumPage, InfoPage}) do
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,0,600)
    page.ScrollBarThickness = 6
end
FreePage.Visible = true

-- === FREE FEATURES ===
local function CreateButton(parent, text, pos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 300, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(255,60,60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateButton(FreePage, "FLY: OFF", UDim2.new(0,20,0,20), function()
    flying = not flying
    local root = getRoot()
    if not root then return end
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,0,0)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 20000
        bg.CFrame = root.CFrame
        getHum().PlatformStand = true
        connections.fly = RunService.Heartbeat:Connect(function()
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move.Unit * flySpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2 or 1)
            bg.CFrame = camera.CFrame
        end)
        btn.Text = "FLY: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.fly then connections.fly:Disconnect() end
        for _,v in pairs(root:GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end
        getHum().PlatformStand = false
        btn.Text = "FLY: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255,60,60)
    end
end)

CreateButton(FreePage, "NOCLIP", UDim2.new(0,20,0,90), function()
    noclipping = not noclipping
    if noclipping then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(getChar():GetDescendants()) do
                if part:IsA("BasePart") and part ~= getRoot() then part.CanCollide = false end
            end
        end)
        btn.BackgroundColor3 = Color3.fromRGB(0,220,0)
    else
        if connections.noclip then connections.noclip:Disconnect() end
        btn.BackgroundColor3 = Color3.fromRGB(255,60,60)
    end
end)

CreateButton(FreePage, "ESP", UDim2.new(0,20,0,160), function()
    espEnabled = not espEnabled
    btn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    btn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,220,0) or Color3.fromRGB(255,60,60)
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local box = Drawing.new("Square")
                box.Thickness = 2; box.Color = Color3.fromRGB(0,255,255); box.Filled = false; box.Transparency = 1
                espObjects[plr] = box
                spawn(function()
                    while espEnabled and plr.Character and plr.Character:FindFirstChild("Head") do
                        local head = plr.Character.Head
                        local pos, onscreen = camera:WorldToViewportPoint(head.Position)
                        if onscreen then
                            local size = Vector2.new(1000/head.Position.Magnitude, 1600/head.Position.Magnitude) * 50
                            box.Size = size
                            box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                            box.Visible = true
                        else
                            box.Visible = false
                        end
                        RunService.RenderStepped:Wait()
                    end
                    if box then box:Remove() end
                end)
            end
        end
    else
        for _, box in pairs(espObjects) do box:Remove() end
        espObjects = {}
    end
end)

-- === PREMIUM FEATURES (Only visible if unlocked) ===
if premiumUnlocked then
    PremiumPage.Visible = true
    CreateButton(PremiumPage, "AIMBOT", UDim2.new(0,20,0,20), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/yall-menu-premium/main/aimbot.lua"))() end)
    CreateButton(PremiumPage, "GODMODE", UDim2.new(0,20,0,90), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/yall-menu-premium/main/godmode.lua"))() end)
    CreateButton(PremiumPage, "SILENT AIM", UDim2.new(0,20,0,160), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/yall-menu-premium/main/silentaim.lua"))() end)
else
    local Lock = Instance.new("TextLabel", PremiumPage)
    Lock.Size = UDim2.new(1,0,1,0)
    Lock.BackgroundTransparency = 1
    Lock.Text = "PREMIUM LOCKED\n\nGet key at:\nyallcode.github.io/Yall-Menu"
    Lock.TextColor3 = Color3.fromRGB(255,100,100)
    Lock.Font = Enum.Font.GothamBold
    Lock.TextSize = 22
    PremiumPage.Visible = false
end

-- === INFO PAGE ===
local InfoText = Instance.new("TextLabel", InfoPage)
InfoText.Size = UDim2.new(1, -40, 1, 0)
InfoText.Position = UDim2.new(0, 20, 0, 0)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(0,255,255)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 16
InfoText.TextWrapped = true
InfoText.Text = [[YALL MENU v3.5
Nothing serious, just vibes.

Free: Fly • Noclip • ESP • Teleports
Premium: Aimbot • Godmode • Silent Aim

Key site: yallcode.github.io/Yall-Menu
Keys repo: github.com/yallcode/yall-keys

Toggle: RightShift
Made with love in 2025]]

InfoPage.Visible = false

-- === TAB SWITCHING ===
Tabs.Free.MouseButton1Click:Connect(function()
    FreePage.Visible = true; PremiumPage.Visible = false; InfoPage.Visible = false
    Tabs.Free.BackgroundColor3 = Color3.fromRGB(0,180,180)
    Tabs.Premium.BackgroundColor3 = premiumUnlocked and Color3.fromRGB(180,120,0) or Color3.fromRGB(80,80,80)
    Tabs.Info.BackgroundColor3 = Color3.fromRGB(60,60,80)
end)

Tabs.Premium.MouseButton1Click:Connect(function()
    if premiumUnlocked then
        FreePage.Visible = false; PremiumPage.Visible = true; InfoPage.Visible = false
        Tabs.Premium.BackgroundColor3 = Color3.fromRGB(220,160,0)
        Tabs.Free.BackgroundColor3 = Color3.fromRGB(60,60,80)
        Tabs.Info.BackgroundColor3 = Color3.fromRGB(60,60,80)
    end
end)

Tabs.Info.MouseButton1Click:Connect(function()
    FreePage.Visible = false; PremiumPage.Visible = false; InfoPage.Visible = true
    Tabs.Info.BackgroundColor3 = Color3.fromRGB(100,100,200)
    Tabs.Free.BackgroundColor3 = Color3.fromRGB(60,60,80)
    Tabs.Premium.BackgroundColor3 = premiumUnlocked and Color3.fromRGB(180,120,0) or Color3.fromRGB(80,80,80)
end)

-- === TOGGLE MENU (RightShift) ===
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- === NOTIFICATION ===
game.StarterGui:SetCore("SendNotification", {
    Title = "Yall-Menu v3.5";
    Text = "Loaded • RightShift to toggle • Premium tab unlocked: "..tostring(premiumUnlocked);
    Duration = 8;
})

print("YALL MENU v3.5 LOADED - PREMIUM TAB READY")
