local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Solo Hunters: God Mode ⚔️", "DarkScene")

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.AttackDistance = 10
_G.AutoSkill = false

-- [[ UI TABS ]]
local MainTab = Window:NewTab("Auto Farm")
local Section = MainTab:NewSection("Main Logic")

Section:NewToggle("Start Auto Farm", "บินไปเหนือหัวมอนและตีอัตโนมัติ", function(state)
    _G.AutoFarm = state
    if state then StartFarm() end
end)

Section:NewSlider("Height (ความสูง)", "ปรับระยะห่างจากมอน", 20, 5, function(s)
    _G.AttackDistance = s
end)

-- [[ FUNCTIONS ]]
local LP = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")

function StartFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                -- หาเป้าหมาย
                local target = nil
                local dist = math.huge
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        local m = (LP.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if m < dist then dist = m; target = v end
                    end
                end
                
                if target then
                    -- บินไปล็อคตำแหน่ง
                    LP.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.AttackDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    -- สั่งตี
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(0.05)
                    VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end
