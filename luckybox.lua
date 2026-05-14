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
-- 1. UI SETUP (MODERN HUB)
-- ==========================================
local SG = Instance.new("ScreenGui")
SG.Name = "GreathubUI"
SG.ResetOnSpawn = false
SG.Parent = PGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = SG

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Dragging Logic
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local FixCorner = Instance.new("Frame")
FixCorner.Size = UDim2.new(0, 10, 1, 0)
FixCorner.Position = UDim2.new(1, -10, 0, 0)
FixCorner.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FixCorner.BorderSizePixel = 0
FixCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "GreatHub"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -150, 1, -20)
TabContainer.Position = UDim2.new(0, 150, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tabs = {}
local function createTab(name, isActive)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, -30)
    frame.Position = UDim2.new(0, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.Visible = isActive
    frame.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    Tabs[name] = frame
    return frame
end

local MainTab = createTab("Main", true)
local SettingsTab = createTab("Settings", false)

local function createTabBtn(y, name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Tabs[name].Visible and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(20, 20, 25)
    btn.Text = name
    btn.TextColor3 = Tabs[name].Visible and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = Sidebar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for tName, tFrame in pairs(Tabs) do
            tFrame.Visible = (tName == name)
        end
        for _, v in ipairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                if v.Text == name then
                    v.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    v.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    v.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
        end
    end)
end

createTabBtn(70, "Main")
createTabBtn(115, "Settings")

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = TabContainer

local LastRollLabel = Instance.new("TextLabel")
LastRollLabel.Size = UDim2.new(1, 0, 0, 20)
LastRollLabel.Position = UDim2.new(0, 0, 0, 20)
LastRollLabel.BackgroundTransparency = 1
LastRollLabel.Text = "Last Roll: -"
LastRollLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
LastRollLabel.Font = Enum.Font.GothamBold
LastRollLabel.TextSize = 13
LastRollLabel.TextXAlignment = Enum.TextXAlignment.Left
LastRollLabel.Parent = TabContainer

local function setStatus(txt, col)
    StatusLabel.Text = "Status: " .. txt
    StatusLabel.TextColor3 = col or Color3.fromRGB(180, 180, 180)
end

local function setLastRoll(txt)
    LastRollLabel.Text = "Last Roll: " .. txt
end

local function makeToggle(parent, text, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -65, 0.5, -12.5)
    btn.BackgroundColor3 = S[key] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    btn.Text = S[key] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = frame
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 4)
    corner2.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        btn.BackgroundColor3 = S[key] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        btn.Text = S[key] and "ON" or "OFF"
    end)
end

makeToggle(MainTab, "Auto Farm Brainrot", "AutoFarm")

local function makeTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -20, 1, 0)
    tb.Position = UDim2.new(0, 10, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 12
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = frame
    
    tb.FocusLost:Connect(function()
        callback(tb.Text)
    end)
    return tb
end

S.UseFilter = false
S.FilterList = {}

-- Settings Tab
makeToggle(SettingsTab, "Use Brainrot Filter", "UseFilter")
makeTextBox(SettingsTab, "Filter: misal (Ambalabu, Mutated)", function(txt)
    S.FilterList = {}
    for word in string.gmatch(txt, '([^,]+)') do
        local cleanWord = word:match("^%s*(.-)%s*$")
        if cleanWord ~= "" then
            table.insert(S.FilterList, cleanWord:upper())
        end
    end
end)

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(1, -10, 0, 40)
ModeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ModeBtn.Text = "Kick Mode: " .. S.KickMode
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.Font = Enum.Font.GothamSemibold
ModeBtn.TextSize = 14
ModeBtn.Parent = SettingsTab
local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 6)
corner3.Parent = ModeBtn

local modes = {"Sempurna", "Hebat", "Bagus"}
local modeIndex = 1
ModeBtn.MouseButton1Click:Connect(function()
    modeIndex = modeIndex + 1
    if modeIndex > #modes then modeIndex = 1 end
    S.KickMode = modes[modeIndex]
    ModeBtn.Text = "Kick Mode: " .. S.KickMode
end)

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(1, -10, 0, 40)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.Text = "Tutup Script"
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.TextSize = 14
DestroyBtn.Parent = SettingsTab
local corner4 = Instance.new("UICorner")
corner4.CornerRadius = UDim.new(0, 6)
corner4.Parent = DestroyBtn


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
        pcall(function() task.wait(0.01) btn.MouseButton1Up:Fire() end)
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
local loopConn

loopConn = RunService.Heartbeat:Connect(function()
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
            vu:Button1Down(Vector2.new(50,50))
            task.wait(0.01)
            vu:Button1Up(Vector2.new(50,50))
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

DestroyBtn.MouseButton1Click:Connect(function()
    if loopConn then loopConn:Disconnect() end
    SG:Destroy()
end)

setStatus("Ready", Color3.fromRGB(100, 255, 100))
