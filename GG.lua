-- [[ SOLO HUNTER: ULTIMATE TELEPORT FIX ]]
-- (ใช้ร่วมกับเมนู Rayfield เดิมของคุณได้เลย หรือจะแทนที่ทั้งหมดก็ได้ครับ)

-- [[ ส่วนแก้ไขการ Teleport ]]
local function TeleportToDungeon()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- ลองวาร์ปด้วย 3 พิกัดที่นิยมที่สุดใน Solo Hunters (ประตู D)
        local locations = {
            Vector3.new(450, 15, -320),  -- พิกัดหลัก
            Vector3.new(462, 12, -315),  -- พิกัดสำรอง 1
            Vector3.new(440, 20, -325)   -- พิกัดสำรอง 2
        }
        
        -- ใช้ Loop วาร์ปสั้นๆ เพื่อให้ระบบเกมยอมรับการชน (Collision)
        for _, pos in pairs(locations) do
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
            task.wait(0.1)
        end
        
        -- ส่งสัญญาณเข้าดันเจี้ยนโดยตรง (Remote)
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("StartDungeon") or 
                  game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("EnterDungeon")
        if r then
            r:FireServer("Dungeon1", "Normal")
        end
        
        Rayfield:Notify({Title = "Teleporting...", Content = "กำลังวาร์ปและพยายามเข้าดันเจี้ยน", Duration = 3})
    end
end

-- นำฟังก์ชันนี้ไปใส่ในปุ่ม DungeonTab เดิมของคุณ:
DungeonTab:CreateButton({
   Name = "FORCE ENTER DUNGEON (FIXED)",
   Callback = function()
      TeleportToDungeon()
   end,
})
