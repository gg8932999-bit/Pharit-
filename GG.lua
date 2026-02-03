local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v12 - ระบบฟาร์มภาษาไทย",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by MyHub",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- ปิดระบบคีย์เพื่อให้ใช้งานได้ทันที
})

-- ตัวแปรเก็บค่าต่างๆ
getgenv().SelectedOres = {}
getgenv().SelectedMobs = {}

-- [[ แท็บฟาร์มแร่ ]]
local MineTab = Window:CreateTab("ขุดแร่ & หิน", 4483345998)

MineTab:CreateDropdown({
   Name = "เลือกชนิดหิน/แร่ที่จะขุด",
   Options = {"Stone", "Iron Ore", "Gold Ore", "Diamond Ore", "Emerald", "Ruby"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedOres = Options
   end,
})

MineTab:CreateToggle({
   Name = "เริ่มขุดอัตโนมัติ (ข้ามแร่ที่ไม่เลือก)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoMine = Value
       while getgenv().AutoMine do
           for _, v in pairs(workspace:GetDescendants()) do
               if not getgenv().AutoMine then break end
               -- เช็คว่าชื่อตรงกับที่เลือกไว้ไหม
               local isTarget = false
               for _, targetName in pairs(getgenv().SelectedOres) do
                   if v.Name == targetName then isTarget = true break end
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
   end,
})

-- [[ แท็บต่อสู้ ]]
local CombatTab = Window:CreateTab("ระบบต่อสู้", 4483345998)

CombatTab:CreateDropdown({
   Name = "เลือกมอนสเตอร์ (รายชื่อทั้งหมด)",
   Options = {"Slime", "Goblin", "Skeleton", "Orc", "Wolf", "Boss"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedMobs = Options
   end,
})

CombatTab:CreateToggle({
   Name = "เริ่มตีมอนสเตอร์อัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoKill = Value
       -- ใส่ระบบโจมตีของคุณที่นี่
   end,
})

-- [[ แท็บตั้งค่าตัวละคร & แสง ]]
local SettingTab = Window:CreateTab("ตั้งค่าตัวละคร", 4483345998)

SettingTab:CreateSlider({
   Name = "ความไวการบิน/เดิน",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

SettingTab:CreateToggle({
   Name = "โหมดอมตะ (God Mode)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().GodMode = Value
       -- ระบบอมตะ
   end,
})

SettingTab:CreateToggle({
   Name = "หายตัว (Invisiblity)",
   CurrentValue = false,
   Callback = function(Value)
       -- ระบบหายตัว
   end,
})

-- [[ แท็บหน้าจอ & แสง ]]
local VisualTab = Window:CreateTab("หน้าจอ & แสง", 4483345998)

VisualTab:CreateButton({
   Name = "ตัดหมอก (Remove Fog)",
   Callback = function()
       game.Lighting.FogEnd = 100000
       for i,v in pairs(game.Lighting:GetDescendants()) do
           if v:IsA("Atmosphere") then v:Destroy() end
       end
   end,
})

VisualTab:CreateSlider({
   Name = "เพิ่มแสงสว่าง (Brightness)",
   Range = {0, 10},
   Increment = 0.5,
   Suffix = "Level",
   CurrentValue = 2,
   Callback = function(Value)
       game.Lighting.Brightness = Value
   end,
})
