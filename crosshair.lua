-- Phone-Friendly Crosshair Menu
-- For your own Roblox experience / Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "CrosshairGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Crosshair
local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.fromOffset(1, 1)
crosshair.BackgroundTransparency = 1
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.fromScale(0.5, 0.5)
crosshair.Parent = gui

local lines = {}

local function makeLine(name)
	local line = Instance.new("Frame")
	line.Name = name
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Color3.new(1, 1, 1)
	line.Parent = crosshair
	lines[name] = line
	return line
end

local top = makeLine("Top")
local bottom = makeLine("Bottom")
local left = makeLine("Left")
local right = makeLine("Right")

local size = 6
local gap = 4
local thickness = 2
local transparency = 0
local enabled = true
local xOffset = 0
local yOffset = 0

local function updateCrosshair()
	crosshair.Position = UDim2.new(
		0.5,
		xOffset,
		0.5,
		yOffset
	)

	for _, line in pairs(lines) do
		line.BackgroundTransparency = transparency
	end

	top.Size = UDim2.fromOffset(thickness, size)
	top.Position = UDim2.new(0.5, -thickness / 2, 0, -(gap + size))

	bottom.Size = UDim2.fromOffset(thickness, size)
	bottom.Position = UDim2.new(0.5, -thickness / 2, 0, gap)

	left.Size = UDim2.fromOffset(size, thickness)
	left.Position = UDim2.new(0, -(gap + size), 0.5, -thickness / 2)

	right.Size = UDim2.fromOffset(size, thickness)
	right.Position = UDim2.new(0, gap, 0.5, -thickness / 2)

	for _, line in pairs(lines) do
		line.Visible = enabled
	end
end

updateCrosshair()

-- MENU
local menu = Instance.new("Frame")
menu.Name = "SettingsMenu"
menu.Size = UDim2.fromOffset(260, 380)
menu.Position = UDim2.new(0.5, -130, 0.5, -190)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

-- Drag bar
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 42)
dragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dragBar.BorderSizePixel = 0
dragBar.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Crosshair"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragBar

-- Minimize
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(32, 28)
minimize.Position = UDim2.new(1, -38, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Parent = dragBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimize

-- Slider creator
local function createSlider(name, y, minValue, maxValue, defaultValue, callback)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -24, 0, 22)
	label.Position = UDim2.fromOffset(12, y)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. tostring(defaultValue)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = menu

	local bar = Instance.new("TextButton")
	bar.Size = UDim2.new(1, -24, 0, 12)
	bar.Position = UDim2.fromOffset(12, y + 25)
	bar.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	bar.BorderSizePixel = 0
	bar.Text = ""
	bar.AutoButtonColor = false
	bar.Parent = menu

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = bar

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = bar

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local dragging = false

	local function setValue(inputX)
		local percent = math.clamp(
			(inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,
			1
		)

		local value = math.floor(
			minValue + (maxValue - minValue) * percent + 0.5
		)

		knob.Position = UDim2.new(percent, 0, 0.5, 0)
		label.Text = name .. ": " .. tostring(value)
		callback(value)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			setValue(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			setValue(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local percent = (defaultValue - minValue) / (maxValue - minValue)
	knob.Position = UDim2.new(percent, 0, 0.5, 0)
end

createSlider("Size", 52, 1, 20, size, function(v)
	size = v
	updateCrosshair()
end)

createSlider("Gap", 107, 0, 20, gap, function(v)
	gap = v
	updateCrosshair()
end)

createSlider("Thickness", 162, 1, 8, thickness, function(v)
	thickness = v
	updateCrosshair()
end)

createSlider("Transparency", 217, 0, 100, 0, function(v)
	transparency = v / 100
	updateCrosshair()
end)

createSlider("X Position", 272, -100, 100, 0, function(v)
	xOffset = v
	updateCrosshair()
end)

createSlider("Y Position", 327, -100, 100, 0, function(v)
	yOffset = v
	updateCrosshair()
end)

-- Minimize / restore
local restore = Instance.new("TextButton")
restore.Name = "Restore"
restore.Size = UDim2.fromOffset(48, 40)
restore.Position = UDim2.new(0, 12, 0.5, -20)
restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
restore.BorderSizePixel = 0
restore.Text = "☰"
restore.TextColor3 = Color3.new(1, 1, 1)
restore.TextSize = 20
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 8)
restoreCorner.Parent = restore

minimize.MouseButton1Click:Connect(function()
	menu.Visible = false
	restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
	menu.Visible = true
	restore.Visible = false
end)

-- Dragging
local draggingMenu = false
local dragStart
local startPosition

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingMenu = true
		dragStart = input.Position
		startPosition = menu.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingMenu and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then

		local delta = input.Position - dragStart

		menu.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		draggingMenu = false
	end
end)

-- Right Shift toggles the menu on keyboard
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then
		menu.Visible = not menu.Visible
		restore.Visible = not menu.Visible
	end
end)