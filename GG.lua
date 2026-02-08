--[[
    Aurora Configuration for Abyss
    Saved on my GitHub
--]]

local aurora = { config = {
    ["Conditions"] = {
        ['Visible'] = true,
        ['Knocked'] = false, -- ปิดไว้เพื่อไม่ให้ล็อคเป้าคนที่ล้มแล้ว
        ['SelfKnocked'] = false,
        ['Grabbed'] = true,
        ['Forcefield'] = false,
    },

    ["Macro"] = {
        ['Enabled'] = true,
        ['Keybind'] = {
            ['Key'] = 'X', -- ปุ่มสำหรับทำ Speed Glitch
            ['Mode'] = 'Hold',
        }
    },
        
    ["SilentAim"] = {
        ['Enabled'] = true, -- เปิดใช้งาน Silent Aim
        ['DualBind'] = false,
        ['Toggle'] = 'C', -- ปุ่มเปิด/ปิด
        ['Untoggle'] = 'X',
        ['FovType'] = '2DBox',
        ['Mode'] = 'Auto', 
        ['Point'] = 'Nearest Point',
        ['Type'] = 'Advanced',
        ['Scale'] = 0.5,
        ['FOV'] = {
            ['Visible'] = true, -- แสดงวงกลม FOV
            ['FOV'] = {
                ['Weapon Configuration'] = {
                    ['Shotguns'] = { ['WidthLeftSide'] = 0.6, ['WidthRightSide'] = 0.6, ['HeightUpper'] = 1.1, ['HeightLower'] = 1.1 },
                    ['Rifles'] = { ['WidthLeftSide'] = 0.5, ['WidthRightSide'] = 0.5, ['HeightUpper'] = 1.0, ['HeightLower'] = 1.0 },
                    ['Pistols'] = { ['WidthLeftSide'] = 0.5, ['WidthRightSide'] = 0.5, ['HeightUpper'] = 1.0, ['HeightLower'] = 1.0 },
                },
            },
        },
        ['Prediction'] = { 
            ['Enabled'] = true, 
            ['Ground'] = 0.125, -- ปรับตาม Ping (0.12 - 0.15)
            ['Air'] = 0.125, 
            ['Stabilize'] = 5,
        }, 
    },

    ["TriggerBot"] = {
        ['Enabled'] = true,
        ['HitboxRadius'] = 1,
        ['Toggle'] = 'E', -- ปุ่มกดยิงอัตโนมัติ
        ['Input'] = 'Keyboard',
        ['DetectionMode'] = '2DBox',
        ['Type'] = 'Hold',
        ['Delay'] = { 
            ['Enabled'] = true,
            ['Weapon'] = { 
                ['[Double-Barrel SG]'] = 0.05, 
                ['[TacticalShotgun]'] = 0.05, 
                ['[Revolver]'] = 0.05,
                ['[AK47]'] = 0.07,
                ['[AR]'] = 0.07
            } 
        },
    },

    ["Enhancements"] = { 
        ['Spread Modifier'] = { 
            ['Enabled'] = true, 
            ['Weapon'] = { 
                ['[Double-Barrel SG]'] = 0.25,
                ['[Shotgun]'] = 0.25 
            },
            ['Randomizer'] = { 
                ['Enabled'] = true, 
                ['Value'] = math.random(0.15, 0.45) 
            } 
        },
    }, 

    ['Speed Modifiers'] = {
        ['Enabled'] = false, -- แนะนำให้ปิดไว้เพื่อความปลอดภัย
        ['Multiplier Mode'] = 'Multiply',
		['Normal'] = { ['Multiplier'] = 1.5 },
    },
} }

-- ส่งค่า Config ไปยังตัวสคริปต์หลัก
_G.aurora = aurora
getgenv().aurora = aurora

-- บรรทัดโหลด Loader หลักของ Aurora
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nflar/abyss/refs/heads/main/roblox.lua"))()
