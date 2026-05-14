-- ================================================
--   GREATHUB - SIMPLE UI VERSION
--   Kick a Lucky Block
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

-- Bersihkan UI lama
local oldGui = PGui:FindFirstChild("SimpleKickUI")
if oldGui then oldGui:Destroy() end

local S = {
    AutoGo   = false,
    AutoKick = false,
    KickMode = "Sempurna",
    Speed    = 24,
    Timing   = { Sempurna = 0.68, Hebat = 0.42, Bagus = 0.22 },
    SpawnDelay = 0.01,
    JumpChance = 0.28,
}

-- Buat UI
local SG = Instance.new("ScreenGui")
SG.Name = "SimpleKickUI"
SG.ResetOnSpawn = false
SG.Parent = PGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 280)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = SG
MainFrame.Active = true

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Kick Block - Simple"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local function setStatus(txt, col)
    StatusLabel.Text = "Status: " .. txt
    StatusLabel.TextColor3 = col or Color3.fromRGB(180, 180, 180)
end

local function makeToggle(y, text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        if S[key] then
            btn.Text = text .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.Text = text .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

makeToggle(70, "Auto Go To Block", "AutoGo")
makeToggle(110, "Auto Kick", "AutoKick")

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(1, -20, 0, 20)
ModeLabel.Position = UDim2.new(0, 10, 0, 150)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Mode: Sempurna"
ModeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextSize = 12
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = MainFrame

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0, 80, 0, 25)
ModeBtn.Position = UDim2.new(1, -90, 0, 147)
ModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ModeBtn.Text = "Ganti Mode"
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.Font = Enum.Font.Gotham
ModeBtn.TextSize = 12
ModeBtn.Parent = MainFrame
local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 4)
corner1.Parent = ModeBtn

local modes = {"Sempurna", "Hebat", "Bagus"}
local modeIndex = 1
ModeBtn.MouseButton1Click:Connect(function()
    modeIndex = modeIndex + 1
    if modeIndex > #modes then modeIndex = 1 end
    S.KickMode = modes[modeIndex]
    ModeLabel.Text = "Mode: " .. S.KickMode
end)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 185)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 24"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpdDown = Instance.new("TextButton")
SpdDown.Size = UDim2.new(0, 30, 0, 25)
SpdDown.Position = UDim2.new(1, -75, 0, 182)
SpdDown.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpdDown.Text = "-"
SpdDown.TextColor3 = Color3.fromRGB(255, 255, 255)
SpdDown.Parent = MainFrame
local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 4)
corner2.Parent = SpdDown

local SpdUp = Instance.new("TextButton")
SpdUp.Size = UDim2.new(0, 30, 0, 25)
SpdUp.Position = UDim2.new(1, -40, 0, 182)
SpdUp.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpdUp.Text = "+"
SpdUp.TextColor3 = Color3.fromRGB(255, 255, 255)
SpdUp.Parent = MainFrame
local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 4)
corner3.Parent = SpdUp

SpdDown.MouseButton1Click:Connect(function()
    S.Speed = math.max(16, S.Speed - 1)
    SpeedLabel.Text = "Speed: " .. S.Speed
end)
SpdUp.MouseButton1Click:Connect(function()
    S.Speed = math.min(32, S.Speed + 1)
    SpeedLabel.Text = "Speed: " .. S.Speed
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 230)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "Tutup Script"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame
local corner4 = Instance.new("UICorner")
corner4.CornerRadius = UDim.new(0, 6)
corner4.Parent = CloseBtn

-- Core Functions

