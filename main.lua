local Library = {}

local Player = game:GetService("Players").LocalPlayer
local TS, UIS, RunService = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")

function Library:Create(name, subtext)
    -- Main UI
    local xz = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local PageHolder = Instance.new("Frame")
    
    -- Styling
    xz.Name = name
    xz.Parent = game.CoreGui
    xz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Main.Name = "Main"
    Main.Parent = xz
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BackgroundTransparency = 0.15
    Main.Position = UDim2.new(0.3, 0, 0.3, 0)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Border effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Color3.fromRGB(106, 90, 205)
    UIStroke.Transparency = 0.7
    UIStroke.Parent = Main
    
    -- Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main
    
    -- Title
    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.02, 0, 0.02, 0)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = Main
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0.02, 0, 0.1, 0)
    SubTitle.Size = UDim2.new(0, 200, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = subtext or ""
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab system
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundTransparency = 1
    TabHolder.Position = UDim2.new(0.02, 0, 0.2, 0)
    TabHolder.Size = UDim2.new(0, 150, 0, 280)
    
    PageHolder.Name = "PageHolder"
    PageHolder.Parent = Main
    PageHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PageHolder.BackgroundTransparency = 0.2
    PageHolder.Position = UDim2.new(0.35, 0, 0.1, 0)
    PageHolder.Size = UDim2.new(0, 310, 0, 300)
    
    -- Drag functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Toggle visibility
    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)
    
    -- Window API
    local Window = {}
    
    function Window:Tab(name, default)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.BackgroundTransparency = 0.5
        TabButton.Size = UDim2.new(0, 140, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = name
        TabPage.Parent = PageHolder
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(106, 90, 205)
        TabPage.Visible = default or false
        
        -- Tab switching logic
        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(PageHolder:GetChildren()) do
                if page:IsA("ScrollingFrame") then
                    page.Visible = false
                end
            end
            TabPage.Visible = true
        end)
        
        -- Elements container
        local Container = Instance.new("Frame")
        Container.Name = "Container"
        Container.Parent = TabPage
        Container.BackgroundTransparency = 1
        Container.Size = UDim2.new(1, 0, 1, 0)
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = Container
        UIListLayout.Padding = UDim.new(0, 10)
        
        -- Elements API
        local Elements = {}
        
        function Elements:Button(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Button.BackgroundTransparency = 0.5
            Button.Size = UDim2.new(1, -20, 0, 35)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.AutoButtonColor = false
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                TS:Create(Button, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TS:Create(Button, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end
        
        -- More elements can be added here (Toggle, Slider, etc.)
        
        return Elements
    end
    
    return Window
end

return Library
