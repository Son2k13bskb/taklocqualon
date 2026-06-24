-- [[ SEORB HUB - MAIN SCRIPT ]]

_G.SeorbConfig = {
    FarmLevel = false,
    WeaponSelect = "Combat", 
    AttackSpeed = "Fast Attack", 
    AutoStats = false,
    StatsTarget = "Melee",
    AutoStoreFruit = true,
    AutoSeaEvent = false,
    SeaEventSkills = {Combat = {Z = true, X = true, C = true}, Fruit = {Z = true, C = true, V = true}},
    SkillHoldTimes = {Combat = 1.5, Fruit = 2.5},
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoBuyChip = false,
    AutoStartRaid = false,
    AutoAwaken = false,
    AutoCyborg = false,
    FlySpeed = 50
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local function SmoothMove(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = _G.SeorbConfig.FlySpeed * 5 
    local duration = distance / speed
    if duration == 0 then return end
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local function HoldSkill(key, holdTime)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

task.spawn(function()
    while task.wait(0.1) do 
        if _G.SeorbConfig.AutoStats then
            local points = LocalPlayer.Data.Points.Value
            if points > 0 then CommF:InvokeServer("AddPoint", _G.SeorbConfig.StatsTarget, points) end
        end

        if _G.SeorbConfig.AutoStoreFruit then
            local char = LocalPlayer.Character
            if char then
                for _, item in pairs(char:GetChildren()) do
                    if item:IsA("Tool") and item.Name:find("Fruit") then
                        CommF:InvokeServer("StoreFruit", item:GetAttribute("OriginalName") or item.Name)
                    end
                end
            end
        end

        if _G.SeorbConfig.AutoSeaEvent then
            local weapon = _G.SeorbConfig.WeaponSelect
            local skills = _G.SeorbConfig.SeaEventSkills[weapon]
            local holdTime = _G.SeorbConfig.SkillHoldTimes[weapon] or 1
            
            local char = LocalPlayer.Character
            if char and not char:FindFirstChild(weapon) then
                local tool = LocalPlayer.Backpack:FindFirstChild(weapon)
                if tool then char.Humanoid:EquipTool(tool) end
            end
            
            if skills then
                for key, isEnabled in pairs(skills) do
                    if isEnabled then HoldSkill(key, holdTime); task.wait(0.2) end
                end
            end
        end
    end
end)

print("--- SEORB HUB MAIN STARTED ---")
