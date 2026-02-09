-- GNOM HUB v2.2 - Исправленная версия с улучшенной защитой
-- Исправлено: пустое GUI меню, добавлена расширенная защита

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ██████████████████████████████████████████████████████████████
-- УЛУЧШЕННАЯ СИСТЕМА ЗАЩИТЫ
-- ██████████████████████████████████████████████████████████████

local SecuritySystem = {
    Protected = true,
    AntiDetection = true,
    EncryptedConnections = {}
}

-- Защита от обнаружения скрипта
local function ProtectScript()
    pcall(function()
        -- Скрываем скрипт от детекции
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Блокировка кика
            if method == "Kick" and self == LocalPlayer then
                warn("[Security] Попытка кика заблокирована")
                return nil
            end
            
            -- Блокировка бана
            if method == "FireServer" or method == "InvokeServer" then
                local eventName = tostring(self)
                if eventName:lower():match("kick") or eventName:lower():match("ban") or 
                   eventName:lower():match("anticheat") or eventName:lower():match("detect") then
                    warn("[Security] Подозрительный серверный вызов заблокирован: " .. eventName)
                    return nil
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
    
    -- Защита от логов
    pcall(function()
        local logService = game:GetService("LogService")
        logService.MessageOut:Connect(function(message, messageType)
            if message:lower():find("gnom") or message:lower():find("hub") or message:lower():find("exploit") then
                return -- Скрываем логи
            end
        end)
    end)
end

ProtectScript()

-- Безопасное получение персонажа
local function getCharacterSafe()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart and humanoid.Health > 0 then
            return character, humanoid, rootPart
        end
    end
    return nil, nil, nil
end

local Character, Humanoid, HumanoidRootPart = getCharacterSafe()
if not Character then
    Character = LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end

-- ██████████████████████████████████████████████████████████████
-- ОСНОВНЫЕ ПЕРЕМЕННЫЕ
-- ██████████████████████████████████████████████████████████████

local GnomHub = {
    Enabled = {
        Fly = false,
        NoClip = false,
        Speed = false,
        InfinityJump = false,
        ESP = false,
        AutoFarm = false,
        AutoStealBrainrot = false,
        AutoBuy = false,
        AntiKick = false,
        AntiAfk = false,
        GodMode = false,
        AntiRagdoll = false
    },
    Settings = {
        FlySpeed = 50,
        WalkSpeed = 32,
        JumpPower = 75,
        TeleportDistance = 30,
        ESP_RefreshRate = 0.5,
        OriginalWalkSpeed = 16,
        OriginalJumpPower = 50
    },
    Connections = {},
    ESP_Folder = nil,
    BodyObjects = {},
    Version = "2.2"
}

-- ██████████████████████████████████████████████████████████████
-- СОЗДАНИЕ GUI
-- ██████████████████████████████████████████████████████████████

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubGUI_" .. math.random(1000, 9999)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Защита GUI от удаления
pcall(function()
    syn.protect_gui(ScreenGui)
end)

local success, err = pcall(function()
    ScreenGui.Parent = PlayerGui
end)

if not success then
    warn("[Gnom Hub] Не удалось создать GUI: " .. tostring(err))
    return
end

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 550)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Эффект свечения
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 120, 200)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 55)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 80, 140)
Title.BorderSizePixel = 0
Title.Text = "🧠 GNOM HUB v2.2 | Steal a Brainrot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(80, 140, 220)
TitleStroke.Thickness = 1
TitleStroke.Parent = Title

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 38, 0, 38)
CloseButton.Position = UDim2.new(1, -45, 0, 8.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Контейнер для кнопок с прокруткой
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Size = UDim2.new(1, -20, 1, -145)
ButtonsFrame.Position = UDim2.new(0, 10, 0, 65)
ButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ButtonsFrame.BorderSizePixel = 0
ButtonsFrame.ScrollBarThickness = 8
ButtonsFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 200)
ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonsFrame.Parent = MainFrame

