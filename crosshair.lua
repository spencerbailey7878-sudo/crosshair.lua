--//==================================================
--// DRAGGABLE + MINIMIZE MENU
--//==================================================

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.Size = UDim2.fromOffset(35, 30)
minimize.Position = UDim2.new(1, -42, 0, 8)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamBold
minimize.Parent = menu

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimize

-- Small button shown while minimized
local restore = Instance.new("TextButton")
restore.Name = "Restore"
restore.Size = UDim2.fromOffset(50, 40)
restore.Position = UDim2.new(0.5, -25, 0.5, -20)
restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
restore.BorderSizePixel = 0
restore.Text = "☰"
restore.TextColor3 = Color3.fromRGB(255, 255, 255)
restore.TextSize = 20
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 8)
restoreCorner.Parent = restore

-- Minimize
minimize.MouseButton1Click:Connect(function()
	menu.Visible = false
	restore.Visible = true
end)

-- Restore
restore.MouseButton1Click:Connect(function()
	menu.Visible = true
	restore.Visible = false
end)

--==================================================
-- DRAG MENU
--==================================================

local dragging = false
local dragStart
local startPosition

local function drag(input)

	local delta = input.Position - dragStart

	menu.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,

		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

-- Drag from the title
title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = menu.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		drag(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)