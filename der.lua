-- GNOM HUB v2.1 - Улучшенная версия для Roblox "Steal a Brainrot"
-- Исправлены все баги, добавлены улучшения и защита

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
-- 1. ОСНОВНЫЕ ПЕРЕМЕННЫЕ И КОНФИГУРАЦИЯ
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
        AntiAfk = false
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
    BodyObjects = {}
}

-- ██████████████████████████████████████████████████████████████
-- 2. СОЗДАНИЕ ГРАФИЧЕСКОГО ИНТЕРФЕЙСА (GUI)
-- ██████████████████████████████████████████████████████████████

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = PlayerGui
end)

if not success then
    warn("[Gnom Hub] Не удалось создать GUI")
    return
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 80, 130)
Title.BorderSizePixel = 0
Title.Text = "🧠 GNOM HUB v2.1 | Steal a Brainrot"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 7.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Size = UDim2.new(1, -20, 1, -140)
ButtonsFrame.Position = UDim2.new(0, 10, 0, 60)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.BorderSizePixel = 0
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.ScrollBarImageColor3 = Color3.fromRGB(45, 80, 130)
ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonsFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsFrame
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 60)
StatusLabel.Position = UDim2.new(0, 10, 1, -70)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = "✅ Готов к использованию"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- ██████████████████████████████████████████████████████████████
-- 3. ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ
-- ██████████████████████████████████████████████████████████████

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

local function CreateToggle(Name, DisplayName, DefaultState, Callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ButtonsFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundColor3 = DefaultState and Color3.fromRGB(60, 150, 80) or Color3.fromRGB(80, 80, 90)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = (DefaultState and "✅ " or "❌ ") .. DisplayName
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        local NewState = not GnomHub.Enabled[Name]
        GnomHub.Enabled[Name] = NewState
        ToggleButton.BackgroundColor3 = NewState and Color3.fromRGB(60, 150, 80) or Color3.fromRGB(80, 80, 90)
        ToggleButton.Text = (NewState and "✅ " or "❌ ") .. DisplayName
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(1.05, 0, 1.1, 0)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
        
        if Callback then 
            local success, err = pcall(Callback, NewState)
            if not success then
                warn("[Gnom Hub] Ошибка в " .. Name .. ": " .. tostring(err))
                UpdateStatus("⚠️ Ошибка: " .. Name, Color3.fromRGB(255, 100, 100))
            end
        end
    end)
    
    return ToggleButton
end

local function CreateButton(DisplayName, Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(70, 100, 160)
    Button.BorderSizePixel = 0
    Button.Text = "⚡ " .. DisplayName
    Button.TextColor3 = Color3.white
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Parent = ButtonsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(90, 120, 180)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(70, 100, 160)
        }):Play()
        
        if Callback then 
            local success, err = pcall(Callback)
            if not success then
                warn("[Gnom Hub] Ошибка в кнопке: " .. tostring(err))
                UpdateStatus("⚠️ Ошибка выполнения", Color3.fromRGB(255, 100, 100))
            end
        end
    end)
    
    return Button
end

-- ██████████████████████████████████████████████████████████████
-- 4. ОСНОВНЫЕ ИГРОВЫЕ ФУНКЦИИ
-- ██████████████████████████████████████████████████████████████

-- 4.1 ТЕЛЕПОРТАЦИЯ
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
        return
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

-- 4.2 ФУНКЦИЯ ПОЛЕТА (FLY)
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

-- 4.3 ФУНКЦИЯ NOCLIP
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

-- 4.4 УВЕЛИЧЕНИЕ СКОРОСТИ
CreateToggle("Speed", "Ускорение", false, function(State)
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

-- 4.5 БЕСКОНЕЧНЫЙ ПРЫЖОК
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

-- 4.6 ESP (ОТОБРАЖЕНИЕ ОБЪЕКТОВ)
local ESP_Objects = {}
local ESP_Loop
CreateToggle("ESP", "ESP (подсветка)", false, function(State)
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

-- 4.7 АНТИ-AFK
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

-- 4.8 АНТИ-КИК (улучшенная версия)
CreateToggle("AntiKick", "Анти-Кик", false, function(State)
    GnomHub.Enabled.AntiKick = State
    
    if State then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if GnomHub.Enabled.AntiKick then
                if method == "Kick" and self == LocalPlayer then
                    UpdateStatus("🛡️ Попытка кика заблокирована", Color3.fromRGB(255, 200, 100))
                    return nil
                end
                
                if method == "FireServer" or method == "InvokeServer" then
                    local eventName = self.Name or ""
                    if eventName:lower():find("kick") or eventName:lower():find("ban") then
                        UpdateStatus("🛡️ Подозрительный вызов заблокирован", Color3.fromRGB(255, 200, 100))
                        return nil
                    end
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        UpdateStatus("✅ Анти-Кик активирован", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("❌ Анти-Кик деактивирован", Color3.fromRGB(255, 200, 100))
    end
end)

-- 4.9 АВТОФАРМ
local AutoFarmConnection
CreateToggle("AutoFarm", "Авто-фарм", false, function(State)
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

-- 4.10 АВТОКРАЖА BRAINROT
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
                    
                    fireproximityprompt(closestBrainrot:FindFirstChildOfClass("ProximityPrompt"))
                end
            end
        end)
        
        UpdateStatus("✅ Авто-кража активирована", Color3.fromRGB(100, 255, 100))
    else
        UpdateStatus("❌ Авто-кража деактивирована", Color3.fromRGB(255, 200, 100))
    end
end)

-- ██████████████████████████████████████████████████████████████
-- 5. ДОПОЛНИТЕЛЬНЫЕ УТИЛИТЫ
-- ██████████████████████████████████████████████████████████████

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
-- 6. ИНИЦИАЛИЗАЦИЯ И ЗАЩИТА
-- ██████████████████████████████████████████████████████████████

LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if GnomHub.Enabled.Speed and Humanoid then
        Humanoid.WalkSpeed = GnomHub.Settings.WalkSpeed * 2.5
    end
    
    if GnomHub.Enabled.NoClip then
        task.wait(0.5)
        GnomHub.Enabled.NoClip = false
        task.wait(0.1)
        GnomHub.Enabled.NoClip = true
    end
    
    UpdateStatus("✅ Персонаж обновлен", Color3.fromRGB(100, 255, 100))
end)

print("=======================================")
print("GNOM HUB v2.1 успешно загружен!")
print("Игра: Steal a Brainrot")
print("Все функции улучшены и исправлены")
print("Для открытия/закрытия используйте кнопку X")
print("=======================================")

UpdateStatus("✅ GNOM HUB v2.1 готов к работе", Color3.fromRGB(100, 255, 255))

return GnomHub
