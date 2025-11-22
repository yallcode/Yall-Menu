-- YALL MENU v4.0 — Made by YallaYCode
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/yallcode/Yall-Menu/main/YallMenu.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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

-- Helper
local function Char() return player.Character end
local function Root() return Char() and Char():FindFirstChild("HumanoidRootPart") end
local function Hum() return Char() and Char():FindFirstChildOfClass("Humanoid") end

-- === GUI (Clean 2025 Style) ===
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YallMenuV4"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 620)
Main.Position = UDim2.new(0.5, -250, 0.5, -310)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.ClipsDescendants = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 18)

-- Glow Effect
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
Title.TextSize = 42
Title.TextStrokeTransparency = 0.7

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
Close.Size = UDim2.new(0, 50, 0, 50)
Close.Position = UDim2.new(1, -60, 0, 10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 30
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Content Area
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -40, 1, -120)
Content.Position = UDim2.new(0, 20, 0, 100)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 800)

-- Button Creator
local yPos = 20
local function AddButton(text, color, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0, 420, 0, 70)
    btn.Position = UDim2.new(0, 30, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    
    yPos = yPos + 90
end

-- === FEATURES ===
AddButton("FLY [OFF]", Color3.fromRGB(255, 60, 60), function(btn)
    Flying = not Flying
    btn.Text = Flying and "FLY [ON]" or "FLY [OFF]"
    btn.BackgroundColor3 = Flying and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(255, 60, 60)
    
    if Flying then
        local root = Root()
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 20000
        
        connections.fly = RunService.Heartbeat:Connect(function()
            if not Root() then return end
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
        for _, v in pairs(Root():GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
        end
        Hum().PlatformStand = false
    end
end)

AddButton("NOCLIP [OFF]", Color3.fromRGB(255, 60, 60), function(btn)
    Noclip = not Noclip
    btn.Text = Noclip and "NOCLIP [ON]" or "NOCLIP [OFF]"
    btn.BackgroundColor3 = Noclip and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(255, 60, 60)
    
    if Noclip then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(Char():GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() end
    end
end)

AddButton("ESP [OFF]", Color3.fromRGB(255, 60, 60), function(btn)
    ESP = not ESP
    btn.Text = ESP and "ESP [ON]" or "ESP [OFF]"
    btn.BackgroundColor3 = ESP and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(255, 60, 60)
    
    if ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Color = Color3.fromRGB(0, 255, 255)
                box.Filled = false
                box.Transparency = 1
                espBoxes[plr] = box
                
                spawn(function()
                    while ESP and plr.Character and plr.Character:FindFirstChild("Head") do
                        local head = plr.Character.Head
                        local pos, onscreen = camera:WorldToViewportPoint(head.Position)
                        if onscreen then
                            local scale = 1000 / (camera.CFrame.Position - head.Position).Magnitude
                            box.Size = Vector2.new(scale * 3, scale * 4)
                            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
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
        for _, box in pairs(espBoxes) do box:Remove() end
        espBoxes = {}
    end
end)

AddButton("TP TO MOUSE", Color3.fromRGB(100, 150, 255), function()
    if mouse.Hit then
        Root().CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
    end
end)

-- Premium Button (Task Unlock)
AddButton("PREMIUM UNLOCKED: NO", Color3.fromRGB(180, 0, 0), function(btn)
    btn.Text = "PREMIUM UNLOCKED: YES"
    btn.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    Premium = true
    game.StarterGui:SetCore("SendNotification", {
        Title = "YallaYCode";
        Text = "Premium unlocked! Subscribe done!";
        Duration = 6;
    })
    -- Load premium features here later
end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "YALL MENU v4.0";
    Text = "Loaded! RightShift to toggle • Made by YallaYCode";
    Duration = 8;
})

print("YALL MENU v4.0 — Fully Loaded")
