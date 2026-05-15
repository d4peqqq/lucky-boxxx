-- ================================================
--   GREATHUB - MODERN HUB VERSION
--   Game: Brainrot / Lucky Block
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

-- KOORDINAT SAFE ZONE
local SafeZonePos = Vector3.new(695.3816528320312, 2.998032569885254, 223.67698669433594)

local S = {
    AutoFarm = false,
    AutoWeight = false,
    KickMode = "Sempurna",
    Timing = { Sempurna = 0.68, Hebat = 0.42, Bagus = 0.22 },
}

-- Bersihkan UI Lama
for _, v in ipairs(PGui:GetChildren()) do
    if v.Name == "GreathubUI" or v.Name == "SimpleKickUI" then
        v:Destroy()
    end
end

-- ==========================================
-- 1. UI SETUP (WIND UI)
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "GreatHub | Lucky Box Auto Farm",
    Icon = "solar:box-minimalistic-bold",
    Folder = "GreatHub",
    Size = UDim2.fromOffset(500, 400),
    OpenButton = {
        Title = "GreatHub",
        Icon = "solar:ghost-bold",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(
            Color3.fromHex("#10C550"),
            Color3.fromHex("#30FF6A")
        ),
    }
})

Window:Tag({
    Title = "Auto Farm Active",
    Icon = "solar:bolt-bold",
    Color = Color3.fromHex("#10C550")
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "solar:home-2-bold",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "solar:settings-bold",
})

local StatusSection = MainTab:Section({ Title = "Dashboard" })
local StatusLabel = StatusSection:Paragraph({
    Title = "Status",
    Desc = "Idle"
})
local LastRollLabel = StatusSection:Paragraph({
    Title = "Last Roll",
    Desc = "-"
})

local function setStatus(txt, col)
    pcall(function()
        StatusLabel:SetDesc(txt)
    end)
    pcall(function()
        StatusLabel:Set({ Title = "Status", Desc = txt })
    end)
end

local function setLastRoll(txt)
    pcall(function()
        LastRollLabel:SetDesc(txt)
    end)
    pcall(function()
        LastRollLabel:Set({ Title = "Last Roll", Desc = txt })
    end)
    WindUI:Notify({
        Title = "Got Brainrot!",
        Content = txt,
        Duration = 3,
    })
end

local FarmSection = MainTab:Section({ Title = "Auto Farming" })
FarmSection:Toggle({
    Title = "Auto Farm Brainrot",
    Value = S.AutoFarm,
    Callback = function(state)
        S.AutoFarm = state
    end,
})

FarmSection:Toggle({
    Title = "Auto Weight",
    Value = S.AutoWeight,
    Callback = function(state)
        S.AutoWeight = state
    end,
})

local FilterSection = SettingsTab:Section({ Title = "Filter Configuration" })
S.UseFilter = false
S.FilterList = {}

FilterSection:Toggle({
    Title = "Use Brainrot Filter",
    Value = S.UseFilter,
    Callback = function(state)
        S.UseFilter = state
    end,
})

FilterSection:Input({
    Title = "Brainrot Filter",
    Desc = "Pisahkan dengan koma (misal: Ambalabu, Mutated)",
    Value = "",
    Placeholder = "Ketik disini...",
    Callback = function(txt)
        S.FilterList = {}
        for word in string.gmatch(txt, '([^,]+)') do
            local cleanWord = word:match("^%s*(.-)%s*$")
            if cleanWord ~= "" then
                table.insert(S.FilterList, cleanWord:upper())
            end
        end
    end,
})

local MiscSection = SettingsTab:Section({ Title = "Miscellaneous" })
MiscSection:Dropdown({
    Title = "Kick Mode",
    Values = { "Sempurna", "Hebat", "Bagus" },
    Value = S.KickMode,
    Callback = function(option)
        S.KickMode = option
    end,
})

