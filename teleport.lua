--===[ INIT ]===--
local plr  = game.Players.LocalPlayer
local hrp  = plr.Character:WaitForChild("HumanoidRootPart")
local UIS  = game:GetService("UserInputService")

local gui  = Instance.new("ScreenGui", game.CoreGui)
gui.Name, gui.ResetOnSpawn = "TeleportMenu", false

--===[ DATA KOORDINAT CAMP ]===--
local coords = {
    ["Camp 1"]  = Vector3.new(3359.697265625 , 9032.9970703125 , 5637.6806640625),
    ["Camp 2"]  = Vector3.new(3077.659912109375, 9108.9970703125, 4458.33056640625),
    ["Camp 3"]  = Vector3.new(1876.11572265625 , 9552.99609375  , 3490.1376953125),
    ["Camp 4"]  = Vector3.new(1370.075927734375, 9776.9970703125, 3129.393798828125),
    ["Camp 5"]  = Vector3.new(1191, 10122.33, 2297),
    ["Summit"]  = Vector3.new(-116, 10825.855, 3022),
}

--===[ UI FRAME ]===--
local btnH, gap, topPad = 40, 5, 55                -- tinggi tombol, jarak, padding atas
local totalBtns         = #table.getn(coords) + 3   -- teleport btn + grind + stop + toggle
local frameHeight       = topPad + totalBtns*(btnH+gap) + 10

local frame = Instance.new("Frame", gui)
frame.Size            = UDim2.new(0, 265, 0, frameHeight)
frame.Position        = UDim2.new(0, 20, 0, 90)
frame.BackgroundColor3= Color3.fromRGB(35,35,35)
frame.Active          = true

--===[ Title ]===--
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.Text = "🏔️ Rinjani Teleport Menu"
title.TextScaled, title.Font, title.TextColor3 = true, Enum.Font.SourceSansBold, Color3.new(1,1,1)

--===[ Drag ]===--
local dragging, dragStart, startPos = false,nil,nil
frame.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, inp.Position, frame.Position
        inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
        local d = inp.Position-dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

--===[ Helper: membuat tombol ]===--
local buttons, order = {}, 0
local function addBtn(text, callback, exclude)
    order += 1
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,btnH)
    b.Position = UDim2.new(0,10,0, topPad + (order-1)*(btnH+gap))
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3, b.TextScaled, b.Font = Color3.new(1,1,1), true, Enum.Font.SourceSansBold
    b.Text = text
    b.MouseButton1Click:Connect(callback)
    if not exclude then table.insert(buttons,b) end
    return b
end

--===[ Teleport buttons ]===--
for name,vec in pairs(coords) do
    addBtn("Teleport "..name, function() hrp.CFrame = CFrame.new(vec) end)
end

--===[ Grind logic ]===--
local grinding, grindTask = false,nil
local pos5, summit = coords["Camp 5"], coords["Summit"]

addBtn("Mulai Grind 🚀 (5↔Summit)", function()
    if not grinding then
        grinding = true
        grindTask = task.spawn(function()
            while grinding do
                hrp.CFrame = CFrame.new(pos5) ; task.wait(2)
                hrp.CFrame = CFrame.new(summit) ; task.wait(2)
            end
        end)
    end
end)

addBtn("Stop Grind ⏹️", function()
    grinding=false
    if grindTask then task.cancel(grindTask) end
end)

--===[ Toggle show/hide ]===--
local hidden=false
addBtn("🔒 Hide / Show Buttons", function()
    hidden = not hidden
    for _,b in ipairs(buttons) do b.Visible = not hidden end
end, true) -- exclude = true → tombol ini tidak ikut disembunyikan
