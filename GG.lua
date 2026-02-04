local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v19 - ระบบฟาร์มภาษาไทย (The Forge)",
   LoadingTitle = "กำลังดึงข้อมูลจาก Airlines...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- เปิดใช้งานได้ทันทีไม่ต้องใส่คีย์
})

-[span_1](start_span)- รายชื่อแร่จริงจากฐานข้อมูลเกม[span_1](end_span)
local OreOptions = {"Stone", "Coal", "Copper Ore", "Tin Ore", "Iron Ore", "Lead Ore", "Silver Ore", "Gold Ore", "Cobalt Ore", "Mithril Ore", "Adamantite Ore", "Diamond", "Emerald", "Ruby"}
getgenv().SelectedOres = {}

-- [[ แท็บฟาร์มแร่ ]]
local MineTab = Window:CreateTab("ฟาร์มแร่ & หิน", 4483345998)

MineTab:CreateDropdown({
   Name = "เลือกชนิดหิน/แร่ (เลือกได้หลายอย่าง)",
   Options = OreOptions,
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedOres = Options
   end,
})

MineTab:CreateToggle({
   Name = "เริ่มขุดอัตโนมัติ (วาร์ป+ขุดรัว)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoMine = Value
       task.spawn(function()
           while getgenv().AutoMine do
               local found = false
               for _, v in pairs(workspace:GetDescendants()) do
                   if not getgenv().AutoMine then break end
                   
                   -[span_2](start_span)- ตรวจสอบว่าชื่อแร่ตรงกับที่เลือกไว้[span_2](end_span)
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
                               hrp.CFrame = v:GetPivot() * CFrame.new(0, 0, 2)
                               task.wait(0.2)
                               -[span_3](start_span)- ขุดรัวๆ จนกว่าแร่จะแตก[span_3](end_span)
                               repeat
                                   fireproximityprompt(prompt)
                                   task.wait(0.1)
                               until not v.Parent or not getgenv().AutoMine
                           end
                       end
                   end
               end
               if not found then task.wait(1) end
           end
       end)
   end,
})

-- [[ แท็บต่อสู้ ]]
local CombatTab = Window:CreateTab("ต่อสู้มอนสเตอร์", 4483345998)

CombatTab:CreateDropdown({
   Name = "เลือกชนิดมอนสเตอร์",
   Options = {"Slime", "Boar", "Skeleton Warrior", "Zombie", "Cave Spider", "Rock Golem"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedMobs = Options
   end,
})

CombatTab:CreateToggle({
   Name = "ระบบอมตะ (God Mode)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().GodMode = Value
       -- เพิ่มโค้ดระบบอมตะที่นี่
   end,
})

-- [[ แท็บตั้งค่าตัวละคร ]]
local SettingsTab = Window:CreateTab("ตั้งค่าตัวละคร", 4483345998)

SettingsTab:CreateSlider({
   Name = "ความเร็วการบิน/เดิน",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

SettingsTab:CreateButton({
   Name = "เปิดแสงสว่าง & ตัดหมอก",
   Callback = function()
       game.Lighting.Brightness = 2
       game.Lighting.FogEnd = 100000
   end,
})
