--// CUSTOM CROSSHAIR + POSITION MENU
--// Put this LocalScript in:
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local Settings = {
	Size = 10,
	Gap = 5,
	Thickness = 2,
	Transparency = 0,

	-- Position offset from screen center
	X = 0,
	Y = 0,

	Color = Color3.fromRGB(255, 255, 255),
	Enabled = true
}

--==================================================
-- MAIN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "CustomCrosshairGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--==================================================
-- CROSSHAIR
--==================================================

local crosshair = Instance.new("Folder")
crosshair.Name = "Crosshair"
crosshair.Parent = gui

local lines = {}

local function createLine(name)
	local line = Instance.new("Frame")
	line.Name = name
	line.BorderSizePixel = 0
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Parent = crosshair

	lines[name] = line
	return line
end

local top = createLine("Top")
local bottom = createLine("Bottom")
local left = createLine("Left")
local right = createLine("Right")

local function updateCrosshair()

	local size = Settings.Size
	local gap = Settings.Gap
	local thickness = Settings.Thickness

	for _, line in pairs(lines) do
		line.BackgroundColor3 = Settings.Color
		line.BackgroundTransparency = Settings.Transparency
		line.Visible = Settings.Enabled
	end

	-- TOP
	top.Size = UDim2.fromOffset(thickness, size)
	top.Position = UDim2.new(
		0.5, Settings.X,
		0.5, Settings.Y - (gap + size / 2)
	)

	-- BOTTOM
	bottom.Size = UDim2.fromOffset(thickness, size)
	bottom.Position = UDim2.new(
		0.5, Settings.X,
		0.5, Settings.Y + gap + size / 2
	)

	-- LEFT
	left.Size = UDim2.fromOffset(size, thickness)
	left.Position = UDim2.new(
		0.5, Settings.X - (gap + size / 2),
		0.5, Settings.Y
	)

	-- RIGHT
	right.Size = UDim2.fromOffset(size, thickness)
	right.Position = UDim2.new(
		0.5, Settings.X + gap + size / 2,
		0.5, Settings.Y
	)
end

--==================================================
-- MENU
--==================================================

local menu = Instance.new("Frame")
menu.Name = "SettingsMenu"
menu.Size = UDim2.fromOffset(320, 500)
menu.Position = UDim2.new(0.5, -160, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "CROSSHAIR SETTINGS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = menu

--==================================================
-- LABEL
--==================================================

local function makeLabel(text, y)

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(1, -30, 0, 24)
	label.Position = UDim2.fromOffset(15, y)

	label.BackgroundTransparency = 1
	label.Text = text

	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Parent = menu

	return label
end

--==================================================
-- SLIDER
--==================================================

local function makeSlider(
	name,
	y,
	minValue,
	maxValue,
	defaultValue,
	callback
)

	local label = makeLabel(
		name .. ": " .. defaultValue,
		y
	)

	local slider = Instance.new("TextButton")

	slider.Size = UDim2.new(1, -30, 0, 20)
	slider.Position = UDim2.fromOffset(15, y + 27)

	slider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	slider.BorderSizePixel = 0

	slider.Text = ""
	slider.AutoButtonColor = false

	slider.Parent = menu

	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 5)
	sliderCorner.Parent = slider

	local fill = Instance.new("Frame")

	local startingPercent =
		(defaultValue - minValue)
		/ (maxValue - minValue)

	fill.Size = UDim2.new(
		startingPercent,
		0,
		1,
		0
	)

	fill.BackgroundColor3 =
		Color3.fromRGB(255, 255, 255)

	fill.BorderSizePixel = 0
	fill.Parent = slider

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = fill

	local dragging = false

	local function updateSlider(x)

		local percent = math.clamp(
			(x - slider.AbsolutePosition.X)
			/ slider.AbsoluteSize.X,
			0,
			1
		)

		local value =
			minValue
			+ (maxValue - minValue)
			* percent

		value = math.round(value)

		fill.Size = UDim2.new(
			percent,
			0,
			1,
			0
		)

		label.Text =
			name .. ": " .. value

		callback(value)

		updateCrosshair()
	end

	slider.InputBegan:Connect(function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = true
			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging then

			if input.UserInputType ==
				Enum.UserInputType.MouseMovement
				or input.UserInputType ==
				Enum.UserInputType.Touch then

				updateSlider(input.Position.X)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = false
		end
	end)
end

--==================================================
-- SETTINGS SLIDERS
--==================================================

makeSlider(
	"Size",
	55,
	2,
	30,
	Settings.Size,
	function(value)
		Settings.Size = value
	end
)

makeSlider(
	"Gap",
	110,
	0,
	30,
	Settings.Gap,
	function(value)
		Settings.Gap = value
	end
)

makeSlider(
	"Thickness",
	165,
	1,
	10,
	Settings.Thickness,
	function(value)
		Settings.Thickness = value
	end
)

makeSlider(
	"Transparency",
	220,
	0,
	100,
	Settings.Transparency * 100,
	function(value)
		Settings.Transparency =
			value / 100
	end
)

--==================================================
-- X POSITION
--==================================================

makeSlider(
	"Left / Right",
	275,
	-500,
	500,
	Settings.X,
	function(value)
		Settings.X = value
	end
)

--==================================================
-- Y POSITION
--==================================================

makeSlider(
	"Up / Down",
	330,
	-500,
	500,
	Settings.Y,
	function(value)
		Settings.Y = value
	end
)

--==================================================
-- CENTER BUTTON
--==================================================

local centerButton = Instance.new("TextButton")

centerButton.Size =
	UDim2.new(1, -30, 0, 38)

centerButton.Position =
	UDim2.fromOffset(15, 385)

centerButton.BackgroundColor3 =
	Color3.fromRGB(55, 55, 55)

centerButton.BorderSizePixel = 0

centerButton.Text = "CENTER CROSSHAIR"
centerButton.TextColor3 =
	Color3.fromRGB(255, 255, 255)

centerButton.TextSize = 14
centerButton.Font = Enum.Font.GothamBold

centerButton.Parent = menu

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius =
	UDim.new(0, 6)

centerCorner.Parent = centerButton

centerButton.MouseButton1Click:Connect(function()

	Settings.X = 0
	Settings.Y = 0

	updateCrosshair()
end)

--==================================================
-- SHOW / HIDE
--==================================================

local toggle = Instance.new("TextButton")

toggle.Size =
	UDim2.new(1, -30, 0, 38)

toggle.Position =
	UDim2.fromOffset(15, 435)

toggle.BackgroundColor3 =
	Color3.fromRGB(55, 55, 55)

toggle.BorderSizePixel = 0

toggle.Text = "CROSSHAIR: ON"
toggle.TextColor3 =
	Color3.fromRGB(255, 255, 255)

toggle.TextSize = 14
toggle.Font = Enum.Font.GothamBold

toggle.Parent = menu

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius =
	UDim.new(0, 6)

toggleCorner.Parent = toggle

toggle.MouseButton1Click:Connect(function()

	Settings.Enabled =
		not Settings.Enabled

	if Settings.Enabled then
		toggle.Text = "CROSSHAIR: ON"
	else
		toggle.Text = "CROSSHAIR: OFF"
	end

	updateCrosshair()
end)

--==================================================
-- OPEN / CLOSE MENU
-- RIGHT SHIFT
--==================================================

UserInputService.InputBegan:Connect(function(
	input,
	processed
)

	if processed then
		return
	end

	if input.KeyCode ==
		Enum.KeyCode.RightShift then

		menu.Visible =
			not menu.Visible
	end
end)

--==================================================
-- START
--==================================================

updateCrosshair()