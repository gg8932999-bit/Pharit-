-- [[ Solo Hunters: ULTIMATE GOD HUB ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabHolder = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SOLO HUNTER: ULTIMATE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- [[ ฟังก์ชันสร้างปุ่มแบบง่าย ]]
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Name = name
    btn.Text = name
    btn.Position = pos
    btn.Size = UDim2.new(0, 210, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.AutoStats = false

-- [[ BUTTONS ]]
local farmBtn = CreateButton("AUTO FARM: OFF", UDim2.new(0, 20, 0, 50), function()
    _G.AutoFarm = not _G.AutoFarm
    game.CoreGui.ScreenGui.Frame["AUTO FARM: OFF"].Text = _G.AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    game.CoreGui.ScreenGui.Frame["AUTO FARM: OFF"].BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if _G.AutoFarm then StartFarm() end
end)

CreateButton("ENTER DUNGEON (AUTO)", UDim2.new(0, 20, 0, 95), function()
    local r = game:GetService("ReplicatedStorage"):FindFirstChild("EnterDungeon") or game:GetService("ReplicatedStorage"):FindFirstChild("StartGame")
    if r then r:FireServer("Dungeon1", "Normal") end
end)

CreateButton("AUTO STATS: ON/OFF", UDim2.new(0, 20, 0, 140), function()
    _G.AutoStats = not _G.AutoStats
    print("Auto Stats: "..tostring(_G.AutoStats))
end)

-- [[ CORE LOGIC ]]
function StartFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local lp = game.Players.LocalPlayer
                local root = lp.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        if v.Parent.Name ~= lp.Name then
                            -- บินล็อคเป้าและตี
                            root.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end)
end
