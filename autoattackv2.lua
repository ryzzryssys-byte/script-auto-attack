-- Memuat UI Library (Orion)
local OrionLib = loadstring(game:HttpGet(("https://githubusercontent.com")))()

-- Membuat Jendela Menu Utama (Akan langsung muncul di layar)
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
_G.AutoAttackActive = false -- Status awal mati

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

-- Membuat Tombol Sakelar (Toggle) ON/OFF di dalam Menu UI
Tab:AddToggle({
    Name = "Auto Attack (Staf Magma)",
    Default = false,
    Callback = function(Value)
        _G.AutoAttackActive = Value
        
        -- Jika tombol diubah ke ON (true), jalankan fungsi menyerang
        if Value then
            task.spawn(function()
                while _G.AutoAttackActive do
                    local LocalPlayer = game.Players.LocalPlayer
                    local karakter = LocalPlayer.Character
                    
                    if karakter and karakter:FindFirstChild("Humanoid") and karakter.Humanoid.Health > 0 then
                        -- Ambil Staf Magma secara otomatis
                        local tool = karakter:FindFirstChild(NAMA_SENJATA) or LocalPlayer.Backpack:FindFirstChild(NAMA_SENJATA)
                        if tool then
                            if tool.Parent == LocalPlayer.Backpack then
                                tool.Parent = karakter
                            end
                            
                            -- Cari musuh terdekat
                            local musuh = cariMusuhTerdekat()
                            if musuh and musuh:FindFirstChild("HumanoidRootPart") then
                                -- Karakter otomatis menghadap ke musuh
                                local posisiMusuh = musuh.HumanoidRootPart.Position
                                karakter.HumanoidRootPart.CFrame = CFrame.new(
                                    karakter.HumanoidRootPart.Position, 
                                    Vector3.new(posisiMusuh.X, karakter.HumanoidRootPart.Position.Y, posisiMusuh.Z)
                                )
                                
                                -- Eksekusi serangan
                                tool:Activate()
                            end
                        end
                    end
                    task.wait(JEDA_SERANG) -- Cooldown 0.5 detik
                end
            end)
        end
    end    
})

-- Menginisialisasi UI agar muncul di layar
OrionLib:Init()
