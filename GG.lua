local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v8 - Stable (ไทย)",
   LoadingTitle = "กำลังย้อนกลับไปยังเวอร์ชันที่เสถียร...",
   ConfigurationSaving = { Enabled = false }
})

-- รายชื่อแร่ทั้งหมดที่รวบรวมไว้
local Ores = {"Stone", "Coal", "Copper Ore", "Tin Ore", "Iron Ore", "Silver Ore", "Gold Ore", "Cobalt Ore", "Mithril Ore", "Adamantite Ore"}

local MainTab = Window:CreateTab("Auto Farm", 4483345998) -- แท็บซ้ายมือตามภาพ

MainTab:CreateSection("Farm Settings") -- หัวข้อขวามือตามภาพ

MainTab:CreateDropdown({
   Name = "เลือกแร่เป้าหมาย",
   Options = Ores,
   CurrentOption = {"Stone"},
   Callback = function(Option)
       getgenv().TargetOre = Option[1]
   end,
})

MainTab:CreateToggle({
   Name = "Auto Farm Ores", -- ปุ่มเปิด/ปิดตามภาพ
   CurrentValue = false,
   Callback = function(Value)
       getgenv().StartFarm = Value
       if Value then
           task.spawn(function()
               while getgenv().StartFarm do
                   -- ใช้ Logic การค้นหาแบบ Airlines เพื่อให้ตัวขยับ
                   for _, v in pairs(workspace:GetDescendants()) do
                       if v.Name == getgenv().TargetOre and v:FindFirstChildOfClass("ProximityPrompt") then
                           local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                           if hrp then
                               hrp.CFrame = v:GetPivot() * CFrame.new(0, 0, 3)
                               task.wait(0.3)
                               fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                               while v.Parent and getgenv().StartFarm do task.wait(0.5) end
                           end
                       end
                       if not getgenv().StartFarm then break end
                   end
                   task.wait(1)
               end
           end)
       end
   end,
})
