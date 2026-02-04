local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Solo Hunters: GOD HUB ⚔️", "DarkScene")

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.Distance = 10
_G.SelectedDungeon = "Dungeon 1"

-- [[ TABS ]]
local MainTab = Window:NewTab("Main Auto")
local DungeonTab = Window:NewTab("Dungeon Select")

-- [[ 1. เมนูฟาร์มหลัก ]]
local Section = MainTab:NewSection("Automation")

Section:NewToggle("Auto Farm (God Mode)", "วาร์ปไปเหนือหัวมอนและตีอัตโนมัติ", function(state)
    _G.AutoFarm = state
    if state then StartSuperFarm() end
end)

Section:NewSlider("Fly Height", "ปรับระยะความสูง", 20, 5, function(s)
    _G.Distance = s
end)

-- [[ 2. เมนูเลือกดันเจี้ยน ]]
local DSection = DungeonTab:NewSection("Dungeon Settings")

DSection:NewDropdown("Select Dungeon", "เลือกดันเจี้ยนที่ต้องการ", {"Dungeon 1", "Dungeon 2", "Dungeon 3", "Boss Raid"}, function(v)
    _G.SelectedDungeon = v
end)

DSection:NewButton("Enter Dungeon", "กดเพื่อเข้าดันเจี้ยนทันที", function()
    -- ระบบจะพยายามส่ง Remote ไปที่เซิร์ฟเวอร์เพื่อเริ่มเกม
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StartDungeon") or 
                   game:GetService("ReplicatedStorage"):FindFirstChild("EnterDungeon")
    if remote then
        remote:FireServer(_G.SelectedDungeon)
    else
        print("ไม่พบ Remote เข้าดันเจี้ยน กรุณาเดินเข้าประตูเอง")
    end
end)

-- [[ 3. ระบบโจมตีและวาร์ป ]]
local LP = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")

function StartSuperFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local root = LP.Character.HumanoidRootPart
                local target = nil
                local dist = math.huge
                
                -- ค้นหามอนสเตอร์ทุกที่ในแมพ
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
                        if v.Parent.Name ~= LP.Name then
                            local d = (root.Position - v.Parent.HumanoidRootPart.Position).Magnitude
                            if d < dist then dist = d; target = v.Parent.HumanoidRootPart end
                        end
                    end
                end

                if target then
                    -- บินล็อคเป้าเหนือหัวมอน
                    root.CFrame = target.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    -- จำลองการคลิกตี
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end

-- ระบบ Anti-AFK กันหลุด
LP.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
