-- โหลด Library (ใช้ลิงก์สำรองที่เสถียรกว่า)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- สร้างหน้าต่างหลัก
local Window = OrionLib:MakeWindow({
    Name = "MyHub v7 - Final Fix", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Loading MyHub..."
})

-- สร้างแท็บ
local Tab = Window:MakeTab({
    Name = "Main Farm",
    Icon = "rbxassetid://4483345998"
})

-- ปุ่มฟาร์มแบบรวม (ไม่ต้องเลือกชนิดแร่ เพื่อทดสอบว่าใช้งานได้ไหม)
Tab:AddToggle({
    Name = "Auto Farm All (ฟาร์มแร่ทั้งหมดที่เจอ)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        while getgenv().AutoFarm do
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().AutoFarm then break end
                -- ค้นหาวัตถุที่มี ProximityPrompt (จุดขุด)
                if v:IsA("ProximityPrompt") then
                    local target = v.Parent
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and target:IsA("BasePart") then
                        hrp.CFrame = target.CFrame
                        task.wait(0.2)
                        fireproximityprompt(v)
                    end
                end
            end
            task.wait(0.5)
        end
    end
})

-- ปุ่มวอล์คสปีด (เพื่อเช็คว่าสคริปต์ทำงานไหม)
Tab:AddSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 150, Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- สำคัญมาก: บรรทัดนี้ต้องอยู่ท้ายสุดเสมอเพื่อให้เมนูโชว์
OrionLib:Init()
