-- [[ SOLO HUNTER: MINIMIZABLE HUB ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local OpenBtn = Instance.new("TextButton") -- ปุ่มกลมๆ สำหรับเปิด/ปิด
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SoloHunterMiniHub"

-- 1. สร้างปุ่มเปิด/ปิดขนาดเล็ก (ปุ่มพับ)
OpenBtn.Parent = ScreenGui
OpenBtn.Name = "ToggleMini"
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "MENU"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Draggable = true -- ลากปุ่มไปวางตรงไหนก็ได้ในจอ

-- 2. ตัวเมนูหลัก
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.Visible = false -- เริ่มต้นแบบซ่อนไว้
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "PRO HUNTER v3"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- ระบบสลับ เปิด/ปิด เมนู
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function CreateBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Text = text
    btn.Position = pos
    btn.Size = UDim2.new(0, 160, 0, 35)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [ฟังก์ชัน: AUTO FARM]
_G.Farm = false
local farmBtn = CreateBtn("FARM: OFF", UDim2.new(0, 20, 0, 45), Color3.fromRGB(60, 60, 60), function()
    _G.Farm = not _G.Farm
    MainFrame.TextButton.Text = _G.Farm and "FARM: ON" or "FARM: OFF"
    MainFrame.TextButton.BackgroundColor3 = _G.Farm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if _G.Farm then StartFarm() end
end)

-- [ฟังก์ชัน: ENTER DUNGEON] (วาร์ปไปทับหน้าประตู)
CreateBtn("GO DUNGEON", UDim2.new(0, 20, 0, 90), Color3.fromRGB(200, 50, 50), function()
    -- พิกัดหน้าประตู D (อ้างอิงจากรูป 994.jpg)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(450, 12, -320)
end)

-- [[ LOGIC: กันตีคน + ฟาร์ม ]]
function StartFarm()
    task.spawn(function()
        local lp = game.Players.LocalPlayer
        while _G.Farm do
            task.wait(0.1)
            pcall(function()
                local root = lp.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        -- ตรวจสอบอย่างละเอียดว่าไม่ใช่ผู้เล่น
                        if not game.Players:GetPlayerFromCharacter(v.Parent) and v.Parent.Name ~= lp.Name then
                            root.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end
