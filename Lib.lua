-- ZL UI Library
local ZLUILibrary = {}

-- Servicios
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Variables globales
local player = Players.LocalPlayer
local screenGui = nil
local mainButton = nil
local mainFrame = nil
local configFrame = nil
local uiOpen = false
local dragging = false
local dragInput, dragStart, startPos

-- Estados y configuraciones
ZLUILibrary.FunctionStates = {
    Aimbot = false,
    SpeedBoost = false,
    AntiKnockback = false,
    AntiRagdoll = false,
    AutoHit = false,
    InfiniteJump = false,
    GrabActivator = false,
    AntiKnockbackV2 = false,
    ShiftLock = false,
    SpinBot = false
}

ZLUILibrary.FloatingIcons = {}
ZLUILibrary.SectionContents = {}
ZLUILibrary.SectionButtons = {}

-- Función para crear elementos UI
function ZLUILibrary:CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- Función para crear botones de sección
function ZLUILibrary:CreateSectionButton(name, position, isFirst)
    local button = self:CreateElement("TextButton", {
        BackgroundColor3 = isFirst and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35),
        Position = position,
        Size = UDim2.new(1, -10, 0, 30),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(250, 215, 0),
        TextSize = 12,
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    return button
end

-- Función para crear controles de ajuste
function ZLUILibrary:CreateAdjustmentControl(name, position, parent, minValue, maxValue, step, currentValue, callback)
    local controlFrame = self:CreateElement("Frame", {
        Parent = parent,
        Name = name .. "Control",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Position = position,
        Size = UDim2.new(1, -10, 0, 25)
    })
    
    self:CreateElement("UICorner", {
        Parent = controlFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    self:CreateElement("UIStroke", {
        Parent = controlFrame,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    local nameLabel = self:CreateElement("TextLabel", {
        Parent = controlFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(0.4, -8, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local valueLabel = self:CreateElement("TextLabel", {
        Parent = controlFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.4, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = string.format("%.2f", currentValue),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11
    })
    
    local minusButton = self:CreateElement("TextButton", {
        Parent = controlFrame,
        Name = "MinusBtn",
        BackgroundColor3 = Color3.fromRGB(80, 80, 90),
        Position = UDim2.new(0.7, 5, 0, 3),
        Size = UDim2.new(0, 25, 0, 19),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = minusButton,
        CornerRadius = UDim.new(0, 3)
    })
    
    local plusButton = self:CreateElement("TextButton", {
        Parent = controlFrame,
        Name = "PlusBtn",
        BackgroundColor3 = Color3.fromRGB(80, 80, 90),
        Position = UDim2.new(0.85, 5, 0, 3),
        Size = UDim2.new(0, 25, 0, 19),
        Font = Enum.Font.GothamBold,
        Text = "+",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = plusButton,
        CornerRadius = UDim.new(0, 3)
    })
    
    local function updateValue(newValue)
        local clampedValue = math.clamp(newValue, minValue, maxValue)
        valueLabel.Text = string.format("%.2f", clampedValue)
        callback(clampedValue)
        return clampedValue
    end
    
    minusButton.MouseButton1Click:Connect(function()
        local newValue = currentValue - step
        currentValue = updateValue(newValue)
    end)
    
    plusButton.MouseButton1Click:Connect(function()
        local newValue = currentValue + step
        currentValue = updateValue(newValue)
    end)
    
    -- Efectos hover para botones
    local function setupButtonEffects(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 110)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            }):Play()
        end)
    end
    
    setupButtonEffects(minusButton)
    setupButtonEffects(plusButton)
    
    currentValue = updateValue(currentValue)
    
    return controlFrame
end

-- Función para crear toggle buttons
function ZLUILibrary:CreateToggle(name, position, parent, funcName, customCallback, initialState)
    local toggleFrame = self:CreateElement("Frame", {
        Parent = parent,
        Name = name .. "Toggle",
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Position = position,
        Size = UDim2.new(1, -10, 0, 25)
    })
    
    self:CreateElement("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    self:CreateElement("UIStroke", {
        Parent = toggleFrame,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    local toggleText = self:CreateElement("TextButton", {
        Parent = toggleFrame,
        Name = "ToggleText",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(0.7, -8, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    
    local toggleButton = self:CreateElement("TextButton", {
        Parent = toggleFrame,
        Name = "ToggleBtn",
        BackgroundColor3 = Color3.fromRGB(80, 80, 90),
        Position = UDim2.new(0.7, 5, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        Font = Enum.Font.SourceSans,
        Text = "",
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local configButton = self:CreateElement("TextButton", {
        Parent = toggleFrame,
        Name = "ConfigBtn",
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        Position = UDim2.new(0.85, 5, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        Font = Enum.Font.GothamBold,
        Text = "⚙",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 10,
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = configButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    local isConfigToggle = customCallback ~= nil
    local toggleState = initialState or (self.FunctionStates[funcName] or false)
    
    local function updateToggle()
        if toggleState then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            }):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            }):Play()
        end
        
        if isConfigToggle then
            customCallback(toggleState)
        else
            self.FunctionStates[funcName] = toggleState
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        updateToggle()
        
        if isConfigToggle then
            customCallback(toggleState)
        else
            if self.ToggleFunction then
                self.ToggleFunction(funcName, toggleState)
            end
        end
    })
    
    configButton.MouseButton1Click:Connect(function()
        if self.ShowFunctionConfig then
            self:ShowFunctionConfig(funcName)
        end
    end)
    
    -- Efectos hover
    local function setupButtonEffects(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 110)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            }):Play()
        end)
    end
    
    setupButtonEffects(configButton)
    
    toggleText.MouseEnter:Connect(function()
        TweenService:Create(toggleText, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    toggleText.MouseLeave:Connect(function()
        TweenService:Create(toggleText, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    updateToggle()
    
    return toggleFrame
end

-- Función para crear iconos flotantes
function ZLUILibrary:CreateFloatingIcon(funcName, displayName)
    if self.FloatingIcons[funcName] then
        self.FloatingIcons[funcName].Main:Destroy()
    end
    
    local gridPositions = {
        Aimbot = {x = 720, y = 20},
        SpeedBoost = {x = 720, y = 60},
        AntiKnockback = {x = 720, y = 100},
        AntiRagdoll = {x = 720, y = 140},
        AutoHit = {x = 720, y = 180},
        InfiniteJump = {x = 620, y = 140},
        GrabActivator = {x = 620, y = 20},
        AntiKnockbackV2 = {x = 620, y = 40},
        ShiftLock = {x = 620, y = 80}
    }
    
    local displayTexts = {
        Aimbot = "Aim",
        SpeedBoost = "Speed",
        AntiKnockback = "AntiKB",
        AntiRagdoll = "ragdoll",
        AutoHit = "AutoHit",
        InfiniteJump = "Jump",
        GrabActivator = "AutGrab",
        AntiKnockbackV2 = "AntiKB2",
        ShiftLock = "Shift"
    }
    
    local pos = gridPositions[funcName] or {x = math.random(100, 400), y = math.random(100, 400)}
    local displayText = displayTexts[funcName] or displayName:sub(1, 3)
    
    local icon = self:CreateElement("TextButton", {
        Parent = screenGui,
        Name = funcName .. "Icon",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, pos.x, 0, pos.y),
        Size = UDim2.new(0, 80, 0, 32),
        AutoButtonColor = false,
        Text = displayText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        Draggable = true
    })
    
    self:CreateElement("UICorner", {
        Parent = icon,
        CornerRadius = UDim.new(0, 6)
    })
    
    local dot = self:CreateElement("Frame", {
        Parent = icon,
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(1, -14, 0, 12),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        BorderSizePixel = 0
    })
    
    self:CreateElement("UICorner", {
        Parent = dot,
        CornerRadius = UDim.new(1, 0)
    })
    
    local function updateIconVisual()
        if self.FunctionStates[funcName] then
            icon.BackgroundTransparency = 0.25
            dot.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
            icon.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            icon.BackgroundTransparency = 0.4
            dot.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    icon.MouseButton1Click:Connect(function()
        if self.ToggleFunction then
            self.ToggleFunction(funcName, not self.FunctionStates[funcName])
        end
        updateIconVisual()
    end)
    
    updateIconVisual()
    
    self.FloatingIcons[funcName] = {
        Main = icon,
        Dot = dot,
        UpdateVisual = updateIconVisual
    }
    
    return self.FloatingIcons[funcName]
end

-- Función para mostrar configuración de función
function ZLUILibrary:ShowFunctionConfig(funcName)
    if not configFrame then return end
    
    for _, child in ipairs(configFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "ConfigContent" then
            for _, contentChild in ipairs(child:GetChildren()) do
                if contentChild:IsA("Frame") then
                    contentChild:Destroy()
                end
            end
        end
    end
    
    local configTitle = configFrame:FindFirstChild("ConfigTitle")
    if configTitle then
        configTitle.Text = "CONFIGURACIÓN - " .. funcName:upper()
    end
    
    -- Aquí puedes agregar configuraciones específicas para cada función
    -- Similar a la función showFunctionConfig original
    
    configFrame.Visible = true
end

-- Función para cerrar panel de configuración
function ZLUILibrary:CloseConfigPanel()
    if configFrame then
        configFrame.Visible = false
    end
end

-- Función para mostrar sección
function ZLUILibrary:ShowSection(sectionName)
    if self.CurrentSection then
        self.SectionContents[self.CurrentSection].Visible = false
        TweenService:Create(self.SectionButtons[self.CurrentSection], TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        }):Play()
    end
    
    self.CurrentSection = sectionName
    self.SectionContents[sectionName].Visible = true
    TweenService:Create(self.SectionButtons[sectionName], TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    }):Play()
end

-- Función principal para crear la interfaz
function ZLUILibrary:CreateInterface()
    -- Crear ScreenGui principal
    screenGui = self:CreateElement("ScreenGui", {
        Name = "ZLCompactUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    else
        screenGui.Parent = game:GetService("CoreGui")
    end

    -- Crear botón principal
    mainButton = self:CreateElement("ImageButton", {
        Parent = screenGui,
        Name = "MainButton",
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0, 35, 0, 35),
        AutoButtonColor = false,
        Active = true,
        Draggable = true
    })

    -- Hacer botón redondo
    self:CreateElement("UICorner", {
        Parent = mainButton,
        CornerRadius = UDim.new(1, 0)
    })

    -- Borde dorado
    local buttonStroke = self:CreateElement("UIStroke", {
        Parent = mainButton,
        Color = Color3.fromRGB(255, 215, 0),
        Thickness = 1,
        Transparency = 0.7
    })

    -- Efecto glow
    local glowStroke = self:CreateElement("UIStroke", {
        Parent = mainButton,
        Color = Color3.fromRGB(255, 215, 0),
        Thickness = 1,
        Transparency = 0.6
    })

    -- Texto ZL
    local buttonText = self:CreateElement("TextLabel", {
        Parent = mainButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "ZL",
        TextColor3 = Color3.fromRGB(255, 215, 0),
        TextSize = 14,
        TextStrokeColor3 = Color3.fromRGB(100, 100, 100),
        TextStrokeTransparency = 0.8
    })

    -- Crear frame principal
    mainFrame = self:CreateElement("Frame", {
        Parent = screenGui,
        Name = "MainFrame",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 350, 0, 250),
        Visible = false
    })

    self:CreateElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 6)
    })

    self:CreateElement("UIStroke", {
        Parent = mainFrame,
        Color = Color3.fromRGB(255, 215, 0),
        Thickness = 1
    })

    -- Crear panel de configuración
    configFrame = self:CreateElement("Frame", {
        Parent = screenGui,
        Name = "ConfigFrame",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Position = UDim2.new(-0.88, 750, 0.3, 0),
        Size = UDim2.new(0, 200, 0, 249),
        Visible = false
    })

    self:CreateElement("UICorner", {
        Parent = configFrame,
        CornerRadius = UDim.new(0, 6)
    })

    self:CreateElement("UIStroke", {
        Parent = configFrame,
        Color = Color3.fromRGB(80, 80, 90),
        Thickness = 1
    })

    -- Barra de título del panel de configuración
    local configTitle = self:CreateElement("TextLabel", {
        Parent = configFrame,
        Name = "ConfigTitle",
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "Settings",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13
    })

    self:CreateElement("UICorner", {
        Parent = configTitle,
        CornerRadius = UDim.new(0, 0, 0, 6)
    })

    -- Contenido de configuración
    local configContent = self:CreateElement("ScrollingFrame", {
        Parent = configFrame,
        Name = "ConfigContent",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30),
        CanvasSize = UDim2.new(0, 0, 0, 300),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    })

    -- Barra de título principal
    local titleBar = self:CreateElement("Frame", {
        Parent = mainFrame,
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        Size = UDim2.new(1, 0, 0, 30)
    })

    self:CreateElement("UICorner", {
        Parent = titleBar,
        CornerRadius = UDim.new(0, 6)
    })

    local titleText = self:CreateElement("TextLabel", {
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "ZL PvP",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Botón Discord
    local copyDiscordButton = self:CreateElement("TextButton", {
        Parent = titleBar,
        Name = "CopyDiscordButton",
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        Position = UDim2.new(1, -120, 0, 5),
        Size = UDim2.new(0, 45, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "Discord",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 16
    })

    self:CreateElement("UICorner", {
        Parent = copyDiscordButton,
        CornerRadius = UDim.new(0, 10)
    })

    -- Botón cerrar
    local closeButton = self:CreateElement("TextButton", {
        Parent = titleBar,
        Name = "CloseButton",
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Position = UDim2.new(1, -25, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12
    })

    self:CreateElement("UICorner", {
        Parent = closeButton,
        CornerRadius = UDim.new(0, 4)
    })

    -- Contenedor principal
    local container = self:CreateElement("Frame", {
        Parent = mainFrame,
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })

    -- Barra lateral
    local sidebar = self:CreateElement("Frame", {
        Parent = container,
        Name = "Sidebar",
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Size = UDim2.new(0, 100, 1, 0)
    })

    self:CreateElement("UICorner", {
        Parent = sidebar,
        CornerRadius = UDim.new(0, 6)
    })

    -- Contenido de secciones
    local contentFrame = self:CreateElement("Frame", {
        Parent = container,
        Name = "ContentFrame",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 105, 0, 0),
        Size = UDim2.new(1, -105, 1, 0)
    })

    -- Crear secciones
    local sections = {"Combat", "suggestions"}
    
    for i, sectionName in ipairs(sections) do
        local buttonPos = UDim2.new(0, 5, 0, (i-1) * 35 + 5)
        self.SectionButtons[sectionName] = self:CreateSectionButton(sectionName, buttonPos, i == 1)
        
        local content = self:CreateElement("ScrollingFrame", {
            Parent = contentFrame,
            Name = sectionName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = i == 1,
            CanvasSize = UDim2.new(0, 0, 0, 400),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        })
        
        self.SectionContents[sectionName] = content
        
        -- Agregar funciones a la sección Combat
        if sectionName == "Combat" then
            local functions = {
                {name = "Aimbot", func = "Aimbot"},
                {name = "Shift Lock", func = "ShiftLock"},
                {name = "Speed Boost", func = "SpeedBoost"},
                {name = "Anti-Knockback", func = "AntiKnockback"},
                {name = "Anti-Knockback V2", func = "AntiKnockbackV2"},
                {name = "Anti ragdoll (descarado)", func = "AntiRagdoll"},
                {name = "Auto Hit (se activa solo)", func = "AutoHit"},
                {name = "Jump Boost", func = "InfiniteJump"},
                {name = "Auto Grab", func = "GrabActivator"},
                {name = "Auto Spin(360)", func = "SpinBot"}
            }
            
            for j, funcData in ipairs(functions) do
                self:CreateToggle(funcData.name, UDim2.new(0, 0, 0, (j-1) * 30 + 5), content, funcData.func)
            end
        end
    end

    -- Conectar eventos de sección
    for sectionName, button in pairs(self.SectionButtons) do
        button.MouseButton1Click:Connect(function()
            self:ShowSection(sectionName)
        end)
    end

    -- Sistema de arrastre
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end

    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            configFrame.Position = UDim2.new(
                mainFrame.Position.X.Scale, 
                mainFrame.Position.X.Offset + 350,
                mainFrame.Position.Y.Scale, 
                mainFrame.Position.Y.Offset
            )
        end
    end

    -- Conectar eventos de arrastre
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(input)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    -- Conectar eventos del botón principal
    mainButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            mainButton.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Toggle interfaz con botón principal
    mainButton.MouseButton1Click:Connect(function()
        uiOpen = not uiOpen
        mainFrame.Visible = uiOpen
        
        if uiOpen then
            TweenService:Create(mainButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
                Size = UDim2.new(0, 45, 0, 45)
            }):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.3), {
                Color = Color3.new(0, 1, 0)
            }):Play()
        else
            TweenService:Create(mainButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.3), {
                Color = Color3.new(1, 0, 0)
            }):Play()
            self:CloseConfigPanel()
        end
    end)

    -- Cerrar interfaz
    closeButton.MouseButton1Click:Connect(function()
        uiOpen = false
        mainFrame.Visible = false
        TweenService:Create(mainButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.3), {
            Color = Color3.new(1, 0, 0)
        }):Play()
        self:CloseConfigPanel()
    end)

    -- Efectos hover botón principal
    mainButton.MouseEnter:Connect(function()
        if not uiOpen then
            TweenService:Create(mainButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            }):Play()
        end
    end)

    mainButton.MouseLeave:Connect(function()
        if not uiOpen then
            TweenService:Create(mainButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0, 0, 0)
            }):Play()
        end
    end)

    -- Botón Discord
    copyDiscordButton.MouseButton1Click:Connect(function()
        local toCopy = "https://discord.gg/jPyrNxJJVN"
        pcall(function()
            if setclipboard then
                setclipboard(toCopy)
            elseif set_clipboard then
                set_clipboard(toCopy)
            elseif syn and syn.set_clipboard then
                syn.set_clipboard(toCopy)
            end
        end)
        
        pcall(function()
            local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(copyDiscordButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 180, 80)}):Play()
            wait(0.25)
            TweenService:Create(copyDiscordButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
    end)

    -- Efecto glow para el borde
    local glowTween = TweenService:Create(glowStroke, TweenInfo.new(
        1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true
    ), {Transparency = 0.3})
    glowTween:Play()

    self.CurrentSection = "Combat"
    
    print("📱 ZL UI Library Cargada Correctamente")
    return self
end

-- Función para limpiar la interfaz
function ZLUILibrary:Destroy()
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end
end

-- Función para establecer callback de toggle
function ZLUILibrary:SetToggleCallback(callback)
    self.ToggleFunction = callback
end

-- Función para establecer callback de configuración
function ZLUILibrary:SetConfigCallback(callback)
    self.ShowFunctionConfig = callback
end

return ZLUILibrary
