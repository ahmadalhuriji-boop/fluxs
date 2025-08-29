-- UI Library by KB3R
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local OrionLib = {}

-- Colors
OrionLib.Theme = {
	Primary = Color3.fromRGB(255, 136, 0),
	Secondary = Color3.fromRGB(255, 170, 0),
	Background = Color3.fromRGB(30, 30, 30),
	Text = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(255, 102, 0)
}

-- Create main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OrionLib"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = OrionLib.Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- UI Corner
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- UI Stroke
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = OrionLib.Theme.Primary
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Background gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, OrionLib.Theme.Primary),
	ColorSequenceKeypoint.new(1, OrionLib.Theme.Secondary)
}
gradient.Rotation = 45
gradient.Enabled = false -- We'll use this for elements, not the main background
mainFrame.BackgroundColor3 = OrionLib.Theme.Background

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = OrionLib.Theme.Primary
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = OrionLib.Theme.Text
titleText.Text = "Orion UI Library"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = OrionLib.Theme.Text
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

-- Tab container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-- Content container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -20, 1, -70)
contentContainer.Position = UDim2.new(0, 10, 0, 60)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Tabs storage
OrionLib.Tabs = {}
OrionLib.CurrentTab = nil

-- Make window draggable
local dragging = false
local dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if dragging then
			update(input)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if dragging then
			update(input)
		end
	end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = not screenGui.Enabled
end)

-- Toggle UI with Left Control
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

-- Create tab function
function OrionLib:CreateTab(name)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "TabButton"
	tabButton.Size = UDim2.new(0, 80, 1, 0)
	tabButton.Position = UDim2.new(0, (#self.Tabs * 80), 0, 0)
	tabButton.BackgroundColor3 = OrionLib.Theme.Primary
	tabButton.BorderSizePixel = 0
	tabButton.TextColor3 = OrionLib.Theme.Text
	tabButton.Text = name
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 12
	tabButton.Parent = tabContainer
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tabButton
	
	local tabFrame = Instance.new("ScrollingFrame")
	tabFrame.Name = name .. "Frame"
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.Position = UDim2.new(0, 0, 0, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	tabFrame.ScrollBarThickness = 4
	tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabFrame.Parent = contentContainer
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.Parent = tabFrame
	
	uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
	end)
	
	local tab = {
		Name = name,
		Button = tabButton,
		Frame = tabFrame,
		Elements = {}
	}
	
	table.insert(self.Tabs, tab)
	
	-- Set first tab as active if none is active
	if not self.CurrentTab then
		self:SwitchTab(tab)
	end
	
	tabButton.MouseButton1Click:Connect(function()
		self:SwitchTab(tab)
	end)
	
	return tab
end

-- Switch tab function
function OrionLib:SwitchTab(tab)
	if self.CurrentTab then
		self.CurrentTab.Frame.Visible = false
		self.CurrentTab.Button.BackgroundColor3 = OrionLib.Theme.Primary
	end
	
	self.CurrentTab = tab
	tab.Frame.Visible = true
	tab.Button.BackgroundColor3 = OrionLib.Theme.Accent
end

-- Create button function
function OrionLib:CreateButton(tab, name, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 5, 0, #tab.Elements * 38)
	button.BackgroundColor3 = OrionLib.Theme.Primary
	button.BorderSizePixel = 0
	button.TextColor3 = OrionLib.Theme.Text
	button.Text = name
	button.Font = Enum.Font.Gotham
	button.TextSize = 12
	button.Parent = tab.Frame
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = button
	
	local buttonGradient = Instance.new("UIGradient")
	buttonGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, OrionLib.Theme.Primary),
		ColorSequenceKeypoint.new(1, OrionLib.Theme.Secondary)
	}
	buttonGradient.Rotation = 90
	buttonGradient.Parent = button
	
	button.MouseButton1Click:Connect(function()
		callback()
	end)
	
	table.insert(tab.Elements, button)
	
	return button
end

-- Create toggle function
function OrionLib:CreateToggle(tab, name, default, callback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = name
	toggleFrame.Size = UDim2.new(1, -10, 0, 30)
	toggleFrame.Position = UDim2.new(0, 5, 0, #tab.Elements * 38)
	toggleFrame.BackgroundTransparency = 1
	toggleFrame.Parent = tab.Frame
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0, 50, 1, 0)
	toggleButton.Position = UDim2.new(1, -50, 0, 0)
	toggleButton.BackgroundColor3 = default and OrionLib.Theme.Accent or Color3.fromRGB(80, 80, 80)
	toggleButton.BorderSizePixel = 0
	toggleButton.Text = ""
	toggleButton.Parent = toggleFrame
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 15)
	toggleCorner.Parent = toggleButton
	
	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "Indicator"
	toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
	toggleIndicator.Position = default and UDim2.new(1, -25, 0.5, -10) or UDim2.new(0, 5, 0.5, -10)
	toggleIndicator.BackgroundColor3 = OrionLib.Theme.Text
	toggleIndicator.BorderSizePixel = 0
	toggleIndicator.Parent = toggleButton
	
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 10)
	indicatorCorner.Parent = toggleIndicator
	
	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Name = "Label"
	toggleLabel.Size = UDim2.new(1, -60, 1, 0)
	toggleLabel.Position = UDim2.new(0, 0, 0, 0)
	toggleLabel.BackgroundTransparency = 1
	toggleLabel.TextColor3 = OrionLib.Theme.Text
	toggleLabel.Text = name
	toggleLabel.Font = Enum.Font.Gotham
	toggleLabel.TextSize = 12
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleLabel.Parent = toggleFrame
	
	local isToggled = default
	
	toggleButton.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		
		if isToggled then
			TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -10)}):Play()
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = OrionLib.Theme.Accent}):Play()
		else
			TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 5, 0.5, -10)}):Play()
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
		end
		
		callback(isToggled)
	end)
	
	table.insert(tab.Elements, toggleFrame)
	
	return {
		Frame = toggleFrame,
		Button = toggleButton,
		Indicator = toggleIndicator,
		Label = toggleLabel,
		Value = isToggled
	}
