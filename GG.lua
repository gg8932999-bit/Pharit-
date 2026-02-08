--[[
    CUSTOM ABYSS SCRIPT - BY [YOUR NAME/GITHUB]
    VERSION: 1.0
--]]

local Library = {} -- สร้าง Library สำหรับ GUI แบบง่าย
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)

-- // UI SETUP // --
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากเมนูไปมาได้

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CUSTOM ABYSS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- // CONFIGURATION // --
_G.SilentAim = true
_G.Prediction = 0.125
_G.FOV = 150
_G.TriggerBot = false

-- // FUNCTIONS // --
local function GetClosestPlayer()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
                if magnitude < dist then
                    target = v
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- // SILENT AIM LOGIC // --
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if _G.SilentAim and method == "FindPartOnRayWithIgnoreList" then
        local target = GetClosestPlayer()
        if target then
            args[1] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * _G.Prediction) - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- // SIMPLE UI BUTTONS // --
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    
    btn.MouseButton1Click:Connect(callback)
end

-- สร้างปุ่มควบคุม
CreateButton("Toggle Silent Aim: ON", 60, function()
    _G.SilentAim = not _G.SilentAim
    print("Silent Aim: " .. tostring(_G.SilentAim))
end)

CreateButton("Toggle TriggerBot: OFF", 110, function()
    _G.TriggerBot = not _G.TriggerBot
    print("TriggerBot: " .. tostring(_G.TriggerBot))
end)

CreateButton("Reset Config", 160, function()
    _G.Prediction = 0.125
    _G.FOV = 150
end)

print("Script Loaded Successfully!")
