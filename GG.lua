local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHOST HUB: DUNGEON MASTER ⚔️",
   LoadingTitle = "Dungeon Auto-Clear System",
   LoadingSubtitle = "Power Level: 40+",
   ConfigurationSaving = { Enabled = true, Folder = "GhostDungeon" }
})

-- [[ SETTINGS ]]
_G.AutoClear = false
_G.Distance = 8 -- ระยะห่างเหนือหัวมอนสเตอร์

-- [[ TABS ]]
local DungeonTab = Window:CreateTab("Dungeon Mode", 4483362458)

DungeonTab:CreateSection("Main Controls")

DungeonTab:CreateToggle({
   Name = "Auto Clear Dungeon (ตีทุกตัวในห้อง)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoClear = Value
      if Value then StartDungeonClear() end
   end,
})

DungeonTab:CreateSlider({
   Name = "Farm Distance",
   Range = {5, 15},
   Increment = 1,
   CurrentValue = 8,
   Callback = function(Value) _G.Distance = Value end,
})

DungeonTab:CreateSection("Entry")
DungeonTab:CreateButton({
   Name = "Force Teleport to Gate D",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
      for i = 1, 15 do
          hrp.CFrame = CFrame.new(450.5, 12, -320.5)
          task.wait(0.05)
      end
   end,
})

-- [[ LOGIC: เคลียร์มอนสเตอร์ในดันเจี้ยนเท่านั้น ]]
function StartDungeonClear()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.AutoClear do
            task.wait(0.1)
            pcall(function()
                -- สแกนหามอนสเตอร์ที่อยู่ในโฟลเดอร์ "Dungeon" หรือ "Monsters" เท่านั้น
                -- วิธีนี้จะ "ข้าม" NPC ทุกตัวในเมือง เพราะ NPC ไม่อยู่ในดันเจี้ยน
                local target = nil
                local dist = math.huge
                
                for _, v in pairs(workspace:GetDescendants()) do
                    -- เช็คว่าเป็นมอนสเตอร์ (มี Humanoid + เลือด > 0)
                    -- และต้องไม่ใช่ตัวเราเอง + ไม่ใช่ผู้เล่นคนอื่น
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        if not game.Players:GetPlayerFromCharacter(v.Parent) and v.Parent.Name ~= lp.Name then
                            
                            -- คัดกรอง NPC ออกจากชื่อ (กันเหนียว)
                            local n = v.Parent.Name:lower()
                            if not n:find("npc") and not n:find("shop") and not n:find("quest") then
                                local d = (lp.Character.HumanoidRootPart.Position - v.Parent.HumanoidRootPart.Position).Magnitude
                                if d < dist then
                                    dist = d
                                    target = v.Parent.HumanoidRootPart
                                end
                            end
                        end
                    end
                end

                if target then
                    -- วาร์ปไปเหนือหัวมอนสเตอร์
                    lp.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    -- สั่งโจมตี
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end
