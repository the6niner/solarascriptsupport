--antiafk
task.spawn(function()
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
end)
-- i x 300 = money
local i = 50
-- find car
local name = game.Players.LocalPlayer
for _, v in pairs (game:GetService("Workspace").Vehicles:GetDescendants()) do
    if v:IsA("StringValue") and v.Value == tostring(name) and v.Name == 'Owner' then
        print(v.Parent)
    car = v.Parent
    end
end
car:SetPrimaryPartCFrame(CFrame.new(7732, 89, -9410, 0, 10, 0, 1.7))
-- function
local function dollas()
car.Weight.Anchored = false
car:SetPrimaryPartCFrame(CFrame.new(7732, 89, -9410, 0, 10, 0, 1))
car.Weight.Velocity = Vector3.new(0,0,600)
wait(4)
end
-- loop
while i > 0 and car.Weight.Anchored == false do
dollas()
i = i - 1
print(i)
end
-- stop
car.Weight.Anchored = true
