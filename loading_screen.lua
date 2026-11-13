
-- Elysium Loader - Fixed Version (Will NOT crash)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local loaderGui = nil
local isLoaderVisible = false
local rotatingElements = {}
local stopAnimations = false

-- Utility functions
local function createRoundedCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function createStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

local function createGradient(instance, colors, rotation)
    local gradient = Instance.new("UIGradient")
    local colorPoints = {}
    
    for i, colorData in ipairs(colors) do
        table.insert(colorPoints, ColorSequenceKeypoint.new(colorData[1], colorData[2]))
    end
    
    gradient.Color = ColorSequence.new(colorPoints)
    gradient.Rotation = rotation or 0
    gradient.Parent = instance
    return gradient
end

-- UI Creation
local function createLoaderUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ElysiumLoader"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 99999999
    screenGui.Parent = CoreGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(6, 4, 14)
    background.BorderSizePixel = 0
    background.BackgroundTransparency = 1
    background.Parent = screenGui
    
    createGradient(background, {
        {0, Color3.fromRGB(12, 8, 26)},
        {1, Color3.fromRGB(4, 3, 9)}
    }, 130)
    
    -- Animated Scanline
    local scanline = Instance.new("Frame")
    scanline.Size = UDim2.new(1, 0, 0, 1)
    scanline.Position = UDim2.new(0, 0, 0, 0)
    scanline.BackgroundColor3 = Color3.fromRGB(150, 90, 255)
    scanline.BackgroundTransparency = 0.84
    scanline.BorderSizePixel = 0
    scanline.ZIndex = 2
    scanline.Parent = background
    
    local dialogSize = UDim2.new(0, 480, 0, 340)
    local dialogPosition = UDim2.new(0.5, 0, 0.5, 0)
    
    local dialog = Instance.new("Frame")
    dialog.AnchorPoint = Vector2.new(0.5, 0.5)
    dialog.Position = dialogPosition
    dialog.Size = dialogSize
    dialog.BackgroundColor3 = Color3.fromRGB(11, 8, 22)
    dialog.BorderSizePixel = 0
    dialog.ClipsDescendants = true
    dialog.Visible = false
    dialog.Parent = background
    
    createRoundedCorner(dialog, 16)
    createStroke(dialog, Color3.fromRGB(110, 60, 210), 1, 0.4)
    createGradient(dialog, {
        {0, Color3.fromRGB(20, 14, 40)},
        {1, Color3.fromRGB(8, 5, 18)}
    }, 145)
    
    -- Top Accent Line
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 3
    accentLine.Parent = dialog
    
    createGradient(accentLine, {
        {0, Color3.fromRGB(60, 30, 150)},
        {0.5, Color3.fromRGB(195, 135, 255)},
        {1, Color3.fromRGB(60, 30, 150)}
    }, 0)
    
    -- Logo Container
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 34, 0, 34)
    logoContainer.Position = UDim2.new(0, 18, 0, 16)
    logoContainer.BackgroundTransparency = 1
    logoContainer.ZIndex = 3
    logoContainer.Parent = dialog
    
    local logoOuter = Instance.new("Frame")
    logoOuter.Size = UDim2.new(1, 0, 1, 0)
    logoOuter.BackgroundTransparency = 1
    logoOuter.ZIndex = 3
    logoOuter.Parent = logoContainer
    
    createRoundedCorner(logoOuter, 34)
    createStroke(logoOuter, Color3.fromRGB(185, 125, 255), 2.5, 0.05)
    
    local logoInner = Instance.new("Frame")
    logoInner.Size = UDim2.new(0.54, 0, 0.54, 0)
    logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
    logoInner.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoInner.BackgroundTransparency = 1
    logoInner.ZIndex = 3
    logoInner.Parent = logoContainer
    
    createRoundedCorner(logoInner, 34)
    createStroke(logoInner, Color3.fromRGB(150, 90, 230), 1.5, 0.25)
    
    local logoLine = Instance.new("Frame")
    logoLine.Size = UDim2.new(0, 50, 0, 2)
    logoLine.AnchorPoint = Vector2.new(0.5, 0.5)
    logoLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoLine.BackgroundColor3 = Color3.fromRGB(225, 195, 255)
    logoLine.BorderSizePixel = 0
    logoLine.Rotation = -22
    logoLine.ZIndex = 4
    logoLine.Parent = logoContainer
    
    createRoundedCorner(logoLine, 34)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 155, 0, 22)
    title.Position = UDim2.new(0, 60, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = "ELYSIUM"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 19
    title.TextColor3 = Color3.fromRGB(244, 236, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = dialog
    
    -- Version Badge
    local versionBadge = Instance.new("Frame")
    versionBadge.Size = UDim2.new(0, 122, 0, 14)
    versionBadge.Position = UDim2.new(0, 60, 0, 40)
    versionBadge.BackgroundColor3 = Color3.fromRGB(75, 38, 165)
    versionBadge.BorderSizePixel = 0
    versionBadge.ZIndex = 3
    versionBadge.Parent = dialog
    
    createRoundedCorner(versionBadge, 4)
    
    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(1, 0, 1, 0)
    versionText.BackgroundTransparency = 1
    versionText.Text = "BYPASS ENGINE  v3.2"
    versionText.Font = Enum.Font.GothamBold
    versionText.TextSize = 9
    versionText.TextColor3 = Color3.fromRGB(205, 178, 255)
    versionText.ZIndex = 4
    versionText.Parent = versionBadge
    
    -- Avatar Container
    local avatarContainer = Instance.new("Frame")
    avatarContainer.Size = UDim2.new(0, 68, 0, 68)
    avatarContainer.AnchorPoint = Vector2.new(1, 0)
    avatarContainer.Position = UDim2.new(1, -18, 0, 12)
    avatarContainer.BackgroundTransparency = 1
    avatarContainer.ZIndex = 3
    avatarContainer.Parent = dialog
    
    local avatarBorder = Instance.new("Frame")
    avatarBorder.Size = UDim2.new(1, 0, 1, 0)
    avatarBorder.BackgroundTransparency = 1
    avatarBorder.ZIndex = 3
    avatarBorder.Parent = avatarContainer
    
    createRoundedCorner(avatarBorder, 34)
    
    local avatarStroke = createStroke(avatarBorder, Color3.fromRGB(210, 155, 255), 3, 0)
    createGradient(avatarStroke, {
        {0, Color3.fromRGB(210, 155, 255)},
        {0.45, Color3.fromRGB(105, 50, 195)},
        {1, Color3.fromRGB(45, 12, 100)}
    }, 0)
    
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0.76, 0, 0.76, 0)
    avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarImage.BackgroundColor3 = Color3.fromRGB(20, 13, 40)
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.ZIndex = 4
    avatarImage.Parent = avatarContainer
    
    createRoundedCorner(avatarImage, 34)
    
    -- Load avatar
    pcall(function()
        local thumbnail = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        if thumbnail then
            avatarImage.Image = thumbnail
        end
    end)
    
    -- Separator Line
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -36, 0, 1)
    separator.Position = UDim2.new(0, 18, 0, 62)
    separator.BackgroundColor3 = Color3.fromRGB(50, 30, 90)
    separator.BorderSizePixel = 0
    separator.ZIndex = 3
    separator.Parent = dialog
    
    -- Status Text
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -110, 0, 18)
    statusText.Position = UDim2.new(0, 18, 0, 71)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Initializing bypass engine..."
    statusText.Font = Enum.Font.GothamMedium
    statusText.TextSize = 12
    statusText.TextColor3 = Color3.fromRGB(160, 142, 200)
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.ZIndex = 3
    statusText.Parent = dialog
    
    -- Progress Percentage
    local progressPercent = Instance.new("TextLabel")
    progressPercent.Size = UDim2.new(0, 75, 0, 18)
    progressPercent.AnchorPoint = Vector2.new(1, 0)
    progressPercent.Position = UDim2.new(1, -18, 0, 71)
    progressPercent.BackgroundTransparency = 1
    progressPercent.Text = "0.0%"
    progressPercent.Font = Enum.Font.GothamBold
    progressPercent.TextSize = 13
    progressPercent.TextColor3 = Color3.fromRGB(175, 118, 255)
    progressPercent.TextXAlignment = Enum.TextXAlignment.Right
    progressPercent.ZIndex = 3
    progressPercent.Parent = dialog
    
    -- Progress Bar Container
    local progressBarBg = Instance.new("Frame")
    progressBarBg.Size = UDim2.new(1, -36, 0, 5)
    progressBarBg.Position = UDim2.new(0, 18, 0, 93)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(22, 15, 44)
    progressBarBg.BorderSizePixel = 0
    progressBarBg.ZIndex = 3
    progressBarBg.Parent = dialog
    
    createRoundedCorner(progressBarBg, 5)
    
    -- Progress Bar Fill
    local progressBarFill = Instance.new("Frame")
    progressBarFill.Size = UDim2.new(0, 0, 1, 0)
    progressBarFill.BackgroundColor3 = Color3.fromRGB(148, 88, 252)
    progressBarFill.BorderSizePixel = 0
    progressBarFill.ZIndex = 4
    progressBarFill.Parent = progressBarBg
    
    createRoundedCorner(progressBarFill, 5)
    createGradient(progressBarFill, {
        {0, Color3.fromRGB(95, 48, 205)},
        {0.6, Color3.fromRGB(170, 108, 255)},
        {1, Color3.fromRGB(218, 178, 255)}
    }, 0)
    
    -- Log Scrolling Frame
    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Size = UDim2.new(1, -36, 0, 148)
    logFrame.Position = UDim2.new(0, 18, 0, 106)
    logFrame.BackgroundColor3 = Color3.fromRGB(5, 3, 12)
    logFrame.BorderSizePixel = 0
    logFrame.ScrollBarThickness = 3
    logFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 48, 155)
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logFrame.ZIndex = 3
    logFrame.Parent = dialog
    
    createRoundedCorner(logFrame, 8)
    createStroke(logFrame, Color3.fromRGB(50, 30, 88), 1, 0.4)
    
    local logLayout = Instance.new("UIListLayout")
    logLayout.Padding = UDim.new(0, 1)
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logLayout.Parent = logFrame
    
    local logPadding = Instance.new("UIPadding")
    logPadding.PaddingLeft = UDim.new(0, 10)
    logPadding.PaddingRight = UDim.new(0, 6)
    logPadding.PaddingTop = UDim.new(0, 7)
    logPadding.PaddingBottom = UDim.new(0, 7)
    logPadding.Parent = logFrame
    
    -- Discord Banner
    local discordBanner = Instance.new("Frame")
    discordBanner.Size = UDim2.new(1, -36, 0, 40)
    discordBanner.Position = UDim2.new(0, 18, 1, -52)
    discordBanner.BackgroundColor3 = Color3.fromRGB(13, 9, 28)
    discordBanner.BackgroundTransparency = 1
    discordBanner.BorderSizePixel = 0
    discordBanner.ZIndex = 3
    discordBanner.Parent = dialog
    
    createRoundedCorner(discordBanner, 10)
    
    local discordStroke = createStroke(discordBanner, Color3.fromRGB(76, 45, 140), 1, 1)
    
    local discordIcon = Instance.new("TextLabel")
    discordIcon.Size = UDim2.new(0, 20, 0, 20)
    discordIcon.Position = UDim2.new(0, 10, 0.5, -10)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Text = "🌐"
    discordIcon.Font = Enum.Font.Gotham
    discordIcon.TextSize = 14
    discordIcon.TextColor3 = Color3.fromRGB(150, 120, 205)
    discordIcon.TextTransparency = 1
    discordIcon.ZIndex = 4
    discordIcon.Parent = discordBanner
    
    local discordText = Instance.new("TextLabel")
    discordText.Size = UDim2.new(0, 200, 1, 0)
    discordText.Position = UDim2.new(0, 36, 0, 0)
    discordText.BackgroundTransparency = 1
    discordText.Text = "Join Elysium! discord.gg/3lysium"
    discordText.Font = Enum.Font.GothamMedium
    discordText.TextSize = 12
    discordText.TextColor3 = Color3.fromRGB(170, 124, 255)
    discordText.TextXAlignment = Enum.TextXAlignment.Left
    discordText.TextTransparency = 1
    discordText.ZIndex = 4
    discordText.Parent = discordBanner
    
    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, 60, 0, 24)
    copyButton.AnchorPoint = Vector2.new(1, 0.5)
    copyButton.Position = UDim2.new(1, -10, 0.5, 0)
    copyButton.BackgroundColor3 = Color3.fromRGB(112, 62, 205)
    copyButton.BackgroundTransparency = 1
    copyButton.Text = "COPY"
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextSize = 11
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.TextTransparency = 1
    copyButton.BorderSizePixel = 0
    copyButton.AutoButtonColor = false
    copyButton.ZIndex = 4
    copyButton.Parent = discordBanner
    
    createRoundedCorner(copyButton, 6)
    
    -- Button hover effects
    copyButton.MouseEnter:Connect(function()
        TweenService:Create(copyButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(148, 92, 252)
        }):Play()
    end)
    
    copyButton.MouseLeave:Connect(function()
        TweenService:Create(copyButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(112, 62, 205)
        }):Play()
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/3lysium")
        end
        copyButton.Text = "✓ COPIED"
        task.delay(1.5, function()
            if copyButton and copyButton.Parent then
                copyButton.Text = "COPY"
            end
        end)
    end)
    
    -- Show discord banner after delay
    task.delay(math.random(150, 180), function()
        local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(discordBanner, tweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(discordStroke, tweenInfo, {Transparency = 0.42}):Play()
        TweenService:Create(discordIcon, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(discordText, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(copyButton, tweenInfo, {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()
    end)
    
    -- Animation functions
    local logCounter = 0
    local function addLogEntry(message, color)
        logCounter = logCounter + 1
        local logEntry = Instance.new("TextLabel")
        logEntry.LayoutOrder = logCounter
        logEntry.Size = UDim2.new(1, 0, 0, 16)
        logEntry.BackgroundTransparency = 1
        logEntry.Text = message
        logEntry.Font = Enum.Font.Code
        logEntry.TextSize = 11
        logEntry.TextColor3 = color or Color3.fromRGB(145, 128, 188)
        logEntry.TextXAlignment = Enum.TextXAlignment.Left
        logEntry.ZIndex = 4
        logEntry.Parent = logFrame
        
        task.defer(function()
            if logFrame and logFrame.Parent then
                logFrame.CanvasPosition = Vector2.new(0, logFrame.AbsoluteCanvasSize.Y)
            end
        end)
    end
    
    -- Show UI with animation
    local uiReady = false
    task.defer(function()
        RunService.RenderStepped:Wait()
        dialog.Parent = background
        dialog.Visible = true
        dialog.Size = UDim2.new(0, 0, 0, 0)
        
        TweenService:Create(background, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
        
        TweenService:Create(dialog, TweenInfo.new(0.44, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = dialogSize,
            Position = dialogPosition
        }):Play()
        
        uiReady = true
        isLoaderVisible = true
    end)
    
    -- Rotation animation for avatar border
    task.spawn(function()
        while not stopAnimations do
            task.wait(0.03)
            if uiReady then
                if avatarBorder then
                    avatarBorder.Rotation = (avatarBorder.Rotation + 2) % 360
                end
                local gradient = avatarStroke:FindFirstChildOfClass("UIGradient")
                if gradient then
                    gradient.Rotation = (gradient.Rotation + 2) % 360
                end
            end
        end
    end)
    
    -- Animate scanline
    task.spawn(function()
        while not stopAnimations and screenGui and screenGui.Parent do
            scanline.Position = UDim2.new(0, 0, -0.01, 0)
            TweenService:Create(scanline, TweenInfo.new(4.5, Enum.EasingStyle.Linear), {
                Position = UDim2.new(0, 0, 1.01, 0)
            }):Play()
            task.wait(4.5)
        end
    end)
    
    -- Progress simulation data
    local logMessages = {
        {pct = 0, msg = "> Enumerating anti-cheat modules...", color = Color3.fromRGB(136, 118, 184)},
        {pct = 7, msg = "> Scanning memory map [0x0000 – 0xFFFF]...", color = Color3.fromRGB(136, 118, 184)},
        {pct = 14, msg = "> Detected: Elysium AC build 2140 — intercepting...", color = Color3.fromRGB(212, 162, 255)},
        {pct = 21, msg = "> Hook table relocated → 0xC0FFEE44", color = Color3.fromRGB(136, 118, 184)},
        {pct = 29, msg = "> Signature spoof layer: ACTIVE", color = Color3.fromRGB(115, 245, 155)},
        {pct = 36, msg = "> Restoring original opcode stream...", color = Color3.fromRGB(136, 118, 184)},
        {pct = 44, msg = "> Injecting __newindex detour...", color = Color3.fromRGB(212, 162, 255)},
        {pct = 52, msg = "> Integrity checksum cleared (0x00000000)", color = Color3.fromRGB(115, 245, 155)},
        {pct = 60, msg = "> WARNING: heartbeat probe triggered — suppressing", color = Color3.fromRGB(255, 192, 85)},
        {pct = 68, msg = "> Re-routing event dispatcher...", color = Color3.fromRGB(136, 118, 184)},
        {pct = 76, msg = "> Spoof layer stable — monitor silent.", color = Color3.fromRGB(115, 245, 155)},
        {pct = 84, msg = "> Finalizing payload delivery...", color = Color3.fromRGB(212, 162, 255)},
        {pct = 92, msg = "> All modules bypassed. Loader armed.", color = Color3.fromRGB(115, 245, 155)}
    }
    
    local statusMessages = {
        {pct = 0, txt = "Initializing bypass engine..."},
        {pct = 9, txt = "Mapping Elysium AC footprint..."},
        {pct = 19, txt = "Patching hook table..."},
        {pct = 31, txt = "Spoofing client signature..."},
        {pct = 45, txt = "Restoring execution flow..."},
        {pct = 58, txt = "Suppressing heartbeat probes..."},
        {pct = 69, txt = "Applying detour patches..."},
        {pct = 80, txt = "Clearing integrity checksums..."},
        {pct = 89, txt = "Finalizing environment..."},
        {pct = 95, txt = "Loader ready — standing by."}
    }
    
    local maxProgress = 100
    local currentProgress = 0
    local loggedPcts = {}
    local lastStatusPct = -1
    
    local startTime = os.clock()
    local rampUpDuration = 8
    local rampDownDuration = 12
    
    local function getTargetProgress()
        local elapsed = math.clamp((os.clock() - startTime) / (rampUpDuration + rampDownDuration), 0, 1)
        return maxProgress * elapsed
    end
    
    -- Progress animation
    task.spawn(function()
        while not stopAnimations do
            local target = getTargetProgress()
            currentProgress = math.clamp(target, 0, maxProgress)
            
            if currentProgress >= maxProgress then
                currentProgress = maxProgress
                progressPercent.Text = "100.0%"
                
                TweenService:Create(progressBarFill, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {
                    Size = UDim2.new(1, 0, 1, 0)
                }):Play()
                
                statusText.Text = "Loader ready — standing by."
                addLogEntry("> Loader ready. Waiting for game signal...", Color3.fromRGB(115, 245, 155))
                break
            end
            
            progressPercent.Text = string.format("%.1f", currentProgress) .. "%"
            
            TweenService:Create(progressBarFill, TweenInfo.new(0.28, Enum.EasingStyle.Sine), {
                Size = UDim2.new(currentProgress / 100, 0, 1, 0)
            }):Play()
            
            -- Update status text
            for i = #statusMessages, 1, -1 do
                local msg = statusMessages[i]
                if currentProgress >= msg.pct and msg.pct > lastStatusPct then
                    lastStatusPct = msg.pct
                    statusText.Text = msg.txt
                    break
                end
            end
            
            -- Add log messages
            for _, msg in ipairs(logMessages) do
                if currentProgress >= msg.pct and not loggedPcts[msg.pct] then
                    loggedPcts[msg.pct] = true
                    addLogEntry(msg.msg, msg.color)
                end
            end
            
            task.wait(0.1)
        end
    end)
    
    return screenGui
end

-- Disable CoreGui and cleanup existing loader
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

pcall(function()
    local existingLoader = CoreGui:FindFirstChild("ElysiumLoader")
    if existingLoader then
        existingLoader:Destroy()
    end
end)

-- Initialize loader
loaderGui = createLoaderUI()

-- Keep loader alive (never ends, just stays visible)
while loaderGui and loaderGui.Parent do
    task.wait(1)
end
