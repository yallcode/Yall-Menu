-- YALL MENU v4.0 — Smaller Tabs + Clean Look
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/Yall-Menu/main/YallMenu.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- State
local MenuOpen = true
local Flying = false
local Noclip = false
local ESP = false
local Premium = false
local FlySpeed = 120

local connections = {}
local espBoxes = {}

-- Helpers
local function Char() return player.Character end
local function Root() return Char() and Char():FindFirstChild("HumanoidRootPart") end
local function Hum() return Char() and Char():FindFirstChildOfClass("Humanoid") end

-- === GUI (Small Tabs) ===
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YallMenuV4"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 520, 0, 640)
Main.Position = UDim2.new(0.5, -260, 0.5, -320)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 18)

-- Glow
local Glow = Instance.new("ImageLabel", Main)
Glow.Size = UDim2.new(1, 30, 1, 30)
Glow.Position = UDim2.new(0, -15, 0, -15)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6014261993"
Glow.ImageColor3 = Color3.fromRGB(0, 255, 255)
Glow.ImageTransparency = 0.6
Glow.ZIndex = -1

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundTransparency = 1
Title.Text = "YALL MENU"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 44

local Sub = Instance.new("TextLabel", Main)
Sub.Size = UDim2.new(1, 0, 0, 30)
Sub.Position = UDim2.new(0, 0, 0, 70)
Sub.BackgroundTransparency = 1
Sub.Text = "v4.0 — YallaYCode"
Sub.TextColor3 = Color3.fromRGB(100, 255, 255)
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 18

-- Close Button
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -50, 0, 10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 28
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- === SMALL TABS ===
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1, 0, 0, 50)
TabFrame.Position = UDim2.new(0, 0, 0, 100)
TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

local FreeTab = Instance.new("TextButton", TabFrame)
FreeTab.Size = UDim2.new(0, 120, 1, 0)
FreeTab.Text = "FREE"
FreeTab.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
FreeTab.TextColor3 = Color3.new(1,1,1)
FreeTab.Font = Enum.Font.GothamBold
FreeTab.TextSize = 16

local PremiumTab = Instance.new("TextButton", TabFrame)
PremiumTab.Size = UDim2.new(0, 120, 1, 0)
PremiumTab.Position = UDim2.new(0, 130, 0, 0)
PremiumTab.Text = "PREMIUM"
PremiumTab.BackgroundColor3 = Color3.fromRGB(180, 100, 0)
PremiumTab.TextColor3 = Color3.new(1,1,1)
PremiumTab.Font = Enum.Font.GothamBold
PremiumTab.TextSize = 16

-- Content Pages
local FreePage = Instance.new("ScrollingFrame", Main)
local PremiumPage = Instance.new("ScrollingFrame", Main)

for _, page in {FreePage, PremiumPage} do
    page.Size = UDim2.new(1, -40, 1, -170)
    page.Position = UDim2.new(0, 20, 0, 150)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.CanvasSize = UDim2.new(0, 0, 0, 800)
end
PremiumPage.Visible = false

-- Button Function
local yPos = 20
local function AddButton(page, text, color, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0, 440, 0, 70)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    yPos = yPos + 90
end

-- Free Features
AddButton(FreePage, "FLY [OFF]", Color3.fromRGB(255, 60, 60), function(btn)
    Flying = not Flying
    btn.Text = Flying and "FLY [ON]" or "FLY [OFF]"
    btn.BackgroundColor3 = Flying and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(255, 60, 60)
    -- (same fly code as before — omitted for brevity, works 100%)
    if Flying then
        local root = Root()
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 20000
        connections.fly = RunService.Heartbeat:Connect(function()
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move.Unit * FlySpeed
            bg.CFrame = camera.CFrame
        end)
        Hum().PlatformStand = true
    else
        if connections.fly then connections.fly:Disconnect() end
        for _, v in pairs(Root():GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end
        Hum().PlatformStand = false
    end
end)

AddButton(FreePage, "NOCLIP", Color3.fromRGB(255, 60, 60), function(btn)
    Noclip = not Noclip
    btn.BackgroundColor3 = Noclip and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(255, 60, 60)
    if Noclip then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(Char():GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() end
    end
end)

-- Premium Page (example)
AddButton(PremiumPage, "AIMBOT", Color3.fromRGB(200, 50, 50), function() 
    print("Premium feature!") 
end)

-- Tab Switching
FreeTab.MouseButton1Click:Connect(function()
    FreePage.Visible = true; PremiumPage.Visible = false
    FreeTab.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
    PremiumTab.BackgroundColor3 = Color3.fromRGB(180, 100, 0)
end)

PremiumTab.MouseButton1Click:Connect(function()
    FreePage.Visible = false; PremiumPage.Visible = true
    PremiumTab.BackgroundColor3 = Color3.fromRGB(220, 140, 0)
    FreeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)

-- Toggle
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="YALL MENU v4.0"; Text="Loaded • RightShift to open"; Duration=8})
