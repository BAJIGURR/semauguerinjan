--========================================================--
--  RINJANI TELEPORT GUI – versi lengkap & ringkas        --
--========================================================--

--===[ INIT ]===--
local plr  = game.Players.LocalPlayer
local hrp  = plr.Character:WaitForChild("HumanoidRootPart")
local UIS  = game:GetService("UserInputService")

local gui  = Instance.new("ScreenGui", game.CoreGui)
gui.Name, gui.ResetOnSpawn = "TeleportMenu", false

--===[ DATA KOORDINAT ]===--
local coords = {
    {name = "Camp 1", vec = Vector3.new(3359.6973 , 9032.997 , 5637.6807)},
    {name = "Camp 2", vec = Vector3.new(3077.6599 , 9108.997 , 4458.3306)},
    {name = "Camp 3", vec = Vector3.new(1877.029418945312, 9552.99609375, 3492.64453125)},
    {name = "Camp 4", vec = Vector3.new(1371.210693359375, 9776.9970703125, 3129.75634765625)},
    {name = "Camp 5", vec = Vector3.new(1191       , 10122.33 , 2297      )},
    {name = "Summit",  vec = Vector3.new(-116      , 10825.855, 3022      )}
}

--===[ FRAME & TITLE ]===--
local btnH, gap, padTop  = 40, 5, 50                  -- tinggi tombol, jarak, padding atas
local totalBtns          = #coords + 3                -- teleport + Grind + Stop + Toggle
local fullH              = padTop + totalBtns*(btnH+gap) + 10
local collapsedH         = padTop + (btnH+gap) + 10   -- hanya title + toggle

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, fullH)
frame.Position = UDim2.new(0, 20, 0, 90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.Text = "🏔️ Rinjani Teleport Menu"
title.TextScaled, title.Font, title.TextColor3 = true, Enum.Font.SourceSansBold, Color3.new(1,1,1)

--===[ DRAG ]===--
local dragging, dragStart, startPos = false
frame.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, inp.Position, frame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
        local d = inp.Position-dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                   startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

--===[ BUTTON FACTORY ]===--
local buttons, idx = {}, 0
local function addBtn(label, callback, exclude)
    idx += 1
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,btnH)
    b.Position = UDim2.new(0,10,0, padTop + (idx-1)*(btnH+gap))
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3, b.TextScaled, b.Font = Color3.new(1,1,1), true, Enum.Font.SourceSansBold
    b.Text = label
    b.MouseButton1Click:Connect(callback)
    if not exclude then table.insert(buttons,b) end
    return b
end

--===[ TELEPORT BUTTONS ]===--
for _,c in ipairs(coords) do
    addBtn("Teleport "..c.name, function() hrp.CFrame = CFrame.new(c.vec) end)
end

--===[ GRIND LOOP Camp 1 ➜ Summit ]===--
local grinding, grindTask = false,nil
addBtn("Mulai Grind 🚀 (C1→Summit)", function()
    if grinding then return end
    grinding = true
    grindTask = task.spawn(function()
        while grinding do
            for _,c in ipairs(coords) do
                if not grinding then break end
                hrp.CFrame = CFrame.new(c.vec)
                task.wait(2)
            end
        end
    end)
end)

addBtn("Stop Grind ⏹️", function()
    grinding = false
    if grindTask then task.cancel(grindTask) end
end)

--===[ TOGGLE SHOW / HIDE ]===--
local hidden = false
addBtn("🔒 Hide / Show Buttons", function()
    hidden = not hidden
    for _,b in ipairs(buttons) do b.Visible = not hidden end

    local target = hidden and UDim2.new(0,270,0,collapsedH)
                         or  UDim2.new(0,270,0,fullH)
    frame:TweenSize(target, Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad, 0.25, true)
end, true)  -- excluded so it never hides itself
