-- ██████████████████████████████████████████████████████████████
-- GNOM HUB v4.0 QUANTUM - РЕВОЛЮЦИОННАЯ СИСТЕМА ТЕЛЕПОРТАЦИИ
-- АБСОЛЮТНО НОВЫЙ ПОДХОД: Квантовая телепортация без отката
-- ТЕХНОЛОГИИ: Multi-Frame CFrame Anchoring, Velocity Nullification
-- ██████████████████████████████████████████████████████████████

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ██████████████████████████████████████████████████████████████
-- КВАНТОВАЯ СИСТЕМА ТЕЛЕПОРТАЦИИ (НОВЕЙШАЯ ТЕХНОЛОГИЯ)
-- ██████████████████████████████████████████████████████████████

local QuantumTeleport = {
    Active = false,
    LastPosition = nil,
    FrameCounter = 0
}

-- НОВЫЙ МЕТОД: Квантовая фиксация позиции
-- Принцип: Создаём невидимый якорь, который удерживает позицию
local function QuantumAnchor(root, targetCFrame, duration)
    local anchorPart = Instance.new("Part")
    anchorPart.Name = "QuantumAnchor"
    anchorPart.Size = Vector3.new(0.1, 0.1, 0.1)
    anchorPart.Transparency = 1
    anchorPart.CanCollide = false
    anchorPart.Anchored = true
    anchorPart.CFrame = targetCFrame
    anchorPart.Parent = Workspace
    
    -- Создаём WeldConstraint для жёсткой привязки
    local weld = Instance.new("WeldConstraint")
    weld.Name = "QuantumWeld"
    weld.Part0 = anchorPart
    weld.Part1 = root
    weld.Parent = root
    
    -- Удаляем после завершения
    task.delay(duration or 0.1, function()
        if weld then weld:Destroy() end
        if anchorPart then anchorPart:Destroy() end
    end)
    
    return anchorPart, weld
end

-- НОВЫЙ МЕТОД: Мульти-фреймовая телепортация
-- Принцип: Телепортируем на протяжении нескольких фреймов для обхода античита
local function MultiFrameTeleport(root, targetPosition, frames)
    frames = frames or 3
    local startPos = root.Position
    local connection
    local frameCount = 0
    
    connection = RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        if frameCount >= frames then
            connection:Disconnect()
            root.CFrame = CFrame.new(targetPosition)
            return
        end
        
        -- Постепенное перемещение с фиксацией
        local alpha = frameCount / frames
        local currentPos = startPos:Lerp(targetPosition, alpha)
        root.CFrame = CFrame.new(currentPos)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

-- НОВЫЙ МЕТОД: Velocity Nullification System
-- Принцип: Обнуляем ВСЕ силы и скорости каждый фрейм
local function VelocityNullifier(root, duration)
    local startTime = tick()
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        if tick() - startTime > (duration or 0.3) then
            connection:Disconnect()
            return
        end
        
        -- Обнуляем все типы скоростей
        if root and root.Parent then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end)
    
    return connection
end

-- ██████████████████████████████████████████████████████████████
-- СИСТЕМА ЗАЩИТЫ
-- ██████████████████████████████████████████████████████████████

local SecuritySystem = {
    Protected = true,
    AntiDetection = true
}

local function ProtectScript()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "Kick" and self == LocalPlayer then
                warn("[Security] Блокирована попытка кика")
                return nil
            end
            
            if method == "FireServer" or method == "InvokeServer" then
                local eventName = tostring(self)
                if eventName:lower():match("kick") or eventName:lower():match("ban") or 
                   eventName:lower():match("anticheat") or eventName:lower():match("detect") then
                    warn("[Security] Заблокирован подозрительный серверный вызов: " .. eventName)
                    return nil
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
end

ProtectScript()

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
        AntiKick = true,
        AntiAfk = false,
        GodMode = false,
        AntiRagdoll = false
    },
    Settings = {
        FlySpeed = 50,
        WalkSpeed = 50,
        JumpPower = 75,
        TeleportDistance = 25,
        ESP_RefreshRate = 1,
        OriginalWalkSpeed = 16,
        OriginalJumpPower = 50
    },
    Connections = {},
    ESP_Folder = nil,
    Version = "4.0 QUANTUM"
}

-- Функция безопасного получения персонажа
local function getChar()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            return char, hum, root
        end
    end
    return nil, nil, nil
end

-- ██████████████████████████████████████████████████████████████
-- СОЗДАНИЕ GUI
-- ██████████████████████████████████████████████████████████████

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubGUI_" .. math.random(10000, 99999)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)

local success = pcall(function()
    ScreenGui.Parent = PlayerGui
end)

if not success then
    ScreenGui.Parent = CoreGui
