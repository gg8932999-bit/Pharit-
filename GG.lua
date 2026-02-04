local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Solo Hunter: Dungeon Hub ⚔️", "DarkScene")

-- [[ SETTINGS ]]
_G.SelectedDungeon = "None"
_G.SelectedDifficulty = "Normal"
_G.AutoFarm = false

-- [[ TABS ]]
local MainTab = Window:NewTab("Auto Dungeon")
local Section = MainTab:NewSection("Dungeon Selection")

-- 1. ตัวเลือกดันเจี้ยน
Section:NewDropdown("Select Dungeon", "เลือกดันเจี้ยนที่ต้องการ", {"Dungeon 1", "Dungeon 2", "Dungeon 3", "Boss Map"}, function(currentOption)
    _G.SelectedDungeon = currentOption
    print("Selected: " .. currentOption)
end)

-- 2. ตัวเลือกความยาก
Section:NewDropdown("Difficulty", "เลือกระดับความยาก", {"Easy", "Normal", "Hard", "Hell"}, function(currentOption)
    _G.SelectedDifficulty = currentOption
end)

-- 3. ปุ่มเริ่มฟาร์ม
Section:NewToggle("Start Auto Farm", "เริ่มวิ่งเข้าดันเจี้ยนและฟาร์ม", function(state)
    _G.AutoFarm = state
    if state then
        -- ใส่โค้ดที่สั่งให้ตัวละครวาร์ปไปหน้าดันเจี้ยน หรือส่ง Remote ไปเริ่มเกม
        StartDungeonFarm()
    end
end)

-- [[ FUNCTIONS ]]
function StartDungeonFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(1)
            -- ตัวอย่าง: ส่ง Remote ไปที่ Server เพื่อเริ่มดันเจี้ยนที่เลือก
            -- game:GetService("ReplicatedStorage").Events.StartDungeon:FireServer(_G.SelectedDungeon, _G.SelectedDifficulty)
            
            -- ส่วนนี้คือ Logic การตีมอนสเตอร์ (ใช้ตัวเดิมที่เราทำไว้)
            pcall(function()
                -- ... (โค้ดหาเป้าหมายและโจมตีจากเวอร์ชันก่อนหน้า) ...
            end)
        end
    end)
end
