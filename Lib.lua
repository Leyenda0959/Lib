-- ZL UI Library v1.0 - Librería Modular Completa
local ZL_UILibrary = {}
ZL_UILibrary.__index = ZL_UILibrary

-- Servicios
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuración por defecto
ZL_UILibrary.DefaultConfig = {
    MainColor = Color3.fromRGB(255, 215, 0),
    BackgroundColor = Color3.fromRGB(20, 20, 25),
    SecondaryColor = Color3.fromRGB(30, 30, 35),
    TextColor = Color3.fromRGB(220, 220, 220),
    AccentColor = Color3.fromRGB(80, 80, 90),
    CornerRadius = 6,
    Font = Enum.Font.Gotham,
    TitleFont = Enum.Font.GothamBold
}

-- Función de inicialización
function ZL_UILibrary:Init(config)
    if config then
        for key, value in pairs(config) do
            if self.DefaultConfig[key] ~= nil then
                self.DefaultConfig[key] = value
            end
        end
    end
    return self
end

-- Función para crear elementos
function ZL_UILibrary:CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        if pcall(function() return element[prop] end) then
            element[prop] = value
        end
    end
    return element
end

-- Función para crear ScreenGui
function ZL_UILibrary:CreateScreenGui(parentTo)
    local screenGui = self:CreateElement("ScreenGui", {
        Name = "ZLCompactUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = parentTo or game:GetService("CoreGui")
    else
        screenGui.Parent = parentTo or game:GetService("CoreGui")
    end
    
    return screenGui
end

-- Función para crear frames redondeados
function ZL_UILibrary:CreateRoundedFrame(config)
    local frame = self:CreateElement("Frame", {
        BackgroundColor3 = config.BackgroundColor or self.DefaultConfig.BackgroundColor,
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        Visible = config.Visible ~= false
    })
    
    self:CreateElement("UICorner", {
        Parent = frame,
        CornerRadius = UDim.new(0, config.CornerRadius or self.DefaultConfig.CornerRadius)
    })
    
    if config.Stroke then
        self:CreateElement("UIStroke", {
            Parent = frame,
            Color = config.StrokeColor or self.DefaultConfig.MainColor,
            Thickness = config.StrokeThickness or 1
        })
    end
    
    if config.Parent then
        frame.Parent = config.Parent
    end
    
    return frame
end

-- Función para crear textos
function ZL_UILibrary:CreateTextLabel(config)
    local label = self:CreateElement("TextLabel", {
        BackgroundTransparency = config.BackgroundTransparency or 1,
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        Font = config.Font or self.DefaultConfig.Font,
        Text = config.Text or "",
        TextColor3 = config.TextColor or self.DefaultConfig.TextColor,
        TextSize = config.TextSize or 14,
        TextXAlignment = config.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = config.TextYAlignment or Enum.TextYAlignment.Center,
        TextWrapped = config.TextWrapped or false
    })
    
    if config.BackgroundColor then
        label.BackgroundTransparency = 0
        label.BackgroundColor3 = config.BackgroundColor
    end
    
    if config.Parent then
        label.Parent = config.Parent
    end
    
    return label
end

-- Función para crear botones
function ZL_UILibrary:CreateButton(config)
    local button = self:CreateElement("TextButton", {
        BackgroundColor3 = config.BackgroundColor or self.DefaultConfig.SecondaryColor,
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        Size = config.Size or UDim2.new(0, 100, 0, 30),
        Font = config.Font or self.DefaultConfig.Font,
        Text = config.Text or "Button",
        TextColor3 = config.TextColor or self.DefaultConfig.TextColor,
        TextSize = config.TextSize or 12,
        AutoButtonColor = config.AutoButtonColor ~= false
    })
    
    self:CreateElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, config.CornerRadius or self.DefaultConfig.CornerRadius)
    })
    
    if config.Stroke then
        self:CreateElement("UIStroke", {
            Parent = button,
            Color = config.StrokeColor or self.DefaultConfig.AccentColor,
            Thickness = 1
        })
    end
    
    if config.Parent then
        button.Parent = config.Parent
    end
    
    -- Efectos hover
    if config.HoverEffects then
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = config.HoverColor or Color3.fromRGB(100, 100, 110)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = config.BackgroundColor or self.DefaultConfig.SecondaryColor
            }):Play()
        end)
    end
    
    if config.OnClick then
        button.MouseButton1Click:Connect(config.OnClick)
    end
    
    return button
end

