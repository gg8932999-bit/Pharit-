local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v25 - The Forge [Wiki Data]",
   LoadingTitle = "กำลังดึงข้อมูลแร่จาก IGN Wiki...",
   ConfigurationSaving = { Enabled = false }
})

-- [[ รายชื่อแร่ทั้งหมดจาก IGN Wiki ]]
local AllOres = {
    "Stone", "Coal", "Copper Ore", "Tin Ore", "Iron Ore", 
    "Lead Ore", "Silver Ore", "Gold Ore", "Cobalt Ore", 
    "Mithril Ore", "Adamantite Ore", "Titanium Ore", 
    "Uranium Ore", "Obsidian", "Mythical Ore",
    "Diamond", "Emerald", "Ruby", "Sapphire", "Amethyst"
}

-- [[ รายชื่อมอนสเตอร์จาก Beebom ]]
local AllMobs = {
    "Zombie (HP 52)", "Delver Zombie (HP 175)", "Brute Zombie (HP 370)",
    "Skeleton Rogue (HP 195)", "Axe Skeleton (HP 215)", "Slime (HP 870)",
    "Crystal Spider (HP 720)", "Common Orc (HP 1000)", "Crystal Golem (HP 4000)",
    "Yeti (HP 14000)"
}

-- [[ แท็บฟาร์มแร่ ]]
local MineTab = Window:CreateTab("ระบบขุดแร่", 4483345998)

MineTab:CreateDropdown({
   Name = "เลือกชนิดแร่ (IGN List)",
   Options = AllOres,
   CurrentOption = {"Stone"},
   Callback = function(Option) getgenv().TargetOre = Option[1] end,
})

MineTab:CreateToggle({
   Name = "เริ่มขุดอัตโนมัติ (Auto Mine)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoMine = Value
       task.spawn(function()
           while getgenv().AutoMine do
               local found = false
               for _, v in pairs(workspace:GetDescendants()) do
                   if v.Name == getgenv().TargetOre and v:FindFirstChildOfClass("ProximityPrompt") then
                       local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                       hrp.CFrame = v:GetPivot() * CFrame.new(0, 0, 3)
                       task.wait(0.3)
                       fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                       while v.Parent and getgenv().AutoMine do task.wait(0.5) end
                       found = true break
                   end
               end
               if not found then task.wait(1) end
           end
       end)
   end,
})

-- [[ แท็บล่ามอนสเตอร์ ]]
local MobTab = Window:CreateTab("ล่ามอนสเตอร์", 4483345998)

MobTab:CreateDropdown({
   Name = "เลือกศัตรู (Beebom List)",
   Options = AllMobs,
   Callback = function(v) getgenv().TargetMob = string.split(v[1], " (")[1] end,
})

MobTab:CreateToggle({
   Name = "เริ่มล่าอัตโนมัติ (Auto Mob)",
   CurrentValue = false,
   Callback = function(v) getgenv().AutoMob = v end
})

-- [[ แท็บตั้งค่าตัวละคร ]]
local SettingsTab = Window:CreateTab("ตั้งค่า & แสง", 4483345998)

SettingsTab:CreateSlider({
   Name = "ความเร็วเดิน/วิ่ง",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

SettingsTab:CreateButton({
   Name = "เปิดไฟสว่าง (ตัดหมอก)",
   Callback = function()
       game.Lighting.Brightness = 2
       game.Lighting.FogEnd = 100000
   end
})
