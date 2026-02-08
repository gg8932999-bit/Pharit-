-- [[ ABYSS PRO HUB - TWEEN VERSION ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

getgenv().Config = {
    TargetFish = "Hammerhead",
    AutoFly = false,
    Speed = 50 -- ความเร็วในการเคลื่อนที่ไปหาปลา
}

-- // ฟังก์ชันค้นหาปลา (เช็คละเอียดทุก Part) // --
local function GetTarget()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(v.Name:lower(), getgenv().Config.TargetFish:lower()) then
            local p = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head") or v:FindFirstChildOfClass("Part")
            if p then return p end
        end
    end
    return nil
end

-- // ระบบเคลื่อนที่แบบ Tween (ไม่ค้างแน่นอน) // --
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config.AutoFly then
            local targetPart = GetTarget()
            local char = LocalPlayer.Character
            if targetPart and char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - targetPart.Position).Magnitude
                local info = TweenInfo.new(dist / getgenv().Config.Speed, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(char.HumanoidRootPart, info, {CFrame = targetPart.CFrame * CFrame.new(0, 0, 3)})
                tween:Play()
            end
        end
    end
end)

-- // UI แบบปุ่มกดพับได้ (Mini Menu) // --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Menu = Instance.new("Frame", ScreenGui)
Menu.Size = UDim2.new(0, 140, 0, 150)
Menu.Position = UDim2.new(0, 10, 0.4, 0)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Menu.Visible = true

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 80, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0.35, 0)
Toggle.Text = "Menu"

Toggle.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

local function AddBtn(txt, pos, fish)
    local b = Instance.new("TextButton", Menu)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Position = UDim2.new(0, 0, 0, pos)
    b.Text = txt
    b.MouseButton1Click:Connect(function() 
        getgenv().Config.TargetFish = fish
        print("เลือกเป้าหมาย: "..fish)
    end)
end

AddBtn("Hammerhead", 0, "Hammerhead")
AddBtn("Blue Tang", 35, "Blue Tang")
AddBtn("Red Fish", 70, "Red Fish")

local FlyBtn = Instance.new("TextButton", Menu)
FlyBtn.Size = UDim2.new(1, 0, 0, 40)
FlyBtn.Position = UDim2.new(0, 0, 0, 110)
FlyBtn.Text = "Start Auto Fly"
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)

FlyBtn.MouseButton1Click:Connect(function()
    getgenv().Config.AutoFly = not getgenv().Config.AutoFly
    FlyBtn.Text = getgenv().Config.AutoFly and "Stop" or "Start Auto Fly"
    FlyBtn.BackgroundColor3 = getgenv().Config.AutoFly and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(0, 120, 0)
end)
