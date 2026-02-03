local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "MyHub v3 - The Forge", SaveConfig = true})

-- แท็บการต่อสู้และฟาร์ม
local CombatTab = Window:MakeTab({Name = "Combat & Farm", Icon = "rbxassetid://4483345998"})

-- 🛡️ ระบบอมตะ
CombatTab:AddToggle({
    Name = "God Mode (มอนสเตอร์ตีไม่เข้า)",
    Default = false,
    Callback = function(v)
        getgenv().GodMode = v
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanTouch = not v 
                end
            end
        end
    end
})

-- ⚔️ ระบบฆ่ามอนสเตอร์อัตโนมัติ
CombatTab:AddToggle({
    Name = "Auto Kill Monsters (ฆ่ามอนรอบตัว)",
    Default = false,
    Callback = function(v)
        getgenv().AutoKill = v
        while getgenv().AutoKill do
            for _, monster in pairs(workspace:GetChildren()) do
                if not getgenv().AutoKill then break end
                if monster:FindFirstChild("Humanoid") and monster.Humanoid.Health > 0 then
                    local playerHRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local monsterHRP = monster:FindFirstChild("HumanoidRootPart")
                    if playerHRP and monsterHRP then
                        local dist = (playerHRP.Position - monsterHRP.Position).magnitude
                        if dist < 25 then
                            monster.Humanoid.Health = 0 -- แก้ไขตามระบบโจมตีของเกม
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end
})

-- ⛏️ ระบบฟาร์มแร่เดิมของคุณ
CombatTab:AddToggle({
    Name = "Auto Farm Ores (ฟาร์มแร่)",
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