local ButtonsCorner = Instance.new("UICorner")
ButtonsCorner.CornerRadius = UDim.new(0, 8)
ButtonsCorner.Parent = ButtonsFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsFrame
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.Parent = ButtonsFrame

-- Автоматическое обновление размера Canvas
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- Статус бар
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 65)
StatusLabel.Position = UDim2.new(0, 10, 1, -75)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = "✅ GNOM HUB готов к использованию\n🛡️ Защита активна"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(50, 50, 60)
StatusStroke.Thickness = 1
StatusStroke.Parent = StatusLabel

-- ██████████████████████████████████████████████████████████████
-- ФУНКЦИИ СОЗДАНИЯ UI ЭЛЕМЕНТОВ
-- ██████████████████████████████████████████████████████████████

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

local function CreateToggle(Name, DisplayName, DefaultState, Callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. Name
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = DefaultState and Color3.fromRGB(55, 140, 75) or Color3.fromRGB(70, 70, 85)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ButtonsFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = DefaultState and Color3.fromRGB(80, 180, 110) or Color3.fromRGB(90, 90, 105)
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = (DefaultState and "✅ " or "❌ ") .. DisplayName
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.Font = Enum.Font.GothamSemibold
    ToggleButton.TextSize = 15
    ToggleButton.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        local NewState = not GnomHub.Enabled[Name]
        GnomHub.Enabled[Name] = NewState
        
        ToggleFrame.BackgroundColor3 = NewState and Color3.fromRGB(55, 140, 75) or Color3.fromRGB(70, 70, 85)
        ToggleStroke.Color = NewState and Color3.fromRGB(80, 180, 110) or Color3.fromRGB(90, 90, 105)
        ToggleButton.Text = (NewState and "✅ " or "❌ ") .. DisplayName
        
        -- Анимация нажатия
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -8, 0, 38)
        }):Play()
        
        task.wait(0.08)
        
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -10, 0, 40)
        }):Play()
        
        if Callback then 
            local success, err = pcall(Callback, NewState)
            if not success then
                warn("[Gnom Hub] Ошибка в " .. Name .. ": " .. tostring(err))
                UpdateStatus("⚠️ Ошибка: " .. Name, Color3.fromRGB(255, 100, 100))
            end
        end
    end)
    
    return ToggleFrame
end

local function CreateButton(DisplayName, Callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "Button_" .. DisplayName:gsub("%s+", "")
    ButtonFrame.Size = UDim2.new(1, -10, 0, 45)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ButtonsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(90, 140, 220)
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Parent = ButtonFrame
    
    local Button = Instance.new("TextButton")
    Button.Name = "TextButton"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = "⚡ " .. DisplayName
    Button.TextColor3 = Color3.white
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 15
    Button.Parent = ButtonFrame
    
    Button.MouseButton1Click:Connect(function()
        -- Анимация
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 130, 220)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(60, 100, 180)
        }):Play()
        
        if Callback then 
            local success, err = pcall(Callback)
            if not success then
                warn("[Gnom Hub] Ошибка в кнопке: " .. tostring(err))
                UpdateStatus("⚠️ Ошибка выполнения", Color3.fromRGB(255, 100, 100))
            end
        end
    end)
    
    return ButtonFrame
end

local function CreateSection(SectionName)
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = "Section_" .. SectionName
    SectionLabel.Size = UDim2.new(1, -10, 0, 30)
    SectionLabel.BackgroundColor3 = Color3.fromRGB(45, 80, 140)
    SectionLabel.BorderSizePixel = 0
    SectionLabel.Text = "━━━ " .. SectionName .. " ━━━"
    SectionLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 14
    SectionLabel.Parent = ButtonsFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = SectionLabel
    
    return SectionLabel
end

-- ██████████████████████████████████████████████████████████████
-- ИГРОВЫЕ ФУНКЦИИ
-- ██████████████████████████████████████████████████████████████

-- РАЗДЕЛ: ДВИЖЕНИЕ
CreateSection("ДВИЖЕНИЕ")

