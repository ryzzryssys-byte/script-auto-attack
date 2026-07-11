local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

getgenv().MagmaMeteorAuto = false
getgenv().RadarDistance = 350 
getgenv().AttackSpeed = 0.25 

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet('https://githubusercontent.com'))()
	end)
end)

if CoreGui:FindFirstChild("MagmaStaffV11UI") then
	CoreGui.MagmaStaffV11UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MagmaStaffV11UI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 90)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -30, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
Title.Text = "  Magma Real V11"
Title.TextColor3 = Color3.new(1, 0.5, 0)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 160, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
ToggleBtn.Text = "Meteor: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.SourceSansBold

CloseBtn.MouseButton1Click:Connect(function()
	getgenv().MagmaMeteorAuto = false
	ScreenGui:Destroy()
end)

ToggleBtn.MouseButton1Click:Connect(function()
	getgenv().MagmaMeteorAuto = not getgenv().MagmaMeteorAuto
	ToggleBtn.Text = getgenv().MagmaMeteorAuto and "Meteor: ON" or "Meteor: OFF"
	ToggleBtn.BackgroundColor3 = getgenv().MagmaMeteorAuto and Color3.fromRGB(220, 100, 20) or Color3.fromRGB(120, 30, 30)
	
	if getgenv().MagmaMeteorAuto then
		task.spawn(function()
			pcall(function()
				loadstring(game:HttpGet('https://githubusercontent.com'))()
			end)
		end)
	end
end)

local function getNearestMonster()
	local nearestPart = nil
	local distance = getgenv().RadarDistance
	local character = LocalPlayer.Character
	if not character then return nil end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end

	local function scan(obj)
		if obj:IsA("Model") and obj ~= character and not Players:GetPlayerFromCharacter(obj) then
			local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
			local targetHuman = obj:FindFirstChildOfClass("Humanoid")
			
			if targetRoot and targetHuman and targetHuman.Health > 0 then
				local mag = (rootPart.Position - targetRoot.Position).Magnitude
				if mag < distance then
					distance = mag
					nearestPart = targetRoot
				end
			end
		end
	end

	for _, child in pairs(Workspace:GetChildren()) do
		scan(child)
		if child:IsA("Folder") or child:IsA("Model") then
			for _, subChild in pairs(child:GetChildren()) do
				scan(subChild)
			end
		end
	end
	return nearestPart
end

local MouseMetatable = getrawmetatable(game) or debug.getmetatable(game)
if MouseMetatable and setreadonly then
	setreadonly(MouseMetatable, false)
	local oldIndex = MouseMetatable.__index
	
	MouseMetatable.__index = newcclosure(function(self, index)
		if getgenv().MagmaMeteorAuto and self == Mouse then
			local monsterRoot = getNearestMonster()
			if monsterRoot then
				if index == "Hit" then
					return monsterRoot.CFrame
				elseif index == "Target" then
					return monsterRoot
				end
			end
		end
		return oldIndex(self, index)
	end)
	setreadonly(MouseMetatable, true)
end

task.spawn(function()
	while true do
		task.wait(getgenv().AttackSpeed)
		if getgenv().MagmaMeteorAuto then
			local character = LocalPlayer.Character
			local tool = character and character:FindFirstChildOfClass("Tool")
			
			if tool then
				local monsterRoot = getNearestMonster()
				if monsterRoot then
					tool:Activate()
				end
			end
		end
	end
end)
