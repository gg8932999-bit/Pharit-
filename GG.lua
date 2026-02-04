local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SOLO HUNTER: PRO HUB ⚔️",
   LoadingTitle = "Ghost Style Interface",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = true, Folder = "SoloHunterConfigs" }
})

-- [[ VARIABLES ]]
_G.AutoFarm = false
_G.AutoSkill = false
_G.SelectedMonster = "Monster"

-- [[ TABS ]]
local MainTab = Window:CreateTab("Main Farm", 4483362458) -- ไอคอนบ้าน
local DungeonTab = Window:CreateTab("Dungeons", 4483362458) -- ไอคอนดาบ
local StatsTab = Window:CreateTab("Auto Stats", 4483362458) -- ไอคอนกราฟ

-- [[ 1. MAIN FARM TAB ]]
MainTab:CreateSection("Auto Farming Systems")

MainTab:CreateToggle({
   Name = "Auto Farm (Monster Only)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then StartSuperFarm() end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Use Skills (Z, X, C, V)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoSkill = Value
      if Value then StartAutoSkill() end
   end,
})

-- [[ 2. DUNGEON TAB ]]
DungeonTab:CreateSection("Fast Travel & Entry")

DungeonTab:CreateButton({
   Name = "Teleport to Dungeon (D)",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(450, 15, -320)
      Rayfield:Notify({Title = "Teleported", Content = "วาร์ปไปหน้าประตู D แล้ว", Duration = 3})
   end,
})

DungeonTab:CreateButton({
   Name = "Force Join Dungeon",
   Callback = function()
      local r = game:GetService("ReplicatedStorage"):FindFirstChild("StartDungeon") or 
                game:GetService("ReplicatedStorage"):FindFirstChild("EnterDungeon")
      if r then r:FireServer("Dungeon1", "Normal") end
   end,
})

-- [[ LOGIC: ฟาร์มแบบไม่ตี NPC/คน ]]
function StartSuperFarm()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local obj = v.Parent
                        -- คัดกรอง NPC และผู้เล่นออก 100%
                        if not game.Players:GetPlayerFromCharacter(obj) and not obj.Name:find("NPC") and obj.Name ~= lp.Name then
                            lp.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end

function StartAutoSkill()
    task.spawn(function()
        while _G.AutoSkill do
            task.wait(1)
            local keys = {"Z", "X", "C", "V"}
            for _, k in pairs(keys) do
                game:GetService("VirtualInputManager"):SendKeyEvent(true, k, false, game)
            end
        end
    end)
end

Rayfield:LoadConfiguration()
