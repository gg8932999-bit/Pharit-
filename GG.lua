local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHOST HUB: SOLO HUNTERS ⚔️",
   LoadingTitle = "Ultimate Quest & Farm",
   LoadingSubtitle = "Power Level: 40",
   ConfigurationSaving = { Enabled = true, Folder = "GhostHub_V5" }
})

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.AutoQuest = false
_G.SelectMonster = "None"
_G.Distance = 10

-- [[ BLACKLIST & MONSTER SCANNER ]]
local Blacklist = {"npc", "shop", "quest", "trainer", "stat", "dummy", "bank", "gate"}
local MonsterList = {}
for _, v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(v) then
        local nameLower = v.Name:lower()
        local isBlacklisted = false
        for _, word in pairs(Blacklist) do if nameLower:find(word) then isBlacklisted = true end end
        if not isBlacklisted and v.Humanoid.Health > 0 then
            if not table.find(MonsterList, v.Name) then table.insert(MonsterList, v.Name) end
        end
    end
end

-- [[ TABS ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local QuestTab = Window:CreateTab("Quests", 4483362458)
local DungeonTab = Window:CreateTab("Dungeons", 4483362458)

-- [[ 1. MAIN FARM TAB ]]
MainTab:CreateDropdown({
   Name = "Select Monster",
   Options = MonsterList,
   CurrentOption = "None",
   Callback = function(Option) _G.SelectMonster = Option[1] end,
})

MainTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then StartFarm() end
   end,
})

-- [[ 2. QUEST TAB (เพิ่มใหม่) ]]
QuestTab:CreateSection("Auto Questing System")

QuestTab:CreateToggle({
   Name = "Auto Accept/Complete Quest",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoQuest = Value
      if Value then StartQuestLogic() end
   end,
})

QuestTab:CreateParagraph({Title = "คำแนะนำ", Content = "ระบบจะพยายามรับเควสที่ตรงกับมอนสเตอร์ที่คุณเลือกในหน้า Auto Farm ให้อัตโนมัติ"})

-- [[ 3. DUNGEON TAB ]]
DungeonTab:CreateButton({
   Name = "TP to Dungeon Entrance (Wait 1s)",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
      for i = 1, 20 do -- เพิ่มเป็น 20 รอบเพื่อกันเด้ง
          hrp.CFrame = CFrame.new(450.5, 12, -320.5)
          task.wait(0.05)
      end
   end,
})

-- [[ LOGIC CORE ]]

-- ฟังก์ชันจัดการเควส
function StartQuestLogic()
    task.spawn(function()
        while _G.AutoQuest do
            task.wait(2)
            pcall(function()
                -- ค้นหา Remote สำหรับรับเควส (ชื่อมักจะวนเวียนอยู่กับ Quest/Accept)
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AcceptQuest") or 
                              game:GetService("ReplicatedStorage"):FindFirstChild("GetQuest") or
                              game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
                
                if remote and _G.SelectMonster ~= "None" then
                    -- พยายามรับเควสตามชื่อมอนสเตอร์ที่เลือกไว้
                    remote:FireServer(_G.SelectMonster)
                end
            end)
        end
    end)
end

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

Rayfield:LoadConfiguration()