-- Función para crear toggles
function ZL_UILibrary:CreateToggle(config)
    local toggleFrame = self:CreateRoundedFrame({
        Position = config.Position,
        Size = config.Size or UDim2.new(1, -10, 0, 25),
        BackgroundColor = self.DefaultConfig.SecondaryColor,
        Stroke = true,
        StrokeColor = self.DefaultConfig.AccentColor,
        Parent = config.Parent
    })
    
    local toggleText = self:CreateTextLabel({
        Parent = toggleFrame,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(0.7, -8, 1, 0),
        Text = config.Text or "Toggle",
        TextSize = 12
    })
    
    local toggleButton = self:CreateElement("TextButton", {
        Parent = toggleFrame,
        BackgroundColor3 = self.DefaultConfig.AccentColor,
        Position = UDim2.new(0.7, 5, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        Text = "",
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local configButton = self:CreateButton({
        Parent = toggleFrame,
        Position = UDim2.new(0.85, 5, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        Text = "⚙",
        TextSize = 10,
        BackgroundColor = self.DefaultConfig.AccentColor,
        HoverEffects = true
    })
    
    local toggleState = config.InitialState or false
    
    local function updateToggle()
        if toggleState then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            }):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.DefaultConfig.AccentColor
            }):Play()
        end
        
        if config.OnToggle then
            config.OnToggle(toggleState)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        updateToggle()
    end)
    
    if config.OnConfig then
        configButton.MouseButton1Click:Connect(config.OnConfig)
    end
    
    updateToggle()
    
    return {
        Frame = toggleFrame,
        SetState = function(state)
            toggleState = state
            updateToggle()
        end,
        GetState = function()
            return toggleState
        end
    }
end

-- Función para crear sliders
function ZL_UILibrary:CreateSlider(config)
    local sliderFrame = self:CreateRoundedFrame({
        Position = config.Position,
        Size = config.Size or UDim2.new(1, -10, 0, 40),
        BackgroundColor = self.DefaultConfig.SecondaryColor,
        Stroke = true,
        Parent = config.Parent
    })
    
    local nameLabel = self:CreateTextLabel({
        Parent = sliderFrame,
        Position = UDim2.new(0, 8, 0, 5),
        Size = UDim2.new(1, -16, 0, 15),
        Text = config.Text or "Slider",
        TextSize = 11
    })
    
    local valueLabel = self:CreateTextLabel({
        Parent = sliderFrame,
        Position = UDim2.new(0, 8, 0, 20),
        Size = UDim2.new(1, -16, 0, 15),
        Text = tostring(config.Value or config.Min or 0),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local track = self:CreateElement("Frame", {
        Parent = sliderFrame,
        BackgroundColor3 = self.DefaultConfig.AccentColor,
        Position = UDim2.new(0, 8, 0, 32),
        Size = UDim2.new(1, -16, 0, 4)
    })
    
    self:CreateElement("UICorner", {
        Parent = track,
        CornerRadius = UDim.new(1, 0)
    })
    
    local fill = self:CreateElement("Frame", {
        Parent = track,
        BackgroundColor3 = self.DefaultConfig.MainColor,
        Size = UDim2.new(0, 0, 1, 0)
    })
    
    self:CreateElement("UICorner", {
        Parent = fill,
        CornerRadius = UDim.new(1, 0)
    })
    
    local handle = self:CreateElement("TextButton", {
        Parent = track,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 0, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12),
        Text = "",
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = handle,
        CornerRadius = UDim.new(1, 0)
    })
    
    local min = config.Min or 0
    local max = config.Max or 100
    local current = config.Value or min
    local step = config.Step or 1
    
    local function updateSlider(value)
        current = math.clamp(value, min, max)
        local ratio = (current - min) / (max - min)
        
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        handle.Position = UDim2.new(ratio, -6, 0.5, -6)
        valueLabel.Text = string.format("%.2f", current)
        
        if config.OnChange then
            config.OnChange(current)
        end
    end
    
    local function setValueFromPosition(x)
        local relativeX = math.clamp(x, 0, track.AbsoluteSize.X)
        local ratio = relativeX / track.AbsoluteSize.X
        local value = min + (max - min) * ratio
        value = math.floor(value / step) * step
        updateSlider(value)
    end
    
    handle.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local trackPos = track.AbsolutePosition
                setValueFromPosition(mousePos.X - trackPos.X)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    track.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local trackPos = track.AbsolutePosition
        setValueFromPosition(mousePos.X - trackPos.X)
    end)
    
    updateSlider(current)
    
    return {
        Frame = sliderFrame,
        SetValue = updateSlider,
        GetValue = function() return current end
    }
