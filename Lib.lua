pcall(function()
    game:GetService('CoreGui'):FindFirstChild('ui'):Remove()
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Create UI
function Library:Window(title)
    local ui = Instance.new("ScreenGui")
    ui.Name = "ui"
    ui.Parent = CoreGui
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.377, 0, 0.368, 0)
    Main.Size = UDim2.new(0, 470, 0, 283)
    Main.Active = true
    Main.Selectable = true
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateInput(input)
        local Delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
    end
    
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = Main
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shadow.BackgroundTransparency = 1.000
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    
    -- Top Bar
    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 34)
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 6)
    TopCorner.Parent = Top
    
    local TopCover = Instance.new("Frame")
    TopCover.Name = "Cover"
    TopCover.Parent = Top
    TopCover.AnchorPoint = Vector2.new(0.5, 1)
    TopCover.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    TopCover.BorderSizePixel = 0
    TopCover.Position = UDim2.new(0.5, 0, 1, 0)
    TopCover.Size = UDim2.new(1, 0, 0, 4)
    
    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.Parent = Top
    Line.AnchorPoint = Vector2.new(0.5, 1)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.920
    Line.Position = UDim2.new(0.5, 0, 1, 1)
    Line.Size = UDim2.new(1, 0, 0, 1)
    
    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = Top
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.Position = UDim2.new(0, 4, 0.5, 0)
    Logo.Size = UDim2.new(0, 26, 0, 30)
    Logo.Image = "http://www.roblox.com/asset/?id=110728705873113"
    Logo.ImageColor3 = Color3.fromRGB(232, 17, 85)
    
    -- Minimize Button (using minus icon)
    local Minimize = Instance.new("ImageButton")
    Minimize.Name = "Minimize"
    Minimize.Parent = Top
    Minimize.AnchorPoint = Vector2.new(1, 0.5)
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.BackgroundTransparency = 1.000
    Minimize.Position = UDim2.new(1, -6, 0.5, 0)  -- ← DE -30 A -6
    Minimize.Size = UDim2.new(0, 20, 0, 20)
    Minimize.Image = "rbxassetid://7733771811" -- Minus icon
    Minimize.ImageColor3 = Color3.fromRGB(199, 199, 199)
    Minimize.ScaleType = Enum.ScaleType.Crop
        
    -- Minimized Icon (initially hidden)
    local MinimizedIcon = Instance.new("ImageButton")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.Parent = ui
    MinimizedIcon.AnchorPoint = Vector2.new(1, 1)
    MinimizedIcon.BackgroundColor3 = Color3.fromRGB(232, 17, 85)
    MinimizedIcon.BackgroundTransparency = 0
    MinimizedIcon.BorderSizePixel = 0
    MinimizedIcon.Position = UDim2.new(1, -20, 1, -20)
    MinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
    MinimizedIcon.Visible = false
    MinimizedIcon.ZIndex = 10
    MinimizedIcon.Image = "http://www.roblox.com/asset/?id=110728705873113"
    
    local MinimizedCorner = Instance.new("UICorner")
    MinimizedCorner.CornerRadius = UDim.new(0, 8)
    MinimizedCorner.Parent = MinimizedIcon
    
    -- Make minimized icon draggable
    local minDragging = false
    local minDragInput, minDragStart, minStartPos
    
    local function updateMinInput(input)
        local Delta = input.Position - minDragStart
        MinimizedIcon.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + Delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + Delta.Y)
    end
    
    MinimizedIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            minDragging = true
            minDragStart = input.Position
            minStartPos = MinimizedIcon.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    minDragging = false
                end
            end)
        end
    end)
    
    MinimizedIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            minDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == minDragInput and minDragging then
            updateMinInput(input)
        end
    end)
    
    -- Minimize functionality
    Minimize.MouseButton1Click:Connect(function()
        Main.Visible = false
        MinimizedIcon.Visible = true
    end)
    
    Minimize.MouseEnter:Connect(function()
        TweenService:Create(Minimize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    
    Minimize.MouseLeave:Connect(function()
        TweenService:Create(Minimize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(166, 166, 166)}):Play()
    end)
    
    -- Restore functionality
    MinimizedIcon.MouseButton1Click:Connect(function()
        Main.Visible = true
        MinimizedIcon.Visible = false
    end)
    
    -- Close Button (OCULTO)
    local Close = Instance.new("ImageButton")
    Close.Name = "Close"
    Close.Parent = Top
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 1.000
    Close.Position = UDim2.new(1, -6, 0.5, 0)
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Image = "http://www.roblox.com/asset/?id=7755372427"
    Close.ImageColor3 = Color3.fromRGB(199, 199, 199)
    Close.ScaleType = Enum.ScaleType.Crop
    Close.Visible = false  -- ← ESTA ES LA LÍNEA IMPORTANTE
    Close.Active = false   -- ← Y ESTA TAMBIÉN

-- Mantener estas funciones por si acaso, pero no se ejecutarán porque el botón está oculto
Close.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(166, 166, 166)}):Play()
end)
    
    -- Title
    local GameName = Instance.new("TextLabel")
    GameName.Name = "GameName"
    GameName.Parent = Top 
    GameName.AnchorPoint = Vector2.new(0, 0.5)
    GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GameName.BackgroundTransparency = 1.000
    GameName.Position = UDim2.new(0, 32, 0.5, 0)
    GameName.Size = UDim2.new(0, 165, 0, 22)
    GameName.Font = Enum.Font.Gotham
    GameName.Text = title or "Game Name"
    GameName.TextColor3 = Color3.fromRGB(232, 17, 85)
    GameName.TextSize = 14.000
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tabs Container
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.Parent = Main
    Tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0, 0, 0, 35)
    Tabs.Size = UDim2.new(0, 122, 1, -35)
    
    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = UDim.new(0, 6)
    TabsCorner.Parent = Tabs
    
    local TabsCover = Instance.new("Frame")
    TabsCover.Name = "Cover"
    TabsCover.Parent = Tabs
    TabsCover.AnchorPoint = Vector2.new(1, 0.5)
    TabsCover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    TabsCover.BorderSizePixel = 0
    TabsCover.Position = UDim2.new(1, 0, 0.5, 0)
    TabsCover.Size = UDim2.new(0, 5, 1, 0)
    
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = Tabs
    TabsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsContainer.BackgroundTransparency = 1.000
    TabsContainer.Size = UDim2.new(1, 0, 1, 0)
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.Name = "TabsList"
    TabsList.Parent = TabsContainer
    TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0, 5)
    
    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.Parent = TabsContainer
    TabsPadding.PaddingTop = UDim.new(0, 5)
    
    -- Pages Container
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Parent = Main
    Pages.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Pages.BorderSizePixel = 0
    Pages.Position = UDim2.new(0, 130, 0, 42)
    Pages.Size = UDim2.new(1, -138, 1, -50)
    
    local PagesCorner = Instance.new("UICorner")
    PagesCorner.CornerRadius = UDim.new(0, 6)
    PagesCorner.Parent = Pages
    
    -- Resize Button
    local Resize = Instance.new("ImageButton")
    Resize.Name = "Resize"
    Resize.Parent = Main
    Resize.AnchorPoint = Vector2.new(1, 1)
    Resize.BackgroundTransparency = 1.000
    Resize.Position = UDim2.new(1, -4, 1, -4)
    Resize.Size = UDim2.new(0, 16, 0, 16)
    Resize.ZIndex = 2
    Resize.Image = "rbxassetid://3926307971"
    Resize.ImageColor3 = Color3.fromRGB(186, 13, 68)
    Resize.ImageRectOffset = Vector2.new(204, 364)
    Resize.ImageRectSize = Vector2.new(36, 36)
    
    -- Resize functionality
    local resizing = false
    local resizeStart, startSize
    
    Resize.MouseButton1Down:Connect(function()
        resizing = true
        resizeStart = Vector2.new(Mouse.X, Mouse.Y)
        startSize = Main.Size
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = Vector2.new(input.Position.X - resizeStart.X, input.Position.Y - resizeStart.Y)
            Main.Size = UDim2.new(0, math.max(470, startSize.X.Offset + delta.X), 0, math.max(283, startSize.Y.Offset + delta.Y))
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
    
    -- Tab functionality
    local TabFunctions = {}
    function TabFunctions:Tab(tabInfo)
        local title, icon
        if type(tabInfo) == "table" then
            title = tabInfo[1] or "Tab"
            icon = tabInfo[2]
        else
            title = tabInfo or "Tab"
        end
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton"
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(232, 17, 85)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -12, 0, 30)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(72,72,72)
        TabButton.TextSize = 14.000
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Create container for icon and text
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent"
        TabContent.Parent = TabButton
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        
        -- Add icon if provided
        local Icon = nil
        if icon then
            Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Parent = TabContent
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0, 5, 0.5, -10)
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Image = icon
            Icon.ImageColor3 = Color3.fromRGB(232, 17, 85)
        end
        
        -- Add text label
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "TextLabel"
        TextLabel.Parent = TabContent
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.Text = title
        TextLabel.TextColor3 = Color3.fromRGB(72,72,72)
        TextLabel.TextSize = 14.000
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        -- Adjust text position if icon is present
        if Icon then
            TextLabel.Position = UDim2.new(0, 25, 0, 0)
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page"
        Page.Visible = false
        Page.Parent = Pages
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Page.BackgroundTransparency = 1.000
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasPosition = Vector2.new(0, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 24, 101)
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 6)
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 5)
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y)
        end)
        
        -- Tab button functionality
        TabButton.MouseButton1Click:Connect(function()
            for _,v in next, Pages:GetChildren() do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
            
            for _,v in next, TabsContainer:GetChildren() do
                if v.Name == 'TabButton' then
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    if v:FindFirstChild("TabContent") and v.TabContent:FindFirstChild("TextLabel") then
                        TweenService:Create(v.TabContent.TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(72,72,72)}):Play()
                    end
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        
        -- First tab should be selected by default
        if #TabsContainer:GetChildren() == 1 then
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end
        
        -- Element functions
        local Elements = {}
        
        -- Button
        function Elements:Button(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -6, 0, 34)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.Gotham
            Button.Text = text or "Button"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14.000
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(160, 12, 59)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(134, 10, 49)}):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            -- Mobile support
            Button.TouchTap:Connect(function()
                callback()
            end)
        end
        
        -- Toggle
