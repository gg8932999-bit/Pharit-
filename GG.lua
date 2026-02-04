-- [[ Solo Hunters: God Mode V2 ]]
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then 
    warn("Library Load Failed, Re-trying...")
    Library = loadstring(game:HttpGet("https://pastebin.com/raw/vpf6v9S0"))() -- ลิงก์สำรอง
end

local Window = Library.CreateLib("Solo Hunters: God Mode ⚔️", "DarkScene")

-- [[ SETTINGS ]]
_G.Settings = {
    AutoFarm = false,
    AttackDistance = 10,
    TweenSpeed = 60,
    AutoSkill = false
}

-- [[ TABS ]]
local MainTab = Window:NewTab("Main Farm")
local ConfigTab = Window:NewTab("Settings")

local FarmSection = MainTab:NewSection("Automation")

FarmSection:NewToggle("Auto Farm (God Mode)", "บินไปเหนือหัวมอนและตีอัตโนมัติ", function(state)
    _G.Settings.AutoFarm = state
    if state then
        task.spawn(function()
            while _G.Settings.AutoFarm do
                task.wait(0.1)
                pcall(function()
                    local target = nil
                    local dist = math.huge
                    local folder = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies") or workspace
                    for _, v in pairs(folder:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if mag < dist then dist = mag; target = v end
                        end
                    end
                    
                    if target then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.AttackDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        task.wait(0.05)
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end
                end)
            end
        end)
    end
end)

local ConfigSection = ConfigTab:NewSection("Adjustment")
ConfigSection:NewSlider("Attack Distance", "ความสูง", 20, 5, function(s)
    _G.Settings.AttackDistance = s
end)
