-- [[ ABYSS MISSION HELPER - LITE EDITION ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ตั้งค่าเป้าหมายตามภารกิจในรูปของคุณ
getgenv().MissionConfig = {
    SilentAim = true,
    Prediction = 0.14, -- เพิ่มนิดหน่อยเพราะ Hammerhead ว่ายไว
    FOVSize = 150,
    -- รายชื่อปลาที่สคริปต์จะค้นหา
    Targets = {"Hammerhead", "Blue Tang", "Red Fish", "Fish"} 
}

local function GetMissionTarget()
    local Target = nil
    local Closest = getgenv().MissionConfig.FOVSize

    -- ค้นหาใน Workspace (มักจะอยู่ใน Folder เช่น Mobs หรือ Fish)
    for _, v in pairs(workspace:GetChildren()) do
        local isTarget = false
        for _, name in pairs(getgenv().MissionConfig.Targets) do
            if string.find(v.Name, name) then
                isTarget = true
                break
            end
        end

        if isTarget and v:FindFirstChild("HumanoidRootPart") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.HumanoidRootPart.Position)
            if OnScreen then
                local Dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Dist < Closest then
                    Closest = Dist
                    Target = v
                end
            end
        end
    end
    return Target
end

-- ระบบล็อคเป้าฉมวก (ใช้ Index เพื่อความลื่นไหลที่สุด)
local OldIndex
OldIndex = hookmetamethod(game, "__index", function(self, index)
    if self == Mouse and (index == "Hit") and getgenv().MissionConfig.SilentAim then
        local Target = GetMissionTarget()
        if Target then
            local PredictedPos = Target.HumanoidRootPart.Position + (Target.HumanoidRootPart.Velocity * getgenv().MissionConfig.Prediction)
            return CFrame.new(PredictedPos)
        end
    end
    return OldIndex(self, index)
end)

-- ปุ่มกดแบบลอย (เล็กและไม่กินสเปก)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainBtn = Instance.new("TextButton", ScreenGui)
MainBtn.Size = UDim2.new(0, 120, 0, 40)
MainBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
MainBtn.Text = "Mission Aim: ON"
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
MainBtn.TextColor3 = Color3.new(1, 1, 1)
MainBtn.Draggable = true -- ลากไปวางตรงไหนก็ได้ไม่ให้บังจอ

MainBtn.MouseButton1Click:Connect(function()
    getgenv().MissionConfig.SilentAim = not getgenv().MissionConfig.SilentAim
    MainBtn.Text = getgenv().MissionConfig.SilentAim and "Mission Aim: ON" or "Mission Aim: OFF"
    MainBtn.BackgroundColor3 = getgenv().MissionConfig.SilentAim and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(150, 0, 0)
end)

print("Abyss Mission Script Loaded - Ready to hunt Hammerhead!")
