-- Tween TP Navigator - FINAL
-- Nearest Point | Tween Speed 600 | Clean UI | CLOSE button

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local SPEED = 600
local tweening = false
local index = 1

-- ===== POINT LIST (BOTTOM → TOP) =====
local Points = {
    Vector3.new(200, -2.17, -26.02),
    Vector3.new(286.51, -2.17, -18.56),
    Vector3.new(403.35, -2.17, -9.08),
    Vector3.new(541.44, -2.17, 16.74),
    Vector3.new(759.35, -2.17, 23.77),
    Vector3.new(1074, -2.17, 15.14),
    Vector3.new(1549, -2.17, 32.63),
    Vector3.new(2242.88, -2.17, -0.57),
    Vector3.new(2590.69, -2.17, 16.21),
}

-- ===== CORE =====
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function getNearestIndex()
    local hrp = getHRP()
    local closest, dist = 1, math.huge
    for i, pos in ipairs(Points) do
        local d = (hrp.Position - pos).Magnitude
        if d < dist then
            dist = d
            closest = i
        end
    end
    return closest
end

local function TweenTo(i)
    if tweening then return end
    tweening = true

    local hrp = getHRP()
    local target = Points[i]
    local dist = (hrp.Position - target).Magnitude
    local time = math.max(dist / SPEED, 0.05)

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(target)}
    )

    tween:Play()
    tween.Completed:Wait()
    tweening = false
end

-- ===== UI =====
pcall(function()
    if game.CoreGui:FindFirstChild("TweenTP_UI") then
        game.CoreGui.TweenTP_UI:Destroy()
    end
end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TweenTP_UI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(90, 170)
main.Position = UDim2.fromScale(0.95, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 30, 35)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local function makeButton(y, text, size, bg)
    local b = Instance.new("TextButton", main)
    b.Size = size
    b.Position = UDim2.fromOffset(10, y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.fromRGB(230, 255, 255)
    b.TextSize = 20
    b.BackgroundColor3 = bg
    b.BackgroundTransparency = 0.2
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local up = makeButton(10, "▲", UDim2.fromOffset(70, 45), Color3.fromRGB(0, 160, 180))
up.TextSize = 22

local down = makeButton(60, "▼", UDim2.fromOffset(70, 45), Color3.fromRGB(0, 140, 165))
down.TextSize = 22

local close = makeButton(115, "CLOSE", UDim2.fromOffset(70, 35), Color3.fromRGB(255, 90, 90))
close.TextSize = 14
close.BackgroundTransparency = 0.15

-- ===== BUTTON LOGIC =====
up.MouseButton1Click:Connect(function()
    if index < #Points then
        index += 1
        TweenTo(index)
    end
end)

down.MouseButton1Click:Connect(function()
    if index > 1 then
        index -= 1
        TweenTo(index)
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== AUTO DETECT ON LOAD =====
task.wait(0.3)
index = getNearestIndex()
TweenTo(index)

-- ===== AUTO RE-DETECT AFTER RESET =====
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    index = getNearestIndex()
end)
