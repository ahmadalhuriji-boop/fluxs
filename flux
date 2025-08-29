-- Flux XHub Style UI Library
local Flux = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Colors (xHub inspired)
Flux.Colors = {
    Background = Color3.fromRGB(20, 20, 30),
    Primary = Color3.fromRGB(30, 30, 45),
    Secondary = Color3.fromRGB(40, 40, 60),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(240, 240, 240),
    Success = Color3.fromRGB(0, 200, 100),
    Warning = Color3.fromRGB(255, 170, 0),
    Error = Color3.fromRGB(255, 70, 70),
    Stroke = Color3.fromRGB(60, 60, 80)
}

-- Utility function to create instances with styles
function Flux:CreateInstance(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

-- Add rounded corners
function Flux:AddCorner(instance, radius)
    local corner = self:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
    return corner
end

-- Add UI stroke
function Flux:AddStroke(instance, color, thickness)
    local stroke = self:CreateInstance("UIStroke", {
        Color = color or Flux.Colors.Stroke,
        Thickness = thickness or 2,
        Parent = instance
    })
    return stroke
end

-- Add gradient
function Flux:AddGradient(instance, colors)
    local gradient = self:CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or {
            Color3.fromRGB(0, 170, 255),
            Color3.fromRGB(85, 170, 255)
        }),
        Rotation = 90,
        Parent = instance
    })
    return gradient
end

