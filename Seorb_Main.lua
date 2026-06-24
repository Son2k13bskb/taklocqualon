-- [[ SEORB HUB - MAIN SCRIPT ]]

local PlaceId = game.PlaceId
local Sea1_ID = 2753915549
local Sea2_ID = 4442272000
local Sea3_ID = 7449423635

_G.SeorbConfig = _G.SeorbConfig or {
    FarmLevel = false,
    AutoYama = false,
    AutoTushita = false,
    AutoCDK = false,
    AutoSoulGuitar = false,
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

local SeorbHub = {Tabs = {}}

-- Các Tab CƠ BẢN (Xuất hiện ở mọi Sea)
SeorbHub.Tabs.MainFarm = function() print("[UI] Tải Tab: Main Farm & Stats...") end
SeorbHub.Tabs.ESP = function() print("[UI] Tải Tab: ESP & Cài đặt người chơi...") end

-- Các Tab SEA 2 (Chỉ xuất hiện nếu ở Sea 2 hoặc Sea 3)
SeorbHub.Tabs.Sea2_Features = function()
    print("[UI] Tải Tab: Đi Raid Thức Tỉnh & Auto Cyborg...")
end

-- Các Tab SEA 3 (Chỉ xuất hiện nếu ở Sea 3)
SeorbHub.Tabs.Sea3_Features = function()
    print("[UI] Tải Tab: Vũ Khí Tối Thượng Sea 3")
    print("  + Toggle: Auto Yama (Nhận Quest Elite Hunter)")
    print("  + Toggle: Auto Tushita (Chờ đuốc và diệt quái)")
    print("  + Toggle: Auto CDK Quest (Làm chuỗi nhiệm vụ)")
    print("  + Toggle: Auto Soul Guitar (Làm trò giải đố Nghĩa trang)")
    print("[UI] Tải Tab: Sea Event (Tiki Outpost)...")
end

-- TIẾN HÀNH RENDER GIAO DIỆN DỰA TRÊN PLACE ID
print("--- KHỞI TẠO SEORB UI CHO KHU VỰC HIỆN TẠI ---")
SeorbHub.Tabs.MainFarm()
SeorbHub.Tabs.ESP()

if PlaceId == Sea2_ID then
    print("[HỆ THỐNG] Nhận diện: Đang ở Sea 2!")
    SeorbHub.Tabs.Sea2_Features()
    
elseif PlaceId == Sea3_ID then
    print("[HỆ THỐNG] Nhận diện: Đang ở Sea 3!")
    SeorbHub.Tabs.Sea2_Features() -- Kế thừa các tính năng Raid từ Sea 2
    SeorbHub.Tabs.Sea3_Features()
    
elseif PlaceId == Sea1_ID then
    print("[HỆ THỐNG] Nhận diện: Đang ở Sea 1! Chỉ tải các chức năng cơ bản.")
end

print("--- SEORB HUB MAIN ĐÃ SẴN SÀNG ---")