-- Toggle con animación de switch estilo iOS
function Elements:Toggle(text, default, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = Page
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, -6, 0, 34)
    Toggle.AutoButtonColor = false
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = ""
    Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.TextSize = 14.000
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Toggle
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0, 8, 0, 0)
    Title.Size = UDim2.new(1, -6, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = text or "Toggle"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Switch Container (estilo iOS)
    local SwitchContainer = Instance.new("Frame")
    SwitchContainer.Name = "SwitchContainer"
    SwitchContainer.Parent = Toggle
    SwitchContainer.AnchorPoint = Vector2.new(1, 0.5)
    SwitchContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SwitchContainer.BorderSizePixel = 0
    SwitchContainer.Position = UDim2.new(1, -8, 0.5, 0)
    SwitchContainer.Size = UDim2.new(0, 36, 0, 20)
    
    local SwitchContainerCorner = Instance.new("UICorner")
    SwitchContainerCorner.CornerRadius = UDim.new(1, 0)
    SwitchContainerCorner.Parent = SwitchContainer
    
    local SwitchContainerStroke = Instance.new("UIStroke")
    SwitchContainerStroke.Parent = SwitchContainer
    SwitchContainerStroke.Color = Color3.fromRGB(80, 80, 80)
    SwitchContainerStroke.Thickness = 1
    
    -- Switch Circle (botón deslizante)
    local SwitchCircle = Instance.new("Frame")
    SwitchCircle.Name = "SwitchCircle"
    SwitchCircle.Parent = SwitchContainer
    SwitchCircle.AnchorPoint = Vector2.new(0, 0.5)
    SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchCircle.BorderSizePixel = 0
    SwitchCircle.Position = UDim2.new(0, 2, 0.5, 0)
    SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
    
    local SwitchCircleCorner = Instance.new("UICorner")
    SwitchCircleCorner.CornerRadius = UDim.new(1, 0)
    SwitchCircleCorner.Parent = SwitchCircle
    
    local SwitchCircleStroke = Instance.new("UIStroke")
    SwitchCircleStroke.Parent = SwitchCircle
    SwitchCircleStroke.Color = Color3.fromRGB(200, 200, 200)
    SwitchCircleStroke.Thickness = 1
    
    local toggled = default or false
    
    -- Función para actualizar la animación del switch
    local function updateSwitchAnimation()
        if toggled then
            -- Estado ACTIVADO
            TweenService:Create(SwitchContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 0, 170, 255 xd
            }):Play()
            
            TweenService:Create(SwitchContainerStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(136, 8, 8)
            }):Play()
            
            TweenService:Create(SwitchCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -18, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            TweenService:Create(SwitchCircleStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(230, 230, 230)
            }):Play()
        else
            -- Estado DESACTIVADO
            TweenService:Create(SwitchContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
            
            TweenService:Create(SwitchContainerStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(80, 80, 80)
            }):Play()
            
            TweenService:Create(SwitchCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            TweenService:Create(SwitchCircleStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
    end
    
    -- Configurar estado inicial
    if toggled then
        SwitchContainer.BackgroundColor3 = Color3.fromRGB(136, 8, 8)
        SwitchContainerStroke.Color = Color3.fromRGB(0, 140, 255)
        SwitchCircle.Position = UDim2.new(1, -18, 0.5, 0)
    else
        SwitchContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SwitchContainerStroke.Color = Color3.fromRGB(80, 80, 80)
        SwitchCircle.Position = UDim2.new(0, 2, 0.5, 0)
    end
    
    -- Efectos hover
    Toggle.MouseEnter:Connect(function()
        TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)
    
    Toggle.MouseLeave:Connect(function()
        TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end)
    
    -- Click functionality
    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateSwitchAnimation()
        callback(toggled)
    end)
    
    -- Efecto de pulsación en el círculo
    local function circlePressEffect()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 14, 0, 14)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(SwitchCircle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 16, 0, 16)
        }):Play()
    end
    
SwitchContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggled = not toggled
        circlePressEffect()
        updateSwitchAnimation()
        callback(toggled)
    end
end)

SwitchCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggled = not toggled
        circlePressEffect()
        updateSwitchAnimation()
        callback(toggled)
    end
end)
    
    -- Mobile support
    Toggle.TouchTap:Connect(function()
        Toggle.MouseButton1Click:Fire()
    end)
    
    SwitchContainer.TouchTap:Connect(function()
        SwitchContainer.MouseButton1Click:Fire()
    end)
    
    -- Función para cambiar el estado externamente
    local toggleFunctions = {}
    
    function toggleFunctions:SetState(newState)
        toggled = newState
        updateSwitchAnimation()
        callback(toggled)
    end
    
    function toggleFunctions:GetState()
        return toggled
    end
    
    return toggleFunctions
end
        
        -- Label
        function Elements:Label(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = Page
            Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Label.BorderSizePixel = 0
            Label.Size = UDim2.new(1, -6, 0, 34)
            Label.Font = Enum.Font.Gotham
            Label.Text = "  " .. (text or "Label")
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14.000
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = Label
        end
        
        -- Slider
        function Elements:Slider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
            Slider.Parent = Page
            Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Slider.Size = UDim2.new(1, -6, 0, 48)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = Slider
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 0, 34)
            Title.Font = Enum.Font.Gotham
            Title.Text = text or "Slider"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Value = Instance.new("TextLabel")
            Value.Name = "Value"
            Value.Parent = Slider
            Value.AnchorPoint = Vector2.new(1, 0)
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Position = UDim2.new(1, -10, 0, 0)
            Value.Size = UDim2.new(1, 0, 0, 34)
            Value.Font = Enum.Font.Gotham
            Value.Text = tostring(default)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14.000
            Value.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderClick = Instance.new("TextButton")
            SliderClick.Name = "SliderClick"
            SliderClick.Parent = Slider
            SliderClick.AnchorPoint = Vector2.new(0.5, 1)
            SliderClick.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
            SliderClick.Position = UDim2.new(0.5, 0, 1, -8)
            SliderClick.Size = UDim2.new(1, -12, 0, 6)
            SliderClick.AutoButtonColor = false
            SliderClick.Text = ''
            
            local SliderClickCorner = Instance.new("UICorner")
            SliderClickCorner.CornerRadius = UDim.new(0, 6)
            SliderClickCorner.Parent = SliderClick
            
            local SliderDrag = Instance.new("Frame")
            SliderDrag.Name = "SliderDrag"
            SliderDrag.Parent = SliderClick
            SliderDrag.BackgroundColor3 = Color3.fromRGB(188, 14, 69)
            SliderDrag.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local SliderDragCorner = Instance.new("UICorner")
            SliderDragCorner.CornerRadius = UDim.new(0, 6)
            SliderDragCorner.Parent = SliderDrag
            
            local dragging = false
            
            local function slide(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - SliderClick.AbsolutePosition.X) / SliderClick.AbsoluteSize.X, 0, 1),
                    0, 0, 6
                )
                SliderDrag:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                local value = math.floor(min + (pos.X.Scale * (max - min)))
                Value.Text = tostring(value)
                callback(value)
            end
            
            SliderClick.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    slide(input)
                    dragging = true
                end
            end)
            
            SliderClick.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    slide(input)
                end
            end)
        end
        
        -- Keybind
        function Elements:Keybind(text, defaultKey, callback)
            local Keybind = Instance.new("TextButton")
            Keybind.Name = "Keybind"
            Keybind.Parent = Page
            Keybind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Keybind.Size = UDim2.new(1, -6, 0, 34)
            Keybind.AutoButtonColor = false
            Keybind.Font = Enum.Font.SourceSans
            Keybind.Text = ""
            Keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.TextSize = 14.000
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = Keybind
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = Keybind
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text or "Keybind"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local CurrentKey = Instance.new("TextLabel")
            CurrentKey.Name = "CurrentKey"
            CurrentKey.Parent = Keybind
            CurrentKey.AnchorPoint = Vector2.new(1, 0.5)
            CurrentKey.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            CurrentKey.Position = UDim2.new(1, -6, 0.5, 0)
            CurrentKey.Size = UDim2.new(-0, 46, 0, 24)
            CurrentKey.Font = Enum.Font.Gotham
            CurrentKey.Text = defaultKey.Name or ". . ."
            CurrentKey.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentKey.TextSize = 14.000
            
            local CurrentKeyCorner = Instance.new("UICorner")
            CurrentKeyCorner.CornerRadius = UDim.new(0, 4)
            CurrentKeyCorner.Parent = CurrentKey
            
            local binding = false
            local key = defaultKey
            
            Keybind.MouseButton1Click:Connect(function()
                binding = true
                CurrentKey.Text = ". . ."
                
                local input
                input = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        CurrentKey.Text = key.Name
                        binding = false
                        input:Disconnect()
                    end
                end)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == key then
                    callback(key)
                end
            end)
            
            -- Mobile support
            Keybind.TouchTap:Connect(function()
                Keybind.MouseButton1Click:Fire()
            end)
        end
        
        -- InputBox
        function Elements:InputBox(text, placeholder, callback)
            local InputBox = Instance.new("Frame")
            InputBox.Name = "InputBox"
            InputBox.Parent = Page
            InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            InputBox.Size = UDim2.new(1, -6, 0, 48)
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = InputBox
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 0, 20)
            Title.Font = Enum.Font.Gotham
            Title.Text = text or "Input"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Box = Instance.new("TextBox")
            Box.Name = "Box"
            Box.Parent = InputBox
            Box.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            Box.BorderSizePixel = 0
            Box.Position = UDim2.new(0, 8, 0, 24)
            Box.Size = UDim2.new(1, -16, 0, 20)
            Box.Font = Enum.Font.Gotham
            Box.PlaceholderText = placeholder or "Enter text..."
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.TextSize = 14.000
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = Box
            
            Box.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Box.Text)
                end
            end)
            
            -- Mobile support
            Box.TouchTap:Connect(function()
                Box:CaptureFocus()
            end)
        end
        
        -- Dropdown
        function Elements:Dropdown(text, options, callback, multiSelect)
            multiSelect = multiSelect or false
            options = options or {}
            callback = callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Page
            Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.BackgroundTransparency = 1.000
            Dropdown.BorderSizePixel = 0
            Dropdown.ClipsDescendants = true
            Dropdown.Size = UDim2.new(1, -6, 0, 34)
            
            local DropdownList = Instance.new("UIListLayout")
            DropdownList.Parent = Dropdown
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 5)
            
            local Choose = Instance.new("Frame")
            Choose.Name = "Choose"
            Choose.Parent = Dropdown
            Choose.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Choose.BorderSizePixel = 0
            Choose.Size = UDim2.new(1, 0, 0, 34)
            
            local ChooseCorner = Instance.new("UICorner")
            ChooseCorner.CornerRadius = UDim.new(0, 6)
            ChooseCorner.Parent = Choose
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = Choose
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text or "Dropdown"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Arrow = Instance.new("ImageButton")
            Arrow.Name = "Arrow"
            Arrow.Parent = Choose
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.BackgroundTransparency = 1.000
            Arrow.LayoutOrder = 10
            Arrow.Position = UDim2.new(1, -2, 0.5, 0)
            Arrow.Size = UDim2.new(0, 28, 0, 28)
            Arrow.ZIndex = 2
            Arrow.Image = "rbxassetid://3926307971"
            Arrow.ImageColor3 = Color3.fromRGB(161, 12, 59)
            Arrow.ImageRectOffset = Vector2.new(324, 524)
            Arrow.ImageRectSize = Vector2.new(36, 36)
            Arrow.ScaleType = Enum.ScaleType.Crop
            
            local OptionHolder = Instance.new("Frame")
            OptionHolder.Name = "OptionHolder"
            OptionHolder.Parent = Dropdown
            OptionHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OptionHolder.BorderSizePixel = 0
            OptionHolder.Position = UDim2.new(0, 0, 0, 34)
            OptionHolder.Size = UDim2.new(1, 0, 0, 0)
            
            local OptionHolderCorner = Instance.new("UICorner")
            OptionHolderCorner.CornerRadius = UDim.new(0, 6)
            OptionHolderCorner.Parent = OptionHolder
            
            local OptionList = Instance.new("UIListLayout")
            OptionList.Name = "OptionList"
            OptionList.Parent = OptionHolder
            OptionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            OptionList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionList.Padding = UDim.new(0, 5)
            
            local OptionPadding = Instance.new("UIPadding")
            OptionPadding.Parent = OptionHolder
            OptionPadding.PaddingTop = UDim.new(0, 8)
            
            local dropped = false
            local selected = {}
            
            local function updateTitle()
                if multiSelect then
                    local selectedList = {}
                    for item, _ in pairs(selected) do
                        table.insert(selectedList, item)
                    end
                    
                    if #selectedList > 0 then
                        if #selectedList <= 3 then
                            Title.Text = text .. ": " .. table.concat(selectedList, ", ")
                        else
                            Title.Text = text .. ": " .. #selectedList .. " selected"
                        end
                    else
                        Title.Text = text
                    end
                end
            end
            
            -- Create options
            for i, option in ipairs(options) do
                local Option = Instance.new("TextButton")
                Option.Name = "Option"
                Option.Parent = OptionHolder
                Option.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
                Option.BorderSizePixel = 0
                Option.Size = UDim2.new(1, -16, 0, 30)
                Option.AutoButtonColor = false
                Option.Font = Enum.Font.Gotham
                Option.Text = option
                Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                Option.TextSize = 14.000
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = Option
                
                -- Add checkmark for multi-select
                if multiSelect then
                    local Checkmark = Instance.new("ImageLabel")
                    Checkmark.Name = "Checkmark"
                    Checkmark.Parent = Option
                    Checkmark.BackgroundTransparency = 1
                    Checkmark.Image = "rbxassetid://6031068421"
                    Checkmark.ImageTransparency = 1
                    Checkmark.Size = UDim2.new(0, 16, 0, 16)
                    Checkmark.Position = UDim2.new(0, 8, 0.5, -8)
                end
                
                Option.MouseButton1Click:Connect(function()
                    if multiSelect then
                        -- Toggle selection
                        if selected[option] then
                            selected[option] = nil
                            Option.Checkmark.ImageTransparency = 1
                        else
                            selected[option] = true
                            Option.Checkmark.ImageTransparency = 0
                        end
                        
                        updateTitle()
                        
                        -- Pass selected items to callback
                        local selectedList = {}
                        for item, _ in pairs(selected) do
                            table.insert(selectedList, item)
                        end
                        callback(selectedList)
                    else
                        -- Single select
                        callback(option)
                        Title.Text = text .. ": " .. option
                        dropped = false
                        TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                    end
                end)
                
                -- Mobile support
                Option.TouchTap:Connect(function()
                    Option.MouseButton1Click:Fire()
                end)
            end
            
            -- Update option holder size
            OptionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if dropped then
                    OptionHolder.Size = UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15)
                    Dropdown.Size = UDim2.new(1, -6, 0, 34 + OptionList.AbsoluteContentSize.Y + 15)
                end
            end)
            
            -- Toggle dropdown
            Choose.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dropped = not dropped
                    
                    if dropped then
                        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34 + OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
                        TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
                    else
                        TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
                    end
                end
            end)
            
            -- Mobile support
