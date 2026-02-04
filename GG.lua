-- สร้างเมนูแบบด่วน (ไม่ต้องพึ่ง Library นอก)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
MainFrame.Size = UDim2.new(0, 150, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Solo Hunter Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

FarmBtn.Parent = MainFrame
FarmBtn.Position = UDim2.new(0, 10, 0, 40)
FarmBtn.Size = UDim2.new(0, 130, 0, 40)
FarmBtn.Text = "START AUTO"
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

_G.Auto = false
FarmBtn.MouseButton1Click:Connect(function()
    _G.Auto = not _G.Auto
    FarmBtn.Text = _G.Auto and "STOP AUTO" or "START AUTO"
    FarmBtn.BackgroundColor3 = _G.Auto and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    
    if _G.Auto then
        task.spawn(function()
            while _G.Auto do
                task.wait(0.1)
                pcall(function()
                    local lp = game.Players.LocalPlayer
                    local char = lp.Character
                    -- หาเป้าหมายใน Workspace
                    for _, v in pairs(workspace:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end)
            end
        end)
    end
end)
