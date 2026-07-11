-- [[ PENGATURAN SKRIP ]] --
local NAMA_SENJATA = "Staf Magma" -- Nama tool sesuai yang ada di tas
local RADIUS_SERANG = 250        -- Jarak maksimal deteksi (studs)
local JEDA_SERANG = 0.5          -- Cooldown serangan (detik)

-- [[ VARIABEL UTAMA ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Fungsi mencari musuh terdekat dalam radius
local function cariMusuhTerdekat()
    local karakter = LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return nil end
    
    local posisiSaya = karakter.HumanoidRootPart.Position
    local targetTerdekat = nil
    local jarakTerdekat = RADIUS_SERANG

    -- Memindai semua objek di game
    for _, objek in pairs(Workspace:GetChildren()) do
        -- Mendeteksi NPC / Monster / Karakter Player Lain
        if objek:IsA("Model") and objek ~= karakter then
            local humanoid = objek:FindFirstChildOfClass("Humanoid")
            local rootPart = objek:FindFirstChild("HumanoidRootPart") or objek:FindFirstChild("Torso")
            
            -- Pastikan musuh masih hidup dan berada dalam jangkauan radius
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

-- Loop utama Auto Attack
task.spawn(function()
    while true do
        task.wait(JEDA_SERANG)
        
        local karakter = LocalPlayer.Character
        if karakter and karakter:FindFirstChild("Humanoid") and karakter.Humanoid.Health > 0 then
            
            -- 1. Otomatis ambil Staf Magma dari Backpack ke tangan
            local tool = karakter:FindFirstChild(NAMA_SENJATA) or LocalPlayer.Backpack:FindFirstChild(NAMA_SENJATA)
            if tool then
                if tool.Parent == LocalPlayer.Backpack then
                    tool.Parent = karakter
                end
                
                -- 2. Cari target terdekat
                local musuh = cariMusuhTerdekat()
                if musuh and musuh:FindFirstChild("HumanoidRootPart") then
                    
                    -- 3. Hadapkan karakter ke musuh agar serangan akurat
                    local posisiMusuh = musuh.HumanoidRootPart.Position
                    karakter.HumanoidRootPart.CFrame = CFrame.new(
                        karakter.HumanoidRootPart.Position, 
                        Vector3.new(posisiMusuh.X, karakter.HumanoidRootPart.Position.Y, posisiMusuh.Z)
                    )
                    
                    -- 4. Eksekusi serangan
                    tool:Activate()
                end
            end
        end
    end
end)