Choose.TouchTap:Connect(function()
    dropped = not dropped
    if dropped then
        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34 + OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
        TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
    else
        TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
    end
end)
            
            -- Dropdown functions
            local DropdownFunctions = {}
            
            function DropdownFunctions:Refresh(newOptions)
                newOptions = newOptions or {}
                selected = {}
                dropped = false
                
                TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                
                -- Clear existing options
                for _, child in ipairs(OptionHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Reset title
                Title.Text = text
                
                -- Create new options
                for i, option in ipairs(newOptions) do
                    local Option = Instance.new("TextButton")
                    Option.Name = "Option"
                    Option.Parent = OptionHolder
                    Option.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -16, 0, 30)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.Gotham
                    Option.Text = option
                    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Option.TextSize = 14.000
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = Option
                    
                    -- Add checkmark for multi-select
                    if multiSelect then
                        local Checkmark = Instance.new("ImageLabel")
                        Checkmark.Name = "Checkmark"
                        Checkmark.Parent = Option
                        Checkmark.BackgroundTransparency = 1
                        Checkmark.Image = "rbxassetid://6031068421"
                        Checkmark.ImageTransparency = 1
                        Checkmark.Size = UDim2.new(0, 16, 0, 16)
                        Checkmark.Position = UDim2.new(0, 8, 0.5, -8)
                    end
                    
                    Option.MouseButton1Click:Connect(function()
                        if multiSelect then
                            if selected[option] then
                                selected[option] = nil
                                Option.Checkmark.ImageTransparency = 1
                            else
                                selected[option] = true
                                Option.Checkmark.ImageTransparency = 0
                            end
                            
                            updateTitle()
                            
                            local selectedList = {}
                            for item, _ in pairs(selected) do
                                table.insert(selectedList, item)
                            end
                            callback(selectedList)
                        else
                            callback(option)
                            Title.Text = text .. ": " .. option
                            dropped = false
                            TweenService:Create(Arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                            Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                        end
                    end)
                    
                    -- Mobile support
                    Option.TouchTap:Connect(function()
                        Option.MouseButton1Click:Fire()
                    end)
                end
                
                -- Update option holder size
                OptionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if dropped then
                        OptionHolder.Size = UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15)
                        Dropdown.Size = UDim2.new(1, -6, 0, 34 + OptionList.AbsoluteContentSize.Y + 15)
                    end
                end)
            end
            
            return DropdownFunctions
        end
        
        return Elements
    end
    
    return TabFunctions
