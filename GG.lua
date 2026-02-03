local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v14 - ระบบย่อหน้าต่าง",
   LoadingTitle = "กำลังเปิดเมนู...",
   LoadingSubtitle = "by MyHub",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- เปิดมาใช้งานได้เลย
})

-- ตัวแปรเก็บค่า
getgenv().SelectedOres = {}

-- [[ แท็บฟาร์มแร่ ]]
local MineTab = Window:CreateTab("ฟาร์มแร่", 4483345998)

-- เลือกชนิดแร่ (ข้ามตัวที่ไม่ได้เลือก)
MineTab:CreateDropdown({
   Name = "ประเภทหินที่จะขุด",
   Options = {"Stone", "Iron Ore", "Gold Ore", "Diamond"}, -- แก้ชื่อตามในเกม
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedOres = Options
   end,
})

MineTab:CreateToggle({
   Name = "เริ่มขุดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoMine = Value
       task.spawn(function()
           while getgenv().AutoMine do
               for _, v in pairs(workspace:GetDescendants()) do
                   if not getgenv().AutoMine then break end
                   
                   local isTarget = false
                   for _, target in pairs(getgenv().SelectedOres) do
                       if v.Name == target then isTarget = true break end
                   end

                   if isTarget and v:IsA("ProximityPrompt") then
                       local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                       if hrp then
                           hrp.CFrame = v.Parent.CFrame
                           task.wait(0.2)
                           fireproximityprompt(v)
                       end
                   end
               end
               task.wait(0.5)
           end
       end)
   end,
})

-- [[ แท็บต่อสู้ & มอนสเตอร์ ]]
local CombatTab = Window:CreateTab("ต่อสู้", 4483345998)

CombatTab:CreateDropdown({
   Name = "รายชื่อมอนสเตอร์",
   Options = {"Slime", "Goblin", "Skeleton", "Orc", "Boss"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedMobs = Options
   end,
})

CombatTab:CreateToggle({
   Name = "อมตะ (God Mode)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().GodMode = Value
   end,
})

-- [[ แท็บตั้งค่าตัวละคร ]]
local SettingTab = Window:CreateTab("ตัวละคร", 4483345998)

SettingTab:CreateSlider({
   Name = "ความไวการบิน/เดิน",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

SettingTab:CreateButton({
   Name = "หายตัว",
   Callback = function()
       -- ระบบหายตัว
   end,
})

-- [[ แท็บแสงสว่าง ]]
local VisualTab = Window:CreateTab("หน้าจอ", 4483345998)

VisualTab:CreateButton({
   Name = "เปิดไฟ & ตัดหมอก",
   Callback = function()
       game.Lighting.Brightness = 2
       game.Lighting.FogEnd = 100000
   end,
})