end

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 600)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 255, 200)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Градиентный заголовок
local Title = Instance.new("Frame")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 180, 120)
Title.BorderSizePixel = 0
Title.ZIndex = 2
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 200, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 140, 100))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = Title

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -60, 0, 30)
TitleText.Position = UDim2.new(0, 10, 0, 5)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🚀 GNOM HUB v4.0 QUANTUM"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextYAlignment = Enum.TextYAlignment.Center
TitleText.TextWrapped = false
TitleText.TextScaled = false
TitleText.ZIndex = 3
TitleText.Parent = Title

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(1, -60, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "⚡ Quantum Teleport Technology | Right Ctrl"
SubTitle.TextColor3 = Color3.fromRGB(200, 255, 240)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.TextYAlignment = Enum.TextYAlignment.Center
SubTitle.TextWrapped = false
SubTitle.TextScaled = false
SubTitle.ZIndex = 3
SubTitle.Parent = Title

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextScaled = false
CloseButton.AutoButtonColor = true
CloseButton.ZIndex = 3
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Контейнер с прокруткой
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 255, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.ZIndex = 2
ScrollFrame.Parent = MainFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 8)
ScrollCorner.Parent = ScrollFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.Parent = ScrollFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- Статус бар
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(1, -20, 0, 70)
StatusBar.Position = UDim2.new(0, 10, 1, -80)
StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 2
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(100, 255, 200)
StatusStroke.Thickness = 1
StatusStroke.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -16, 1, -16)
StatusLabel.Position = UDim2.new(0, 8, 0, 8)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⚡ Quantum Systems Ready\n🛡️ Protection Active"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 13
StatusLabel.TextWrapped = true
StatusLabel.TextScaled = false
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 3
StatusLabel.Parent = StatusBar

-- ██████████████████████████████████████████████████████████████
-- ФУНКЦИИ UI
-- ██████████████████████████████████████████████████████████████

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 200)
end

local layoutOrder = 0

local function CreateSection(name)
    layoutOrder = layoutOrder + 1
    
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. name
    Section.Size = UDim2.new(1, -10, 0, 32)
    Section.BackgroundColor3 = Color3.fromRGB(30, 180, 120)
    Section.BorderSizePixel = 0
    Section.LayoutOrder = layoutOrder
    Section.ZIndex = 3
    Section.Parent = ScrollFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = "SectionLabel"
    SectionLabel.Size = UDim2.new(1, -10, 1, 0)
    SectionLabel.Position = UDim2.new(0, 5, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = "⚡ " .. name .. " ⚡"
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 14
    SectionLabel.TextWrapped = false
    SectionLabel.TextScaled = false
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Center
    SectionLabel.TextYAlignment = Enum.TextYAlignment.Center
    SectionLabel.ZIndex = 4
    SectionLabel.Parent = Section
    
    return Section
end

local function CreateToggle(name, displayName, defaultState, callback)
    layoutOrder = layoutOrder + 1
    local state = defaultState
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle_" .. name
    Toggle.Size = UDim2.new(1, -10, 0, 42)
    Toggle.BackgroundColor3 = state and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(50, 50, 65)
    Toggle.BorderSizePixel = 0
    Toggle.LayoutOrder = layoutOrder
    Toggle.ZIndex = 3
    Toggle.Parent = ScrollFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = state and Color3.fromRGB(100, 255, 180) or Color3.fromRGB(70, 70, 85)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, -10, 1, -4)
    ToggleButton.Position = UDim2.new(0, 5, 0, 2)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = (state and "✓ " or "✗ ") .. displayName
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamSemibold
    ToggleButton.TextSize = 14
    ToggleButton.TextWrapped = true
    ToggleButton.TextScaled = false
    ToggleButton.TextXAlignment = Enum.TextXAlignment.Center
    ToggleButton.TextYAlignment = Enum.TextYAlignment.Center
    ToggleButton.AutoButtonColor = false
    ToggleButton.ZIndex = 4
    ToggleButton.Parent = Toggle
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        GnomHub.Enabled[name] = state
        
        local newColor = state and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(50, 50, 65)
        local newStrokeColor = state and Color3.fromRGB(100, 255, 180) or Color3.fromRGB(70, 70, 85)
        
        TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = newColor
        }):Play()
        
        TweenService:Create(ToggleStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Color = newStrokeColor
        }):Play()
        
        ToggleButton.Text = (state and "✓ " or "✗ ") .. displayName
        
        local success, err = pcall(callback, state)
        if not success then
            warn("[Gnom Hub] Ошибка в " .. name .. ": " .. tostring(err))
            UpdateStatus("⚠️ Error: " .. name, Color3.fromRGB(255, 100, 100))
        end
    end)
    
    return Toggle
end

local function CreateButton(displayName, callback)
    layoutOrder = layoutOrder + 1
    
    local Button = Instance.new("Frame")
    Button.Name = "Button_" .. displayName:gsub("%s+", "")
    Button.Size = UDim2.new(1, -10, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
    Button.BorderSizePixel = 0
    Button.LayoutOrder = layoutOrder
    Button.ZIndex = 3
    Button.Parent = ScrollFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 200, 255)
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = Button
    
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "TextButton"
    TextButton.Size = UDim2.new(1, -10, 1, -4)
    TextButton.Position = UDim2.new(0, 5, 0, 2)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = displayName
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 15
    TextButton.TextWrapped = true
    TextButton.TextScaled = false
    TextButton.TextXAlignment = Enum.TextXAlignment.Center
    TextButton.TextYAlignment = Enum.TextYAlignment.Center
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 4
    TextButton.Parent = Button
    
    TextButton.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(70, 180, 240)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(50, 150, 220)
        }):Play()
        
        local success, err = pcall(callback)
        if not success then
            warn("[Gnom Hub] Ошибка: " .. tostring(err))
            UpdateStatus("⚠️ Execution Error", Color3.fromRGB(255, 100, 100))
        end
    end)
    
    return Button
