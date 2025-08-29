-- Flux UI Library for Solara (Simplified)
local Flux = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Colors
Flux.Colors = {
    Primary = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(240, 240, 240),
    Success = Color3.fromRGB(0, 200, 100),
    Warning = Color3.fromRGB(255, 170, 0),
    Error = Color3.fromRGB(255, 70, 70)
}

-- Utility function to create instances
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

-- Create a new window
function Flux:CreateWindow(title)
    local window = {}
    
    -- Create the main GUI
    window.Gui = Flux:CreateInstance("ScreenGui", {
        Name = "FluxUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })
    
    -- Main window frame
    window.MainFrame = Flux:CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Flux.Colors.Primary,
        BorderSizePixel = 0,
        Parent = window.Gui
    })
    
    -- Top bar
    window.TopBar = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Flux.Colors.Secondary,
        BorderSizePixel = 0,
        Parent = window.MainFrame
    })
    
    -- Title
    window.Title = Flux:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Flux UI",
        TextColor3 = Flux.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TopBar
    })
    
    -- Close button
    window.CloseButton = Flux:CreateInstance("TextButton", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Flux.Colors.Error,
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = Flux.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = window.TopBar
    })
    
    -- Tab container
    window.TabContainer = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = window.MainFrame
    })
    
    -- Tab layout
    Flux:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        Parent = window.TabContainer
    })
    
    -- Content area
    window.ContentFrame = Flux:CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -80),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        Parent = window.MainFrame
    })
    
    -- Tabs storage
    window.Tabs = {}
    
    -- Close button functionality
    window.CloseButton.MouseButton1Click:Connect(function()
        window.MainFrame.Visible = not window.MainFrame.Visible
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
        
        -- Tab button
        tab.Button = Flux:CreateInstance("TextButton", {
            Size = UDim2.new(0, 80, 1, 0),
            BackgroundColor3 = Flux.Colors.Secondary,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Flux.Colors.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Parent = self.TabContainer
        })
        
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
            Padding = UDim.new(0, 10),
            Parent = tab.Content
        })
        
        -- Tab button functionality
        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundColor3 = Flux.Colors.Secondary
            end
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Flux.Colors.Accent
        end)
        
        -- Add section method
        function tab:AddSection(title)
            local section = {}
            
            section.Frame = Flux:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Flux.Colors.Secondary,
                BorderSizePixel = 0,
                Parent = self.Content
            })
            
            section.Title = Flux:CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
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
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = section.Frame
            })
            
            local layout = Flux:CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = section.Content
            })
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
                section.Frame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 40)
            end)
            
            -- Add button method
            function section:AddButton(text, callback)
                local button = Flux:CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Flux.Colors.Primary,
                    BorderSizePixel = 0,
                    Text = text,
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = self.Content
                })
                
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return button
            end
            
            -- Add toggle method
            function section:AddToggle(text, default, callback)
                local toggle = {Value = default or false}
                
                local frame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = self.Content
                })
                
                local label = Flux:CreateInstance("TextLabel", {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame
                })
                
                local toggleFrame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),
                    BackgroundColor3 = Flux.Colors.Primary,
                    BorderSizePixel = 0,
                    Parent = frame
                })
                
                local toggleButton = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = toggle.Value and Flux.Colors.Success or Flux.Colors.Error,
                    BorderSizePixel = 0,
                    Parent = toggleFrame
                })
                
                frame.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    toggleButton.BackgroundColor3 = toggle.Value and Flux.Colors.Success or Flux.Colors.Error
                    toggleButton.Position = toggle.Value and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
                    if callback then
                        callback(toggle.Value)
                    end
                end)
                
                return toggle
            end
            
            -- Add textbox method
            function section:AddTextBox(placeholder, callback)
                local frame = Flux:CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = self.Content
                })
                
                local textBox = Flux:CreateInstance("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Flux.Colors.Primary,
                    BorderSizePixel = 0,
                    Text = "",
                    PlaceholderText = placeholder or "",
                    TextColor3 = Flux.Colors.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = frame
                })
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(textBox.Text)
                    end
                end)
                
                return textBox
            end
            
            return section
        end
        
        table.insert(self.Tabs, tab)
        
        -- Activate first tab
        if #self.Tabs == 1 then
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Flux.Colors.Accent
        end
        
        return tab
    end
    
    return window
end

return Flux
