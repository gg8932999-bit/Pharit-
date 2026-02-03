local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "MyHub v4 - The Forge", SaveConfig = true, ConfigFolder = "OrionTest"})

-- เก็บค่าแร่ที่เลือกไว้
getgenv().SelectedOres = {}

local FarmTab = Window:MakeTab({Name = "Farm & Combat", Icon = "rbxassetid://4483345998"})

-- 1. เมนูเลือกชนิดแร่
FarmTab:AddDropdown({
	Name = "Select Ores (เลือกชนิดแร่)",
	Default = "",
	Options = {"Iron Ore", "Gold Ore", "Diamond Ore", "Copper Ore", "Coal Ore"}, -- แก้ชื่อแร่ให้ตรงกับในเกมของคุณ
	Callback = function(Value)
		-- เพิ่มหรือเอาแร่ออกจากรายการที่เลือก
        if not table.find(getgenv().SelectedOres, Value) then
            table.insert(getgenv().SelectedOres, Value)
            OrionLib:MakeNotification({Name = "Selected", Content = "เพิ่ม: "..Value, Time = 2})
        else
            for i, v in pairs(getgenv().SelectedOres) do
                if v == Value then table.remove(getgenv().SelectedOres, i) end
            end
            OrionLib:MakeNotification({Name = "Removed", Content = "เอาออก: "..Value, Time = 2})
        end
	end    
})

-- 2. ปุ่มล้างรายการที่เลือก
FarmTab:AddButton({
	Name = "Clear Selected (ล้างรายการที่เลือก)",
	Callback = function()
		getgenv().SelectedOres = {}
        OrionLib:MakeNotification({Name = "System", Content = "ล้างรายการแร่ทั้งหมดแล้ว", Time = 3})
	end
})

-- 3. สวิตช์เปิดฟาร์ม (จะฟาร์มเฉพาะแร่ที่เลือก)
FarmTab:AddToggle({
    Name = "Auto Farm Selected Ores",
    Default = false,
    Callback = function(v)
        getgenv().AutoFarm = v
        while getgenv().AutoFarm do
            for _, ore in pairs(workspace:GetChildren()) do
                if not getgenv().AutoFarm then break end
                
                -- ตรวจสอบว่าแร่นี้อยู่ในรายการที่เลือกหรือไม่
                local isSelected = false
                for _, selectedName in pairs(getgenv().SelectedOres) do
                    if ore.Name:find(selectedName) then isSelected = true break end
                end

                if isSelected and ore:FindFirstChild("ProximityPrompt") then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = ore.CFrame
                        task.wait(0.3)
                        fireproximityprompt(ore.ProximityPrompt)
                    end
                end
            end
            task.wait(0.1)
        end
    end
})

-- ใส่ส่วนของ God Mode และ Auto Kill เดิมของคุณไว้ที่นี่ได้เลยครับ
-- ... (โค้ดส่วนอื่นคงเดิม)

OrionLib:Init()