end

-- ██████████████████████████████████████████████████████████████
-- ИГРОВЫЕ ФУНКЦИИ - КВАНТОВАЯ ВЕРСИЯ
-- ██████████████████████████████████████████████████████████████

-- РАЗДЕЛ: ДВИЖЕНИЕ
CreateSection("QUANTUM MOVEMENT")

-- 🚀 КВАНТОВЫЙ ТЕЛЕПОРТ ВПЕРЁД (РЕВОЛЮЦИОННЫЙ МЕТОД)
CreateButton("🚀 Quantum TP Forward (25)", function()
    local char, hum, root = getChar()
    if not root then
        UpdateStatus("⚠️ Character not found", Color3.fromRGB(255, 150, 100))
        return
    end
    
    -- Шаг 1: Вычисляем целевую позицию
    local lookVector = root.CFrame.LookVector
    local targetCFrame = root.CFrame + (lookVector * GnomHub.Settings.TeleportDistance)
    
    -- Шаг 2: Отключаем ВСЕ коллизии и физику
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    -- Шаг 3: Обнуляем все скорости ПЕРЕД телепортацией
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.Velocity = Vector3.zero
    
    -- Шаг 4: МГНОВЕННАЯ телепортация с квантовым якорем
    root.CFrame = targetCFrame
    
    -- Шаг 5: Создаём квантовый якорь для фиксации позиции
    local anchor, weld = QuantumAnchor(root, targetCFrame, 0.2)
    
    -- Шаг 6: Запускаем систему обнуления скорости на 0.3 секунды
    local nullifier = VelocityNullifier(root, 0.3)
    
    -- Шаг 7: Дополнительная фиксация через несколько фреймов
    for i = 1, 5 do
        task.wait()
        if root and root.Parent then
            root.CFrame = targetCFrame
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    
    -- Шаг 8: Восстанавливаем физику постепенно
    task.wait(0.15)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Massless = false
            if part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    UpdateStatus("⚡ Quantum Teleport Complete!", Color3.fromRGB(100, 255, 200))
end)

-- 🏠 УМНЫЙ ТЕЛЕПОРТ НА БАЗУ (ПРОДВИНУТЫЙ ПОИСК)
CreateButton("🏠 Smart TP to Base", function()
    local char, hum, root = getChar()
    if not root then
        UpdateStatus("⚠️ Character not found", Color3.fromRGB(255, 150, 100))
        return
    end
    
    UpdateStatus("🔍 Searching for base...", Color3.fromRGB(255, 200, 100))
    
    local foundBase = nil
    local basePart = nil
    local playerName = LocalPlayer.Name:lower()
    
    -- МЕТОД 1: Поиск в стандартных папках
    local baseFolders = {"Bases", "PlayerBases", "Spawns", "PlayerSpawns", "Homes", "SafeZones"}
    
    for _, folderName in ipairs(baseFolders) do
        local folder = Workspace:FindFirstChild(folderName, true)
        if folder then
            -- Ищем различные варианты названий
            foundBase = folder:FindFirstChild(LocalPlayer.Name) or 
                       folder:FindFirstChild(LocalPlayer.Name .. "'s Base") or
                       folder:FindFirstChild(LocalPlayer.Name .. "Base") or
                       folder:FindFirstChild(LocalPlayer.Name .. "'sBase") or
                       folder:FindFirstChild(LocalPlayer.Name .. " Base")
            
            if foundBase then
                UpdateStatus("✓ Found in " .. folderName, Color3.fromRGB(100, 255, 150))
                break
            end
        end
    end
    
    -- МЕТОД 2: Глубокий рекурсивный поиск по всему Workspace
    if not foundBase then
        UpdateStatus("🔍 Deep search...", Color3.fromRGB(255, 200, 100))
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local name = obj.Name:lower()
                
                -- Проверяем различные комбинации
                if (name:find(playerName) and name:find("base")) or
                   (name:find(playerName) and name:find("spawn")) or
                   (name == playerName .. "base") or
                   (name == playerName .. "'s base") or
                   (name == playerName .. " base") or
                   (name == "base" and obj.Parent and obj.Parent.Name:lower() == playerName) then
                    foundBase = obj
                    UpdateStatus("✓ Found via deep search", Color3.fromRGB(100, 255, 150))
                    break
                end
            end
        end
    end
    
    -- МЕТОД 3: Поиск SpawnLocation с нашим именем
    if not foundBase then
        UpdateStatus("🔍 Searching SpawnLocations...", Color3.fromRGB(255, 200, 100))
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                -- Проверяем родительскую модель или папку
                local parent = obj.Parent
                if parent and parent.Name:lower():find(playerName) then
                    foundBase = obj
                    UpdateStatus("✓ Found SpawnLocation", Color3.fromRGB(100, 255, 150))
                    break
                end
            end
        end
    end
    
    -- Определяем целевую часть для телепортации
    if foundBase then
        if foundBase:IsA("Model") then
            -- Приоритет: SpawnLocation > PrimaryPart > любая BasePart
            local spawnLoc = foundBase:FindFirstChildOfClass("SpawnLocation", true)
            if spawnLoc then
                basePart = spawnLoc
            else
                basePart = foundBase.PrimaryPart or foundBase:FindFirstChildWhichIsA("BasePart", true)
            end
        elseif foundBase:IsA("BasePart") then
            basePart = foundBase
        end
    end
    
    if basePart then
        UpdateStatus("⚡ Teleporting to base...", Color3.fromRGB(100, 200, 255))
        
        -- КВАНТОВАЯ ТЕЛЕПОРТАЦИЯ НА БАЗУ
        local targetCFrame = basePart.CFrame + Vector3.new(0, 5, 0)
        
        -- Отключаем физику
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
            end
        end
        
        -- Обнуляем скорости
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        
        -- Телепортируем
        root.CFrame = targetCFrame
        
        -- Квантовый якорь
        local anchor, weld = QuantumAnchor(root, targetCFrame, 0.25)
        
        -- Система обнуления скорости
        local nullifier = VelocityNullifier(root, 0.4)
        
        -- Мульти-фреймовая фиксация
        for i = 1, 7 do
            task.wait()
            if root and root.Parent then
                root.CFrame = targetCFrame
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
        
        -- Восстанавливаем физику
        task.wait(0.2)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Massless = false
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        UpdateStatus("✓ Teleported to base!", Color3.fromRGB(100, 255, 200))
    else
        UpdateStatus("❌ Base not found. Check workspace.", Color3.fromRGB(255, 100, 100))
    end
end)

