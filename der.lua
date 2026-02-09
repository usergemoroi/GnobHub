--весь этот код тебе надо исправть , так же обновить все что было с багами , что не работает изза чего то, и все улучшить на максимум 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

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
        AntiKick = false
    },
    Settings = {
        FlySpeed = 50,
        WalkSpeed = 32,
        JumpPower = 75,
        TeleportDistance = 30,
        ESP_RefreshRate = 0.5
    },
    Connections = {},
    ESP_Folder = nil
}

-- ██████████████████████████████████████████████████████████████
-- 2. СОЗДАНИЕ ГРАФИЧЕСКОГО ИНТЕРФЕЙСА (GUI)
-- ██████████████████████████████████████████████████████████████

-- Основное окно
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 80, 130)
Title.Text = "GNOM HUB v2.0 | Steal a Brainrot"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- Контейнер для кнопок
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Size = UDim2.new(1, -20, 1, -120)
ButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsFrame
UIListLayout.Padding = UDim.new(0, 8)

-- ██████████████████████████████████████████████████████████████
-- 3. ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ
-- ██████████████████████████████████████████████████████████████

local function CreateToggle(Name, DefaultState, Callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ButtonsFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundColor3 = DefaultState and Color3.fromRGB(60, 150, 80) or Color3.fromRGB(80, 80, 80)
    ToggleButton.Text = Name
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        local NewState = not GnomHub.Enabled[Name]
        GnomHub.Enabled[Name] = NewState
        ToggleButton.BackgroundColor3 = NewState and Color3.fromRGB(60, 150, 80) or Color3.fromRGB(80, 80, 80)
        if Callback then Callback(NewState) end
    end)
    
    return ToggleButton
end

local function CreateButton(Name, Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(70, 100, 160)
    Button.Text = Name
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Parent = ButtonsFrame
    
    Button.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)
    
    return Button
end

-- ██████████████████████████████████████████████████████████████
-- 4. ОСНОВНЫЕ ИГРОВЫЕ ФУНКЦИИ
-- ██████████████████████████████████████████████████████████████

-- 4.1 ТЕЛЕПОРТАЦИЯ (2 СПЕЦИАЛЬНЫЕ КНОПКИ)
CreateButton("Телепорт вперед", function()
    if HumanoidRootPart then
        local LookVector = HumanoidRootPart.CFrame.LookVector
        local NewPosition = HumanoidRootPart.Position + (LookVector * GnomHub.Settings.TeleportDistance)
        HumanoidRootPart.CFrame = CFrame.new(NewPosition)
    end
end)

CreateButton("Телепорт на базу с Brainrot", function()
    -- Поиск Brainrot в руках
    local BrainrotInHand = nil
    for _, child in ipairs(Character:GetDescendants()) do
        if child.Name:lower():find("brainrot") and child:IsA("BasePart") then
            BrainrotInHand = child
            break
        end
    end
    
    if BrainrotInHand then
        -- Поиск базы игрока
        local PotentialBase = Workspace:FindFirstChild(LocalPlayer.Name .. "Base")
        if not PotentialBase then
            PotentialBase = Workspace:FindFirstChild("Base") or Workspace:FindFirstChild("Spawn")
        end
        
        if PotentialBase then
            -- Ключевое изменение: телепорт ИГРОКА в центр базы
            -- Brainrot останется у него в руках благодаря welдам
            HumanoidRootPart.CFrame = PotentialBase.CFrame
            
            -- Здесь НЕ нужно удалять weld или добавлять BodyForce
            -- Игровая система автоматически засчитает Brainrot на базе,
            -- как только вы окажетесь внутри её триггера.
            
            print("[Gnom Hub] Телепорт на базу выполнен. Ожидание системы игры...")
        else
            warn("[Gnom Hub] База не найдена!")
        end
    else
        warn("[Gnom Hub] Brainrot не в руках!")
    end
end)

