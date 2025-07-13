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
    {name = "Camp 3", vec = Vector3.new(1876.6221923828125, 9552.997070312, 3493.440429687)},
    {name = "Camp 4", vec = Vector3.new(1371.210693359375, 9776.9970703125, 3129.75634765625)},
    {name = "Camp 5", vec = Vector3.new(1191       , 10122.33 , 2297      )},
    {name = "Summit",  vec = Vector3.new(-116      , 10825.855, 3022      )}
}

--===[ TOGGLE SHOW/HIDE ]===--
local hidden = false
addBtn("🔒 Hide / Show Buttons", function()
    hidden = not hidden
    for _,b in ipairs(buttons) do b.Visible = not hidden end

    -- ubah ukuran frame
    local targetSize = hidden and UDim2.new(0,270,0,collapsedHeight)
                               or UDim2.new(0,270,0,fullHeight)
    frame:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)

end, true) -- exclude supaya tidak ikut disembunyikan

--===[ DRAG SUPPORT ]===--
local dragging, dragStart, startPos = false
frame.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, i.Position, frame.Position
        i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d = i.Position-dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

--===[ HELPER BUAT TOMBOL ]===--
local buttons, idx = {}, 0
local function addBtn(text, callback, exclude)
    idx += 1
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,btnH)
    b.Position = UDim2.new(0,10,0, padTop + (idx-1)*(btnH+gap))
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3, b.TextScaled, b.Font = Color3.new(1,1,1), true, Enum.Font.SourceSansBold
    b.Text = text
    b.MouseButton1Click:Connect(callback)
    if not exclude then table.insert(buttons,b) end
    return b
end

--===[ TELEPORT BUTTONS ]===--
for _,c in ipairs(coords) do
    addBtn("Teleport "..c.name, function() hrp.CFrame = CFrame.new(c.vec) end)
end

--===[ GRIND LOOP CAMP 1 ➜ SUMMIT ]===--
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
    grinding=false
    if grindTask then task.cancel(grindTask) end
end)

--===[ TOGGLE SHOW/HIDE ]===--
local hidden=false
addBtn("🔒 Hide / Show Buttons", function()
    hidden = not hidden
    for _,b in ipairs(buttons) do b.Visible = not hidden end
end, true) -- exclude so it never hides itself