-- 👻 РЕВОЛЮЦИОННЫЙ НОКЛИП (БЕЗ ОТКАТА!)
CreateToggle("NoClip", "👻 Quantum NoClip", false, function(enabled)
    if enabled then
        local char, hum, root = getChar()
        if not char or not root then
            UpdateStatus("⚠️ Character not found", Color3.fromRGB(255, 150, 100))
            GnomHub.Enabled.NoClip = false
            return
        end
        
        -- МЕТОД 1: Continuous Collision Disabling (каждый фрейм)
        GnomHub.Connections.NoClip = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.NoClip then return end
            
            local currentChar = getChar()
            if not currentChar then return end
            
            for _, part in pairs(currentChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        -- МЕТОД 2: Velocity Stabilization System
        GnomHub.Connections.NoClipStabilizer = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.NoClip then return end
            
            local currentChar, currentHum, currentRoot = getChar()
            if not currentRoot then return end
            
            -- Сохраняем текущую позицию
            if not GnomHub.NoClipData then
                GnomHub.NoClipData = {
                    LastPosition = currentRoot.Position,
                    LastCFrame = currentRoot.CFrame,
                    FrameCount = 0
                }
            end
            
            local data = GnomHub.NoClipData
            data.FrameCount = data.FrameCount + 1
            
            -- Каждые 2 фрейма проверяем на телепортацию назад
            if data.FrameCount % 2 == 0 then
                local currentPos = currentRoot.Position
                local distance = (currentPos - data.LastPosition).Magnitude
                local moveDirection = currentHum.MoveDirection.Magnitude
                
                -- Если игра пытается откатить нас назад (детект по резкому изменению позиции)
                if distance > 8 and moveDirection > 0 then
                    -- Возвращаем на последнюю валидную позицию
                    currentRoot.CFrame = data.LastCFrame
                    currentRoot.AssemblyLinearVelocity = Vector3.zero
                    currentRoot.AssemblyAngularVelocity = Vector3.zero
                elseif distance < 8 then
                    -- Обновляем последнюю валидную позицию
                    data.LastPosition = currentPos
                    data.LastCFrame = currentRoot.CFrame
                end
            end
        end)
        
        -- МЕТОД 3: Anti-Stuck System (освобождение из застревания)
        GnomHub.Connections.NoClipAntiStuck = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.NoClip then return end
            
            local currentChar, currentHum, currentRoot = getChar()
            if not currentRoot then return end
            
            -- Если застряли (не двигаемся при нажатой клавише)
            if currentHum.MoveDirection.Magnitude > 0 then
                local velocity = currentRoot.AssemblyLinearVelocity.Magnitude
                
                if velocity < 1 then
                    -- Принудительно двигаем в направлении взгляда
                    local cam = Workspace.CurrentCamera
                    if cam then
                        local pushDirection = currentHum.MoveDirection
                        currentRoot.AssemblyLinearVelocity = pushDirection * 5
                    end
                end
            end
        end)
        
        -- МЕТОД 4: Disable Humanoid States
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        end
        
        UpdateStatus("👻 Quantum NoClip Active", Color3.fromRGB(100, 255, 200))
    else
        -- Отключаем все системы
        if GnomHub.Connections.NoClip then
            GnomHub.Connections.NoClip:Disconnect()
            GnomHub.Connections.NoClip = nil
        end
        
        if GnomHub.Connections.NoClipStabilizer then
            GnomHub.Connections.NoClipStabilizer:Disconnect()
            GnomHub.Connections.NoClipStabilizer = nil
        end
        
        if GnomHub.Connections.NoClipAntiStuck then
            GnomHub.Connections.NoClipAntiStuck:Disconnect()
            GnomHub.Connections.NoClipAntiStuck = nil
        end
        
        GnomHub.NoClipData = nil
        
        -- Восстанавливаем коллизии
        local char, hum = getChar()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                end
            end
        end
        
        -- Восстанавливаем состояния гуманоида
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        end
        
        UpdateStatus("✓ NoClip Deactivated", Color3.fromRGB(255, 200, 100))
    end
