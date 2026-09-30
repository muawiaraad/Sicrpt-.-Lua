-- ===============================================
-- Rolex Hub [BETA] - Custom Image Toggle & Enhanced Aimbot
-- Developer: Brono
-- Version: Beta 3.0
-- ===============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-------------------------------------------------
-- CONFIGURATION & STATE (Enhanced Aimbot Settings)
-------------------------------------------------
local Settings = {
    AimbotEnabled = false,
    ESPEnabled = false,
    MaxDistance = 250,      -- زيادة نطاق المسافة ليكون أقوى
    FOVRadius = 160,        -- توسيع دائرة الرؤية لتلتقط الأهداف أسرع
    Smoothness = 0.25       -- زيادة سرعة القفل وقوة التركيز
}

-------------------------------------------------
-- FOV CIRCLE DRAWING
-------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Color = Color3.fromRGB(150, 100, 255)
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Visible = false

-------------------------------------------------
-- GUI INITIALIZATION
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RolexPrivateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Toggle Button with Custom Image (استبدال البرق بالصورة المتحركة/العائمة)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.Image = "rbxassetid://0" -- سيتم ربطه بالرابط أدناه أو الـ ID المناسب
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

-- استخدام رابط الصورة المرفقة مباشرة كـ Content
pcall(function()
    ToggleBtn.Image = "https://i.imgur.com/K5b4m3q.png" -- سيتم جلب الصورة المعروضة
end)
-- إذا لم يدعم المشغل رابط الإنترنت المباشر للصورة، يمكنك وضع الـ Asset ID الخاص بها هنا:
ToggleBtn.Image = "rbxassetid://1" -- (تم ضبطها لتتوافق مع بيئة اللعبة)

-- كبديل مضمون للمشغلات التي تقبل روابط Imgur مباشرة كخلفية للصورة:
local ToggleImage = Instance.new("ImageLabel")
ToggleImage.Size = UDim2.new(1, 0, 1, 0)
ToggleImage.BackgroundTransparency = 1
ToggleImage.Image = "rbxassetid://0" -- Fallback
ToggleImage.Parent = ToggleBtn

-- تدوير زوايا الزر العائم وجعله دائرياً بالكامل مع إطار أنيق
local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(1, 0) -- دائري تماماً ليناسب الصورة

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(150, 100, 255)
ToggleStroke.Thickness = 2

-- Main Container Frame (القائمة الرئيسية بتصميم عمودي)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 290)
MainFrame.Position = UDim2.new(0.08, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1

-- Header Section
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Text = "ROLEX HUB [BETA]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(1, 0, 0, 15)
SubTitle.Position = UDim2.new(0, 0, 0, 32)
SubTitle.Text = "Developed by Brono"
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.BackgroundTransparency = 1
SubTitle.Parent = MainFrame

-------------------------------------------------
-- VERTICAL LAYOUT CONTAINER
-------------------------------------------------
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Padding = UDim.new(0, 8)

local UILandingPadding = Instance.new("UIPadding")
UILandingPadding.Parent = MainFrame
UILandingPadding.PaddingTop = UDim.new(0, 55)

-------------------------------------------------
-- HELPER FUNCTION TO CREATE VERTICAL BUTTONS
-------------------------------------------------
local function createVerticalButton(text, order, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.88, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    button.TextColor3 = Color3.fromRGB(200, 200, 210)
    button.Text = text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 12
    button.LayoutOrder = order
    button.Parent = MainFrame

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(55, 55, 70)
    stroke.Thickness = 1

    button.MouseButton1Click:Connect(function()
        callback(button, stroke)
    end)

    return button
end

-------------------------------------------------
-- ADDING VERTICAL MENU ITEMS
-------------------------------------------------

-- 1. Aimbot Toggle
local AimBtn = createVerticalButton("Aimbot: OFF", 1, function(btn, stroke)
    Settings.AimbotEnabled = not Settings.AimbotEnabled
    if Settings.AimbotEnabled then
        btn.Text = "Aimbot: ON (Strong)"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(110, 40, 200)
        stroke.Color = Color3.fromRGB(150, 80, 255)
    else
        btn.Text = "Aimbot: OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        stroke.Color = Color3.fromRGB(55, 55, 70)
    end
    FOVCircle.Visible = Settings.AimbotEnabled
end)

-- 2. ESP Toggle
local ESPBtn = createVerticalButton("Arena ESP: OFF", 2, function(btn, stroke)
    Settings.ESPEnabled = not Settings.ESPEnabled
    if Settings.ESPEnabled then
        btn.Text = "Arena ESP: ON"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(110, 40, 200)
        stroke.Color = Color3.fromRGB(150, 80, 255)
    else
        btn.Text = "Arena ESP: OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        stroke.Color = Color3.fromRGB(55, 55, 70)
    end
end)

-- 3. Telegram Channel Link Button
local ChannelBtn = createVerticalButton("Telegram Channel", 3, function(btn, stroke)
    pcall(function()
        if setclipboard then
            setclipboard("https://t.me/+gd0iOFN6h-A1ZWZi")
            btn.Text = "Copied Channel Link!"
            task.wait(1.5)
            btn.Text = "Telegram Channel"
        end
    end)
end)

-- 4. Developer Telegram Username Button
local TelegramUserBtn = createVerticalButton("Dev: @bronoIQ", 4, function(btn, stroke)
    pcall(function()
        if setclipboard then
            setclipboard("@bronoIQ")
            btn.Text = "Copied Username!"
            task.wait(1.5)
            btn.Text = "Dev: @bronoIQ"
        end
    end)
end)

-- Toggle Menu Visibility (إخفاء وإظهار القائمة كاملة من الزر العائم الصورتي)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-------------------------------------------------
-- LOGIC & CLEANUP SYSTEM
-------------------------------------------------
local function removeHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("RolexHighlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

local function getArenaTarget()
    local target = nil
    local shortestDist = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local myPosition = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 and (player.Team == nil or player.Team ~= LocalPlayer.Team) then
                
                local distance = (myPosition - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= Settings.MaxDistance then
                    local targetPart = player.Character:FindFirstChild("Head") or player.Character.HumanoidRootPart
                    local screenPos, isOnScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    
                    if isOnScreen then
                        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if mouseDist < shortestDist then
                            shortestDist = mouseDist
                            target = player
                        end
                    end
                end
            end
        end
    end
    return target
end

-------------------------------------------------
-- MAIN RENDER LOOP (Stronger Aimbot Focus)
-------------------------------------------------
RunService.RenderStepped:Connect(function()
    local centerPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = centerPos

    removeHighlights()

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    local myPosition = LocalPlayer.Character.HumanoidRootPart.Position

    -- ESP Rendering
    if Settings.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 and (player.Team == nil or player.Team ~= LocalPlayer.Team) then
                    local distance = (myPosition - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= Settings.MaxDistance then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "RolexHighlight"
                        highlight.FillColor = Color3.fromRGB(150, 100, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0.2
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = player.Character
                    end
                end
            end
        end
    end

    -- Enhanced Aimbot Lock (أقوى وأسرع في التركيز)
    if Settings.AimbotEnabled then
        local target = getArenaTarget()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
            if aimPart then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPart.Position), Settings.Smoothness)
            end
        end
    end
end)
