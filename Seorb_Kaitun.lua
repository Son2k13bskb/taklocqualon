-- [[ SEORB KAITUN - AUTO PROGRESSION ]]

_G.KaitunConfig = {
    TargetLevel = 2550,
    PriorityWeapon = "Melee",
    AutoUnlockSeas = true
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- XÓA GUI CŨ NẾU ĐÃ TỒN TẠI (Chống trùng lặp khi chạy lại script)
if CoreGui:FindFirstChild("SeorbKaitunGUI") then
    CoreGui.SeorbKaitunGUI:Destroy()
end

-- TẠO GIAO DIỆN HIỂN THỊ (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeorbKaitunGUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 80)
MainFrame.Position = UDim2.new(0.5, -175, 0, 20) -- Đặt ở giữa cạnh trên màn hình
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 128)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SEORB KAITUN ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.Position = UDim2.new(0, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Đang khởi động hệ thống..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- HÀM CẬP NHẬT TRẠNG THÁI CHO GUI
local function UpdateStatus(text)
    StatusLabel.Text = "Status: " .. text
end

-- ==========================================
-- LOGIC KAITUN CHÍNH (BACKEND ENGINE)
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        local currentLevel = LocalPlayer.Data.Level.Value
        
        -- Dừng Kaitun nếu đạt Max Level
        if currentLevel >= _G.KaitunConfig.TargetLevel then
            UpdateStatus("Đã đạt Level Max (" .. currentLevel .. "). Tạm dừng!")
            task.wait(5)
            continue
        end

        -- Logic phân loại Quest theo Level
        if currentLevel < 10 then
            UpdateStatus("Đang farm Băng Cướp (Bandits) - Đảo Khởi Điểm...")
            -- Gọi hàm nhận Quest và đánh quái ở đây
        elseif currentLevel >= 10 and currentLevel < 15 then
            UpdateStatus("Đang farm Khỉ (Monkeys) - Đảo Rừng Rậm...")
            -- Gọi hàm nhận Quest Monkey
        elseif currentLevel >= 700 and currentLevel < 725 then
            UpdateStatus("Đang làm nhiệm vụ sang Sea 2 (Đánh Ice Admiral)...")
            -- Gọi hàm chuỗi Quest sang Sea 2
        else
            UpdateStatus("Đang tự động cày cấp: Level " .. currentLevel .. " / " .. _G.KaitunConfig.TargetLevel)
            -- Logic vòng lặp đánh quái cơ bản
        end
    end
end)

print("--- SEORB KAITUN STARTED ---")
