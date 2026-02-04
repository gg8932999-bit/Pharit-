local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Solo Hunters: GOD HUB ⚔️", "DarkScene")

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.Distance = 10
_G.SelectedDungeon = "Dungeon 1"
_G.SelectedDifficulty = "Normal"

-- [[ TABS ]]
local MainTab = Window:NewTab("Main Auto")
local DungeonTab = Window:NewTab("Dungeon Settings")

-- [[ MAIN AUTO SECTION ]]
local Section = MainTab:NewSection("Automation")

Section:NewToggle("Auto Farm (Start Here!)", "วาร์ปไปหามอนและตีอัตโนมัติ", function(state)
    _G.AutoFarm = state
    if state then StartSuperFarm() end
end)

Section:NewSlider("Fly Height (ความสูง)", "ปรับระยะความสูงเหนือหัวมอน", 20, 5, function(s)
    _G.Distance = s
end)

-- [[ DUNGEON SECTION ]]
local DSection = DungeonTab:NewSection("Dungeon Setup")

DSection:NewDropdown("Select Map", "เลือกด่านที่ต้องการ", {"Dungeon 1", "Dungeon 2", "Dungeon 3", "Boss Raid"}, function(v)
    _G.SelectedDungeon = v
end)

DSection:NewDropdown("Difficulty", "ระดับความยาก", {"Easy", "Normal", "Hard", "Nightmare"}, function(v)
    _G.SelectedDifficulty = v
end)

DSection:NewButton("Enter Dungeon Now", "วาร์ปเข้าดันที่เลือกทันที", function()
    -- พยายามหา Remote สำหรับเข้าดันเจี้ยน
    local enterRemote = game:GetService("ReplicatedStorage"):FindFirstChild("EnterDungeon") or 
                        game:GetService("ReplicatedStorage"):FindFirstChild("StartGame")
    if enterRemote then
        enterRemote:FireServer(_G.SelectedDungeon, _G.SelectedDifficulty)
    else
        print("กรุณาเดินเข้าประตูเอง หรือใช้ Remote Spy เช็คชื่อ Remote")
    end
end)

-- [[ CORE LOGIC ]]
local LP = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")

function StartSuperFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local char = LP.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                
                -- ค้นหามอนสเตอร์ (แบบละเอียดทุก Folder)
                local target = nil
                local dist = math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
                        if v.Parent.Name ~= LP.Name then
                            local d = (root.Position - v.Parent.HumanoidRootPart.Position).Magnitude
                            if d < dist then
                                dist = d
                                target = v.Parent.HumanoidRootPart
                            end
                        end
                    end
                end

                if target then
                    -- 1. บินล็อคเป้า
                    root.CFrame = target.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    -- 2. สั่งตี (ครอบคลุมทั้ง Click และ Remote)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    
                    -- พยายามยิง Remote โจมตีที่พบบ่อยใน Solo Hunters
                    local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Attack") or 
                                         game:GetService("ReplicatedStorage"):FindFirstChild("Hit")
                    if combatRemote then combatRemote:FireServer() end
                end
            end)
        end
    end)
end

-- Anti-AFK
LP.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
