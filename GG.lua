--[[
    CUSTOM ABYSS HUB (IMPROVED VERSION)
    - Fix: Silent Aim accuracy
    - Add: Field of View (FOV) Circle
    - Add: Better Prediction
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- // CONFIGURATION // --
getgenv().Config = {
    SilentAim = true,
    TriggerBot = false,
    Prediction = 0.135, -- ปรับค่าตามความเร็วของเกม
    FOVSize = 150,
    TargetPart = "HumanoidRootPart"
}

-- // FOV CIRCLE // --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = true

-- // FUNCTIONS // --
local function GetClosestPlayer()
    local Target = nil
    local ClosestDist = getgenv().Config.FOVSize

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Config.TargetPart) then
            -- ตรวจสอบว่าศัตรูไม่ตาย
            local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local ScreenPos, IsVisible = Camera:WorldToViewportPoint(v.Character[getgenv().Config.TargetPart].Position)
                if IsVisible then
                    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    
                    if Distance < ClosestDist then
                        Target = v
                        ClosestDist = Distance
                    end
                end
            end
        end
    end
    return Target
end

-- // SILENT AIM HOOK // --
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if Method == "FindPartOnRayWithIgnoreList" and getgenv().Config.SilentAim and not checkcaller() then
        local Target = GetClosestPlayer()
        if Target then
            local TargetPos = Target.Character[getgenv().Config.TargetPart].Position + (Target.Character[getgenv().Config.TargetPart].Velocity * getgenv().Config.Prediction)
            Args[1] = Ray.new(Camera.CFrame.Position, (TargetPos - Camera.CFrame.Position).Unit * 1000)
            return OldNamecall(Self, unpack(Args))
        end
    end
    return OldNamecall(Self, ...)
end)

-- // UPDATE FOV // --
RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = getgenv().Config.FOVSize
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

-- // UI SETUP (แบบที่คุณใช้อยู่) // --
-- (ส่วนนี้ใช้ UI เดิมที่คุณรันขึ้นมาได้เลยครับ แค่เปลี่ยน Function การทำงานของปุ่ม)
print("Advanced Abyss Script Loaded!")
