
--===[ INIT ]===--
local player = game.Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TeleportMenu"
gui.ResetOnSpawn = false

--===[ UI FRAME UTAMA ]===--
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 240, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

--===[ JUDUL ]===--
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "🏔️ Teleport Rinjani"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Name = "Title"

--===[ DRAG FUNCTION ]===--
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
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

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--===[ KOORDINAT ]===--
local pos5 = Vector3.new(1191, 10122.33, 2297)
local summit = Vector3.new(-116, 10825.855, 3022)

--===[ GRINDING ]===--
local grinding = false
local grindLoop = nil

--===[ FUNGSI BUAT TOMBOL + KOLEKSI UNTUK SHOW/HIDE ]===--
local allButtons = {}

local function createButton(text, order, callback)
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 50 + ((order - 1) * 45))
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Font = Enum.Font.SourceSansBold
	button.Text = text
	button.Name = text
	button.MouseButton1Click:Connect(callback)
	table.insert(allButtons, button)
	return button
end

--===[ TOMBOL FUNGSI ]===--
createButton("Teleport ke Pos 5", 1, function()
	hrp.CFrame = CFrame.new(pos5)
end)

createButton("Teleport ke Summit", 2, function()
	hrp.CFrame = CFrame.new(summit)
end)

createButton("Mulai Grind 🚀", 3, function()
	if not grinding then
		grinding = true
		grindLoop = task.spawn(function()
			while grinding do
				hrp.CFrame = CFrame.new(pos5)
				wait(2)
				hrp.CFrame = CFrame.new(summit)
				wait(2)
			end
		end)
	end
end)

createButton("Stop Grind ⏹️", 4, function()
	grinding = false
	if grindLoop then
		task.cancel(grindLoop)
		grindLoop = nil
	end
end)

--===[ TOMBOL TOGGLE SEMBUNYI - TIDAK DISIMPAN DI allButtons ]===--
local function createToggleButton(text, order, callback)
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 50 + ((order - 1) * 45))
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Font = Enum.Font.SourceSansBold
	button.Text = text
	button.Name = text
	button.MouseButton1Click:Connect(callback)
	return button
end

--===[ Tombol Sembunyikan GUI ]===--
local isHidden = false
local toggleBtn = createToggleButton("🔒 Sembunyikan GUI", 5, function()
	isHidden = not isHidden
	for _, btn in ipairs(allButtons) do
		btn.Visible = not isHidden
	end
	toggleBtn.Text = isHidden and "🔓 Tampilkan GUI" or "🔒 Sembunyikan GUI"
end)