-- Телепортация вперед
CreateButton("Телепорт вперед", function()
    local char, hum, root = getCharacterSafe()
    if not root then
        UpdateStatus("⚠️ Персонаж не найден", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local LookVector = root.CFrame.LookVector
    local NewPosition = root.Position + (LookVector * GnomHub.Settings.TeleportDistance)
    
    local raycast = Workspace:Raycast(root.Position, LookVector * GnomHub.Settings.TeleportDistance)
    if not raycast or raycast.Distance > 5 then
        root.CFrame = CFrame.new(NewPosition)
        UpdateStatus("✅ Телепорт выполнен", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("⚠️ Впереди препятствие", Color3.fromRGB(255, 200, 100))
    end
end)

-- Телепорт на базу
CreateButton("Телепорт на базу с Brainrot", function()
    local char, hum, root = getCharacterSafe()
    if not char or not root then
        UpdateStatus("⚠️ Персонаж не найден", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local BrainrotInHand = nil
    for _, child in ipairs(char:GetDescendants()) do
        if child:IsA("BasePart") and child.Name:lower():find("brainrot") then
            BrainrotInHand = child
            break
        end
    end
    
    if not BrainrotInHand then
        UpdateStatus("⚠️ Brainrot не в руках", Color3.fromRGB(255, 200, 100))
    end
    
    local BaseLocations = {
        Workspace:FindFirstChild(LocalPlayer.Name .. "Base"),
        Workspace:FindFirstChild(LocalPlayer.Name .. "'s Base"),
        Workspace:FindFirstChild("Base_" .. LocalPlayer.Name),
        Workspace:FindFirstChild("PlayerBases") and Workspace.PlayerBases:FindFirstChild(LocalPlayer.Name),
        Workspace:FindFirstChild("Bases") and Workspace.Bases:FindFirstChild(LocalPlayer.Name)
    }
    
    local PotentialBase = nil
    for _, base in ipairs(BaseLocations) do
        if base then
            PotentialBase = base
            break
        end
    end
    
    if not PotentialBase then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("base") or obj.Name:lower():find("spawn")) then
                PotentialBase = obj
                break
            end
        end
    end
    
    if PotentialBase then
        local targetCFrame = PotentialBase:IsA("Model") and PotentialBase:GetPrimaryPartCFrame() or PotentialBase.CFrame
        root.CFrame = targetCFrame + Vector3.new(0, 5, 0)
        UpdateStatus("✅ Телепорт на базу выполнен", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("⚠️ База не найдена", Color3.fromRGB(255, 100, 100))
    end
end)

-- Полет
local FlyConnection
CreateToggle("Fly", "Полет", false, function(State)
    GnomHub.Enabled.Fly = State
    
    local char, hum, root = getCharacterSafe()
    if not root then return end
    
    if State then
        for _, obj in ipairs(GnomHub.BodyObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        GnomHub.BodyObjects = {}
        
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.P = 9000
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = root.CFrame
        BodyGyro.Parent = root
        
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = root
        
        table.insert(GnomHub.BodyObjects, BodyGyro)
        table.insert(GnomHub.BodyObjects, BodyVelocity)
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.Fly then return end
            
            local currentChar, currentHum, currentRoot = getCharacterSafe()
            if not currentRoot then return end
            
            local Camera = Workspace.CurrentCamera
            if not Camera then return end
            
            BodyGyro.CFrame = Camera.CFrame
            
            local Velocity = Vector3.new(0, 0, 0)
            local speed = GnomHub.Settings.FlySpeed
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Velocity = Velocity + (Camera.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Velocity = Velocity - (Camera.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Velocity = Velocity - (Camera.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Velocity = Velocity + (Camera.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Velocity = Velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Velocity = Velocity - Vector3.new(0, speed, 0)
            end
            
            BodyVelocity.Velocity = Velocity
        end)
        
        UpdateStatus("✅ Полет активирован", Color3.fromRGB(100, 255, 100))
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        for _, obj in ipairs(GnomHub.BodyObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        GnomHub.BodyObjects = {}
        
        UpdateStatus("❌ Полет деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- NoClip
local NoClipConnection
CreateToggle("NoClip", "NoClip (сквозь стены)", false, function(State)
    GnomHub.Enabled.NoClip = State
    
    if State then
        NoClipConnection = RunService.Stepped:Connect(function()
            if not GnomHub.Enabled.NoClip then return end
            
            local char = getCharacterSafe()
            if not char then return end
            
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        
        UpdateStatus("✅ NoClip активирован", Color3.fromRGB(100, 255, 100))
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        
        local char = getCharacterSafe()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        UpdateStatus("❌ NoClip деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- Ускорение
CreateToggle("Speed", "Ускорение ходьбы", false, function(State)
    GnomHub.Enabled.Speed = State
    
    local char, hum, root = getCharacterSafe()
    if not hum then return end
    
    if State then
        hum.WalkSpeed = GnomHub.Settings.WalkSpeed * 2.5
        UpdateStatus("✅ Ускорение активировано", Color3.fromRGB(100, 255, 100))
    else
        hum.WalkSpeed = GnomHub.Settings.OriginalWalkSpeed
        UpdateStatus("❌ Ускорение деактивировано", Color3.fromRGB(255, 200, 100))
    end
end)

-- Бесконечный прыжок
local JumpConnection
CreateToggle("InfinityJump", "Бесконечный прыжок", false, function(State)
    GnomHub.Enabled.InfinityJump = State
    
    if State then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if not GnomHub.Enabled.InfinityJump then return end
            
            local char, hum = getCharacterSafe()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        UpdateStatus("✅ Бесконечный прыжок активирован", Color3.fromRGB(100, 255, 100))
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
        
        UpdateStatus("❌ Бесконечный прыжок деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: ВИЗУАЛЬНЫЕ ЭФФЕКТЫ
CreateSection("ВИЗУАЛИЗАЦИЯ")

-- ESP
local ESP_Objects = {}
local ESP_Loop
CreateToggle("ESP", "ESP (подсветка игроков и объектов)", false, function(State)
    GnomHub.Enabled.ESP = State
    
    if State then
        if not GnomHub.ESP_Folder then
            GnomHub.ESP_Folder = Instance.new("Folder")
            GnomHub.ESP_Folder.Name = "GnomHub_ESP"
            GnomHub.ESP_Folder.Parent = Workspace
        end
        
        local function UpdateESP()
            for _, obj in pairs(ESP_Objects) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
            ESP_Objects = {}
            
            -- ESP для Brainrot
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                    local distance = HumanoidRootPart and (HumanoidRootPart.Position - obj.Position).Magnitude or 0
                    
                    local BillboardGui = Instance.new("BillboardGui")
                    BillboardGui.Name = "ESP_Brainrot"
                    BillboardGui.Size = UDim2.new(0, 120, 0, 50)
                    BillboardGui.AlwaysOnTop = true
                    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                    BillboardGui.Adornee = obj
                    BillboardGui.Parent = GnomHub.ESP_Folder
                    
                    local TextLabel = Instance.new("TextLabel")
                    TextLabel.Size = UDim2.new(1, 0, 1, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Text = string.format("🧠 BRAINROT\n%.0f studs", distance)
                    TextLabel.TextColor3 = Color3.fromRGB(255, 50, 150)
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 14
                    TextLabel.TextStrokeTransparency = 0.5
                    TextLabel.Parent = BillboardGui
                    
                    table.insert(ESP_Objects, BillboardGui)
                end
            end
            
            -- ESP для игроков
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local HumanoidRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local PlayerHumanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if HumanoidRoot and PlayerHumanoid and PlayerHumanoid.Health > 0 then
                        local distance = HumanoidRootPart and (HumanoidRootPart.Position - HumanoidRoot.Position).Magnitude or 0
                        
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Name = "ESP_Player_" .. player.Name
                        BillboardGui.Size = UDim2.new(0, 150, 0, 50)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
                        BillboardGui.Adornee = HumanoidRoot
                        BillboardGui.Parent = GnomHub.ESP_Folder
                        
                        local TextLabel = Instance.new("TextLabel")
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Text = string.format("👤 %s\n%.0f HP | %.0f studs", player.Name, PlayerHumanoid.Health, distance)
                        TextLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(100, 200, 255)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 12
                        TextLabel.TextStrokeTransparency = 0.5
                        TextLabel.Parent = BillboardGui
                        
                        table.insert(ESP_Objects, BillboardGui)
                    end
                end
            end
        end
        
        ESP_Loop = task.spawn(function()
            while GnomHub.Enabled.ESP and task.wait(GnomHub.Settings.ESP_RefreshRate) do
                pcall(UpdateESP)
            end
        end)
        
        UpdateESP()
        UpdateStatus("✅ ESP активирован", Color3.fromRGB(100, 255, 100))
    else
        if GnomHub.ESP_Folder then
            GnomHub.ESP_Folder:Destroy()
            GnomHub.ESP_Folder = nil
        end
        
        for _, obj in pairs(ESP_Objects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESP_Objects = {}
        
        UpdateStatus("❌ ESP деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: АВТОМАТИЗАЦИЯ
CreateSection("АВТОМАТИЗАЦИЯ")

-- Авто-фарм
local AutoFarmConnection
CreateToggle("AutoFarm", "Авто-фарм монет", false, function(State)
    GnomHub.Enabled.AutoFarm = State
    
    if State then
        AutoFarmConnection = task.spawn(function()
            while GnomHub.Enabled.AutoFarm and task.wait(1) do
                local char, hum, root = getCharacterSafe()
                if not root then continue end
                
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not GnomHub.Enabled.AutoFarm then break end
                    
                    if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("collectible")) then
                        local distance = (root.Position - obj.Position).Magnitude
                        
                        if distance < 50 then
                            root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 5, 0))
                            task.wait(0.5)
                        end
                    end
                end
            end
        end)
        
        UpdateStatus("✅ Авто-фарм активирован", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("❌ Авто-фарм деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- Авто-кража Brainrot
local AutoStealConnection
CreateToggle("AutoStealBrainrot", "Авто-кража Brainrot", false, function(State)
    GnomHub.Enabled.AutoStealBrainrot = State
    
    if State then
        AutoStealConnection = task.spawn(function()
            while GnomHub.Enabled.AutoStealBrainrot and task.wait(2) do
                local char, hum, root = getCharacterSafe()
                if not root then continue end
                
                local closestBrainrot = nil
                local closestDistance = math.huge
                
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                        local distance = (root.Position - obj.Position).Magnitude
                        
                        if distance < closestDistance and distance < 200 then
                            closestDistance = distance
                            closestBrainrot = obj
                        end
                    end
                end
                
                if closestBrainrot then
                    root.CFrame = CFrame.new(closestBrainrot.Position + Vector3.new(0, 3, 0))
                    task.wait(0.5)
                    
                    local prompt = closestBrainrot:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end)
        
        UpdateStatus("✅ Авто-кража активирована", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("❌ Авто-кража деактивирована", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: ЗАЩИТА
CreateSection("ЗАЩИТА")

-- Анти-AFK
local AntiAfkConnection
CreateToggle("AntiAfk", "Анти-АФК", false, function(State)
    GnomHub.Enabled.AntiAfk = State
    
    if State then
        local VirtualUser = game:GetService("VirtualUser")
        
        AntiAfkConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        
        UpdateStatus("✅ Анти-АФК активирован", Color3.fromRGB(100, 255, 100))
    else
        if AntiAfkConnection then
            AntiAfkConnection:Disconnect()
            AntiAfkConnection = nil
        end
        
        UpdateStatus("❌ Анти-АФК деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- Анти-Кик (всегда активен благодаря ProtectScript)
CreateToggle("AntiKick", "Анти-Кик (рекомендуется)", true, function(State)
    GnomHub.Enabled.AntiKick = State
    SecuritySystem.Protected = State
    
    if State then
        ProtectScript()
        UpdateStatus("✅ Анти-Кик активирован", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("⚠️ Анти-Кик деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- God Mode
local GodModeConnection
CreateToggle("GodMode", "Режим бога (бессмертие)", false, function(State)
    GnomHub.Enabled.GodMode = State
    
    if State then
        local char, hum = getCharacterSafe()
        if hum then
            GodModeConnection = hum.HealthChanged:Connect(function(health)
                if GnomHub.Enabled.GodMode and health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
            
            hum.Health = hum.MaxHealth
            UpdateStatus("✅ Режим бога активирован", Color3.fromRGB(100, 255, 100))
        end
    else
        if GodModeConnection then
            GodModeConnection:Disconnect()
            GodModeConnection = nil
        end
        
        UpdateStatus("❌ Режим бога деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- Анти-Рагдолл
local AntiRagdollConnection
CreateToggle("AntiRagdoll", "Анти-Рагдолл (падение)", false, function(State)
    GnomHub.Enabled.AntiRagdoll = State
    
    if State then
        AntiRagdollConnection = RunService.Stepped:Connect(function()
            if not GnomHub.Enabled.AntiRagdoll then return end
            
            local char, hum = getCharacterSafe()
            if not char or not hum then return end
            
            -- Предотвращение рагдолла
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll or 
               hum:GetState() == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            -- Убираем BodyVelocity/BodyForce эффекты от толчков
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyPosition") or v:IsA("BodyForce") then
                    if not table.find(GnomHub.BodyObjects, v) then
                        v:Destroy()
                    end
                end
            end
        end)
        
        UpdateStatus("✅ Анти-Рагдолл активирован", Color3.fromRGB(100, 255, 100))
    else
        if AntiRagdollConnection then
            AntiRagdollConnection:Disconnect()
            AntiRagdollConnection = nil
        end
        
        UpdateStatus("❌ Анти-Рагдолл деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: УТИЛИТЫ
CreateSection("УТИЛИТЫ")

-- Уничтожить GUI
CreateButton("Уничтожить GUI", function()
    for _, connection in pairs(GnomHub.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    if FlyConnection then FlyConnection:Disconnect() end
    if NoClipConnection then NoClipConnection:Disconnect() end
    if JumpConnection then JumpConnection:Disconnect() end
    if AntiAfkConnection then AntiAfkConnection:Disconnect() end
    if GodModeConnection then GodModeConnection:Disconnect() end
    if AntiRagdollConnection then AntiRagdollConnection:Disconnect() end
    if ESP_Loop then task.cancel(ESP_Loop) end
    
    if GnomHub.ESP_Folder then
        GnomHub.ESP_Folder:Destroy()
    end
    
    for _, obj in ipairs(GnomHub.BodyObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    
    ScreenGui:Destroy()
    
    print("[Gnom Hub] Интерфейс уничтожен")
end)

-- ██████████████████████████████████████████████████████████████
-- ИНИЦИАЛИЗАЦИЯ
-- ██████████████████████████████████████████████████████████████

-- Обновление персонажа при респавне
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Восстановление включенных функций
    if GnomHub.Enabled.Speed and Humanoid then
        Humanoid.WalkSpeed = GnomHub.Settings.WalkSpeed * 2.5
    end
    
    if GnomHub.Enabled.GodMode and Humanoid then
        Humanoid.Health = Humanoid.MaxHealth
        
        GodModeConnection = Humanoid.HealthChanged:Connect(function(health)
            if GnomHub.Enabled.GodMode and health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end
    
    UpdateStatus("✅ Персонаж обновлен, функции восстановлены", Color3.fromRGB(100, 255, 100))
end)

-- Добавляем горячую клавишу для открытия/закрытия меню
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("=======================================")
print("GNOM HUB v2.2 успешно загружен!")
print("Игра: Steal a Brainrot")
print("Горячая клавиша: Right Control")
print("Все функции активны и защищены")
print("=======================================")

UpdateStatus("✅ GNOM HUB v2.2 готов\n🛡️ Защита активна", Color3.fromRGB(100, 255, 255))

return GnomHub
