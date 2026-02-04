local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v22 - The Forge [Lite]",
   LoadingTitle = "กำลังเริ่มระบบแบบประหยัดทรัพยากร...",
   ConfigurationSaving = { Enabled = false }
})

-- ตัวแปรตั้งค่า
getgenv().AutoMine = false
getgenv().SelectedOre = "Stone" -- ค่าเริ่มต้น

local Tab = Window:CreateTab("ฟาร์มแร่", 4483345998)

Tab:CreateDropdown({
   Name = "เลือกแร่ที่จะขุด",
   Options = {"Stone", "Coal", "Copper Ore", "Iron Ore", "Gold Ore", "Diamond"},
   CurrentOption = {"Stone"},
   MultipleOptions = false, -- เปลี่ยนเป็นเลือกทีละอย่างเพื่อลดอาการแล็ก
   Callback = function(Option)
       getgenv().SelectedOre = Option[1]
   end,
})

Tab:CreateToggle({
   Name = "เปิดระบบขุดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoMine = Value
       if Value then
           task.spawn(function()
               while getgenv().AutoMine do
                   -- ค้นหาเฉพาะแร่ที่อยู่ใกล้ตัวที่สุด 1 ก้อน แทนการสแกนทั้งแผนที่
                   local target = nil
                   local dist = math.huge
                   for _, v in pairs(workspace:GetDescendants()) do
                       if v.Name == getgenv().SelectedOre and v:FindFirstChildWhichIsA("ProximityPrompt") then
                           local mag = (v:GetPivot().Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                           if mag < dist then
                               dist = mag
                               target = v
                           end
                       end
                       if not getgenv().AutoMine then break end
                   end

                   if target then
                       local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                       local prompt = target:FindFirstChildWhichIsA("ProximityPrompt")
                       hrp.CFrame = target:GetPivot() * CFrame.new(0, 0, 3)
                       task.wait(0.5)
                       fireproximityprompt(prompt)
                       -- รอให้แร่หายไปก่อนค่อยไปก้อนถัดไป
                       while target.Parent and getgenv().AutoMine do task.wait(0.5) end
                   end
                   task.wait(1) -- พักเครื่อง 1 วินาทีก่อนหาใหม่เพื่อลดอาการแล็ก
               end
           end)
       end
   end,
})

local SettingTab = Window:CreateTab("ตั้งค่า", 4483345998)
SettingTab:CreateSlider({
   Name = "ความเร็วเดิน",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})