-- 4.2 ФУНКЦИЯ ПОЛЕТА (FLY)
local FlyConnection
CreateToggle("Fly", false, function(State)
    GnomHub.Enabled.Fly = State
    
    if State then
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.P = 10000
        BodyGyro.D = 1000
        BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        BodyGyro.CFrame = HumanoidRootPart.CFrame
        BodyGyro.Parent = HumanoidRootPart
        
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = HumanoidRootPart
        
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not GnomHub.Enabled.Fly then return end
            
            local Camera = Workspace.CurrentCamera
            BodyGyro.CFrame = Camera.CFrame
            
            local Velocity = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Velocity = Velocity + (Camera.CFrame.LookVector * GnomHub.Settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Velocity = Velocity - (Camera.CFrame.LookVector * GnomHub.Settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Velocity = Velocity - (Camera.CFrame.RightVector * GnomHub.Settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Velocity = Velocity + (Camera.CFrame.RightVector * GnomHub.Settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Velocity = Velocity + (Vector3.new(0, 1, 0) * GnomHub.Settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Velocity = Velocity - (Vector3.new(0, 1, 0) * GnomHub.Settings.FlySpeed)
            end
            
            BodyVelocity.Velocity = Velocity
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        for _, obj in ipairs({HumanoidRootPart:GetChildren()}) do
            if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                obj:Destroy()
            end
        end
    end
end)

-- 4.3 ФУНКЦИЯ NOCLIP
local NoClipConnection
CreateToggle("NoClip", false, function(State)
    GnomHub.Enabled.NoClip = State
    
    if State then
        NoClipConnection = RunService.Stepped:Connect(function()
            if not GnomHub.Enabled.NoClip then return end
            
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- 4.4 УВЕЛИЧЕНИЕ СКОРОСТИ (SPEED)
CreateToggle("Speed", false, function(State)
    GnomHub.Enabled.Speed = State
    
    if State then
        Humanoid.WalkSpeed = GnomHub.Settings.WalkSpeed * 2.5
    else
        Humanoid.WalkSpeed = 16
    end
end)

-- 4.5 БЕСКОНЕЧНЫЙ ПРЫЖОК (INFINITY JUMP)
local JumpConnection
CreateToggle("InfinityJump", false, function(State)
    GnomHub.Enabled.InfinityJump = State
    
    if State then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if GnomHub.Enabled.InfinityJump then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
    end
end)

-- 4.6 ESP (ОТОБРАЖЕНИЕ ОБЪЕКТОВ)
local ESP_Objects = {}
CreateToggle("ESP", false, function(State)
    GnomHub.Enabled.ESP = State
    
    if State then
        if not GnomHub.ESP_Folder then
            GnomHub.ESP_Folder = Instance.new("Folder")
            GnomHub.ESP_Folder.Name = "GnomHub_ESP"
            GnomHub.ESP_Folder.Parent = Workspace
        end
        
        local function UpdateESP()
            -- Очистка старых объектов
            for _, obj in pairs(ESP_Objects) do
                if obj then obj:Destroy() end
            end
            ESP_Objects = {}
            
            -- Поиск Brainrot
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                    local BillboardGui = Instance.new("BillboardGui")
                    BillboardGui.Name = "ESP_Brainrot"
                    BillboardGui.Size = UDim2.new(0, 100, 0, 40)
                    BillboardGui.AlwaysOnTop = true
                    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                    BillboardGui.Adornee = obj
                    BillboardGui.Parent = GnomHub.ESP_Folder
                    
                    local TextLabel = Instance.new("TextLabel")
                    TextLabel.Size = UDim2.new(1, 0, 1, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Text = "🧠 BRAINROT"
                    TextLabel.TextColor3 = Color3.fromRGB(255, 50, 150)
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 16
                    TextLabel.Parent = BillboardGui
                    
                    table.insert(ESP_Objects, BillboardGui)
                end
            end
            
            -- Поиск игроков
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local HumanoidRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if HumanoidRoot then
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Name = "ESP_Player_" .. player.Name
                        BillboardGui.Size = UDim2.new(0, 150, 0, 40)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
                        BillboardGui.Adornee = HumanoidRoot
                        BillboardGui.Parent = GnomHub.ESP_Folder
                        
                        local TextLabel = Instance.new("TextLabel")
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Text = "👤 " .. player.Name
                        TextLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(100, 200, 255)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 14
                        TextLabel.Parent = BillboardGui
                        
                        table.insert(ESP_Objects, BillboardGui)
                    end
                end
            end
        end
        
        -- Периодическое обновление ESP
        local ESP_Loop
        ESP_Loop = RunService.Heartbeat:Connect(function()
            if not GnomHub.Enabled.ESP then
                ESP_Loop:Disconnect()
                return
            end
            
            UpdateESP()
            task.wait(GnomHub.Settings.ESP_RefreshRate)
        end)
        
        UpdateESP()
    else
        if GnomHub.ESP_Folder then
            GnomHub.ESP_Folder:Destroy()
            GnomHub.ESP_Folder = nil
        end
    end
end)

-- 4.7 АВТОФАРМ РЕСУРСОВ
CreateToggle("AutoFarm", false, function(State)
    GnomHub.Enabled.AutoFarm = State
    
    if State then
        warn("[Gnom Hub] Автофарм активирован. Функция требует настройки под конкретные ресурсы игры.")
        -- Логика поиска и сбора ресурсов будет зависеть от структуры игры
    else
        warn("[Gnom Hub] Автофарм деактивирован.")
    end
end)

-- 4.8 АВТОМАТИЧЕСКОЕ ВОРОВСТВО BRAINROT
CreateToggle("AutoStealBrainrot", false, function(State)
    GnomHub.Enabled.AutoStealBrainrot = State
    
    if State then
        warn("[Gnom Hub] Авто-воровство Brainrot активировано. Функция требует настройки под механику игры.")
        -- Логика автоматического кража Brainrot у других игроков
    else
        warn("[Gnom Hub] Авто-воровство Brainrot деактивировано.")
    end
end)

-- 4.9 АВТОПОКУПКА (ссылка на готовый скрипт[citation:2])
CreateToggle("AutoBuy", false, function(State)
    GnomHub.Enabled.AutoBuy = State
    
    if State then
        warn("[Gnom Hub] Автопокупка активирована. Рекомендуется использовать готовые решения[citation:2].")
        -- Можно интегрировать готовый скрипт автопокупки[citation:2]
    else
        warn("[Gnom Hub] Автопокупка деактивирована.")
    end
end)

-- 4.10 АНТИ-КИК СИСТЕМА
CreateToggle("AntiKick", false, function(State)
    GnomHub.Enabled.AntiKick = State
    
    if State then
        -- Перехват попыток кика
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Блокировка вызовов кика
            if GnomHub.Enabled.AntiKick then
                if (method == "Kick" or method == "kick") and self == LocalPlayer then
                    warn("[Gnom Hub Anti-Kick] Попытка кика заблокирована!")
                    return nil
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
        setreadonly(mt, true)
        
        warn("[Gnom Hub] Анти-кик система активирована.")
    else
        warn("[Gnom Hub] Анти-кик система деактивирована.")
    end
end)

-- ██████████████████████████████████████████████████████████████
-- 5. ДОПОЛНИТЕЛЬНЫЕ УТИЛИТЫ
-- ██████████████████████████████████████████████████████████████

CreateButton("Установить скорость полета", function()
    local Speed = tonumber(game:GetService("TextChatService").TextChannels.RBXGeneral:DisplayInputBox(
        "Введите скорость полета (по умолчанию 50):",
        "number",
        tostring(GnomHub.Settings.FlySpeed)
    ))
    
    if Speed and Speed > 0 and Speed < 500 then
        GnomHub.Settings.FlySpeed = Speed
        warn("[Gnom Hub] Скорость полета установлена: " .. Speed)
    end
end)

CreateButton("Установить скорость бега", function()
    local Speed = tonumber(game:GetService("TextChatService").TextChannels.RBXGeneral:DisplayInputBox(
        "Введите скорость бега (по умолчанию 32):",
        "number",
        tostring(GnomHub.Settings.WalkSpeed)
    ))
    
    if Speed and Speed > 16 and Speed < 200 then
        GnomHub.Settings.WalkSpeed = Speed
        if GnomHub.Enabled.Speed then
            Humanoid.WalkSpeed = Speed * 2.5
        end
        warn("[Gnom Hub] Скорость бега установлена: " .. Speed)
    end
end)

CreateButton("Уничтожить GUI", function()
    ScreenGui:Destroy()
    warn("[Gnom Hub] Интерфейс уничтожен. Для повторного запуска перезагрузите скрипт.")
end)

-- ██████████████████████████████████████████████████████████████
-- 6. ИНИЦИАЛИЗАЦИЯ И ЗАЩИТА
-- ██████████████████████████████████████████████████████████████

-- Защита от потери GUI при смерти
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Восстановление активных функций
    if GnomHub.Enabled.Speed then
        Humanoid.WalkSpeed = GnomHub.Settings.WalkSpeed * 2.5
    end
end)

-- Информация о загрузке
warn("=======================================")
warn("GNOM HUB v2.0 успешно загружен!")
warn("Игра: Steal a Brainrot")
warn("Исполнитель: Delta/Xeno/Universal")
warn("Для открытия/закрытия GUI используйте кнопку X")
warn("=======================================")

return GnomHub