-- Create a new xHub style window
function Flux:CreateWindow(title)
    local window = {}
    
    -- Create the main GUI
    window.Gui = Flux:CreateInstance("ScreenGui", {
        Name = "XHubUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })
    
    -- Main window frame with xHub style
    window.MainFrame = Flux:CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 450),
        Position = UDim2.new(0.5, -250, 0.5, -225),
        BackgroundColor3 = Flux.Colors.Background,
        BorderSizePixel = 0,
        Parent = window.Gui
    })
    
    -- Add rounded corners
    Flux:AddCorner(window.MainFrame, 8)
    Flux:AddStroke(window.MainFrame, Flux.Colors.Stroke, 2)
    
    -- Top bar with gradient
    window.TopBar = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Flux.Colors.Primary,
        BorderSizePixel = 0,
        Parent = window.MainFrame
    })
    
    Flux:AddCorner(window.TopBar, 8)
    Flux:AddStroke(window.TopBar, Flux.Colors.Stroke, 1)
    
    -- Title with xHub style
    window.Title = Flux:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "XHub UI",
        TextColor3 = Flux.Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TopBar
    })
    
    -- Close button with xHub style
    window.CloseButton = Flux:CreateInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Flux.Colors.Error,
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = Flux.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = window.TopBar
    })
    
    Flux:AddCorner(window.CloseButton, 6)
    Flux:AddStroke(window.CloseButton, Color3.fromRGB(180, 60, 60), 1)
    
    -- Tab container
    window.TabContainer = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Parent = window.MainFrame
    })
    
    -- Tab layout
    Flux:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        Parent = window.TabContainer
    })
    
    -- Content area
    window.ContentFrame = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -90),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundTransparency = 1,
        Parent = window.MainFrame
    })
    
    -- Tabs storage
    window.Tabs = {}
    
    -- Close button functionality
    window.CloseButton.MouseButton1Click:Connect(function()
        window.MainFrame.Visible = not window.MainFrame.Visible
    end)
    
    -- Hover effects for close button
    window.CloseButton.MouseEnter:Connect(function()
        window.CloseButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    
    window.CloseButton.MouseLeave:Connect(function()
        window.CloseButton.BackgroundColor3 = Flux.Colors.Error
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    window.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    window.TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            window.MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    -- Add tab method
    function window:AddTab(name)
        local tab = {}
        tab.Name = name
        
        -- Tab button with xHub style
        tab.Button = Flux:CreateInstance("TextButton", {
            Size = UDim2.new(0, 90, 1, 0),
            BackgroundColor3 = Flux.Colors.Secondary,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Flux.Colors.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            Parent = self.TabContainer
        })
        
        Flux:AddCorner(tab.Button, 6)
        Flux:AddStroke(tab.Button, Flux.Colors.Stroke, 1)
        
        -- Tab content
        tab.Content = Flux:CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Flux.Colors.Accent,
            Visible = false,
            Parent = self.ContentFrame
        })
        
        Flux:CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = tab.Content
        })
        
        -- Tab button functionality
        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundColor3 = Flux.Colors.Secondary
                otherTab.Button.TextColor3 = Flux.Colors.Text
            end
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Flux.Colors.Accent
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        -- Hover effects for tab buttons
        tab.Button.MouseEnter:Connect(function()
            if tab.Button.BackgroundColor3 ~= Flux.Colors.Accent then
                tab.Button.BackgroundColor3 = Flux.Colors.Primary
            end
        end)
        
        tab.Button.MouseLeave:Connect(function()
            if tab.Button.BackgroundColor3 ~= Flux.Colors.Accent then
                tab.Button.BackgroundColor3 = Flux.Colors.Secondary
            end
        end)
        
        -- Add section method
        function tab:AddSection(title)
            local section = {}
            
            section.Frame = Flux:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Flux.Colors.Primary,
                BorderSizePixel = 0,
                Parent = self.Content
            })
            
            Flux:AddCorner(section.Frame, 6)
            Flux:AddStroke(section.Frame, Flux.Colors.Stroke, 1)
            
            section.Title = Flux:CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 35),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = Flux.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section.Frame
            })
            
            section.Content = Flux:CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 40),
                BackgroundTransparency = 1,
                Parent = section.Frame
            })
            
            local layout = Flux:CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = section.Content
            })
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
                section.Frame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 50)
            end)
            
            -- Add button method with xHub style
            function section:AddButton(text, callback)
                local button = Flux:CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Flux.Colors.Secondary,
                    BorderSizePixel = 0,
                    Text = text,
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = self.Content
                })
                
                Flux:AddCorner(button, 5)
                Flux:AddStroke(button, Flux.Colors.Stroke, 1)
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = Flux.Colors.Accent
                end)
                
                button.MouseLeave:Connect(function()
                    button.BackgroundColor3 = Flux.Colors.Secondary
                end)
                
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return button
            end
            
            -- Add toggle method with xHub style
            function section:AddToggle(text, default, callback)
                local toggle = {Value = default or false}
                
                local frame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = self.Content
                })
                
                local label = Flux:CreateInstance("TextLabel", {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame
                })
                
                local toggleFrame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(0, 55, 0, 25),
                    Position = UDim2.new(1, -55, 0.5, -12.5),
                    BackgroundColor3 = Flux.Colors.Secondary,
                    BorderSizePixel = 0,
                    Parent = frame
                })
                
                Flux:AddCorner(toggleFrame, 12)
                Flux:AddStroke(toggleFrame, Flux.Colors.Stroke, 1)
                
                local toggleButton = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = UDim2.new(0, 2, 0.5, -10.5),
                    BackgroundColor3 = toggle.Value and Flux.Colors.Success or Flux.Colors.Error,
                    BorderSizePixel = 0,
                    Parent = toggleFrame
                })
                
                Flux:AddCorner(toggleButton, 12)
                
                frame.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    toggleButton.BackgroundColor3 = toggle.Value and Flux.Colors.Success or Flux.Colors.Error
                    toggleButton.Position = toggle.Value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                    if callback then
                        callback(toggle.Value)
                    end
                end)
                
                -- Hover effects
                frame.MouseEnter:Connect(function()
                    toggleFrame.BackgroundColor3 = Flux.Colors.Primary
                end)
                
                frame.MouseLeave:Connect(function()
                    toggleFrame.BackgroundColor3 = Flux.Colors.Secondary
                end)
                
                return toggle
            end
            
            -- Add textbox method with xHub style
            function section:AddTextBox(placeholder, callback)
                local frame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = self.Content
                })
                
                local textBox = Flux:CreateInstance("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Flux.Colors.Secondary,
                    BorderSizePixel = 0,
                    Text = "",
                    PlaceholderText = placeholder or "Type here...",
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = frame
                })
                
                Flux:AddCorner(textBox, 5)
                Flux:AddStroke(textBox, Flux.Colors.Stroke, 1)
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(textBox.Text)
                    end
                end)
                
                -- Hover effects
                textBox.MouseEnter:Connect(function()
                    textBox.BackgroundColor3 = Flux.Colors.Primary
                end)
                
                textBox.MouseLeave:Connect(function()
                    textBox.BackgroundColor3 = Flux.Colors.Secondary
                end)
                
                return textBox
            end
            
            -- Add label method
            function section:AddLabel(text)
                local label = Flux:CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = self.Content
                })
                
                return label
            end
            
            return section
        end
        
        table.insert(self.Tabs, tab)
        
        -- Activate first tab
        if #self.Tabs == 1 then
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Flux.Colors.Accent
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        return tab
    end
    
    return window
end

return Flux
