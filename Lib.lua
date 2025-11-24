-- ZL_UI.lua - Biblioteca de Interfaz para ZL Hub
local ZL_UI = {}

-- Servicios
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Variables de la UI
ZL_UI.screenGui = nil
ZL_UI.mainFrame = nil
ZL_UI.configFrame = nil
ZL_UI.uiOpen = false
ZL_UI.dragging = false
ZL_UI.currentSection = "Combat"
ZL_UI.floatingIcons = {}
ZL_UI.sectionContents = {}
ZL_UI.sectionButtons = {}

-- Función para crear elementos
function ZL_UI.createElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- Función para crear botones de sección
function ZL_UI.createSectionButton(name, position, isFirst, parent)
    local button = ZL_UI.createElement("TextButton", {
        Parent = parent,
        Name = name .. "Btn",
        BackgroundColor3 = isFirst and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35),
        Position = position,
        Size = UDim2.new(1, -10, 0, 30),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(250, 215, 0),
        TextSize = 12,
        AutoButtonColor = false
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    return button
end

-- Función para crear controles de ajuste
function ZL_UI.createAdjustmentControl(name, position, parent, minValue, maxValue, step, currentValue, callback)
    local controlFrame = ZL_UI.createElement("Frame", {
        Parent = parent,
        Name = name .. "Control",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Position = position,
        Size = UDim2.new(1, -10, 0, 25)
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = controlFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    ZL_UI.createElement("UIStroke", {
        Parent = controlFrame,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    local nameLabel = ZL_UI.createElement("TextLabel", {
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
    
    local valueLabel = ZL_UI.createElement("TextLabel", {
        Parent = controlFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.4, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = string.format("%.2f", currentValue),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11
    })
    
    local minusButton = ZL_UI.createElement("TextButton", {
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
    
    ZL_UI.createElement("UICorner", {
        Parent = minusButton,
        CornerRadius = UDim.new(0, 3)
    })
    
    local plusButton = ZL_UI.createElement("TextButton", {
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
    
    ZL_UI.createElement("UICorner", {
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
    
    setupButtonEffects(minusButton)
    setupButtonEffects(plusButton)
    
    currentValue = updateValue(currentValue)
    
    return controlFrame
end

-- Función para crear toggle buttons
function ZL_UI.createToggle(name, position, parent, funcName, customCallback, initialState, configCallback)
    local toggleFrame = ZL_UI.createElement("Frame", {
        Parent = parent,
        Name = name .. "Toggle",
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Position = position,
        Size = UDim2.new(1, -10, 0, 25)
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    ZL_UI.createElement("UIStroke", {
        Parent = toggleFrame,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    local toggleText = ZL_UI.createElement("TextButton", {
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
    
    local toggleButton = ZL_UI.createElement("TextButton", {
        Parent = toggleFrame,
        Name = "ToggleBtn",
        BackgroundColor3 = Color3.fromRGB(80, 80, 90),
        Position = UDim2.new(0.7, 5, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        Font = Enum.Font.SourceSans,
        Text = "",
        AutoButtonColor = false
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Botón de configuración
    local configButton = ZL_UI.createElement("TextButton", {
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
    
    ZL_UI.createElement("UICorner", {
        Parent = configButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    local isConfigToggle = customCallback ~= nil
    local toggleState = initialState or false
    
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
            if ZL_UI.onToggleChanged then
                ZL_UI.onToggleChanged(funcName, toggleState)
            end
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        updateToggle()
    end)
    
    configButton.MouseButton1Click:Connect(function()
        if configCallback then
            configCallback(funcName)
        elseif ZL_UI.onConfigClicked then
            ZL_UI.onConfigClicked(funcName)
        end
    end)
    
    -- Efectos hover
    configButton.MouseEnter:Connect(function()
        TweenService:Create(configButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 110)
        }):Play()
    end)
    
    configButton.MouseLeave:Connect(function()
        TweenService:Create(configButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        }):Play()
    end)
    
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

-- Función para mostrar configuración de función
function ZL_UI.showFunctionConfig(funcName, settings)
    if not ZL_UI.configFrame then return end
    
    -- Limpiar contenido anterior
    for _, child in ipairs(ZL_UI.configContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Actualizar título
    ZL_UI.configTitle.Text = "CONFIGURACIÓN - " .. funcName:upper()
    
    -- Crear controles según la función
    if funcName == "Aimbot" and settings then
        ZL_UI.createAdjustmentControl("Rango", UDim2.new(0, 0, 0, 0), ZL_UI.configContent, 5, 50, 1, settings.Range or 25, function(value)
            if ZL_UI.onSettingChanged then
                ZL_UI.onSettingChanged(funcName, "Range", value)
            end
        end)
        
        ZL_UI.createAdjustmentControl("Suavizado", UDim2.new(0, 0, 0, 30), ZL_UI.configContent, 0.08, 1, 0.01, settings.SoftCamera or 0.08, function(value)
            if ZL_UI.onSettingChanged then
                ZL_UI.onSettingChanged(funcName, "SoftCamera", value)
            end
        end)
        
        ZL_UI.configContent.CanvasSize = UDim2.new(0, 0, 0, 60)
    elseif funcName == "SpeedBoost" and settings then
        ZL_UI.createAdjustmentControl("Velocidad Base", UDim2.new(0, 0, 0, 0), ZL_UI.configContent, 10, 100, 1, settings.BaseSpeed or 27, function(value)
            if ZL_UI.onSettingChanged then
                ZL_UI.onSettingChanged(funcName, "BaseSpeed", value)
            end
        end)
        
        ZL_UI.configContent.CanvasSize = UDim2.new(0, 0, 0, 30)
    end
    
    -- Mostrar panel de configuración
    ZL_UI.configFrame.Visible = true
end

-- Función para crear iconos flotantes
function ZL_UI.createFloatingIcon(funcName, displayName, position)
    if ZL_UI.floatingIcons[funcName] then
        ZL_UI.floatingIcons[funcName]:Destroy()
    end
    
    local displayTexts = {
        Aimbot = "Aim",
        SpeedBoost = "Speed", 
        AntiKnockback = "AntiKB",
        AutoHit = "AutoHit",
        InfiniteJump = "Jump"
    }
    
    local pos = position or {x = 620, y = 20 + (#ZL_UI.floatingIcons * 40)}
    local displayText = displayTexts[funcName] or displayName:sub(1, 3)
    
    local icon = ZL_UI.createElement("TextButton", {
        Parent = ZL_UI.screenGui,
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
    
    ZL_UI.createElement("UICorner", {
        Parent = icon,
        CornerRadius = UDim.new(0, 6)
    })
    
    ZL_UI.floatingIcons[funcName] = icon
    
    return icon
end

-- Función para inicializar la UI
function ZL_UI.Initialize(callbacks)
    -- Configurar callbacks
    ZL_UI.onToggleChanged = callbacks.onToggleChanged
    ZL_UI.onConfigClicked = callbacks.onConfigClicked
    ZL_UI.onSettingChanged = callbacks.onSettingChanged
    
    -- Crear ScreenGui
    ZL_UI.screenGui = ZL_UI.createElement("ScreenGui", {
        Name = "ZLCompactUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if gethui then
        ZL_UI.screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ZL_UI.screenGui)
        ZL_UI.screenGui.Parent = game:GetService("CoreGui")
    else
        ZL_UI.screenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Crear botón principal
    local mainButton = ZL_UI.createElement("ImageButton", {
        Parent = ZL_UI.screenGui,
        Name = "MainButton",
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0, 35, 0, 35),
        AutoButtonColor = false,
        Active = true,
        Draggable = true
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = mainButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local buttonText = ZL_UI.createElement("TextLabel", {
        Parent = mainButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "ZL",
        TextColor3 = Color3.fromRGB(255, 215, 0),
        TextSize = 14
    })
    
    -- Crear menú principal
    ZL_UI.mainFrame = ZL_UI.createElement("Frame", {
        Parent = ZL_UI.screenGui,
        Name = "MainFrame",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 350, 0, 250),
        Visible = false
    })
    
    ZL_UI.createElement("UICorner", {
        Parent = ZL_UI.mainFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Barra de título
    local titleBar = ZL_UI.createElement("Frame", {
        Parent = ZL_UI.mainFrame,
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local titleText = ZL_UI.createElement("TextLabel", {
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
    
    -- Botón cerrar
    local closeButton = ZL_UI.createElement("TextButton", {
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
    
    -- Contenedor principal
    local container = ZL_UI.createElement("Frame", {
        Parent = ZL_UI.mainFrame,
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })
    
    -- Barra lateral
    local sidebar = ZL_UI.createElement("Frame", {
        Parent = container,
        Name = "Sidebar",
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Size = UDim2.new(0, 100, 1, 0)
    })
    
    -- Contenido
    local contentFrame = ZL_UI.createElement("Frame", {
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
        ZL_UI.sectionButtons[sectionName] = ZL_UI.createSectionButton(sectionName, buttonPos, i == 1, sidebar)
        
        ZL_UI.sectionContents[sectionName] = ZL_UI.createElement("ScrollingFrame", {
            Parent = contentFrame,
            Name = sectionName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = i == 1,
            CanvasSize = UDim2.new(0, 0, 0, 400),
            ScrollBarThickness = 3
        })
    end
    
    -- Conectar eventos
    mainButton.MouseButton1Click:Connect(function()
        ZL_UI.uiOpen = not ZL_UI.uiOpen
        ZL_UI.mainFrame.Visible = ZL_UI.uiOpen
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        ZL_UI.uiOpen = false
        ZL_UI.mainFrame.Visible = false
    end)
    
    -- Sistema de arrastre
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = ZL_UI.mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ZL_UI.mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    print("✅ ZL UI Biblioteca Cargada")
    return ZL_UI
end

return ZL_UI
