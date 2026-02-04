-- [[ SOLO HUNTER: ANTI-NPC & MINIMIZABLE HUB ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local OpenBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SoloHunterProHub"

-- 1. ปุ่มพับเมนู (วงกลมเล็กๆ ลากได้)
OpenBtn.Parent = ScreenGui
OpenBtn.Name = "ToggleMini"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150) -- สีเขียวสว่าง
OpenBtn.Text = "HUNT"
OpenBtn.TextColor3 = Color3.new(0, 0, 0)
OpenBtn.Draggable = true
local Corner = Instance.new("UICorner", OpenBtn)
Corner.CornerRadius = ToolBuffer.new(0, 25)

-- 2. ตัวเมนูหลัก
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -80)
MainFrame.Size = UDim2.new(0, 200, 0, 170)
MainFrame.Visible = false 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TRUE HUNTER v4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function CreateBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Text = text
    btn.Position = pos
    btn.Size = UDim2.new(0, 170, 0, 35)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn)
    return btn
end

-- [ระบบฟาร์ม]
_G.Farm = false
CreateBtn("AUTO FARM: OFF", UDim2.new(0, 15, 0, 45), Color3.fromRGB(50, 50, 50), function(self)
    _G.Farm = not _G.Farm
    MainFrame.TextButton.Text = _G.Farm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    MainFrame.TextButton.BackgroundColor3 = _G.Farm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    if _G.Farm then StartUltimateFarm() end
end)

-- [ระบบวาร์ปหน้าดันเจี้ยน]
CreateBtn("TP TO DUNGEON", UDim2.new(0, 15, 0, 90), Color3.fromRGB(150, 0, 0), function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(450, 15, -320)
end)

-- [ปุ่มปิดสคริปต์]
CreateBtn("CLOSE SCRIPT", UDim2.new(0, 15, 0, 135), Color3.fromRGB(80, 80, 80), function()
    ScreenGui:Destroy()
end)

-- [[ LOGIC: กรอง NPC + ผู้เล่น แบบ 100% ]]
function StartUltimateFarm()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.Farm do
            task.wait(0.1)
            pcall(function()
                local root = lp.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local obj = v.Parent
                        local isPlayer = game.Players:GetPlayerFromCharacter(obj)
                        
                        -- เงื่อนไขคัดกรอง:
                        -- 1. ไม่ใช่ตัวเราเอง
                        -- 2. ไม่ใช่ผู้เล่นคนอื่น
                        -- 3. ชื่อต้องไม่มีคำว่า "NPC", "Shop", "Quest", "Trainer"
                        local name = obj.Name:lower()
                        local isNPC = name:find("npc") or name:find("shop") or name:find("quest") or name:find("trainer")
                        
                        if not isPlayer and not isNPC and obj.Name ~= lp.Name then
                            root.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end
