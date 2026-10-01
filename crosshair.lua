-- RED DOT CROSSHAIR
-- Phone-friendly UI
-- Menu dragging does NOT move the camera
-- For your own Roblox experience / Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "CrosshairGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local size = 6
local transparency = 0
local enabled = true
local xOffset = 0
local yOffset = 0

--------------------------------------------------
-- RED DOT
--------------------------------------------------

local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.fromOffset(size, size)
crosshair.Position = UDim2.new(0.5, xOffset, 0.5, yOffset)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
crosshair.BorderSizePixel = 0
crosshair.Parent = gui

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = crosshair

local function updateCrosshair()

	crosshair.Size = UDim2.fromOffset(size, size)

	crosshair.Position = UDim2.new(
		0.5,
		xOffset,
		0.5,
		yOffset
	)

	crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	crosshair.BackgroundTransparency = transparency
	crosshair.Visible = enabled
end

updateCrosshair()

--------------------------------------------------
-- PHONE MENU
--------------------------------------------------

local menu = Instance.new("Frame")
menu.Name = "SettingsMenu"
menu.Size = UDim2.fromOffset(260, 285)
menu.Position = UDim2.new(0.5, -130, 0.5, -142)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Active = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

--------------------------------------------------
-- DRAG BAR
--------------------------------------------------

local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 42)
dragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dragBar.BorderSizePixel = 0
dragBar.Active = true
dragBar.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Red Dot"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragBar

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.Size = UDim2.fromOffset(32, 28)
minimize.Position = UDim2.new(1, -38, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Parent = dragBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimize

--------------------------------------------------
-- SLIDER FUNCTION
--------------------------------------------------

local function createSlider(
	name,
	y,
	minValue,
	maxValue,
	defaultValue,
	callback
)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -24, 0, 22)
	label.Position = UDim2.fromOffset(12, y)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. tostring(defaultValue)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
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

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	knob.BorderSizePixel = 0
	knob.Parent = bar

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local sliderDragging = false

	local function setValue(inputX)

		local percent = math.clamp(
			(inputX - bar.AbsolutePosition.X)
				/ bar.AbsoluteSize.X,
			0,
			1
		)

		local value = math.floor(
			minValue
				+ (maxValue - minValue) * percent
				+ 0.5
		)

		knob.Position = UDim2.new(
			percent,
			0,
			0.5,
			0
		)

		label.Text = name .. ": " .. tostring(value)

		callback(value)
	end

	bar.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			sliderDragging = true
			setValue(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if sliderDragging then

			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then

				setValue(input.Position.X)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			sliderDragging = false
		end
	end)

	local percent =
		(defaultValue - minValue)
		/ (maxValue - minValue)

	knob.Position = UDim2.new(
		percent,
		0,
		0.5,
		0
	)
end

--------------------------------------------------
-- DOT CONTROLS
--------------------------------------------------

createSlider(
	"Size",
	52,
	1,
	30,
	size,
	function(v)
		size = v
		updateCrosshair()
	end
)

createSlider(
	"Transparency",
	107,
	0,
	100,
	0,
	function(v)
		transparency = v / 100
		updateCrosshair()
	end
)

createSlider(
	"X Position",
	162,
	-100,
	100,
	0,
	function(v)
		xOffset = v
		updateCrosshair()
	end
)

createSlider(
	"Y Position",
	217,
	-100,
	100,
	0,
	function(v)
		yOffset = v
		updateCrosshair()
	end
)

--------------------------------------------------
-- ON / OFF BUTTON
--------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.fromOffset(110, 30)
toggle.Position = UDim2.fromOffset(12, 252)
toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggle.BorderSizePixel = 0
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.Parent = menu

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggle

local function updateToggleText()

	if enabled then
		toggle.Text = "Dot: ON"
	else
		toggle.Text = "Dot: OFF"
	end

	updateCrosshair()
end

toggle.MouseButton1Click:Connect(function()

	enabled = not enabled
	updateToggleText()

end)

updateToggleText()

--------------------------------------------------
-- RESTORE BUTTON
--------------------------------------------------

local restore = Instance.new("TextButton")
restore.Name = "RestoreButton"
restore.Size = UDim2.fromOffset(38, 38)
restore.Position = UDim2.new(
	0,
	12,
	0.5,
	-19
)
restore.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
restore.BorderSizePixel = 0
restore.Text = "☰"
restore.TextColor3 = Color3.fromRGB(255, 255, 255)
restore.TextSize = 17
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.ZIndex = 10
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 8)
restoreCorner.Parent = restore

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

minimize.MouseButton1Click:Connect(function()

	menu.Visible = false
	restore.Visible = true

end)

--------------------------------------------------
-- DRAG MENU WITHOUT MOVING CAMERA
--------------------------------------------------

local menuDragging = false
local menuDragStart
local menuStartPosition

local DRAG_ACTION = "CrosshairMenuDragBlock"

local function blockCameraInput()

	if menuDragging then
		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end

ContextActionService:BindActionAtPriority(
	DRAG_ACTION,
	blockCameraInput,
	false,
	Enum.ContextActionPriority.High.Value,
	Enum.UserInputType.MouseMovement,
	Enum.UserInputType.Touch
)

dragBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		menuDragging = true
		menuDragStart = input.Position
		menuStartPosition = menu.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if menuDragging then

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta =
				input.Position - menuDragStart

			menu.Position = UDim2.new(
				menuStartPosition.X.Scale,
				menuStartPosition.X.Offset + delta.X,
				menuStartPosition.Y.Scale,
				menuStartPosition.Y.Offset + delta.Y
			)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		menuDragging = false
	end
end)

--------------------------------------------------
-- DRAG RESTORE BUTTON
--------------------------------------------------

local restoreDragging = false
local restoreMoved = false
local restoreDragStart
local restoreStartPosition

restore.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		restoreDragging = true
		restoreMoved = false

		restoreDragStart = input.Position
		restoreStartPosition = restore.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if restoreDragging then

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta =
				input.Position - restoreDragStart

			if math.abs(delta.X) > 5
				or math.abs(delta.Y) > 5 then

				restoreMoved = true
			end

			restore.Position = UDim2.new(
				restoreStartPosition.X.Scale,
				restoreStartPosition.X.Offset + delta.X,
				restoreStartPosition.Y.Scale,
				restoreStartPosition.Y.Offset + delta.Y
			)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		if restoreDragging and not restoreMoved then

			menu.Visible = true
			restore.Visible = false
		end

		restoreDragging = false
	end
end)

--------------------------------------------------
-- RIGHT SHIFT
--------------------------------------------------

UserInputService.InputBegan:Connect(function(input, processed)

	if not processed
		and input.KeyCode == Enum.KeyCode.RightShift then

		menu.Visible = not menu.Visible
		restore.Visible = not menu.Visible
	end
end)