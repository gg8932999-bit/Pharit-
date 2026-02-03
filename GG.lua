local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "MyHub v1 - The Forge", SaveConfig = true})

local Tab = Window:MakeTab({Name = "ฟาร์มหลัก", Icon = "rbxassetid://4483345998"})

Tab:AddToggle({
    Name = "เปิดวิ่งไว (Speed 60)",
    Default = false,
    Callback = function(v)
        getgenv().SpeedEnabled = v
        spawn(function()
            while getgenv().SpeedEnabled do
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = 60
                end
                task.wait(0.5)
            end
            if game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end
})

Tab:AddToggle({
    Name = "ฟาร์มแร่อัตโนมัติ",
    Default = false,
    Callback = function(v)
        getgenv().AutoFarm = v
        while getgenv().AutoFarm do
            for _, ore in pairs(workspace:GetChildren()) do
                if not getgenv().AutoFarm then break end
                if ore.Name:find("Ore") and ore:FindFirstChild("ProximityPrompt") then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = ore.CFrame
                        task.wait(0.2)
                        fireproximityprompt(ore.ProximityPrompt)
                    end
                end
            end
            task.wait(0.1)
        end
    end
})

OrionLib:Init()
