local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MyHub v20 - The Forge [Airlines Mode]",
   LoadingTitle = "กำลังเริ่มระบบฟาร์มภาษาไทย...",
   ConfigurationSaving = { Enabled = false }
})

getgenv().SelectedOres = {}
local TweenService = game:GetService("TweenService")

local Tab = Window:CreateTab("ฟาร์มแร่", 4483345998)

Tab:CreateDropdown({
   Name = "เลือกแร่ (เลือกหลายอย่างได้)",
   Options = {"Stone", "Coal", "Copper Ore", "Tin Ore", "Iron Ore", "Silver Ore", "Gold Ore", "Lead Ore", "Cobalt Ore", "Mithril Ore", "Adamantite Ore"},
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       getgenv().SelectedOres = Options
   end,
})

Tab:CreateToggle({
   Name = "เปิดระบบฟาร์มอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoFarm = Value
       task.spawn(function()
           while getgenv().AutoFarm do
               local target = nil
               -- ค้นหาแร่ที่ใกล้ที่สุดและตรงกับที่เลือก
               for _, v in pairs(workspace:GetDescendants()) do
                   if not getgenv().AutoFarm then break end
                   local isSelected = false
                   for _, name in pairs(getgenv().SelectedOres) do
                       if v.Name == name then isSelected = true break end
                   end
                   
                   if isSelected and v:FindFirstChildOfClass("ProximityPrompt") then
                       target = v
                       break -- เจอแล้วหยุดหา
                   end
               end

               if target then
                   local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                   local prompt = target:FindFirstChildOfClass("ProximityPrompt")
                   
                   if hrp and prompt then
                       -- ใช้การ Tween เพื่อเลื่อนไปหาแร่ (กันตัวค้าง/กันแบน)
                       local tween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = target.CFrame * CFrame.new(0, 0, 3)})
                       tween:Play()
                       tween.Completed:Wait()
                       
                       -- วนลูปกดขุดจนกว่าแร่จะหายไป
                       repeat
                           task.wait(0.1)
                           fireproximityprompt(prompt)
                       until not target.Parent or not getgenv().AutoFarm
                   end
               end
               task.wait(1)
           end
       end)
   end,
})

local SettingTab = Window:CreateTab("ตัวละคร", 4483345998)
SettingTab:CreateSlider({
   Name = "ปรับความเร็วเดิน",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})
