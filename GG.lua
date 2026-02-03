local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Test Hub", SaveConfig = false})

local Tab = Window:MakeTab({Name = "Farm", Icon = "rbxassetid://4483345998"})

Tab:AddButton({
	Name = "Check Script (กดเพื่อเช็คว่าทำงานไหม)",
	Callback = function()
      print("สคริปต์ทำงานปกติ!")
      OrionLib:MakeNotification({Name = "Success", Content = "เมนูทำงานแล้วครับ!", Time = 5})
  	end    
})

OrionLib:Init()