local function findTendang()
    for _, sg in ipairs(PGui:GetChildren()) do
        if sg:IsA("ScreenGui") and sg.Name ~= "SimpleKickUI" then
            for _, v in ipairs(sg:GetDescendants()) do
                if v:IsA("TextButton") or v:IsA("ImageButton") then
                    local txt = ""
                    if v:IsA("TextButton") then
                        txt = v.Text
                    else
                        local label = v:FindFirstChildWhichIsA("TextLabel")
                        if label then txt = label.Text end
                    end
                    
                    local name = v.Name
                    
                    if txt:upper():find("TENDANG") or txt:upper():find("KICK") or name:upper():find("KICK") or name:upper():find("TENDANG") then
                        if v.Visible then -- Menghapus syarat v.Active karena kadang developer men-disable Active sementara
                            return v
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function clickBtn(btn)
    if not btn then return end
    
    -- Method 1: Menggunakan firesignal (Biasa digunakan di Executor seperti Delta)
    pcall(function() firesignal(btn.MouseButton1Down) end)
    pcall(function() firesignal(btn.MouseButton1Click) end)
    pcall(function() firesignal(btn.Activated) end)
    
    -- Method 2: Executor getconnections (Alternatif yang sangat kuat)
    pcall(function()
        for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
            pcall(function() conn.Function() end)
            pcall(function() conn:Fire() end)
        end
    end)
    pcall(function()
        for _, conn in ipairs(getconnections(btn.Activated)) do
            pcall(function() conn.Function() end)
            pcall(function() conn:Fire() end)
        end
    end)

    -- Method 3: Roblox Native Signals
    pcall(function() btn.MouseButton1Down:Fire() end)
    pcall(function() task.wait(0.01) btn.MouseButton1Up:Fire() end)
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function() btn.Activated:Fire() end)

    -- Method 4: Virtual Input Manager (Paling murni, meniru klik asli)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local ap = btn.AbsolutePosition
        local as = btn.AbsoluteSize
        local cx = ap.X + (as.X / 2)
        local cy = ap.Y + (as.Y / 2) + 36 -- +36 biasanya untuk offset TopBar GUI Roblox
        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.02)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end)
end

local function findBlock()
    local ws = game:GetService("Workspace")
    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("lucky") or n:find("block") then
                if v.Size.Y < 6 and v.Size.X < 6 then
                    return v
                end
            end
        end
    end
    return nil
end

local function setSpeed(spd)
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = spd end
end

local function walkTo(targetPos)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    setSpeed(S.Speed)

    local maxTime = 8
    local elapsed = 0
    local arrived = false

    hum:MoveTo(targetPos)

    local jumpConn
    jumpConn = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        if not S.AutoGo or elapsed > maxTime then
            jumpConn:Disconnect()
            arrived = true
            return
        end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist < 4 then
            jumpConn:Disconnect()
            arrived = true
            return
        end
        if elapsed % 1.5 < dt then
            hum:MoveTo(targetPos)
        end
        if math.random() < S.JumpChance * dt then
            hum.Jump = true
        end
    end)

    local t = 0
    while not arrived and t < maxTime do
        task.wait(0.1)
        t = t + 0.1
    end

    setSpeed(16)
end

-- Main Loop
local busy = false
local loopConn
loopConn = RunService.Heartbeat:Connect(function()
    if not (S.AutoGo or S.AutoKick) then
        busy = false
        return
    end
    if busy then return end
    busy = true

    task.spawn(function()
        if S.AutoGo then
            setStatus("Mencari Block...", Color3.fromRGB(255, 255, 100))
            local block = findBlock()
            if block then
                setStatus("Menuju Block...", Color3.fromRGB(100, 200, 255))
                task.wait(S.SpawnDelay)
                local dest = block.Position + Vector3.new(0, -block.Size.Y/2 + 1, 3.5)
                walkTo(dest)
                setStatus("Di posisi kick!", Color3.fromRGB(100, 255, 100))
            else
                setStatus("Block tak ditemukan", Color3.fromRGB(200, 100, 100))
                task.wait(1)
                busy = false
                return
            end
        end

        if S.AutoKick then
            setStatus("Tunggu tombol...", Color3.fromRGB(255, 255, 100))
            local btn = nil
            local waited = 0
            while waited < 6 do
                btn = findTendang()
                if btn then break end
                task.wait(0.05)
                waited = waited + 0.05
            end

            if not btn then
                setStatus("Tombol tak muncul", Color3.fromRGB(255, 100, 100))
                task.wait(1)
                busy = false
                return
            end

            local delayTime = S.Timing[S.KickMode] or 0.68
            setStatus("Timing " .. S.KickMode, Color3.fromRGB(255, 255, 100))
            task.wait(delayTime)

            clickBtn(btn)
            setStatus("Kicked!", Color3.fromRGB(100, 255, 100))
            task.wait(1.5)
        end

        task.wait(0.3)
        busy = false
    end)
end)

local childConn = game:GetService("Workspace").ChildAdded:Connect(function(child)
    task.wait(S.SpawnDelay)
    if S.AutoGo or S.AutoKick then
        if child:IsA("BasePart") or child:IsA("Model") then
            local n = child.Name:lower()
            if n:find("lucky") or n:find("block") then
                busy = false
            end
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    if loopConn then loopConn:Disconnect() end
    if childConn then childConn:Disconnect() end
    SG:Destroy()
end)

setStatus("Ready", Color3.fromRGB(100, 255, 100))