MiscSection:Button({
    Title = "Tutup Script",
    Icon = "shredder",
    Callback = function()
        Window:Destroy()
        if loopConn then loopConn:Disconnect() end
    end,
})


-- ==========================================
-- 2. CORE LOGIC
-- ==========================================
local function findTendang()
    -- Prioritaskan tombol dengan teks KICK tapi BUKAN TAP

    -- 1. Cari di PlayerGui
    for _, sg in ipairs(PGui:GetChildren()) do
        if sg:IsA("ScreenGui") and sg.Name ~= "GreathubUI" then
            for _, v in ipairs(sg:GetDescendants()) do
                if v:IsA("TextButton") or v:IsA("ImageButton") then
                    local txt = ""
                    if v:IsA("TextButton") then
                        txt = v.Text
                    else
                        local label = v:FindFirstChildWhichIsA("TextLabel")
                        if label then txt = label.Text end
                    end

                    local txtUp = txt:upper()
                    if (txtUp:find("KICK") or txtUp:find("TENDANG")) and not txtUp:find("TAP") then
                        if v.Visible then return v end
                    end
                end
            end
        end
    end

    -- 2. Cari di Workspace (Jika tombolnya menempel di udara / BillboardGui)
    local ws = game:GetService("Workspace")
    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("TextButton") or v:IsA("ImageButton") then
            local txt = ""
            if v:IsA("TextButton") then
                txt = v.Text
            else
                local label = v:FindFirstChildWhichIsA("TextLabel")
                if label then txt = label.Text end
            end

            local txtUp = txt:upper()
            if (txtUp:find("KICK") or txtUp:find("TENDANG")) and not txtUp:find("TAP") then
                return v
            end
        end
    end

    return nil
end

local function clickBtn(btn)
    if not btn then return end
    local clicked = false
    pcall(function()
        for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
            pcall(function() conn.Function() end)
            clicked = true
        end
    end)
    pcall(function()
        for _, conn in ipairs(getconnections(btn.Activated)) do
            pcall(function() conn.Function() end)
            clicked = true
        end
    end)
    if not clicked then
        pcall(function() btn.MouseButton1Down:Fire() end)
        pcall(function()
            task.wait(0.01)
            btn.MouseButton1Up:Fire()
        end)
        pcall(function() btn.MouseButton1Click:Fire() end)
        pcall(function() btn.Activated:Fire() end)
    end
end

local function walkTo(targetPos)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local maxTime = 15 -- Batas waktu jalan max 15 detik
    local elapsed = 0
    local arrived = false

    hum:MoveTo(targetPos)

    local walkConn
    walkConn = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        if not S.AutoFarm or elapsed > maxTime then
            walkConn:Disconnect()
            arrived = true
            return
        end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist < 5 then
            walkConn:Disconnect()
            arrived = true
            return
        end
        if elapsed % 1.5 < dt then
            hum:MoveTo(targetPos)
        end
        -- Auto Jump jika tersangkut
        if math.random() < 0.2 * dt then
            hum.Jump = true
        end
    end)

    while not arrived do task.wait(0.1) end
end

