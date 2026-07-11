-- PENGATURAN UTAMA
local NAMA_TOOL = "staf magma" -- Nama senjata Anda
local JARAK_DETEKSI = 250      -- JAKUR DETEKSI DIUBAH MENJADI 250 STUDS

-- VARIABEL SISTEM
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
_G.AutoHitMagma = true -- Ubah ke false untuk mematikan script lewat executor

-- FUNGSI UNTUK MENCARI MUSUH TERDEKAT
local function dapatkanMusuhTerdekat()
    local targetTerdekat = nil
    local jarakTerdekat = JARAK_DETEKSI

    for _, objek in pairs(workspace:GetChildren()) do
        if objek:IsA("Model") and objek:FindFirstChild("Humanoid") and objek ~= LocalPlayer.Character then
            local humanoid = objek.Humanoid
            local enemyRoot = objek:FindFirstChild("HumanoidRootPart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoid.Health > 0 and enemyRoot and myRoot then
                local jarak = (myRoot.Position - enemyRoot.Position).Magnitude
                if jarak < jarakTerdekat then
                    jarakTerdekat = jarak
                    targetTerdekat = objek
                end
            end
        end
    end
    return targetTerdekat
end

-- PERULANGAN UTAMA (SPAM 0.5 MILIDETIK)
task.spawn(function()
    while _G.AutoHitMagma do
        local musuh = dapatkanMusuhTerdekat()
        
        if musuh then
            -- 1. Ambil "staf magma" secara otomatis jika belum dipegang
            local tool = LocalPlayer.Backpack:FindFirstChild(NAMA_TOOL) or LocalPlayer.Character:FindFirstChild(NAMA_TOOL)
            
            if tool then
                if tool.Parent == LocalPlayer.Backpack then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                end

                -- 2. Trik Menembus Batas FPS (Spam Multi-Hit 0.5 milidetik)
                -- Menembakkan 15 pukulan sekaligus dalam satu frame kedipan mata
                for i = 1, 15 do
                    -- METODE A: Klik Makro Instan (Gunakan ini jika tool biasa)
                    tool:Activate()

                    -- METODE B: Jalur Remote Event (Ganti bagian bawah ini dengan copy SimpleSpy jika tidak mempan)
                    -- Contoh: game:GetService("ReplicatedStorage").Remotes.MagmaAttack:FireServer(musuh)
                end
                
                -- 3. Mengarahkan Pandangan Karakter ke Musuh agar Akurat
                local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local enemyRoot = musuh:FindFirstChild("HumanoidRootPart")
                if myRoot and enemyRoot then
                    myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(enemyRoot.Position.X, myRoot.Position.Y, enemyRoot.Position.Z))
                end
            end
        end
        
        -- Jeda minimum hardware internal Roblox
        task.wait() 
    end
end)
