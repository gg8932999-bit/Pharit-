local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("MyHub v8 - Stable", "BloodTheme")

local Tab = Window:NewTab("Auto Farm")
local Section = Tab:NewSection("Farm Settings")

Section:NewToggle("Auto Farm Ores", "Teleport and mine ores", function(state)
    getgenv().AutoFarm = state
    while getgenv().AutoFarm do
        for _, v in pairs(workspace:GetDescendants()) do
            if not getgenv().AutoFarm then break end
            if v:IsA("ProximityPrompt") then
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and v.Parent:IsA("BasePart") then
                    hrp.CFrame = v.Parent.CFrame
                    task.wait(0.2)
                    fireproximityprompt(v)
                end
            end
        end
        task.wait(0.5)
    end
end)
