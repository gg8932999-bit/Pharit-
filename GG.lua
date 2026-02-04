local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHOST HUB: SOLO HUNTERS ⚔️",
   LoadingTitle = "Ghost Hub Executive",
   LoadingSubtitle = "by Gemini AI Replica",
   ConfigurationSaving = { Enabled = true, Folder = "GhostHub_Solo" },
   KeySystem = false -- ปิดระบบคีย์เพื่อให้ใช้งานได้ทันที
})

-- [[ VARIABLES ]]
_G.AutoFarm = false
_G.AutoSkill = false
_G.AutoStats = false
_G.SelectMonster = "None"
_G.Distance = 10 -- ระยะความสูงเหนือหัวมอนสเตอร์

local MonsterList = {}
for _, v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(v) then
        if not v.Name:find("NPC") and not table.find(MonsterList, v.Name) then
            table.insert(MonsterList, v.Name)
        end
    end
end

-- [[ TABS เหมือนต้นฉบับ ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local StatsTab = Window:CreateTab("Auto Stats", 4483362458)
local DungeonTab = Window:CreateTab("Dungeons", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- [[ 1. AUTO FARM TAB ]]
MainTab:CreateSection("Farming Settings")

MainTab:CreateDropdown({
   Name = "Select Monster (ล็อคชื่อมอนสเตอร์)",
   Options = MonsterList,
   CurrentOption = "None",
   Callback = function(Option)
      _G.SelectMonster = Option[1]
   end,
})

MainTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then StartFarm() end
   end,
})

MainTab:CreateSlider({
   Name = "Farm Distance (ปรับระยะความสูง)",
   Range = {0, 20},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Callback = function(Value)
      _G.Distance = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Skill (Z, X, C, V)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoSkill = Value
      if Value then StartSkills() end
   end,
})

-- [[ 2. AUTO STATS TAB ]]
StatsTab:CreateSection("Automatic Leveling")
StatsTab:CreateToggle({
   Name = "Auto Strength",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoStats = Value
      task.spawn(function()
          while _G.AutoStats do
              task.wait(1)
              local r = game:GetService("ReplicatedStorage"):FindFirstChild("AddStat")
              if r then r:FireServer("Strength", 1) end
          end
      end)
   end,
})

-- [[ 3. DUNGEON TAB - ระบบแก้ทางวาร์ป ]]
DungeonTab:CreateSection("Dungeon Utilities")
DungeonTab:CreateButton({
   Name = "Teleport to Dungeon Gate (D)",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
      -- ใช้ Tween หรือวาร์ปย้ำๆ เพื่อกันเด้ง
      for i = 1, 10 do
          hrp.CFrame = CFrame.new(450.5, 12, -320.5)
          task.wait(0.05)
      end
   end,
})

-- [[ LOGIC CORE ]]
function StartFarm()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == _G.SelectMonster and v.Humanoid.Health > 0 then
                        lp.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end
                end
            end)
        end
    end)
end

function StartSkills()
    task.spawn(function()
        while _G.AutoSkill do
            task.wait(1)
            local vim = game:GetService("VirtualInputManager")
            for _, k in pairs({"Z", "X", "C", "V"}) do
                vim:SendKeyEvent(true, k, false, game)
            end
        end
    end)
end

Rayfield:Notify({Title = "Ghost Hub Ready", Content = "เริ่มปั้นพลังจาก 40 กันเลย!", Duration = 5})
