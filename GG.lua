local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v17 - The Forge [Detailed]",
   LoadingTitle = "กำลังโหลดข้อมูลแร่ระดับสูง...",
   ConfigurationSaving = { Enabled = false }
})

getgenv().SelectedOres = {}

local Tab = Window:CreateTab("ระบบขุดแร่ละเอียด", 4483345998)

-- รายชื่อแร่ที่ละเอียดที่สุดของเกม The Forge
Tab:CreateDropdown({
   Name = "เลือกชนิดแร่ที่ต้องการ",
   Options = {"Stone", "Coal", "Copper Ore", "Tin Ore", "Iron Ore", "Lead Ore", "Silver Ore", "Gold Ore", "Cobalt Ore", "Mithril Ore", "Adamantite Ore", "Diamond", "Emerald", "Ruby"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedOres = Options
   end,
})

Tab:CreateToggle({
   Name = "เริ่มฟาร์มแบบเช็คค่า HP",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoFarm = Value
       task.spawn(function()
           while getgenv().AutoFarm do
               local found = false
               for _, v in pairs(workspace:GetDescendants()) do
                   if not getgenv().AutoFarm then break end
                   
                   -- ตรวจสอบชื่อแร่จากลิสต์ที่เราเลือก
                   local isTarget = false
                   for _, target in pairs(getgenv().SelectedOres) do
                       if v.Name == target then isTarget = true break end
                   end

                   if isTarget then
                       local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true) or v.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
                       if prompt then
                           local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                           if hrp then
                               found = true
                               -- วาร์ปไปตำแหน่งแร่
                               hrp.CFrame = v:GetPivot() * CFrame.new(0, 0, 3)
                               task.wait(0.2)
                               
                               -- วนลูปกดขุดจนกว่าแร่จะแตก (HP หมด)
                               repeat
                                   fireproximityprompt(prompt)
                                   task.wait(0.1)
                                   -- ตรวจสอบว่าแร่ยังอยู่ไหม (ถ้าถูกทำลายแล้ว v จะไม่มี parent)
                               until not v.Parent or not getgenv().AutoFarm
                           end
                       end
                   end
               end
               if not found then task.wait(1) end
           end
       end)
   end,
})

-- ส่วนของมอนสเตอร์ (ใส่รายชื่อมอนสเตอร์ในโซนต่างๆ)
local MobTab = Window:CreateTab("มอนสเตอร์", 4483345998)
MobTab:CreateDropdown({
   Name = "ประเภทมอนสเตอร์",
   Options = {"Slime", "Boar", "Skeleton Warrior", "Zombie", "Cave Spider", "Rock Golem"},
   Callback = function(v) getgenv().TargetMob = v end
})

-- ระบบตัวละคร
local ConfigTab = Window:CreateTab("ตั้งค่า", 4483345998)
ConfigTab:CreateSlider({
   Name = "ความเร็วตัวละคร (บิน/เดิน)",
   Range = {16, 350},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end
})