end

-- Create slider function
function OrionLib:CreateSlider(tab, name, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = name
	sliderFrame.Size = UDim2.new(1, -10, 0, 50)
	sliderFrame.Position = UDim2.new(0, 5, 0, #tab.Elements * 58)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Parent = tab.Frame
	
	local sliderLabel = Instance.new("TextLabel")
	sliderLabel.Name = "Label"
	sliderLabel.Size = UDim2.new(1, 0, 0, 20)
	sliderLabel.Position = UDim2.new(0, 0, 0, 0)
	sliderLabel.BackgroundTransparency = 1
	sliderLabel.TextColor3 = OrionLib.Theme.Text
	sliderLabel.Text = name .. ": " .. default
	sliderLabel.Font = Enum.Font.Gotham
	sliderLabel.TextSize = 12
	sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
	sliderLabel.Parent = sliderFrame
	
	local sliderTrack = Instance.new("Frame")
	sliderTrack.Name = "Track"
	sliderTrack.Size = UDim2.new(1, 0, 0, 10)
	sliderTrack.Position = UDim2.new(0, 0, 0, 30)
	sliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	sliderTrack.BorderSizePixel = 0
	sliderTrack.Parent = sliderFrame
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 5)
	trackCorner.Parent = sliderTrack
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.Position = UDim2.new(0, 0, 0, 0)
	sliderFill.BackgroundColor3 = OrionLib.Theme.Primary
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderTrack
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = sliderFill
	
	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "SliderButton"
	sliderButton.Size = UDim2.new(0, 20, 0, 20)
	sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
	sliderButton.BackgroundColor3 = OrionLib.Theme.Text
	sliderButton.BorderSizePixel = 0
	sliderButton.Text = ""
	sliderButton.Parent = sliderTrack
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 10)
	buttonCorner.Parent = sliderButton
	
	local isSliding = false
	local currentValue = default
	
	sliderButton.MouseButton1Down:Connect(function()
		isSliding = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isSliding = false
		end
	end)
	
	mouse.Move:Connect(function()
		if isSliding then
			local x = math.clamp(mouse.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
			local value = math.floor(min + (x / sliderTrack.AbsoluteSize.X) * (max - min))
			
			sliderFill.Size = UDim2.new(x / sliderTrack.AbsoluteSize.X, 0, 1, 0)
			sliderButton.Position = UDim2.new(x / sliderTrack.AbsoluteSize.X, -10, 0.5, -10)
			sliderLabel.Text = name .. ": " .. value
			
			if value ~= currentValue then
				currentValue = value
				callback(value)
			end
		end
	end)
	
	table.insert(tab.Elements, sliderFrame)
	
	return {
		Frame = sliderFrame,
		Label = sliderLabel,
		Track = sliderTrack,
		Fill = sliderFill,
		Button = sliderButton,
		Value = currentValue
	}
end

-- Create dropdown function
function OrionLib:CreateDropdown(tab, name, options, default, callback)
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = name
	dropdownFrame.Size = UDim2.new(1, -10, 0, 30)
	dropdownFrame.Position = UDim2.new(0, 5, 0, #tab.Elements * 38)
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.Parent = tab.Frame
	
	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(1, 0, 0, 30)
	dropdownButton.Position = UDim2.new(0, 0, 0, 0)
	dropdownButton.BackgroundColor3 = OrionLib.Theme.Primary
	dropdownButton.BorderSizePixel = 0
	dropdownButton.TextColor3 = OrionLib.Theme.Text
	dropdownButton.Text = name .. ": " .. (default or "Select")
	dropdownButton.Font = Enum.Font.Gotham
	dropdownButton.TextSize = 12
	dropdownButton.Parent = dropdownFrame
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = dropdownButton
	
	local dropdownArrow = Instance.new("TextLabel")
	dropdownArrow.Name = "Arrow"
	dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
	dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
	dropdownArrow.BackgroundTransparency = 1
	dropdownArrow.TextColor3 = OrionLib.Theme.Text
	dropdownArrow.Text = "▼"
	dropdownArrow.Font = Enum.Font.Gotham
	dropdownArrow.TextSize = 12
	dropdownArrow.Parent = dropdownButton
	
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "OptionsFrame"
	optionsFrame.Size = UDim2.new(1, 0, 0, 0)
	optionsFrame.Position = UDim2.new(0, 0, 1, 5)
	optionsFrame.BackgroundColor3 = OrionLib.Theme.Background
	optionsFrame.BorderSizePixel = 0
	optionsFrame.ClipsDescendants = true
	optionsFrame.Visible = false
	optionsFrame.Parent = dropdownFrame
	
	local optionsCorner = Instance.new("UICorner")
	optionsCorner.CornerRadius = UDim.new(0, 6)
	optionsCorner.Parent = optionsFrame
	
	local optionsList = Instance.new("UIListLayout")
	optionsList.Padding = UDim.new(0, 2)
	optionsList.Parent = optionsFrame
	
	local isOpen = false
	local selectedOption = default
	
	local function toggleDropdown()
		isOpen = not isOpen
		optionsFrame.Visible = isOpen
		
		if isOpen then
			TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, #options * 30)}):Play()
			dropdownArrow.Text = "▲"
		else
			TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
			dropdownArrow.Text = "▼"
		end
	end
	
	dropdownButton.MouseButton1Click:Connect(toggleDropdown)
	
	for i, option in ipairs(options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = option
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.Position = UDim2.new(0, 0, 0, (i-1)*32)
		optionButton.BackgroundColor3 = OrionLib.Theme.Primary
		optionButton.BorderSizePixel = 0
		optionButton.TextColor3 = OrionLib.Theme.Text
		optionButton.Text = option
		optionButton.Font = Enum.Font.Gotham
		optionButton.TextSize = 12
		optionButton.Parent = optionsFrame
		
		local optionCorner = Instance.new("UICorner")
		optionCorner.CornerRadius = UDim.new(0, 6)
		optionCorner.Parent = optionButton
		
		optionButton.MouseButton1Click:Connect(function()
			selectedOption = option
			dropdownButton.Text = name .. ": " .. option
			toggleDropdown()
			callback(option)
		end)
	end
	
	table.insert(tab.Elements, dropdownFrame)
	
	return {
		Frame = dropdownFrame,
		Button = dropdownButton,
		Options = optionsFrame,
		Value = selectedOption
	}
end

-- Initialize the library
function OrionLib:Init()
	screenGui.Enabled = true
	
	-- Create a default tab if none exists
	if #self.Tabs == 0 then
		self:CreateTab("Main")
	end
	
	-- Tween in animation
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	if uiStroke then
		uiStroke.Transparency = 1
		local strokeGoal = {Transparency = 0}
		local strokeTween = TweenService:Create(uiStroke, tweenInfo, strokeGoal)
		strokeTween:Play()
	end
end

-- Your existing functions would be integrated here
-- For example, you would connect your button callbacks to the UI elements

return OrionLib
