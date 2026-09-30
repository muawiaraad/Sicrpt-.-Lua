-- ===============================================
-- Custom Aimbot & Distance ESP Hub
-- ===============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إعدادات السكربت
local AimbotEnabled = false
local ESPEnabled = false
local MaxDistance = 150 -- أقصى مسافة للكشف والآيم (لتجاهل اللابي وإظهار حلبة القتال فقط)
local FOVRadius = 120
local Smoothness = 0.08

-- إنشاء زر وصورة دائرة الـ FOV
local FOVCircle = Drawing.new("Image")
FOVCircle.Size = Vector2.new(FOVRadius * 2, FOVRadius * 2)
FOVCircle.Data = game:HttpGet("https://i.imgur.com/vHqY7Z9.png") -- رابط الصورة المرفقة
FOVCircle.Visible = false

-- إنشاء الواجهة الرسومية (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyPrivateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- زر فتح وإغلاق القائمة (Toggle Menu Button)
local MenuToggleBtn = Instance.new("TextButton")
MenuToggleBtn.Size = UDim2.new(0, 50, 0, 50)
MenuToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
MenuToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuToggleBtn.Text = "📜"
MenuToggleBtn.TextSize = 22
MenuToggleBtn.Draggable = true
MenuToggleBtn.Parent = ScreenGui

local MenuUICorner = Instance.new("UICorner", MenuToggleBtn)
MenuUICorner.CornerRadius = UDim.new(0, 10)

-- الإطار الرئيسي للقائمة
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.08, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PRIVATE HUB"
Title.TextColor3 = Color3.fromRGB(150, 100, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- زر تشغيل/إيقاف الآيم بوت
local AimBtn = Instance.new("TextButton")
AimBtn.Size = UDim2.new(0.85, 0, 0, 40)
AimBtn.Position = UDim2.new(0.075, 0, 0.28, 0)
AimBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
AimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBtn.Text = "Aimbot: OFF"
AimBtn.Font = Enum.Font.SourceSansBold
AimBtn.TextSize = 14
AimBtn.Parent = MainFrame
Instance.new("UICorner", AimBtn).CornerRadius = UDim.new(0, 8)

-- زر تشغيل/إيقاف كشف الجدران (Distance ESP)
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.85, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.075, 0, 0.58, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Text = "Arena ESP: OFF"
ESPBtn.Font = Enum.Font.SourceSansBold
ESPBtn.TextSize = 14
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 8)

-- فتح وإغلاق القائمة عند الضغط على زر الأيقونة
MenuToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- تفعيل / تعطيل الآيم
AimBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 40, 40)
    AimBtn.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    FOVCircle.Visible = AimbotEnabled
end)

-- تفعيل / تعطيل الـ ESP
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 40, 40)
    ESPBtn.Text = ESPEnabled and "Arena ESP: ON" or "Arena ESP: OFF"
end)

local Highlights = {}

local function clearHighlights()
    for _, h in pairs(Highlights) do
        if h then h:Destroy() end
    end
    Highlights = {}
end

-- البحث عن أقرب هدف في حدود الحلبة حصراً (بشرط المسافة)
local function getArenaTarget()
    local target, dist = nil, FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") then
            if (v.Team == nil or v.Team ~= LocalPlayer.Team) and v.Character.Humanoid.Health > 0 then
                
                -- شرط المسافة (تجاهل لاعبي اللابي البعيدين)
                local playerDist = (myPos - v.Character.HumanoidRootPart.Position).Magnitude
                if playerDist <= MaxDistance then
                    
                    local part = v.Character:FindFirstChild("Head") or v.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    
                    if onScreen then
                        local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if screenDist < dist then
                            dist = screenDist
                            target = v
                        end
                    end
                end
            end
        end
    end
    return target
end

-- التحديث المستمر
RunService.RenderStepped:Connect(function()
    -- تحديث موقع صورة الـ FOV في المنتصف
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center - Vector2.new(FOVRadius, FOVRadius)

    clearHighlights()

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    -- تحديث الـ ESP للاعبين القريبين داخل الحلبة فقط
    if ESPEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") then
                if (v.Team == nil or v.Team ~= LocalPlayer.Team) and v.Character.Humanoid.Health > 0 then
                    local pDist = (myPos - v.Character.HumanoidRootPart.Position).Magnitude
                    if pDist <= MaxDistance then
                        local h = Instance.new("Highlight")
                        h.FillColor = Color3.fromRGB(255, 0, 100)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = v.Character
                        table.insert(Highlights, h)
                    end
                end
            end
        end
    end

    -- تحديث الآيم بوت
    if AimbotEnabled then
        local target = getArenaTarget()
        if target and target.Character then
            local p = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
            if p then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, p.Position), Smoothness)
            end
        end
    end
end)
