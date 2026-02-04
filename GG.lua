-- [[ Solo Hunters: Ultimate Teleport & Farm ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -100)
MainFrame.Size = UDim2.new(0, 240, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SOLO HUNTER: TP & FARM"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 150) -- สีม่วง

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

-- 1. ปุ่มวาร์ปไปหน้าดันเจี้ยน (ประตู D)
CreateBtn("TP TO DUNGEON ENTRANCE", UDim2.new(0, 20, 0, 40), function()
    local lp = game.Players.LocalPlayer
    -- พิกัดหน้าประตู D (อ้างอิงจากตำแหน่งในรูปที่ 994)
    local dungeonPos = CFrame.new(450, 10, -320) -- พิกัดโดยประมาณของประตู D
    lp.Character.HumanoidRootPart.CFrame = dungeonPos
    print("Teleported to Dungeon Entrance")
end)

-- 2. ปุ่มวาร์ปไปจุดฟาร์มเริ่มต้น (พลัง 40)
CreateBtn("TP TO START FARM (Lv.1)", UDim2.new(0, 20, 0, 80), function()
    local lp = game.Players.LocalPlayer
    local startPos = CFrame.new(0, 10, 0) -- จุดเกิดหรือจุดมอนสเตอร์เลเวลน้อย
    lp.Character.HumanoidRootPart.CFrame = startPos
end)

-- 3. ปุ่มเปิด/ปิดฟาร์มอัตโนมัติ
_G.Farm = false
CreateBtn("AUTO FARM: OFF", UDim2.new(0, 20, 0, 125), function()
    _G.Farm = not _G.Farm
    for _, v in pairs(MainFrame:GetChildren()) do
        if v.Text:find("FARM") then
            v.Text = _G.Farm and "AUTO FARM: ON" or "AUTO FARM: OFF"
            v.BackgroundColor3 = _G.Farm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        end
    end
    if _G.Farm then StartFarm() end
end)

-- [[ LOGIC ฟาร์มเหมือนเดิม ]]
function StartFarm()
    task.spawn(function()
        while _G.Farm do
            task.wait(0.1)
            pcall(function()
                local lp = game.Players.LocalPlayer
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        if not game.Players:GetPlayerFromCharacter(v.Parent) then
                            lp.Character.HumanoidRootPart.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end
