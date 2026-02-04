-- สร้างหน้าต่างเมนูแบบ Manual เพื่อลดปัญหาโหลดไม่ขึ้น
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true -- สามารถลากหน้าต่างไปมาได้

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Solo Hunter Hub (Fixed)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

FarmBtn.Parent = MainFrame
FarmBtn.Position = UDim2.new(0, 20, 0, 50)
FarmBtn.Size = UDim2.new(0, 160, 0, 50)
FarmBtn.Text = "START AUTO"
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
FarmBtn.TextColor3 = Color3.new(1, 1, 1)

_G.Auto = false
FarmBtn.MouseButton1Click:Connect(function()
    _G.Auto = not _G.Auto
    FarmBtn.Text = _G.Auto and "STOP AUTO" or "START AUTO"
    FarmBtn.BackgroundColor3 = _G.Auto and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(0, 180, 0)

    if _G.Auto then
        task.spawn(function()
            while _G.Auto do
                task.wait(0.1)
                pcall(function()
                    local lp = game.Players.LocalPlayer
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
                            if v.Parent.Name ~= lp.Name then
                                lp.Character.HumanoidRootPart.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                            end
                        end
                    end
                end)
            end
        end)
    end
end)
