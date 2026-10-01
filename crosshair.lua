local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("CrosshairRemotes")
local saveEvent = remotes:WaitForChild("SaveSettings")
local loadFunction = remotes:WaitForChild("LoadSettings")

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local Settings = {
	Size = 10,
	Gap = 5,
	Thickness = 2,
	Transparency = 0,
	X = 0,
	Y = 0,
	Enabled = true
}

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "CrosshairGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--------------------------------------------------
-- CROSSHAIR
--------------------------------------------------

local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.fromOffset(1, 1)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 1
crosshair.Parent = gui

local lines = {}

local function makeLine(name)
	local line = Instance.new("Frame")
	line.Name = name
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	line.Parent = crosshair
	lines[name] = line
	return line
end

local top = makeLine("Top")
local bottom = makeLine("Bottom")
local left = makeLine("Left")
local right = makeLine("Right")

local function updateCrosshair()
	crosshair.Position = UDim2.new(
		0.5,
		Settings.X,
		0.5,
		Settings.Y
	)

	top.Size = UDim2.fromOffset(Settings.Thickness, Settings.Size)
	top.Position = UDim2.new(
		0.5,
		-Settings.Thickness / 2,
		0,
		-(Settings.Gap + Settings.Size)
	)

	bottom.Size = UDim2.fromOffset(Settings.Thickness, Settings.Size)
	bottom.Position = UDim2.new(
		0.5,
		-Settings.Thickness / 2,
		0,
		Settings.Gap
	)

	left.Size = UDim2.fromOffset(Settings.Size, Settings.Thickness)
	left.Position = UDim2.new(
		0,
		-(Settings.Gap + Settings.Size),
		0.5,
		-Settings.Thickness / 2
	)

	right.Size = UDim2.fromOffset(Settings.Size, Settings.Thickness)
	right.Position = UDim2.new(
		0,
		Settings.Gap,
		0.5,
		-Settings.Thickness / 2
	)

	for _, line in pairs(lines) do
		line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		line.BackgroundTransparency = Settings.Transparency
		line.Visible = Settings.Enabled
	end
end

--------------------------------------------------
-- MENU
--------------------------------------------------

local menu = Instance.new("Frame")
menu.Name = "SettingsMenu"
menu.Size = UDim2.fromOffset(270, 500)
menu.Position = UDim2.new(0.5, -135, 0.5, -250)
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

local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 42)
dragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dragBar.BorderSizePixel = 0
dragBar.Text = ""
dragBar.AutoButtonColor = false
dragBar.Active = true
dragBar.Modal = true
dragBar.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "🔴 RED + CROSSHAIR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragBar

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(32, 28)
minimize.Position = UDim2.new(1, -38, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Modal = true
minimize.Parent = dragBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimize

--------------------------------------------------
-- SLIDERS
--------------------------------------------------

local sliderSetters = {}

local function createSlider(name, y, minValue, maxValue, defaultValue, callback)

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
	bar.Modal = true
	bar.Parent = menu

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local dragging = false

	local function setValue(value)
		value = math.clamp(
			math.round(value),
			minValue,
			maxValue
		)

		local percent =
			(value - minValue) /
			(maxValue - minValue)

		fill.Size = UDim2.new(
			percent,
			0,
			1,
			0
		)

		label.Text =
			name .. ": " .. tostring(value)

		callback(value)
	end

	local function fromX(x)
		local percent = math.clamp(
			(x - bar.AbsolutePosition.X) /
			bar.AbsoluteSize.X,
			0,
			1
		)

		setValue(
			minValue +
			(maxValue - minValue) * percent
		)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			fromX(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then

				fromX(input.Position.X)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	sliderSetters[name] = setValue
	setValue(defaultValue)
end

createSlider("Size", 52, 1, 30, Settings.Size, function(v)
	Settings.Size = v
	updateCrosshair()
end)

createSlider("Gap", 107, 0, 30, Settings.Gap, function(v)
	Settings.Gap = v
	updateCrosshair()
end)

createSlider("Thickness", 162, 1, 10, Settings.Thickness, function(v)
	Settings.Thickness = v
	updateCrosshair()
end)

createSlider("Transparency", 217, 0, 100, 0, function(v)
	Settings.Transparency = v / 100
	updateCrosshair()
end)

createSlider("X Position", 272, -500, 500, Settings.X, function(v)
	Settings.X = v
	updateCrosshair()
end)

createSlider("Y Position", 327, -500, 500, Settings.Y, function(v)
	Settings.Y = v
	updateCrosshair()
end)

--------------------------------------------------
-- CENTER
--------------------------------------------------

local centerButton = Instance.new("TextButton")
centerButton.Size = UDim2.new(1, -24, 0, 32)
centerButton.Position = UDim2.fromOffset(12, 382)
centerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
centerButton.BorderSizePixel = 0
centerButton.Text = "🎯 CENTER"
centerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
centerButton.TextSize = 13
centerButton.Font = Enum.Font.GothamBold
centerButton.Modal = true
centerButton.Parent = menu

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(0, 7)
centerCorner.Parent = centerButton

centerButton.MouseButton1Click:Connect(function()
	Settings.X = 0
	Settings.Y = 0

	sliderSetters["X Position"](0)
	sliderSetters["Y Position"](0)

	updateCrosshair()
end)

--------------------------------------------------
-- ON/OFF
--------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -24, 0, 32)
toggle.Position = UDim2.fromOffset(12, 420)
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
toggle.BorderSizePixel = 0
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.Modal = true
toggle.Parent = menu

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 7)
toggleCorner.Parent = toggle