end
-- ========== SISTEMA DE ICONOS FLOTANTES ==========
Library.floatingIcons = {}
Library.screenGui = nil

function Library:CreateFloatingIcon(funcName, displayName, callback)
    if not self.screenGui then
        self.screenGui = Instance.new("ScreenGui")
        self.screenGui.Name = "FloatingIcons"
        self.screenGui.ResetOnSpawn = false
        self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.screenGui.Parent = CoreGui
    end
    
    -- Posiciones predefinidas
    local gridPositions = {
        Aimbot = {x = 720, y = 120},
        SpinBot = {x = 720, y = 160},
        AutoHit = {x = 720, y = 200},
        GrabActivator = {x = 720, y = 240},
        SpeedBoost = {x = 720, y = 280},
        AntiKnockback = {x = 720, y = 320},
        InfiniteJump = {x = 920, y = 360},
        AntiRagdoll = {x = 920, y = 400},
        AntiKnockbackV2 = {x = 920, y = 440},
        ShiftLock = {x = 720, y = 480}
    }
    
    local pos = gridPositions[funcName] or {x = math.random(100, 400), y = math.random(100, 400)}
    local displayText = displayName or funcName:sub(1, 3)
    
    -- Eliminar icono existente
    if self.floatingIcons[funcName] then
        self.floatingIcons[funcName].Main:Destroy()
        self.floatingIcons[funcName] = nil
    end
    
    -- Crear botón
    local icon = Instance.new("TextButton")
    icon.Name = funcName .. "Icon"
    icon.Parent = self.screenGui
    icon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    icon.BorderSizePixel = 0
    icon.Position = UDim2.new(0, pos.x, 0, pos.y)
    icon.Size = UDim2.new(0, 80, 0, 32)
    icon.AutoButtonColor = false
    icon.Text = displayText
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Font = Enum.Font.GothamSemibold
    icon.TextSize = 12
    icon.TextWrapped = true
    icon.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = icon
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = icon
    stroke.Color = Color3.fromRGB(161, 12, 59)
    stroke.Thickness = 1
    
    local dot = Instance.new("Frame")
    dot.Parent = icon
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(1, -12, 0, 5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    dot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    local iconState = true -- Siempre empieza activo porque se crea al activar la función
    
    local function updateIconVisual()
        if iconState then
            TweenService:Create(icon, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(134, 10, 49)
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(232, 17, 85)
            }):Play()
            TweenService:Create(dot, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            }):Play()
        else
            TweenService:Create(icon, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(161, 12, 59)
            }):Play()
            TweenService:Create(dot, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            }):Play()
        end
    end

    -- Click simple para activar/desactivar la función SIN eliminar el icono
    icon.MouseButton1Click:Connect(function()
        iconState = not iconState
        updateIconVisual()
        if callback then
            callback(iconState)
        end
        -- NO eliminamos el icono aquí, solo cambiamos el estado
    end)
    
    self.floatingIcons[funcName] = {
        Main = icon,
        Dot = dot,
        UIStroke = stroke,
        UpdateVisual = updateIconVisual,
        SetState = function(state)
            iconState = state
            updateIconVisual()
        end,
        GetState = function()
            return iconState
        end
    }
    
    updateIconVisual()
    return self.floatingIcons[funcName]
end

return Library