local function findBrainrotName()
    local char = LP.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Enabled then
                local labels = {}
                for _, lbl in ipairs(v:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Visible and lbl.Text ~= "" then
                        table.insert(labels, lbl.Text)
                    end
                end
                if #labels > 0 then
                    return table.concat(labels, " | ")
                end
            end
        end
    end
    return "Unknown"
end

local function findTapBtn()
    for _, sg in ipairs(PGui:GetChildren()) do
        if sg:IsA("ScreenGui") and sg.Name ~= "GreathubUI" then
            for _, v in ipairs(sg:GetDescendants()) do
                if (v:IsA("TextButton") or v:IsA("ImageButton") or v:IsA("TextLabel")) and v.Visible then
                    local txt = ""
                    if v:IsA("TextButton") or v:IsA("TextLabel") then
                        txt = v.Text
                    else
                        local label = v:FindFirstChildWhichIsA("TextLabel")
                        if label then txt = label.Text end
                    end
                    if txt:upper():find("TAP") then
                        if v:IsA("TextLabel") then
                            if v.Parent and (v.Parent:IsA("TextButton") or v.Parent:IsA("ImageButton")) then
                                return v.Parent
                            end
                        end
                        return v
                    elseif v:IsA("TextButton") and v.Size.X.Scale >= 0.8 and v.Size.Y.Scale >= 0.8 then
                        return v
                    end
                end
            end
        end
    end
    return nil
end

local function waitForPerfect()
    local rs = game:GetService("RunService")
    task.wait(0.05) -- Beri waktu UI untuk muncul dan bergerak

    local candidates = {}
    for _, v in ipairs(PGui:GetDescendants()) do
        if (v:IsA("Frame") or v:IsA("ImageLabel")) and v.Visible then
            table.insert(candidates, {
                obj = v,
                startScale = v.Size.Y.Scale,
                startOffset = v.Size.Y.Offset
            })
        end
    end

    local targetBar = nil
    local t0 = tick()
    while tick() - t0 < 0.25 do
        rs.RenderStepped:Wait()
        for _, c in ipairs(candidates) do
            if c.obj.Parent and (c.obj.Size.Y.Scale ~= c.startScale or c.obj.Size.Y.Offset ~= c.startOffset) then
                targetBar = c.obj
                break
            end
        end
        if targetBar then break end
    end

    if targetBar then
        setStatus("Membaca pergerakan bar...", Color3.fromRGB(150, 255, 150))
        local timeout = tick()
        while tick() - timeout < 2 do
            rs.RenderStepped:Wait()
            local scale = targetBar.Size.Y.Scale
            if scale == 0 and targetBar.Parent and targetBar.Parent:IsA("GuiObject") then
                local pSize = targetBar.Parent.AbsoluteSize.Y
                if pSize > 0 then
                    scale = targetBar.AbsoluteSize.Y / pSize
                end
            end

            -- Jika bar menggunakan persentase tinggi (0 ke 1)
            local targetScale = 0.85 -- Perfect
            if S.KickMode == "Hebat" then targetScale = 0.65 end
            if S.KickMode == "Bagus" then targetScale = 0.35 end

            if scale >= targetScale then
                break
            end
        end
    else
        -- Fallback ke statis timing jika bar tidak terdeteksi
        local delayTime = S.Timing[S.KickMode] or 0.55
        local start = tick()
        while tick() - start < delayTime do
            rs.RenderStepped:Wait()
        end
    end
end

-- ==========================================
-- 3. MAIN LOOP (AUTO FARM BRAINROT)
-- ==========================================
local busy = false
local lastWeightTime = 0

loopConn = RunService.Heartbeat:Connect(function()
    if S.AutoWeight then
        pcall(function()
            local c = LP.Character
            if c then
                local tool = c:FindFirstChildOfClass("Tool")
                if not tool then
                    tool = LP.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(tool) end
                    end
                end
                
                if tool and tick() - lastWeightTime > 0.1 then
                    lastWeightTime = tick()
                    tool:Activate()
                    
                    local vu = game:GetService("VirtualUser")
                    vu:ClickButton1(Vector2.new(50, 50))
                end
            end
        end)
    end

    if not S.AutoFarm then
        busy = false
        return
    end
    if busy then return end
    busy = true

    task.spawn(function()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then
            busy = false
            return
        end

        -- Step 1: Teleport ke Safe Zone jika posisinya jauh
        local distToSafe = (hrp.Position - SafeZonePos).Magnitude
        if distToSafe > 20 then
            setStatus("Teleport ke Safe Zone...", Color3.fromRGB(200, 200, 255))
            hrp.CFrame = CFrame.new(SafeZonePos + Vector3.new(0, 3, 0))
            task.wait(1.5) -- Tunggu karakter stabil
        end

        -- Step 2: Diam di Safe Zone dan Tunggu Tombol Kick atau Bar Tap
        setStatus("Menunggu Block / Bar Meteran...", Color3.fromRGB(255, 255, 100))
        local btn = nil
        local tapBtn = nil
        local waited = 0
        while waited < 10 do -- Tunggu 10 detik
            btn = findTendang()
            tapBtn = findTapBtn()
            if btn or tapBtn then break end
            task.wait(0.2)
            waited = waited + 0.2
        end

        if not btn and not tapBtn then
            setStatus("Tombol tak kunjung muncul", Color3.fromRGB(200, 100, 100))
            task.wait(1)
            busy = false
            return
        end

        -- Step 3: Nendang
        if btn then
            setStatus("Klik Tombol KICK!", Color3.fromRGB(255, 200, 50))
            clickBtn(btn) -- KLIK PERTAMA: Memulai tendangan & memunculkan bar
        end

        -- Tunggu bar berjalan sampai Sempurna/Hebat/Bagus dengan monitor dinamis
        setStatus("Membidik " .. S.KickMode .. "...", Color3.fromRGB(255, 255, 100))
        waitForPerfect()

        -- KLIK KEDUA: Menghentikan bar
        if not tapBtn then tapBtn = findTapBtn() end
        if tapBtn and (tapBtn:IsA("TextButton") or tapBtn:IsA("ImageButton")) then
            clickBtn(tapBtn)
        end

        -- Fallback 1: VirtualUser
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:Button1Down(Vector2.new(50, 50))
            task.wait(0.01)
            vu:Button1Up(Vector2.new(50, 50))
        end)

        -- Fallback 2: VirtualInputManager (Tengah atas layar, agar tidak nabrak UI Hub)
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            local cam = workspace.CurrentCamera
            local cx, cy = cam.ViewportSize.X / 2, 50
            vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
            task.wait(0.02)
            vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        end)

        setStatus("Kicked!", Color3.fromRGB(100, 255, 100))

        -- Step 4: Berlari lurus ke depan mengejar box
        setStatus("Berlari lurus mengejar box...", Color3.fromRGB(100, 255, 255))
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Jalan lurus searah pandangan karakter sejauh 1000 stud
            local forwardPos = hrp.Position + (hrp.CFrame.LookVector * 1000)
            hum:MoveTo(forwardPos)
        end

        -- Berlari lurus selama 4 detik sambil menunggu karakter berubah jadi brainrot
        task.wait(4)

        -- Cek apakah posisi kita sudah jauh dari Safe Zone
        local newDist = (hrp.Position - SafeZonePos).Magnitude
        if newDist > 15 then
            -- Step 5: JALAN KAKI PULANG KE SAFE ZONE (Membawa lari brainrot)

            local rollName = findBrainrotName()
            if rollName ~= "Unknown" and rollName ~= "" then
                setLastRoll(rollName)
            end

            -- Filter Logic
            local shouldKeep = true
            if S.UseFilter and #S.FilterList > 0 and rollName ~= "Unknown" then
                shouldKeep = false
                local rollUpper = rollName:upper()
                for _, f in ipairs(S.FilterList) do
                    if rollUpper:find(f) then
                        shouldKeep = true
                        break
                    end
                end
            end

            if shouldKeep then
                setStatus("Membawa lari ke Safe Zone...", Color3.fromRGB(100, 255, 150))
                walkTo(SafeZonePos)
                setStatus("Berhasil disetor!", Color3.fromRGB(100, 255, 100))
            else
                setStatus("Brainrot di-skip (Filter)", Color3.fromRGB(200, 150, 100))
                -- Diam saja, loop berikutnya akan melakukan teleport ke Safe Zone untuk reset
            end
        else
            setStatus("Menunggu block baru...", Color3.fromRGB(200, 200, 200))
        end

        task.wait(1)
        busy = false
    end)
end)

setLastRoll("-")
setStatus("Ready", Color3.fromRGB(100, 255, 100))
