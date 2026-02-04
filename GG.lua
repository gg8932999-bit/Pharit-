local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v8 - Stable", -- สไตล์เดิมที่คุณชอบ
   LoadingTitle = "กำลังค้นหา Icy Pebble...",
   ConfigurationSaving = { Enabled = false }
})

-- รายชื่อหินที่เห็นจากในภาพล่าสุดของคุณ
local CustomOres = {"Icy Pebble", "Icy Rock", "Stone", "Coal", "Iron Ore", "Gold Ore"}

local MainTab = Window:CreateTab("Auto Farm", 4483345998) 
MainTab:CreateSection("Farm Settings") 

MainTab:CreateDropdown({
   Name = "เลือกชื่อหิน (จากภาพคือ Icy Pebble)",
   Options = CustomOres,
   CurrentOption = {"Icy Pebble"}, -- ตั้งค่าเริ่มต้นให้ตรงกับภาพ
   Callback = function(Option)
       getgenv().TargetOre = Option[1]
   end,
})

MainTab:CreateToggle({
   Name = "Auto Farm Ores",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().StartFarm = Value
       if Value then
           task.spawn(function()
               while getgenv().StartFarm do
                   local target = nil
                   -- ค้นหาหินที่มีชื่อตรงกับที่เลือก
                   for _, v in pairs(workspace:GetDescendants()) do
                       if v.Name == getgenv().TargetOre and v:FindFirstChildWhichIsA("ProximityPrompt", true) then
                           target = v
                           break
                       end
                   end

                   if target then
                       local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                       local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                       
                       if hrp and prompt then
                           -- สั่งให้ตัวละครวาร์ปไปที่หิน
                           hrp.CFrame = target:GetPivot() * CFrame.new(0, 0, 3)
                           task.wait(0.3)
                           
                           -- กดขุดอัตโนมัติจนกว่าหินจะแตก
                           repeat
                               fireproximityprompt(prompt)
                               task.wait(0.1)
                           until not target.Parent or not getgenv().StartFarm
                       end
                   end
                   task.wait(1)
               end
           end)
       end
   end,
})