local function updateToggle()
	if Settings.Enabled then
		toggle.Text = "👁️ CROSSHAIR: ON"
	else
		toggle.Text = "👁️ CROSSHAIR: OFF"
	end
end

toggle.MouseButton1Click:Connect(function()
	Settings.Enabled = not Settings.Enabled
	updateToggle()
	updateCrosshair()
end)

--------------------------------------------------
-- SAVE
--------------------------------------------------

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(1, -24, 0, 32)
saveButton.Position = UDim2.fromOffset(12, 458)
saveButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
saveButton.BorderSizePixel = 0
saveButton.Text = "💾 SAVE SETTINGS"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextSize = 13
saveButton.Font = Enum.Font.GothamBold
saveButton.Modal = true
saveButton.Parent = menu

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 7)
saveCorner.Parent = saveButton

saveButton.MouseButton1Click:Connect(function()

	saveEvent:FireServer({
		Size = Settings.Size,
		Gap = Settings.Gap,
		Thickness = Settings.Thickness,
		Transparency = Settings.Transparency,
		X = Settings.X,
		Y = Settings.Y,
		Enabled = Settings.Enabled
	})

	saveButton.Text = "✅ SAVED!"

	task.delay(1.5, function()
		if saveButton then
			saveButton.Text = "💾 SAVE SETTINGS"
		end
	end)
end)

--------------------------------------------------
-- RESTORE BUTTON
--------------------------------------------------

local restore = Instance.new("TextButton")
restore.Size = UDim2.fromOffset(38, 38)
restore.Position = UDim2.new(0, 12, 0.5, -19)
restore.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
restore.BorderSizePixel = 0
restore.Text = "☰"
restore.TextColor3 = Color3.fromRGB(255, 255, 255)
restore.TextSize = 17
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.ZIndex = 10
restore.Modal = true
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 8)
restoreCorner.Parent = restore

--------------------------------------------------
-- CAMERA-SAFE MENU DRAG
--------------------------------------------------

local menuDragging = false
local dragStart
local menuStartPosition

local function sinkInput()
	return Enum.ContextActionResult.Sink
end

dragBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		menuDragging = true
		dragStart = input.Position
		menuStartPosition = menu.Position

		ContextActionService:BindActionAtPriority(
			"CrosshairMenuDrag",
			sinkInput,
			false,
			Enum.ContextActionPriority.High.Value,
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.MouseButton1,
			Enum.UserInputType.Touch
		)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not menuDragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		menu.Position = UDim2.new(
			menuStartPosition.X.Scale,
			menuStartPosition.X.Offset + delta.X,
			menuStartPosition.Y.Scale,
			menuStartPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		menuDragging = false

		ContextActionService:UnbindAction(
			"CrosshairMenuDrag"
		)
	end
end)

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

minimize.MouseButton1Click:Connect(function()
	menu.Visible = false
	restore.Visible = true
end)

--------------------------------------------------
-- RESTORE
--------------------------------------------------

local restoreDragging = false
local restoreMoved = false
local restoreStart
local restoreStartPosition

restore.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		restoreDragging = true
		restoreMoved = false
		restoreStart = input.Position
		restoreStartPosition = restore.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not restoreDragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - restoreStart

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

	if not processed and input.KeyCode == Enum.KeyCode.RightShift then

		menu.Visible = not menu.Visible
		restore.Visible = not menu.Visible
	end
end)

--------------------------------------------------
-- LOAD SAVED SETTINGS
--------------------------------------------------

local success, saved = pcall(function()
	return loadFunction:InvokeServer()
end)

if success and type(saved) == "table" then

	Settings.Size = saved.Size or Settings.Size
	Settings.Gap = saved.Gap or Settings.Gap
	Settings.Thickness = saved.Thickness or Settings.Thickness
	Settings.Transparency = saved.Transparency or Settings.Transparency
	Settings.X = saved.X or Settings.X
	Settings.Y = saved.Y or Settings.Y

	if saved.Enabled ~= nil then
		Settings.Enabled = saved.Enabled
	end

	sliderSetters["Size"](Settings.Size)
	sliderSetters["Gap"](Settings.Gap)
	sliderSetters["Thickness"](Settings.Thickness)
	sliderSetters["Transparency"](
		math.round(Settings.Transparency * 100)
	)
	sliderSetters["X Position"](Settings.X)
	sliderSetters["Y Position"](Settings.Y)
end

--------------------------------------------------
-- START
--------------------------------------------------

updateToggle()
updateCrosshair()