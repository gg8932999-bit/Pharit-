local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Solo Hunters: God Mode ⚔️", "DarkScene")

-- [[ SETTINGS INITIALIZE ]]
_G.Settings = {
    AutoFarm = false,
    AttackDistance = 10,
    TweenSpeed = 60,
    AutoSkill = false
}

-- [[ TABS ]]
local MainTab = Window:NewTab("Main Farm")
local ConfigTab = Window:NewTab("Settings")
local CreditsTab = Window:NewTab("Credits")

-- [[ MAIN FARM SECTION ]]
local FarmSection = MainTab:NewSection("Automation")

FarmSection:NewToggle("Auto Farm (God Mode)", "บินไปเหนือหัวมอนสเตอร์และตีอัตโนมัติ", function(state)
    _G.Settings.AutoFarm = state
    if state then
        print("Auto Farm Enabled")
        StartAutoFarm()
    end
end)

FarmSection:NewToggle("Auto Use Skills", "กดสกิลอัตโนมัติ (Q, E, R)", function(state)
    _G.Settings.AutoSkill = state
end)

-- [[ CONFIG SECTION ]]
local ConfigSection = ConfigTab:NewSection("Adjustment")

ConfigSection:NewSlider("Attack Distance", "ปรับความสูงเหนือหัวมอนสเตอร์", 20, 5, function(s)
    _G.Settings.AttackDistance = s
end)

ConfigSection:NewSlider("Tween Speed", "ความเร็วในการบินหาศัตรู", 100, 30, function(s)
    _G.Settings.TweenSpeed = s
end)

-- [[ CREDITS ]]
CreditsTab:NewSection("Created by Gemini AI")
CreditsTab:NewButton("Copy Discord", "Copy link to clipboard", function()
    setclipboard("https://discord.gg/example")
end)

-- [[ CORE FUNCTIONS ]]
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local TS = game:GetService("TweenService")
local VU = game:GetService("VirtualUser")

-- Anti-AFK
for i,v in pairs(getconnections(LP.Idled)) do v:Disable() end

function GetTarget()
    local target = nil
    local dist = math.huge
    local folder = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local mag = (LP.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    return target
end

function StartAutoFarm()
    task.spawn(function()
        while _G.Settings.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local mob = GetTarget()
                if mob then
                    -- Movement
                    local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.AttackDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    TS:Create(LP.Character.HumanoidRootPart, TweenInfo.new(0.1), {CFrame = targetPos}):Play()
                    
                    -- Attack (คลิกหน้าจออัตโนมัติ)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(0.05)
                    VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end
