-- Memuat UI Library (Orion Alternatif yang Lebih Stabil)
local OrionLib = loadstring(game:HttpGet('https://githubusercontent.com'))()

-- Membuat Jendela Menu Utama
local Window = OrionLib:MakeWindow({
    Name = "Ryzz Auto Attack v1.0", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Memuat Skrip..."
})

-- Membuat Tab Fitur
local Tab = Window:MakeTab({
    Name = "Fitur Utama",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- PENGATURAN SKRIP --
local NAMA_SENJATA = "Staf Magma"
local RADIUS_SERANG = 250
local JEDA_SERANG = 0.5
_G.AutoAttackActive = false 

-- Fungsi mencari musuh terdekat
local function cariMusuhTerdekat()
    local karakter = game.Players.LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return nil end
    
    local posisiSaya = karakter.HumanoidRootPart.Position
    local targetTerdekat = nil
    local jarakTerdekat = RADIUS_SERANG

    for _, objek in pairs(workspace:GetChildren()) do
        if objek:IsA("Model") and objek ~= karakter then
            local humanoid = objek:FindFirstChildOfClass("Humanoid")
            local rootPart = objek:FindFirstChild("HumanoidRootPart") or objek:FindFirstChild("Torso")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local jarak = (posisiSaya - rootPart.Position).Magnitude
                if jarak < jarakTerdekat then
                    jarakTerdekat = jarak
                    targetTerdekat = objek
                end
            end
        end
    end
    return targetTerdekat
end

-- Tombol Sakelar Toggle ON/OFF
Tab:AddToggle({
    Name = "Auto Attack (Staf Magma)",
    Default = false,
    Callback = function(Value)
        _G.AutoAttackActive = Value
        
        if Value then
            task.spawn(function()
                while _G.AutoAttackActive do
                    local LocalPlayer = game.Players.LocalPlayer
                    local karakter = LocalPlayer.Character
                    
                    if karakter and karakter:FindFirstChild("Humanoid") and karakter.Humanoid.Health > 0 then
                        local tool = karakter:FindFirstChild(NAMA_SENJATA) or LocalPlayer.Backpack:FindFirstChild(NAMA_SENJATA)
                        if tool then
                            if tool.Parent == LocalPlayer.Backpack then
                                tool.Parent = karakter
                            end
                            
                            local musuh = cariMusuhTerdekat()
                            if musuh and musuh:FindFirstChild("HumanoidRootPart") then
                                local posisiMusuh = musuh.HumanoidRootPart.Position
                                karakter.HumanoidRootPart.CFrame = CFrame.new(
                                    karakter.HumanoidRootPart.Position, 
                                    Vector3.new(posisiMusuh.X, karakter.HumanoidRootPart.Position.Y, posisiMusuh.Z)
                                )
                                tool:Activate()
                            end
                        end
                    end
                    task.wait(JEDA_SERANG)
                end
            end)
        end
    end    
})

OrionLib:Init()