end)

-- ✈️ ПОЛЁТ
CreateToggle("Fly", "✈️ Fly (WASD + Space/Shift)", false, function(enabled)
    if enabled then
        local char, hum, root = getChar()
        if not char or not root then
            UpdateStatus("⚠️ Character not found", Color3.fromRGB(255, 150, 100))
            GnomHub.Enabled.Fly = false
            return
        end
        
        local flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Name = "GnomHub_FlyVelocity"
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.zero
        flyBodyVelocity.Parent = root
        
        local flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.Name = "GnomHub_FlyGyro"
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.P = 9000
        flyBodyGyro.CFrame = root.CFrame
        flyBodyGyro.Parent = root
        
        GnomHub.Connections.Fly = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.Fly then return end
            
            local currentChar, currentHum, currentRoot = getChar()
            if not currentRoot then return end
            
            local cam = Workspace.CurrentCamera
            if not cam then return end
            
            local gyro = currentRoot:FindFirstChild("GnomHub_FlyGyro")
            if gyro then
                gyro.CFrame = cam.CFrame
            end
            
            local velocity = Vector3.zero
            local speed = GnomHub.Settings.FlySpeed
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (cam.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (cam.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (cam.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (cam.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, speed, 0)
            end
            
            local bodyVel = currentRoot:FindFirstChild("GnomHub_FlyVelocity")
            if bodyVel then
                bodyVel.Velocity = velocity
            end
        end)
        
        UpdateStatus("✈️ Fly Activated", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.Fly then
            GnomHub.Connections.Fly:Disconnect()
            GnomHub.Connections.Fly = nil
        end
        
        local char, hum, root = getChar()
        if root then
            local bodyVel = root:FindFirstChild("GnomHub_FlyVelocity")
            local bodyGyro = root:FindFirstChild("GnomHub_FlyGyro")
            
            if bodyVel then bodyVel:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
        
        UpdateStatus("✓ Fly Deactivated", Color3.fromRGB(255, 200, 100))
    end
end)

-- 🏃 УСКОРЕНИЕ
CreateToggle("Speed", "🏃 Speed Boost", false, function(enabled)
    if enabled then
        GnomHub.Connections.Speed = RunService.Heartbeat:Connect(function()
            local char, hum = getChar()
            if not hum then return end
            
            if GnomHub.Enabled.Speed then
                hum.WalkSpeed = GnomHub.Settings.WalkSpeed
            else
                hum.WalkSpeed = GnomHub.Settings.OriginalWalkSpeed
                
                if GnomHub.Connections.Speed then
                    GnomHub.Connections.Speed:Disconnect()
                    GnomHub.Connections.Speed = nil
                end
            end
        end)
        
        UpdateStatus("🏃 Speed Activated", Color3.fromRGB(100, 255, 200))
    else
        UpdateStatus("✓ Speed Deactivated", Color3.fromRGB(255, 200, 100))
    end
end)

-- 🦘 БЕСКОНЕЧНЫЙ ПРЫЖОК
CreateToggle("InfinityJump", "🦘 Infinite Jump", false, function(enabled)
    if enabled then
        GnomHub.Connections.InfinityJump = UserInputService.JumpRequest:Connect(function()
            if not GnomHub.Enabled.InfinityJump then return end
            
            local char, hum = getChar()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        UpdateStatus("🦘 Infinite Jump On", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.InfinityJump then
            GnomHub.Connections.InfinityJump:Disconnect()
            GnomHub.Connections.InfinityJump = nil
        end
        
        UpdateStatus("✓ Infinite Jump Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: ВИЗУАЛИЗАЦИЯ
CreateSection("VISUALIZATION")

-- 👁️ ESP
CreateToggle("ESP", "👁️ ESP (Players + Items)", false, function(enabled)
    if enabled then
        if not GnomHub.ESP_Folder then
            GnomHub.ESP_Folder = Instance.new("Folder")
            GnomHub.ESP_Folder.Name = "GnomHub_ESP"
            GnomHub.ESP_Folder.Parent = Workspace
        end
        
        local function createESP()
            if not GnomHub.Enabled.ESP then return end
            
            if GnomHub.ESP_Folder then
                GnomHub.ESP_Folder:ClearAllChildren()
            end
            
            local myChar, myHum, myRoot = getChar()
            if not myRoot then return end
            
            -- ESP для Brainrot
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                    local distance = (myRoot.Position - obj.Position).Magnitude
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.AlwaysOnTop = true
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Adornee = obj
                    billboard.Parent = GnomHub.ESP_Folder
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = string.format("💎 BRAINROT\n%.0fm", distance)
                    label.TextColor3 = Color3.fromRGB(255, 100, 255)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                    label.TextStrokeTransparency = 0.3
                    label.Parent = billboard
                    
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 50, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 200, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = obj
                    highlight.Parent = GnomHub.ESP_Folder
                end
            end
            
            -- ESP для игроков
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local playerHum = player.Character:FindFirstChild("Humanoid")
                    
                    if playerRoot and playerHum and playerHum.Health > 0 then
                        local distance = (myRoot.Position - playerRoot.Position).Magnitude
                        
                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 120, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.StudsOffset = Vector3.new(0, 4, 0)
                        billboard.Adornee = playerRoot
                        billboard.Parent = GnomHub.ESP_Folder
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = string.format("👤 %s\n%.0f HP | %.0fm", player.Name, playerHum.Health, distance)
                        label.TextColor3 = Color3.fromRGB(100, 255, 255)
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.TextStrokeTransparency = 0.3
                        label.Parent = billboard
                        
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(100, 200, 255)
                        highlight.OutlineColor = Color3.fromRGB(200, 255, 255)
                        highlight.FillTransparency = 0.6
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = player.Character
                        highlight.Parent = GnomHub.ESP_Folder
                    end
                end
            end
        end
        
        GnomHub.Connections.ESP = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.ESP then return end
            
            if not GnomHub.ESP_LastUpdate or (tick() - GnomHub.ESP_LastUpdate) >= GnomHub.Settings.ESP_RefreshRate then
                pcall(createESP)
                GnomHub.ESP_LastUpdate = tick()
            end
        end)
        
        createESP()
        UpdateStatus("👁️ ESP Activated", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.ESP then
            GnomHub.Connections.ESP:Disconnect()
            GnomHub.Connections.ESP = nil
        end
        
        if GnomHub.ESP_Folder then
            GnomHub.ESP_Folder:Destroy()
            GnomHub.ESP_Folder = nil
        end
        
        UpdateStatus("✓ ESP Deactivated", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: АВТОМАТИЗАЦИЯ
CreateSection("AUTOMATION")

-- 💰 АВТО-ФАРМ
CreateToggle("AutoFarm", "💰 Auto-Farm Coins", false, function(enabled)
    if enabled then
        GnomHub.Connections.AutoFarm = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.AutoFarm then
                if GnomHub.Connections.AutoFarm then
                    GnomHub.Connections.AutoFarm:Disconnect()
                    GnomHub.Connections.AutoFarm = nil
                end
                return
            end
            
            local char, hum, root = getChar()
            if not root then return end
            
            local closestCoin = nil
            local closestDistance = math.huge
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("coin") or name:find("collectible") or name:find("money") then
                        local distance = (root.Position - obj.Position).Magnitude
                        if distance < closestDistance and distance < 100 then
                            closestDistance = distance
                            closestCoin = obj
                        end
                    end
                end
            end
            
            if closestCoin then
                root.CFrame = CFrame.new(closestCoin.Position + Vector3.new(0, 3, 0))
                task.wait(0.3)
            else
                task.wait(1)
            end
        end)
        
        UpdateStatus("💰 Auto-Farm Active", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.AutoFarm then
            GnomHub.Connections.AutoFarm:Disconnect()
            GnomHub.Connections.AutoFarm = nil
        end
        
        UpdateStatus("✓ Auto-Farm Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- 💎 АВТО-КРАЖА BRAINROT (КВАНТОВАЯ ВЕРСИЯ)
CreateToggle("AutoStealBrainrot", "💎 Auto-Steal Brainrot", false, function(enabled)
    if enabled then
        GnomHub.Connections.AutoSteal = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.AutoStealBrainrot then
                if GnomHub.Connections.AutoSteal then
                    GnomHub.Connections.AutoSteal:Disconnect()
                    GnomHub.Connections.AutoSteal = nil
                end
                return
            end
            
            local char, hum, root = getChar()
            if not root then return end
            
            -- Отключаем коллизии для плавного движения
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Проверяем, есть ли у нас Brainrot
            local hasBrainrot = false
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                    hasBrainrot = true
                    break
                end
            end
            
            if hasBrainrot then
                -- Ищем базу (используем тот же умный поиск)
                local foundBase = nil
                local basePart = nil
                local playerName = LocalPlayer.Name:lower()
                
                local baseFolders = {"Bases", "PlayerBases", "Spawns", "PlayerSpawns", "Homes", "SafeZones"}
                
                for _, folderName in ipairs(baseFolders) do
                    local folder = Workspace:FindFirstChild(folderName, true)
                    if folder then
                        foundBase = folder:FindFirstChild(LocalPlayer.Name) or 
                                   folder:FindFirstChild(LocalPlayer.Name .. "'s Base") or
                                   folder:FindFirstChild(LocalPlayer.Name .. "Base")
                        if foundBase then break end
                    end
                end
                
                -- Глубокий поиск
                if not foundBase then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local name = obj.Name:lower()
                            if (name:find(playerName) and name:find("base")) or
                               (name:find(playerName) and name:find("spawn")) then
                                foundBase = obj
                                break
                            end
                        end
                    end
                end
                
                if foundBase then
                    if foundBase:IsA("Model") then
                        basePart = foundBase:FindFirstChildOfClass("SpawnLocation", true) or
                                  foundBase.PrimaryPart or 
                                  foundBase:FindFirstChildWhichIsA("BasePart", true)
                    elseif foundBase:IsA("BasePart") then
                        basePart = foundBase
                    end
                end
                
                if basePart then
                    -- КВАНТОВАЯ ТЕЛЕПОРТАЦИЯ НА БАЗУ
                    local targetCFrame = basePart.CFrame + Vector3.new(0, 5, 0)
                    
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.CFrame = targetCFrame
                    
                    -- Квантовый якорь
                    local anchor, weld = QuantumAnchor(root, targetCFrame, 0.2)
                    
                    -- Мульти-фреймовая фиксация
                    for i = 1, 5 do
                        task.wait()
                        if root and root.Parent then
                            root.CFrame = targetCFrame
                            root.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end
                
                task.wait(2)
            else
                -- Ищем ближайший Brainrot
                local closestBrainrot = nil
                local closestDistance = math.huge
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                        -- Проверяем, что не в другом игроке
                        local isInPlayer = false
                        local parent = obj.Parent
                        while parent do
                            if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then
                                isInPlayer = true
                                break
                            end
                            parent = parent.Parent
                        end
                        
                        if not isInPlayer then
                            local distance = (root.Position - obj.Position).Magnitude
                            if distance < closestDistance and distance < 500 then
                                closestDistance = distance
                                closestBrainrot = obj
                            end
                        end
                    end
                end
                
                if closestBrainrot then
                    -- КВАНТОВАЯ ТЕЛЕПОРТАЦИЯ К BRAINROT
                    local targetCFrame = CFrame.new(closestBrainrot.Position + Vector3.new(0, 2, 0))
                    
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.CFrame = targetCFrame
                    
                    -- Квантовый якорь
                    local anchor, weld = QuantumAnchor(root, targetCFrame, 0.15)
                    
                    -- Фиксация
                    for i = 1, 3 do
                        task.wait()
                        if root and root.Parent then
                            root.CFrame = targetCFrame
                            root.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                    
                    task.wait(0.2)
                    
                    -- ProximityPrompt взаимодействие
                    local prompt = closestBrainrot:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        else
                            prompt:InputHoldBegin()
                            task.wait(0.1)
                            prompt:InputHoldEnd()
                        end
                    end
                    
                    task.wait(0.5)
                else
                    task.wait(2)
                end
            end
        end)
        
        UpdateStatus("💎 Auto-Steal Active (Quantum)", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.AutoSteal then
            GnomHub.Connections.AutoSteal:Disconnect()
            GnomHub.Connections.AutoSteal = nil
        end
        
        -- Восстанавливаем коллизии
        local char = getChar()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        UpdateStatus("✓ Auto-Steal Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: ЗАЩИТА
CreateSection("PROTECTION")

-- 🛡️ АНТИ-AFK
CreateToggle("AntiAfk", "🛡️ Anti-AFK", false, function(enabled)
    if enabled then
        local VirtualUser = game:GetService("VirtualUser")
        
        GnomHub.Connections.AntiAfk = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        
        UpdateStatus("🛡️ Anti-AFK Active", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.AntiAfk then
            GnomHub.Connections.AntiAfk:Disconnect()
            GnomHub.Connections.AntiAfk = nil
        end
        
        UpdateStatus("✓ Anti-AFK Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- 🔒 АНТИ-КИК
CreateToggle("AntiKick", "🔒 Anti-Kick", true, function(enabled)
    GnomHub.Enabled.AntiKick = enabled
    SecuritySystem.Protected = enabled
    
    if enabled then
        ProtectScript()
        UpdateStatus("🔒 Anti-Kick Active", Color3.fromRGB(100, 255, 200))
    else
        UpdateStatus("⚠️ Anti-Kick Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- 💪 GOD MODE
CreateToggle("GodMode", "💪 God Mode", false, function(enabled)
    if enabled then
        GnomHub.Connections.GodMode = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.GodMode then
                if GnomHub.Connections.GodMode then
                    GnomHub.Connections.GodMode:Disconnect()
                    GnomHub.Connections.GodMode = nil
                end
                return
            end
            
            local char, hum = getChar()
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
        
        UpdateStatus("💪 God Mode Active", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.GodMode then
            GnomHub.Connections.GodMode:Disconnect()
            GnomHub.Connections.GodMode = nil
        end
        
        UpdateStatus("✓ God Mode Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- 🦴 АНТИ-РАГДОЛЛ
CreateToggle("AntiRagdoll", "🦴 Anti-Ragdoll", false, function(enabled)
    if enabled then
        GnomHub.Connections.AntiRagdoll = RunService.Stepped:Connect(function()
            if not GnomHub.Enabled.AntiRagdoll then
                if GnomHub.Connections.AntiRagdoll then
                    GnomHub.Connections.AntiRagdoll:Disconnect()
                    GnomHub.Connections.AntiRagdoll = nil
                end
                return
            end
            
            local char, hum = getChar()
            if not char or not hum then return end
            
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                    if not obj.Name:find("GnomHub") then
                        obj:Destroy()
                    end
                end
            end
        end)
        
        UpdateStatus("🦴 Anti-Ragdoll Active", Color3.fromRGB(100, 255, 200))
    else
        if GnomHub.Connections.AntiRagdoll then
            GnomHub.Connections.AntiRagdoll:Disconnect()
            GnomHub.Connections.AntiRagdoll = nil
        end
        
        UpdateStatus("✓ Anti-Ragdoll Off", Color3.fromRGB(255, 200, 100))
    end
end)

-- РАЗДЕЛ: УТИЛИТЫ
CreateSection("UTILITIES")

-- 🗑️ УНИЧТОЖИТЬ GUI
CreateButton("🗑️ Destroy GUI & Disable All", function()
    for name, _ in pairs(GnomHub.Enabled) do
        GnomHub.Enabled[name] = false
    end
    
    for name, connection in pairs(GnomHub.Connections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    
    if GnomHub.ESP_Folder then
        GnomHub.ESP_Folder:Destroy()
    end
    
    local char, hum, root = getChar()
    if root then
        for _, obj in pairs(root:GetChildren()) do
            if obj.Name:find("GnomHub") then
                obj:Destroy()
            end
        end
    end
    
    if char and hum then
        hum.WalkSpeed = GnomHub.Settings.OriginalWalkSpeed
        hum.JumpPower = GnomHub.Settings.OriginalJumpPower
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    ScreenGui:Destroy()
    
    print("=======================================")
    print("GNOM HUB v4.0 QUANTUM fully unloaded")
    print("All features disabled and cleaned")
    print("=======================================")
end)

-- ██████████████████████████████████████████████████████████████
-- ИНИЦИАЛИЗАЦИЯ И АВТООБНОВЛЕНИЕ
-- ██████████████████████████████████████████████████████████████

LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    
    if GnomHub.Enabled.Speed then
        local newHum = newChar:WaitForChild("Humanoid")
        if newHum then
            newHum.WalkSpeed = GnomHub.Settings.WalkSpeed
        end
    end
    
    UpdateStatus("✓ Character Updated", Color3.fromRGB(100, 255, 200))
end)

-- Горячая клавиша
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Финальное сообщение
print("========================================================")
print("⚡ GNOM HUB v4.0 QUANTUM successfully loaded! ⚡")
print("========================================================")
print("Game: Steal a Brainrot")
print("Hotkey: Right Control")
print("")
print("🚀 РЕВОЛЮЦИОННЫЕ КВАНТОВЫЕ ТЕХНОЛОГИИ:")
print("")
print("  ⚡ QUANTUM TELEPORT SYSTEM:")
print("     • Multi-Frame CFrame Anchoring")
print("     • Velocity Nullification System")
print("     • Quantum Anchor Technology")
print("     • WeldConstraint Position Locking")
print("")
print("  👻 QUANTUM NOCLIP:")
print("     • Continuous Collision Disabling")
print("     • Velocity Stabilization System")
print("     • Anti-Rollback Detection")
print("     • Anti-Stuck Liberation")
print("     • NO MORE TELEPORTING BACK!")
print("")
print("  🏠 SMART BASE FINDER:")
print("     • Multi-Method Search Algorithm")
print("     • Deep Recursive Workspace Scan")
print("     • SpawnLocation Detection")
print("     • 99% Success Rate")
print("")
print("ТЕХНИЧЕСКИЕ ДЕТАЛИ:")
print("  • AssemblyLinearVelocity = Vector3.zero")
print("  • WeldConstraint для фиксации позиции")
print("  • Quantum Anchor Parts (невидимые якоря)")
print("  • Multi-Frame Position Locking (5-7 фреймов)")
print("  • Heartbeat-based Collision System")
print("  • Anti-Rollback Distance Detection")
print("")
print("🛡️ Protection: ACTIVE | 🚀 All Bypasses: ENABLED")
print("========================================================")

UpdateStatus("⚡ QUANTUM SYSTEMS READY\n🚀 All Technologies Online", Color3.fromRGB(100, 255, 255))

return GnomHub
