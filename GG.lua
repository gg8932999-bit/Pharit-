-- [[ SOLO HUNTER: TRUE AUTO FARM & DUNGEON ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -110)
MainFrame.Size = UDim2.new(0, 240, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PRO HUNTER HUB (FIXED)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(255, 80, 80) -- สีแดงเด่นชัด

local function CreateBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Text = text
    btn.Position = pos
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

_G.Farm = false

-- 1. ปุ่มฟาร์ม (เน้นตรวจสอบว่า "ไม่ใช่ผู้เล่น" อย่างเข้มงวด)
CreateBtn("AUTO FARM: OFF", UDim2.new(0, 20, 0, 45), function(self)
    _G.Farm = not _G.Farm
    MainFrame.TextButton.Text = _G.Farm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    MainFrame.TextButton.BackgroundColor3 = _G.Farm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    if _G.Farm then StartSafeFarm() end
end)

-- 2. ปุ่มวาร์ปเข้าดันเจี้ยน (ลองส่งสัญญาณทุกรูปแบบของเกม)
CreateBtn("FORCE ENTER DUNGEON", UDim2.new(0, 20, 0, 95), function()
    local lp = game.Players.LocalPlayer
    -- วิธีที่ 1: วาร์ปไปที่ตำแหน่งประตูโดยตรง (ให้เกมตรวจการชน)
    lp.Character.HumanoidRootPart.CFrame = CFrame.new(450.5, 12, -320.5) -- พิกัดหน้าประตู D
    
    -- วิธีที่ 2: ส่งสัญญาณผ่าน Remote Storage
    local r = game:GetService("ReplicatedStorage"):FindFirstChild("StartDungeon") or 
              game:GetService("ReplicatedStorage"):FindFirstChild("DungeonRemote")
    if r then r:FireServer("Dungeon1", "Normal") end
end)

-- 3. ปุ่มวาร์ปไปจุดเริ่มต้น (พลัง 40)
CreateBtn("TP TO START (LV.1)", UDim2.new(0, 20, 0, 145), function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
end)

-- [[ LOGIC แก้ไขใหม่ ]]
function StartSafeFarm()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.Farm do
            task.wait(0.1)
            pcall(function()
                local root = lp.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    -- เช็คว่าเป็นมอนสเตอร์ (มี Humanoid + ไม่ใช่คน)
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local isPlayer = game.Players:GetPlayerFromCharacter(v.Parent)
                        if not isPlayer and v.Parent.Name ~= "NPC" then -- มั่นใจว่าไม่ใช่ผู้เล่น
                            root.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end