end

-- Función para crear dropdowns
function ZL_UILibrary:CreateDropdown(config)
    local dropdownFrame = self:CreateRoundedFrame({
        Position = config.Position,
        Size = config.Size or UDim2.new(1, -10, 0, 25),
        BackgroundColor = self.DefaultConfig.SecondaryColor,
        Stroke = true,
        Parent = config.Parent
    })
    
    local currentOption = config.Options[1] or "Select"
    local isOpen = false
    
    local displayLabel = self:CreateTextLabel({
        Parent = dropdownFrame,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Text = currentOption,
        TextSize = 11
    })
    
    local arrowLabel = self:CreateTextLabel({
        Parent = dropdownFrame,
        Position = UDim2.new(1, -20, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Text = "▼",
        TextSize = 10
    })
    
    local optionsFrame = self:CreateRoundedFrame({
        Parent = dropdownFrame,
        Position = UDim2.new(0, 0, 1, 2),
        Size = UDim2.new(1, 0, 0, #config.Options * 25),
        BackgroundColor = self.DefaultConfig.SecondaryColor,
        Stroke = true,
        Visible = false
    })
    
    local function toggleDropdown()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        arrowLabel.Text = isOpen and "▲" or "▼"
    end
    
    local function selectOption(option)
        currentOption = option
        displayLabel.Text = option
        toggleDropdown()
        
        if config.OnSelect then
            config.OnSelect(option)
        end
    end
    
    -- Crear opciones
    for i, option in ipairs(config.Options) do
        local optionButton = self:CreateButton({
            Parent = optionsFrame,
            Position = UDim2.new(0, 0, 0, (i-1) * 25),
            Size = UDim2.new(1, 0, 0, 25),
            Text = option,
            TextSize = 10,
            BackgroundColor = self.DefaultConfig.SecondaryColor,
            CornerRadius = 0,
            Stroke = false,
            OnClick = function()
                selectOption(option)
            end
        })
        
        if i < #config.Options then
            self:CreateElement("Frame", {
                Parent = optionsFrame,
                BackgroundColor3 = self.DefaultConfig.AccentColor,
                Position = UDim2.new(0, 5, 0, i * 25),
                Size = UDim2.new(1, -10, 0, 1)
            })
        end
    end
    
    dropdownFrame.MouseButton1Click:Connect(toggleDropdown)
    
    -- Cerrar dropdown al hacer click fuera
    local function closeDropdown(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = dropdownFrame.AbsolutePosition
            local absSize = dropdownFrame.AbsoluteSize
            
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y + optionsFrame.AbsoluteSize.Y) then
                toggleDropdown()
            end
        end
    end
    
    UserInputService.InputBegan:Connect(closeDropdown)
    
    return {
        Frame = dropdownFrame,
        GetSelected = function() return currentOption end,
        SetSelected = selectOption
    }
end

-- Función para crear ventana principal
function ZL_UILibrary:CreateMainWindow(config)
    local screenGui = self:CreateScreenGui(config.ParentTo)
    
    -- Botón principal flotante
    local mainButton = self:CreateElement("ImageButton", {
        Parent = screenGui,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = config.ButtonPosition or UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0, 35, 0, 35),
        AutoButtonColor = false
    })
    
    self:CreateElement("UICorner", {
        Parent = mainButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local buttonStroke = self:CreateElement("UIStroke", {
        Parent = mainButton,
        Color = self.DefaultConfig.MainColor,
        Thickness = 1
    })
    
    local buttonText = self:CreateTextLabel({
        Parent = mainButton,
        Text = config.ButtonText or "ZL",
        TextColor3 = self.DefaultConfig.MainColor,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    -- Ventana principal
    local mainFrame = self:CreateRoundedFrame({
        Parent = screenGui,
        Position = config.WindowPosition or UDim2.new(0.3, 0, 0.3, 0),
        Size = config.WindowSize or UDim2.new(0, 350, 0, 250),
        Stroke = true,
        StrokeColor = self.DefaultConfig.MainColor,
        Visible = false
    })
    
    -- Barra de título
    local titleBar = self:CreateRoundedFrame({
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor = Color3.fromRGB(15, 15, 20),
        CornerRadius = 0
    })
    
    local titleText = self:CreateTextLabel({
        Parent = titleBar,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Text = config.Title or "ZL PvP",
        Font = self.DefaultConfig.TitleFont
    })
    
    local closeButton = self:CreateButton({
        Parent = titleBar,
        Position = UDim2.new(1, -25, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Text = "X",
        TextSize = 12,
        BackgroundColor = Color3.fromRGB(200, 50, 50),
        OnClick = function()
            mainFrame.Visible = false
            TweenService:Create(mainButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 35, 0, 35)
            }):Play()
        end
    })
    
    -- Contenedor principal
    local container = self:CreateElement("Frame", {
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })
    
    -- Sistema de arrastre
    local dragging = false
    local dragStart, frameStart
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = mainFrame.Position
        end
    end
    
    local function updateDrag(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                frameStart.X.Scale, 
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, 
                frameStart.Y.Offset + delta.Y
            )
        end
    end
    
    local function endDrag()
        dragging = false
    end
    
    titleBar.InputBegan:Connect(startDrag)
    titleBar.InputChanged:Connect(updateDrag)
    UserInputService.InputEnded:Connect(endDrag)
    
    -- Toggle ventana
    mainButton.MouseButton1Click:Connect(function()
        local isVisible = mainFrame.Visible
        mainFrame.Visible = not isVisible
        
        if not isVisible then
            TweenService:Create(mainButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
                Size = UDim2.new(0, 45, 0, 45)
            }):Play()
        else
            TweenService:Create(mainButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 35, 0, 35)
            }):Play()
        end
    end)
    
    return {
        ScreenGui = screenGui,
        MainButton = mainButton,
        MainFrame = mainFrame,
        Container = container,
        TitleBar = titleBar
    }
end

-- Función para crear sistema de tabs
function ZL_UILibrary:CreateTabSystem(parent, tabs)
    local sidebar = self:CreateRoundedFrame({
        Parent = parent,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor = Color3.fromRGB(25, 25, 30)
    })
    
    local contentFrame = self:CreateElement("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 105, 0, 0),
        Size = UDim2.new(1, -105, 1, 0)
    })
    
    local tabContents = {}
    local tabButtons = {}
    local currentTab = nil
    
    for i, tab in ipairs(tabs) do
        -- Botón del tab
        local tabButton = self:CreateButton({
            Parent = sidebar,
            Position = UDim2.new(0, 5, 0, (i-1) * 35 + 5),
            Size = UDim2.new(1, -10, 0, 30),
            Text = tab.Name,
            BackgroundColor = i == 1 and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35),
            HoverEffects = true
        })
        
        -- Contenido del tab
        local tabContent = self:CreateElement("ScrollingFrame", {
            Parent = contentFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = i == 1,
            CanvasSize = UDim2.new(0, 0, 0, 400),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.DefaultConfig.AccentColor
        })
        
        tabContents[tab.Name] = tabContent
        tabButtons[tab.Name] = tabButton
        
        if i == 1 then
            currentTab = tab.Name
        end
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                tabContents[currentTab].Visible = false
                TweenService:Create(tabButtons[currentTab], TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                }):Play()
            end
            
            currentTab = tab.Name
            tabContent.Visible = true
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            }):Play()
            
            if tab.OnSelected then
                tab.OnSelected()
            end
        end)
    end
    
    return {
        Sidebar = sidebar,
        ContentFrame = contentFrame,
        TabContents = tabContents,
        TabButtons = tabButtons,
        CurrentTab = currentTab
    }
end

-- Función para crear iconos flotantes
function ZL_UILibrary:CreateFloatingIcon(config)
    local icon = self:CreateButton({
        Parent = config.Parent,
        Position = config.Position or UDim2.new(0, 100, 0, 100),
        Size = config.Size or UDim2.new(0, 80, 0, 32),
        Text = config.Text or "Icon",
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        AutoButtonColor = false
    })
    
    local dot = self:CreateElement("Frame", {
        Parent = icon,
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(1, -14, 0, 12),
        BackgroundColor3 = config.Active and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(200, 50, 50)
    })
    
    self:CreateElement("UICorner", {
        Parent = dot,
        CornerRadius = UDim.new(1, 0)
    })
    
    if config.OnClick then
        icon.MouseButton1Click:Connect(config.OnClick)
    end
    
    return {
        Icon = icon,
        Dot = dot,
        SetActive = function(active)
            dot.BackgroundColor3 = active and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(200, 50, 50)
            icon.TextColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        end
    }
end

return ZL_UILibrary
