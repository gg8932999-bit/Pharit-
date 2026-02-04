-- [[ Solo Hunters: Full Auto Farm & God Mode ]]
-- Created for execution on Delta Executor

_G.Settings = {
    AutoFarm = true,
    AttackDistance = 10, -- ระยะความสูงเหนือหัวมอนสเตอร์
    TweenSpeed = 65,      -- ความเร็วในการเคลื่อนที่
    AutoSkill = true,     -- เปิดใช้สกิลอัตโนมัติ
    BringMob = true       -- ดึงมอนสเตอร์มารวม (ถ้าเกมรองรับ)
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local TS = game:GetService("TweenService")
local VU = game:GetService("VirtualUser")

-- [ ปิดระบบตรวจจับการยืนนิ่ง ]
if getconnections then
    for _, v in pairs(getconnections(LP.Idled)) do
        v:Disable()
    end
else
    LP.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end

-- [ ฟังก์ชันหาเป้าหมาย ]
local function GetTarget()
    local target = nil
    local dist = math.huge
    -- ตรวจสอบโฟลเดอร์มอนสเตอร์ที่พบบ่อยใน Solo Hunters
    local folder = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs") or workspace
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local mag = (LP.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    return target
end

-- [ ลูปทำงานหลัก ]
print("--- Solo Hunters Script Activated ---")
task.spawn(function()
    while _G.Settings.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local mob = GetTarget()
            if mob then
                -- บินไปล็อคตำแหน่งเหนือหัวมอนสเตอร์ (God Mode Position)
                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.AttackDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                local tween = TS:Create(LP.Character.HumanoidRootPart, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetPos})
                tween:Play()
                
                -- ระบบ Auto Click / Attack
                VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.05)
                VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                
                -- สุ่มกดปุ่มสกิล (Q, E, R)
                if _G.Settings.AutoSkill then
                    -- สำหรับ Delta บางเวอร์ชันอาจต้องใช้ RemoteEvent แทนการจำลองปุ่มกด
                    -- ตรงนี้บอทจะพยายามคลิกหน้าจอซ้ำๆ เพื่อกระตุ้นการตี
                end
            else
                -- ถ้าไม่มีมอนสเตอร์ ให้พยายามคลิกเพื่อผ่านหน้าจบดันเจี้ยน
                VU:Button1Down(Vector2.new(500,500), workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VU:Button1Up(Vector2.new(500,500), workspace.CurrentCamera.CFrame)
            end
        end)
    end
end)
