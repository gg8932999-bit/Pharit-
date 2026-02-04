local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Solo Hunters: Neon GOD ⚔️", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- [[ SETTINGS ]]
_G.AutoFarm = false
_G.Height = 10
_G.SelectedDungeon = "Dungeon 1"
_G.SelectedDifficulty = "Normal"

-- [[ TABS ]]
local MainTab = Window:MakeTab({Name = "Main Auto", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local DungeonTab = Window:MakeTab({Name = "Dungeons", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- [[ 1. MAIN FARM ]]
MainTab:AddToggle({
	Name = "Auto Farm (God Mode)",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
        if Value then StartSuperFarm() end
	end    
})

MainTab:AddSlider({
	Name = "Fly Height (ความสูง)",
	Min = 5,
	Max = 25,
	Default = 10,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Units",
	Callback = function(Value)
		_G.Height = Value
	end    
})

-- [[ 2. DUNGEON SELECTION ]]
DungeonTab:AddDropdown({
	Name = "Select Dungeon",
	Default = "Dungeon 1",
	Options = {"Dungeon 1", "Dungeon 2", "Dungeon 3", "Boss Raid"},
	Callback = function(Value)
		_G.SelectedDungeon = Value
	end    
})

DungeonTab:AddDropdown({
	Name = "Difficulty",
	Default = "Normal",
	Options = {"Easy", "Normal", "Hard", "Hell"},
	Callback = function(Value)
		_G.SelectedDifficulty = Value
	end    
})

DungeonTab:AddButton({
	Name = "Enter Dungeon Now!",
	Callback = function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StartDungeon") or 
                       game:GetService("ReplicatedStorage"):FindFirstChild("EnterDungeon")
        if remote then
            remote:FireServer(_G.SelectedDungeon, _G.SelectedDifficulty)
        end
  	end    
})

-- [[ CORE LOGIC ]]
function StartSuperFarm()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local lp = game.Players.LocalPlayer
                local root = lp.Character.HumanoidRootPart
                local target = nil
                local dist = math.huge
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
                        if v.Parent.Name ~= lp.Name then
                            local d = (root.Position - v.Parent.HumanoidRootPart.Position).Magnitude
                            if d < dist then dist = d; target = v.Parent.HumanoidRootPart end
                        end
                    end
                end

                if target then
                    root.CFrame = target.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end

OrionLib:Init()
