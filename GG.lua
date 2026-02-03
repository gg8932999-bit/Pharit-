local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("MyHub v10 - ระบบภาษาไทย", "BloodTheme")

-- ตั้งค่าตัวแปร
getgenv().SelectedOres = {}
getgenv().SelectedMobs = {}

local Tab1 = Window:NewTab("ฟาร์มแร่ & หิน")
local MineSection = Tab1:NewSection("ตั้งค่าการขุด")

MineSection:NewDropdown("เลือกชนิดหิน/แร่", "เลือกหินที่ต้องการฟาร์ม", {"Stone", "Iron Ore", "Gold Ore", "Diamond Ore", "Coal"}, function(Value)
    if not table.find(getgenv().SelectedOres, Value) then
        table.insert(getgenv().SelectedOres, Value)
    else
        for i, v in pairs(getgenv().SelectedOres) do
            if v == Value then table.remove(getgenv().SelectedOres, i) end
        end
    end
end)

MineSection:NewToggle("เริ่มขุดแร่ที่เลือก", "วาร์ปไปขุดเฉพาะแร่ที่เลือก", function(state)
    getgenv().AutoMine = state
    while getgenv().AutoMine do
        for _, v in pairs(workspace:GetDescendants()) do
            if not getgenv().AutoMine then break end
            local isTarget = false
            for _, name in pairs(getgenv().SelectedOres) do
                if v.Name:find(name) then isTarget = true break end
            end
            if isTarget and v:IsA("ProximityPrompt") then
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

local Tab2 = Window:NewTab("ฟาร์มมอนสเตอร์")
local MobSection = Tab2:NewSection("ตั้งค่าการตีมอน")

MobSection:NewDropdown("เลือกประเภทมอนสเตอร์", "เลือกมอนที่ต้องการตี", {"Slime", "Goblin", "Skeleton", "Wolf"}, function(Value)
    if not table.find(getgenv().SelectedMobs, Value) then
        table.insert(getgenv().SelectedMobs, Value)
    else
        for i, v in pairs(getgenv().SelectedMobs) do
            if v == Value then table.remove(getgenv().SelectedMobs, i) end
        end
    end
end)

MobSection:NewToggle("เริ่มตีมอนสเตอร์", "วาร์ปไปตีมอนสเตอร์ที่เลือก", function(state)
    getgenv().AutoKill = state
    while getgenv().AutoKill do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do -- แก้ตรง workspace.Enemies ให้ตรงกับที่เก็บมอนในเกม
            if not getgenv().AutoKill then break end
            if table.find(getgenv().SelectedMobs, mob.Name) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    -- ใส่คำสั่งตีตรงนี้ (เช่น รีโมทโจมตี)
                end
            end
        end
        task.wait(0.1)
    end
end)

local Tab3 = Window:NewTab("ตั้งค่าตัวละคร")
local PlayerSection = Tab3:NewSection("ตัวช่วยเอาตัวรอด")

PlayerSection:NewToggle("เปิดโหมดอมตะ", "มอนสเตอร์ตีไม่เข้า", function(state)
    getgenv().GodMode = state
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanTouch = not state
            end
        end
    end
end)

PlayerSection:NewToggle("ซื้อโพชั่นอัตโนมัติ", "ซื้อยาเพิ่มเลือดเมื่อเงินพอ", function(state)
    getgenv().AutoBuy = state
    while getgenv().AutoBuy do
        -- ใส่คำสั่งซื้อยาของเกมคุณตรงนี้
        task.wait(5)
    end
end)

local Tab4 = Window:NewTab("เครดิต")
Tab4:NewSection("สคริปต์โดย MyHub")
