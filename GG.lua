local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "MyHub v5 - The Forge", SaveConfig = true, ConfigFolder = "OrionTest"})

getgenv().SelectedOres = {}
local oreList = {}

-- ฟังก์ชันค้นหาชื่อแร่ที่มีอยู่ในเซิร์ฟเวอร์ตอนนี้
for _, v in pairs(workspace:GetChildren()) do
    if v.Name:find("Ore") and not table.find(oreList, v.Name) then
        table.insert(oreList, v.Name)
    end
end

local FarmTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998"})

-- 1. เมนูเลือกชนิดแร่ (จะแสดงชื่อแร่ที่มันเจอในเกมจริงๆ)
FarmTab:AddDropdown({
	Name = "Select Ores (เลือกแร่ที่เจอในเกม)",
	Default = "",
	Options = oreList, 
	Callback = function(Value)
        if not table.find(getgenv().SelectedOres, Value) then
            table.insert(getgenv().SelectedOres, Value)
            OrionLib:MakeNotification({Name = "System", Content = "เลือกฟาร์ม: "..Value, Time = 2})
        end
	end    
})

-- 2. ปุ่มล้างรายการ
FarmTab:AddButton({
	Name = "Reset Selection (ล้างที่เลือกใหม่)",
	Callback = function()
		getgenv().SelectedOres = {}
        OrionLib:MakeNotification({Name = "System", Content = "ล้างรายการแล้ว เลือกใหม่ได้เลย", Time = 3})
	end
})

-- 3. สวิตช์เปิดฟาร์ม
FarmTab:AddToggle({
    Name = "Start Farming (เริ่มฟาร์ม)",
    Default = false,
    Callback = function(v)
        getgenv().AutoFarm = v
        while getgenv().AutoFarm do
            for _, ore in pairs(workspace:GetChildren()) do
                if not getgenv().AutoFarm then break end
                
                -- ตรวจสอบว่าตรงกับแร่ที่เลือกไหม
                if table.find(getgenv().SelectedOres, ore.Name) and ore:FindFirstChild("ProximityPrompt") then
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

OrionLib:Init()
