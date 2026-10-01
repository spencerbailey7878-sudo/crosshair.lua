local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local store = DataStoreService:GetDataStore("CrosshairSettings_V2")

local folder = ReplicatedStorage:FindFirstChild("CrosshairRemotes")

if not folder then
	folder = Instance.new("Folder")
	folder.Name = "CrosshairRemotes"
	folder.Parent = ReplicatedStorage
end

local saveEvent = folder:FindFirstChild("SaveSettings")

if not saveEvent then
	saveEvent = Instance.new("RemoteEvent")
	saveEvent.Name = "SaveSettings"
	saveEvent.Parent = folder
end

local loadFunction = folder:FindFirstChild("LoadSettings")

if not loadFunction then
	loadFunction = Instance.new("RemoteFunction")
	loadFunction.Name = "LoadSettings"
	loadFunction.Parent = folder
end

local DEFAULTS = {
	Size = 10,
	Gap = 5,
	Thickness = 2,
	Transparency = 0,
	X = 0,
	Y = 0,
	Enabled = true
}

loadFunction.OnServerInvoke = function(player)

	local success, data = pcall(function()
		return store:GetAsync("Player_" .. player.UserId)
	end)

	if success and type(data) == "table" then

		for key, value in pairs(DEFAULTS) do
			if data[key] == nil then
				data[key] = value
			end
		end

		return data
	end

	return DEFAULTS
end

saveEvent.OnServerEvent:Connect(function(player, data)

	if type(data) ~= "table" then
		return
	end

	local settings = {
		Size = math.clamp(tonumber(data.Size) or 10, 2, 30),
		Gap = math.clamp(tonumber(data.Gap) or 5, 0, 30),
		Thickness = math.clamp(tonumber(data.Thickness) or 2, 1, 10),
		Transparency = math.clamp(tonumber(data.Transparency) or 0, 0, 1),
		X = math.clamp(tonumber(data.X) or 0, -500, 500),
		Y = math.clamp(tonumber(data.Y) or 0, -500, 500),
		Enabled = data.Enabled == true
	}

	local success, err = pcall(function()
		store:SetAsync(
			"Player_" .. player.UserId,
			settings
		)
	end)

	if not success then
		warn("Crosshair save failed:", err)
	end
end)