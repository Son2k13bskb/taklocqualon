-- [[ SEORB KAITUN - AUTO PROGRESSION ]]

_G.KaitunConfig = {
    TargetLevel = 2550,
    PriorityWeapon = "Melee",
    AutoUnlockSeas = true
}

_G.SeorbConfig = _G.SeorbConfig or {}
_G.SeorbConfig.FarmLevel = true 
_G.SeorbConfig.AutoStats = true
_G.SeorbConfig.AutoStoreFruit = true

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

local function UpdateStatus(text)
    -- Giả sử biến StatusLabel đã được tạo ở đoạn code trên
    -- StatusLabel.Text = "Status: " .. text
    print("[KAITUN STATUS] " .. text) -- Tạm in ra F9 để dễ theo dõi
end

-- 3. LOGIC ĐIỀU HƯỚNG KAITUN CHÍNH
task.spawn(function()
    while task.wait(2) do
        local currentLevel = LocalPlayer.Data.Level.Value
        local placeId = game.PlaceId
        
        if currentLevel >= _G.KaitunConfig.TargetLevel then
            UpdateStatus("Hoàn thành Kaitun! Đạt giới hạn Max Level 2550.")
            _G.SeorbConfig.FarmLevel = false -- Tắt tự farm của Main
            task.wait(10)
            continue
        end

        -- LOGIC CHUYỂN SEA
        if currentLevel >= 700 and placeId == 2753915549 then
            UpdateStatus("Đạt cấp 700! Bắt đầu chuỗi Quest giải cứu để sang Sea 2...")
            -- Kích hoạt logic Auto Quest Sea 2
        elseif currentLevel >= 1500 and placeId == 4442272000 then
            UpdateStatus("Đạt cấp 1500! Đang farm Rip_Indra để sang Sea 3...")
            -- Kích hoạt logic qua Sea 3
        else
            -- LOGIC GHÉP VŨ KHÍ NẾU ĐANG Ở SEA 3 VÀ ĐẠT LEVEL
            if placeId == 7449423635 then
                if currentLevel >= 2000 and not _G.SeorbConfig.AutoCDK then
                    UpdateStatus("Đang tiến hành quest Yama & Tushita để ghép CDK...")
                    _G.SeorbConfig.AutoYama = true
                    _G.SeorbConfig.AutoTushita = true
                elseif currentLevel >= 2300 and not _G.SeorbConfig.AutoSoulGuitar then
                    UpdateStatus("Đủ cấp! Đợi trăng tròn để ghép Soul Guitar...")
                    _G.SeorbConfig.AutoSoulGuitar = true
                else
                    UpdateStatus("Tiến trình: Đang farm tại Sea 3 (Level " .. currentLevel .. ")")
                end
            else
                UpdateStatus("Tiến trình: Cày cấp tự động (Level " .. currentLevel .. ")")
            end
        end
    end
end)

print("--- SEORB KAITUN ENGINE ĐÃ LIÊN KẾT THÀNH CÔNG ---")
