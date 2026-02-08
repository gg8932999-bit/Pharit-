-- [[ ABYSS ULTIMATE HUB - WARP & SELECT TARGET ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

-- // CONFIG // --
getgenv().Config = {
    Target = "Hammerhead", -- ค่าเริ่มต้น
    AutoWarp = false,
    SilentAim = true
}

-- // UI SETUP (แบบพับได้) // --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = true

local ToggleMenu = Instance.new("TextButton", ScreenGui)
ToggleMenu.Size = UDim2.new(0, 60, 0, 30)
ToggleMenu.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleMenu.Text = "เปิด/ปิดเมนู"
ToggleMenu.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

ToggleMenu.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- // FUNCTIONS // --
local function GetFish(name)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(v.Name:lower(), name:lower()) then
            local fishRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
            if fishRoot then return v, fishRoot end
        end
    end
    return nil
end

-- // WARP SYSTEM // --
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config.AutoWarp then
            local targetModel, targetPart = GetFish(getgenv().Config.Target)
            if targetPart then
                Root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 5) -- วาร์ปไปข้างหลังปลา 5 เมตร
            end
        end
    end
end)

-- // UI BUTTONS // --
local function CreateBtn(text, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- เลือกเป้าหมายตามภารกิจของคุณ
CreateBtn("เป้าหมาย: Hammerhead", 10, function() getgenv().Config.Target = "Hammerhead" end)
CreateBtn("เป้าหมาย: Blue Tang", 50, function() getgenv().Config.Target = "Blue Tang" end)
CreateBtn("เป้าหมาย: Red Fish", 90, function() getgenv().Config.Target = "Red Fish" end)

CreateBtn("วาร์ปไปหาปลา: OFF", 140, function(self) 
    getgenv().Config.AutoWarp = not getgenv().Config.AutoWarp
    MainFrame:GetChildren()[5].Text = getgenv().Config.AutoWarp and "วาร์ปไปหาปลา: ON" or "วาร์ปไปหาปลา: OFF"
end)

print("Abyss Warp Hub Loaded!")
