-- Improved UI Library by xz#1111
local Library = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local references
local Player = Players.LocalPlayer
local mouse = Player:GetMouse()

-- Default configuration
local config = {
    toggleBind = Enum.KeyCode.RightShift,
    accentColor = Color3.fromRGB(106, 90, 205),
    darkColor = Color3.fromRGB(20, 20, 20),
    darkerColor = Color3.fromRGB(22, 22, 22),
    darkestColor = Color3.fromRGB(25, 25, 25),
    textColor = Color3.fromRGB(255, 255, 255),
    subTextColor = Color3.fromRGB(157, 157, 157),
    font = Enum.Font.Gotham,
    boldFont = Enum.Font.GothamBold,
    cornerRadius = UDim.new(0, 4)
}

-- Helper functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function applyTheme(instance, themeProperties)
    for property, value in pairs(themeProperties) do
        instance[property] = value
    end
end

-- Main library function
function Library:Create(name, subname)
    -- Create main UI container
    local uiContainer = createInstance("ScreenGui", {
        Name = name,
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main window frame
    local mainFrame = createInstance("Frame", {
        Name = "Main",
        Parent = uiContainer,
        BackgroundColor3 = config.darkColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 192, 0, 224),
        Size = UDim2.new(0, 645, 0, 366),
        Active = true,
        Draggable = false
    })

    createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = mainFrame})

    -- Title elements
    local title = createInstance("TextLabel", {
        Name = "Title",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.009, 0, 0, 0),
        Size = UDim2.new(0, 179, 0, 34),
        Font = config.boldFont,
        Text = name,
        TextColor3 = config.textColor,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local subtitle = createInstance("TextLabel", {
        Name = "SubTitle",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.009, 0, 0.093, 0),
        Size = UDim2.new(0, 179, 0, 18),
        Font = config.font,
        Text = subname,
        TextColor3 = config.subTextColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tabs container
    local tabsHolder = createInstance("Frame", {
        Name = "TabsHolder",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.009, 0, 0.158, 0),
        Size = UDim2.new(0, 179, 0, 302)
    })

    createInstance("UIListLayout", {
        Parent = tabsHolder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    -- Pages container
    local pageHolder = createInstance("Frame", {
        Name = "PageHolder",
        Parent = mainFrame,
        BackgroundColor3 = config.darkerColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.298, 0, 0.019, 0),
        Size = UDim2.new(0, 447, 0, 353)
    })

    createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = pageHolder})

    -- Dragging functionality
    local function makeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    makeDraggable(mainFrame)

    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == config.toggleBind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Window API
    local windowAPI = {}

    function windowAPI:Tab(tabName, isDefault)
        local tabButton = createInstance("TextButton", {
            Name = tabName,
            Parent = tabsHolder,
            BackgroundColor3 = config.darkerColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 179, 0, 26),
            Font = config.font,
            Text = tabName,
            TextColor3 = config.textColor,
            TextSize = 14,
            AutoButtonColor = false
        })

        createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = tabButton})

        local tabPage = createInstance("Frame", {
            Name = tabName,
            Parent = pageHolder,
            BackgroundColor3 = config.darkerColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 447, 0, 353),
            Visible = isDefault or false
        })

        createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = tabPage})

        local scrollFrame = createInstance("ScrollingFrame", {
            Name = "Container",
            Parent = tabPage,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.013, 0, 0.02, 0),
            Size = UDim2.new(0, 435, 0, 339),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = config.accentColor
        })

        createInstance("UIListLayout", {
            Parent = scrollFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        -- Set initial transparency
        tabButton.TextTransparency = isDefault and 0 or 0.5

        -- Tab switching logic
        tabButton.MouseButton1Click:Connect(function()
            for _, page in ipairs(pageHolder:GetChildren()) do
                if page:IsA("Frame") and page ~= tabPage then
                    page.Visible = false
                end
            end
            
            for _, button in ipairs(tabsHolder:GetChildren()) do
                if button:IsA("TextButton") then
                    button.TextTransparency = 0.5
                end
            end
            
            tabPage.Visible = true
            tabButton.TextTransparency = 0
        end)

        -- Page elements API
        local pageAPI = {}

        function pageAPI:Label(text)
            local labelFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 32)
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = labelFrame})

            local labelText = createInstance("TextLabel", {
                Name = "Text",
                Parent = labelFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 423, 0, 32),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            return {
                SetText = function(self, newText)
                    labelText.Text = newText
                end
            }
        end

        function pageAPI:Button(text, callback)
            local buttonFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 32)
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = buttonFrame})

            local button = createInstance("TextButton", {
                Name = "Button",
                Parent = buttonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 423, 0, 32),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })

            local buttonAPI = {}

            -- Hover effects
            button.MouseEnter:Connect(function()
                TweenService:Create(buttonFrame, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play()
            end)

            button.MouseLeave:Connect(function()
                TweenService:Create(buttonFrame, TweenInfo.new(0.15), {
                    BackgroundColor3 = config.darkestColor
                }):Play()
            end)

            button.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)

            function buttonAPI:SetCallback(newCallback)
                callback = newCallback
            end

            function buttonAPI:SetText(newText)
                button.Text = newText
            end

            return buttonAPI
        end

        function pageAPI:Toggle(text, initialState, callback)
            local toggleFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 32)
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = toggleFrame})

            local label = createInstance("TextLabel", {
                Name = "Label",
                Parent = toggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 350, 0, 32),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local toggleButton = createInstance("TextButton", {
                Name = "ToggleButton",
                Parent = toggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.8, 0, 0, 0),
                Size = UDim2.new(0, 70, 0, 32),
                Text = ""
            })

            local toggleIndicator = createInstance("Frame", {
                Name = "Indicator",
                Parent = toggleButton,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = initialState and config.accentColor or Color3.fromRGB(70, 70, 70)
            })

            createInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleIndicator
            })

            local toggleCircle = createInstance("Frame", {
                Name = "Circle",
                Parent = toggleIndicator,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = initialState and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })

            createInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleCircle
            })

            local state = initialState or false
            local toggleAPI = {}

            local function updateToggle()
                local targetColor = state and config.accentColor or Color3.fromRGB(70, 70, 70)
                local targetPosition = state and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
                
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
                    BackgroundColor3 = targetColor
                }):Play()
                
                TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                    Position = targetPosition
                }):Play()
                
                if callback then
                    pcall(callback, state)
                end
            end

            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
            end)

            function toggleAPI:SetState(newState)
                state = newState
                updateToggle()
            end

            function toggleAPI:GetState()
                return state
            end

            function toggleAPI:SetCallback(newCallback)
                callback = newCallback
            end

            return toggleAPI
        end

        function pageAPI:Input(text, placeholder, callback, clearOnFocusLost)
            local inputFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 32)
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = inputFrame})

            local label = createInstance("TextLabel", {
                Name = "Label",
                Parent = inputFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 200, 0, 32),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local textBox = createInstance("TextBox", {
                Name = "Input",
                Parent = inputFrame,
                BackgroundColor3 = config.darkerColor,
                Position = UDim2.new(0.55, 0, 0.125, 0),
                Size = UDim2.new(0, 180, 0, 24),
                Font = config.font,
                Text = "",
                PlaceholderText = placeholder or "",
                TextColor3 = config.textColor,
                TextSize = 14,
                ClearTextOnFocus = false
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = textBox})

            local inputAPI = {}

            textBox.FocusLost:Connect(function(enterPressed)
                if callback then
                    pcall(callback, textBox.Text, enterPressed)
                end
                if clearOnFocusLost then
                    textBox.Text = ""
                end
            end)

            function inputAPI:SetText(newText)
                textBox.Text = newText
            end

            function inputAPI:GetText()
                return textBox.Text
            end

            function inputAPI:SetCallback(newCallback)
                callback = newCallback
            end

            return inputAPI
        end

        function pageAPI:Slider(text, minValue, maxValue, defaultValue, callback)
            local sliderFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 50)
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = sliderFrame})

            local label = createInstance("TextLabel", {
                Name = "Label",
                Parent = sliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 423, 0, 20),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local valueText = createInstance("TextLabel", {
                Name = "Value",
                Parent = sliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.8, 0, 0, 0),
                Size = UDim2.new(0, 80, 0, 20),
                Font = config.font,
                Text = tostring(defaultValue or minValue),
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local sliderTrack = createInstance("Frame", {
                Name = "Track",
                Parent = sliderFrame,
                BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                Position = UDim2.new(0.014, 0, 0.6, 0),
                Size = UDim2.new(0, 423, 0, 5)
            })

            createInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderTrack})

            local sliderFill = createInstance("Frame", {
                Name = "Fill",
                Parent = sliderTrack,
                BackgroundColor3 = config.accentColor,
                Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            })

            createInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderFill})

            local sliderButton = createInstance("TextButton", {
                Name = "Button",
                Parent = sliderTrack,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 2, 0),
                Position = UDim2.new(0, 0, -0.5, 0),
                Text = "",
                AutoButtonColor = false
            })

            local currentValue = defaultValue or minValue
            local isSliding = false

            local function updateSlider(value)
                currentValue = math.clamp(value, minValue, maxValue)
                local ratio = (currentValue - minValue) / (maxValue - minValue)
                
                sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                valueText.Text = tostring(math.floor(currentValue * 100) / 100)
                
                if callback then
                    pcall(callback, currentValue)
                end
            end

            sliderButton.MouseButton1Down:Connect(function()
                isSliding = true
                
                local function slide(input)
                    local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                    local value = minValue + (maxValue - minValue) * math.clamp(relativeX, 0, 1)
                    updateSlider(value)
                end
                
                slide(UserInputService:GetMouseLocation())
                
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        slide(input.Position)
                    end
                end)
                
                local function stopSliding()
                    isSliding = false
                    connection:Disconnect()
                end
                
                sliderButton.MouseButton1Up:Connect(stopSliding)
                sliderButton.MouseLeave:Connect(stopSliding)
            end)

            local sliderAPI = {}

            function sliderAPI:SetValue(value)
                updateSlider(value)
            end

            function sliderAPI:GetValue()
                return currentValue
            end

            function sliderAPI:SetCallback(newCallback)
                callback = newCallback
            end

            return sliderAPI
        end

        function pageAPI:Dropdown(text, options, defaultOption, callback)
            local dropdownFrame = createInstance("Frame", {
                Name = text,
                Parent = scrollFrame,
                BackgroundColor3 = config.darkestColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 435, 0, 32),
                ClipsDescendants = true
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = dropdownFrame})

            local label = createInstance("TextLabel", {
                Name = "Label",
                Parent = dropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.014, 0, 0, 0),
                Size = UDim2.new(0, 200, 0, 32),
                Font = config.font,
                Text = text,
                TextColor3 = config.textColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local currentOption = defaultOption or options[1]
            local isOpen = false

            local dropdownButton = createInstance("TextButton", {
                Name = "DropdownButton",
                Parent = dropdownFrame,
                BackgroundColor3 = config.darkerColor,
                Position = UDim2.new(0.55, 0, 0.125, 0),
                Size = UDim2.new(0, 180, 0, 24),
                Font = config.font,
                Text = currentOption,
                TextColor3 = config.textColor,
                TextSize = 14,
                AutoButtonColor = false
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = dropdownButton})

            local dropdownIcon = createInstance("ImageLabel", {
                Name = "Icon",
                Parent = dropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.9, 0, 0.1, 0),
                Size = UDim2.new(0, 18, 0, 18),
                Image = "rbxassetid://6031090990",
                ImageColor3 = config.textColor
            })

            local optionsFrame = createInstance("Frame", {
                Name = "Options",
                Parent = dropdownFrame,
                BackgroundColor3 = config.darkerColor,
                Position = UDim2.new(0.55, 0, 0.125, 0),
                Size = UDim2.new(0, 180, 0, 0),
                Visible = false
            })

            createInstance("UICorner", {CornerRadius = config.cornerRadius, Parent = optionsFrame})

            createInstance("UIListLayout", {
                Parent = optionsFrame,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local function toggleDropdown()
                isOpen = not isOpen
                
                if isOpen then
                    dropdownFrame.Size = UDim2.new(0, 435, 0, 32 + (#options * 30))
                    optionsFrame.Visible = true
                    optionsFrame.Size = UDim2.new(0, 180, 0, #options * 30)
                    TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                else
                    dropdownFrame.Size = UDim2.new(0, 435, 0, 32)
                    optionsFrame.Visible = false
                    optionsFrame.Size = UDim2.new(0, 180, 0, 0)
                    TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end
            end

            local function selectOption(option)
                currentOption = option
                dropdownButton.Text = option
                toggleDropdown()
                
                if callback then
                    pcall(callback, option)
                end
            end

            dropdownButton.MouseButton1Click:Connect(toggleDropdown)

            -- Create option buttons
            for _, option in ipairs(options) do
                local optionButton = createInstance("TextButton", {
                    Name = option,
                    Parent = optionsFrame,
                    BackgroundColor3 = config.darkerColor,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = option,
                    Font = config.font,
                    TextColor3 = config.textColor,
                    TextSize = 14,
                    AutoButtonColor = false
                })

                optionButton.MouseButton1Click:Connect(function()
                    selectOption(option)
                end)

                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = config.darkestColor
                    }):Play()
                end)

                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = config.darkerColor
                    }):Play()
                end)
            end

            local dropdownAPI = {}

            function dropdownAPI:SetOptions(newOptions, newDefault)
                options = newOptions
                currentOption = newDefault or newOptions[1]
                dropdownButton.Text = currentOption
                
                -- Clear existing options
                for _, child in ipairs(optionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Create new options
                for _, option in ipairs(newOptions) do
                    local optionButton = createInstance("TextButton", {
                        Name = option,
                        Parent = optionsFrame,
                        BackgroundColor3 = config.darkerColor,
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = option,
                        Font = config.font,
                        TextColor3 = config.textColor,
                        TextSize = 14,
                        AutoButtonColor = false
                    })

                    optionButton.MouseButton1Click:Connect(function()
                        selectOption(option)
                    end)
                end
            end

            function dropdownAPI:GetSelected()
                return currentOption
            end

            function dropdownAPI:SetSelected(option)
                if table.find(options, option) then
                    selectOption(option)
                end
            end

            function dropdownAPI:SetCallback(newCallback)
                callback = newCallback
            end

            return dropdownAPI
        end

        return pageAPI
    end

    return windowAPI
end

return Library
