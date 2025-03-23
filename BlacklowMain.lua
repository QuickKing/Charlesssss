
local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/BlacklowDeveloper/Blacklow/refs/heads/main/Ui")))()
local Window = OrionLib:MakeWindow({Name = "Blacklow", HidePremium = true, SaveConfig = true, ConfigFolder = "Blacklow"})

OrionLib:MakeNotification(
    {
        Name = "Created by Zaklom ",
        Content = "Universal Script.",
        Image = "rbxassetid://4483345998",
        Time = 5
    }
)

local Tab =
    Window:MakeTab(
    {
        Name = "Player",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)


local Section =
    Tab:AddSection(
    {
        Name = "Setting player"
    }
)

local ModeWalkspeedJumpPower = "Normal"
local WalkspeedValue = 16
local JumpPowerValue = 50
local ActiveLoop = false

-- Fonction pour arrêter toutes les forces précédentes
local function ClearForces(character)
    if character and character.PrimaryPart then
        for _, force in ipairs(character.PrimaryPart:GetChildren()) do
            if force:IsA("BodyVelocity") or force:IsA("BodyForce") then
                force:Destroy()
            end
        end
    end
end

Tab:AddSlider(
    {
        Name = "Walkspeed",
        Min = 16,
        Max = 500,
        Default = 16,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "Sd",
        Callback = function(Value)
            WalkspeedValue = Value
            local player = game.Players.LocalPlayer
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            if humanoid and ModeWalkspeedJumpPower == "Normal" then
                humanoid.WalkSpeed = WalkspeedValue
            end
        end
    }
)

Tab:AddSlider(
    {
        Name = "JumpPower",
        Min = 50,
        Max = 200,
        Default = 50,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "Jp",
        Callback = function(Value)
            JumpPowerValue = Value
            local player = game.Players.LocalPlayer
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            if humanoid and ModeWalkspeedJumpPower == "Normal" then
                humanoid.JumpPower = JumpPowerValue
            end
        end
    }
)

Tab:AddDropdown(
    {
        Name = "Mode(BETA)",
        Default = "Normal",
        Options = {"Normal", "Velocity", "BodyForce", "Tp"},
        Callback = function(Value)
            ModeWalkspeedJumpPower = Value
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character or not character.PrimaryPart then
                return
            end

            -- Arrête les forces existantes avant de changer de mode
            ActiveLoop = false
            task.wait(0.1) 
            ClearForces(character)

            if ModeWalkspeedJumpPower == "Normal" then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = WalkspeedValue
                    humanoid.JumpPower = JumpPowerValue
                end
            elseif ModeWalkspeedJumpPower == "Velocity" then
                ActiveLoop = true
                task.spawn(
                    function()
                        while ActiveLoop do
                            local velocity = Instance.new("BodyVelocity")
                            velocity.Velocity = character.PrimaryPart.CFrame.LookVector * (WalkspeedValue * 5)
                            velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            velocity.Parent = character.PrimaryPart
                            task.wait(0.1) -- Met à jour toutes les 0.1 secondes
                            velocity:Destroy()
                        end
                    end
                )
            elseif ModeWalkspeedJumpPower == "BodyForce" then
                ActiveLoop = true
                task.spawn(
                    function()
                        while ActiveLoop do
                            local bodyForce = Instance.new("BodyForce")
                            bodyForce.Force =
                                character.PrimaryPart.CFrame.LookVector * (WalkspeedValue * 5) +
                                Vector3.new(0, JumpPowerValue * 100, 0)
                            bodyForce.Parent = character.PrimaryPart
                            task.wait(0.1) -- Met à jour toutes les 0.1 secondes
                            bodyForce:Destroy()
                        end
                    end
                )
            elseif ModeWalkspeedJumpPower == "Tp" then
                ActiveLoop = true
                task.spawn(
                    function()
                        while ActiveLoop do
                            local newPosition =
                                character.PrimaryPart.Position +
                                character.PrimaryPart.CFrame.LookVector * (WalkspeedValue / 5) +
                                Vector3.new(0, JumpPowerValue / 5, 0)
                            character:SetPrimaryPartCFrame(CFrame.new(newPosition))
                            task.wait(0.5) -- Met à jour toutes les 0.5 secondes
                        end
                    end
                )
            end
        end
    }
)

Tab:AddToggle(
    {
        Name = "No Gravity",
        Default = false,
        Callback = function(Value)
            if Value then
                game.Workspace.Gravity = -1
            else
                game.Workspace.Gravity = 196.2
            end
        end
    }
)

Tab:AddButton(
    {
        Name = "Reset",
        Callback = function()
            local player = game.Players.LocalPlayer
            player.Character.Humanoid.Health = 0
        end
    }
)

Tab:AddButton(
    {
        Name = "Gamemode",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/FwfNEqYz", true))()
        end
    }
)

Tab:AddButton(
    {
        Name = "Noclip",
        Callback = function()
            local Noclip = nil
            local Clip = nil

            function noclip()
                Clip = false
                local function Nocl()
                    if Clip == false and game.Players.LocalPlayer.Character ~= nil then
                        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") and v.CanCollide and v.Name ~= floatName then
                                v.CanCollide = false
                            end
                        end
                    end
                    wait(0.21)
                end
                Noclip = game:GetService("RunService").Stepped:Connect(Nocl)
            end

            function clip()
                if Noclip then
                    Noclip:Disconnect()
                end
                Clip = true
            end

            noclip()
        end
    }
)

local Tab2 =
    Window:MakeTab(
    {
        Name = "Fe Utility",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section2 =
    Tab2:AddSection(
    {
        Name = "Teleporte"
    }
)

local playerList = {}
local selectedPlayer = nil

local dropdown =
    Tab2:AddDropdown(
    {
        Name = "Player",
        Default = "Select a Player",
        Options = playerList,
        Callback = function(Value)
            selectedPlayer = Value
        end
    }
)

local function updatePlayerList()
    while wait(1) do
        playerList = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        dropdown:Refresh(playerList, true)
    end
end

spawn(updatePlayerList)

Tab2:AddButton(
    {
        Name = "Teleporte",
        Callback = function()
            local player = game.Players.LocalPlayer
            local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character then
                player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                print("Teleported to " .. targetPlayer.Name)
            else
                print("Player not found or doesn't have a character.")
            end
        end
    }
)
local Section =
    Tab2:AddSection(
    {
        Name = "Other"
    }
)
Tab2:AddButton(
    {
        Name = "Fly",
        Callback = function()
            loadstring(
                "\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10"
            )()
        end
    }
)

Tab2:AddButton(
    {
        Name = "Fe Emote(18+)",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local isR6 = character:FindFirstChild("Torso") ~= nil
            
            -- Notification Function
            local function showNotification(message)
                local notificationGui = Instance.new("ScreenGui")
                notificationGui.Name = "NotificationGui"
                notificationGui.Parent = game.CoreGui
            
                local notificationFrame = Instance.new("Frame")
                notificationFrame.Size = UDim2.new(0, 300, 0, 50)
                notificationFrame.Position = UDim2.new(0.5, -150, 1, -60)
                notificationFrame.AnchorPoint = Vector2.new(0.5, 1)
                notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 255) -- Blue color
                notificationFrame.BorderSizePixel = 0
                notificationFrame.Parent = notificationGui
            
                local uicorner = Instance.new("UICorner")
                uicorner.CornerRadius = UDim.new(0, 10)
                uicorner.Parent = notificationFrame
            
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, -20, 1, 0)
                textLabel.Position = UDim2.new(0, 10, 0, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = message .. " | by pyst"
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextSize = 18
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.Parent = notificationFrame
            
                notificationFrame.BackgroundTransparency = 1
                textLabel.TextTransparency = 1
            
                game:GetService("TweenService"):Create(
                    notificationFrame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0}
                ):Play()
            
                game:GetService("TweenService"):Create(
                    textLabel,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {TextTransparency = 0}
                ):Play()
            
                task.delay(5, function()
                    game:GetService("TweenService"):Create(
                        notificationFrame,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                        {BackgroundTransparency = 1}
                    ):Play()
            
                    game:GetService("TweenService"):Create(
                        textLabel,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                        {TextTransparency = 1}
                    ):Play()
            
                    task.delay(0.5, function()
                        notificationGui:Destroy()
                    end)
                end)
            end
            
            -- Show notification based on rig type
            if isR6 then
                showNotification("🌟 R6 detected!")
            else
                showNotification("✨ R15 detected!")
            end
            
            -- Create Screen GUI
            local gui = Instance.new("ScreenGui")
            gui.Name = "BangGui"
            gui.Parent = game.CoreGui
            
            -- Main Frame
            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 300, 0, 300)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            mainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 255) -- Deep Blue
            mainFrame.BorderSizePixel = 0
            mainFrame.Parent = gui
            
            local uicorner = Instance.new("UICorner")
            uicorner.CornerRadius = UDim.new(0, 20)
            uicorner.Parent = mainFrame
            
            -- Title
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -60, 0, 30)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "🎨 Choose a Script"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Font = Enum.Font.SourceSansBold
            title.TextSize = 24
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = mainFrame
            
            -- Close Button
            local closeButton = Instance.new("TextButton")
            closeButton.Size = UDim2.new(0, 30, 0, 30)
            closeButton.Position = UDim2.new(1, -40, 0, 0)
            closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100) -- Red
            closeButton.Text = "X"
            closeButton.Font = Enum.Font.SourceSansBold
            closeButton.TextSize = 20
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.Parent = mainFrame
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 10)
            closeCorner.Parent = closeButton
            
            closeButton.MouseButton1Click:Connect(function()
                gui:Destroy()
            end)
            
            -- Minimize Button
            local minimizeButton = Instance.new("TextButton")
            minimizeButton.Size = UDim2.new(0, 30, 0, 30)
            minimizeButton.Position = UDim2.new(1, -80, 0, 0)
            minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0) -- Orange
            minimizeButton.Text = "-"
            minimizeButton.Font = Enum.Font.SourceSansBold
            minimizeButton.TextSize = 20
            minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            minimizeButton.Parent = mainFrame
            
            local minimizeCorner = Instance.new("UICorner")
            minimizeCorner.CornerRadius = UDim.new(0, 10)
            minimizeCorner.Parent = minimizeButton
            
            local minimized = false
            minimizeButton.MouseButton1Click:Connect(function()
                minimized = not minimized
                if minimized then
                    mainFrame:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.5)
                else
                    mainFrame:TweenSize(UDim2.new(0, 300, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
                end
            end)
            
            -- Scrolling Frame
            local scrollingFrame = Instance.new("ScrollingFrame")
            scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
            scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
            scrollingFrame.BackgroundTransparency = 1
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
            scrollingFrame.ScrollBarThickness = 6
            scrollingFrame.Parent = mainFrame
            
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 10)
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.Parent = scrollingFrame
            
            -- Buttons Data
            local buttons = {
                {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
                {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
                {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
                {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
                {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
            }
            
            for _, buttonData in ipairs(buttons) do
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(0.8, 0, 0, 40)
                button.BackgroundColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255)) -- Random colors
                button.Text = buttonData.name
                button.Font = Enum.Font.SourceSansBold
                button.TextSize = 20
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Parent = scrollingFrame
            
                local uicorner = Instance.new("UICorner")
                uicorner.CornerRadius = UDim.new(0, 10)
                uicorner.Parent = button
            
                button.MouseButton1Click:Connect(function()
                    if isR6 then
                        loadstring(game:HttpGet(buttonData.r6))()
                    else
                        loadstring(game:HttpGet(buttonData.r15))()
                    end
                end)
            end
        end
    }
)

Tab2:AddButton(
    {
        Name = "ChatBypasser",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/AnnaRoblox/AnnaBypasser/refs/heads/main/AnnaBypasser.lua",
                    true
                )
            )()
        end
    }
)

Tab2:AddButton(
    {
        Name = "SurpWare(Best ChatBypasser)",
        Callback = function()
loadstring((request or http_request){Method="GET", Url="https://raw.githubusercontent.com/ThisAintComputin/SurpOfficial/refs/heads/main/surpware/bootstrapper.lua"}.Body)()
	end
    }
)

Tab2:AddButton(
    {
        Name = "AutoReport",
        Callback = function()


repeat
    task.wait()
until game:IsLoaded()

local lib = {
    ['cooldown'] = false,
    ['username'] = 'unknown',
    ['bw'] = 'unknown'
}

local words = {
    ['gay'] = 'Bullying',
    ['trans'] = 'Bullying',
    ['lgbt'] = 'Bullying',
    ['lesbian'] = 'Bullying',
    ['suicide'] = 'Bullying',
    ['cum'] = 'Swearing',
    ['f@g0t'] = 'Bullying',
    ['cock'] = 'Swearing',
    ['penis'] = 'Swearing',
    ['furry'] = 'Bullying',
    ['furries'] = 'Bullying',
    ['dick'] = 'Swearing',
    ['nigger'] = 'Bullying',
    ['bible'] = 'Bullying',
    ['nigga'] = 'Bullying',
    ['cheat'] = 'Scamming',
    ['report'] = 'Bullying',
    ['niga'] = 'Bullying',
    ['bitch'] = 'Bullying',
    ['sex'] = 'Swearing',
    ['cringe'] = 'Bullying',
    ['trash'] = 'Bullying',
    ['allah'] = 'Bullying',
    ['dumb'] = 'Bullying',
    ['idiot'] = 'Bullying',
    ['kid'] = 'Bullying',
    ['clown'] = 'Bullying',
    ['bozo'] = 'Bullying',
    ['faggot'] = 'Bullying',
    ['autist'] = 'Bullying',
    ['autism'] = 'Bullying',
    ['get a life'] = 'Bullying',
    ['nolife'] = 'Bullying',
    ['no life'] = 'Bullying',
    ['adopted'] = 'Bullying',
    ['skill issue'] = 'Bullying',
    ['muslim'] = 'Bullying',
    ['gender'] = 'Bullying',
    ['parent'] = 'Bullying',
    ['islam'] = 'Bullying',
    ['christian'] = 'Bullying',
    ['noob'] = 'Bullying',
    ['retard'] = 'Bullying',
    ['burn'] = 'Bullying',
    ['stupid'] = 'Bullying',
    ['wthf'] = 'Swearing',
    ['pride'] = 'Bullying',
    ['mother'] = 'Bullying',
    ['father'] = 'Bullying',
    ['homo'] = 'Bullying',
    ['hate'] = 'Bullying',
    ['exploit'] = 'Scamming',
    ['hack'] = 'Scamming',
    ['download'] = 'Scamming',
    ['youtube'] = 'Offsite Links',
    ['racist'] = 'Bullying',
    ['covid'] = 'Bullying',
    ['virus'] = 'Bullying',
    ['mask'] = 'Bullying',
    ['pandemic'] = 'Bullying',
    ['china'] = 'Bullying',
    ['vaccine'] = 'Bullying',
    ['politics'] = 'Bullying',
    ['trump'] = 'Bullying',
    ['biden'] = 'Bullying'
}

local players = game:GetService('Players')
local user = game:GetService('Players').LocalPlayer

function lib.notify(title, description, icon)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = description,
        Icon = icon
    })
end

function lib.report(userId, name, rs)
    if userId and lib.cooldown == false then
        lib.username = name
        local suc, er = pcall(function()
            players:ReportAbuse(players:FindFirstChild(name), rs, 'breaking TOS')
        end)
        if not suc then
            warn("Couldn't report due to the reason: " .. er .. ' | AR')
        else
            lib.notify("Nextix's Auto-Report", "Reported " .. lib.username .. ' for saying "' .. lib.bw .. '"', "rbxassetid://6023426926")
        end
        lib.cooldown = true
        task.wait(5)
        lib.username = 'unknown'
        lib.bw = 'unknown'
        lib.cooldown = false
    end
end

players.PlayerChatted:Connect(function(chatType, plr, msg)
    msg = string.lower(msg)
    if chatType ~= Enum.PlayerChatType.Whisper and plr ~= user then
        for i, v in pairs(words) do
            if string.find(msg, i) then
                lib.bw = i
                lib.report(plr.UserId, plr.Name, v)
            end
        end
    end
end)

lib.notify("Nextix's Auto-Report", "Loaded", "rbxassetid://6023426926")
        end
    }
)


Tab2:AddButton(
    {
        Name = "Super Ring v3",
        Callback = function()
            --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local SoundService = game:GetService("SoundService")
            local StarterGui = game:GetService("StarterGui")
            local TextChatService = game:GetService("TextChatService")

            local LocalPlayer = Players.LocalPlayer

            -- Sound Effects
            local function playSound(soundId)
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. soundId
                sound.Parent = SoundService
                sound:Play()
                sound.Ended:Connect(
                    function()
                        sound:Destroy()
                    end
                )
            end

            -- Play initial sound
            playSound("2865227271")

            -- GUI Creation
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "SuperRingPartsGUI"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local MainFrame = Instance.new("Frame")
            MainFrame.Size = UDim2.new(0, 220, 0, 190)
            MainFrame.Position = UDim2.new(0.5, -110, 0.5, -95)
            MainFrame.BackgroundColor3 = Color3.fromRGB(205, 170, 125) -- Light brown
            MainFrame.BorderSizePixel = 0
            MainFrame.Parent = ScreenGui

            -- Make the GUI round
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 20)
            UICorner.Parent = MainFrame

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, 0, 0, 40)
            Title.Position = UDim2.new(0, 0, 0, 0)
            Title.Text = "Super Ring Parts v3"
            Title.TextColor3 = Color3.fromRGB(101, 67, 33) -- Dark brown
            Title.BackgroundColor3 = Color3.fromRGB(222, 184, 135) -- Lighter brown
            Title.Font = Enum.Font.Fondamento -- More elegant font
            Title.TextSize = 22
            Title.Parent = MainFrame

            -- Round the title
            local TitleCorner = Instance.new("UICorner")
            TitleCorner.CornerRadius = UDim.new(0, 20)
            TitleCorner.Parent = Title

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0.8, 0, 0, 35)
            ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
            ToggleButton.Text = "Ring Parts Off"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(160, 82, 45) -- Sienna
            ToggleButton.TextColor3 = Color3.fromRGB(255, 248, 220) -- Cornsilk
            ToggleButton.Font = Enum.Font.Fondamento
            ToggleButton.TextSize = 18
            ToggleButton.Parent = MainFrame

            -- Round the toggle button
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = ToggleButton

            local DecreaseRadius = Instance.new("TextButton")
            DecreaseRadius.Size = UDim2.new(0.2, 0, 0, 35)
            DecreaseRadius.Position = UDim2.new(0.1, 0, 0.6, 0)
            DecreaseRadius.Text = "<"
            DecreaseRadius.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Saddle brown
            DecreaseRadius.TextColor3 = Color3.fromRGB(255, 248, 220) -- Cornsilk
            DecreaseRadius.Font = Enum.Font.Fondamento
            DecreaseRadius.TextSize = 18
            DecreaseRadius.Parent = MainFrame

            -- Round the decrease button
            local DecreaseCorner = Instance.new("UICorner")
            DecreaseCorner.CornerRadius = UDim.new(0, 10)
            DecreaseCorner.Parent = DecreaseRadius

            local IncreaseRadius = Instance.new("TextButton")
            IncreaseRadius.Size = UDim2.new(0.2, 0, 0, 35)
            IncreaseRadius.Position = UDim2.new(0.7, 0, 0.6, 0)
            IncreaseRadius.Text = ">"
            IncreaseRadius.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Saddle brown
            IncreaseRadius.TextColor3 = Color3.fromRGB(255, 248, 220) -- Cornsilk
            IncreaseRadius.Font = Enum.Font.Fondamento
            IncreaseRadius.TextSize = 18
            IncreaseRadius.Parent = MainFrame

            -- Round the increase button
            local IncreaseCorner = Instance.new("UICorner")
            IncreaseCorner.CornerRadius = UDim.new(0, 10)
            IncreaseCorner.Parent = IncreaseRadius

            local RadiusDisplay = Instance.new("TextLabel")
            RadiusDisplay.Size = UDim2.new(0.4, 0, 0, 35)
            RadiusDisplay.Position = UDim2.new(0.3, 0, 0.6, 0)
            RadiusDisplay.Text = "Radius: 50"
            RadiusDisplay.BackgroundColor3 = Color3.fromRGB(210, 180, 140) -- Tan
            RadiusDisplay.TextColor3 = Color3.fromRGB(101, 67, 33) -- Dark brown
            RadiusDisplay.Font = Enum.Font.Fondamento
            RadiusDisplay.TextSize = 18
            RadiusDisplay.Parent = MainFrame

            -- Round the radius display
            local RadiusCorner = Instance.new("UICorner")
            RadiusCorner.CornerRadius = UDim.new(0, 10)
            RadiusCorner.Parent = RadiusDisplay

            local Watermark = Instance.new("TextLabel")
            Watermark.Size = UDim2.new(1, 0, 0, 20)
            Watermark.Position = UDim2.new(0, 0, 1, -20)
            Watermark.Text = "Super Ring [V3] - Cracked By Projeto LKB"
            Watermark.TextColor3 = Color3.fromRGB(101, 67, 33) -- Dark brown
            Watermark.BackgroundTransparency = 1
            Watermark.Font = Enum.Font.Fondamento
            Watermark.TextSize = 14
            Watermark.Parent = MainFrame

            -- Add minimize button
            local MinimizeButton = Instance.new("TextButton")
            MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
            MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
            MinimizeButton.Text = "-"
            MinimizeButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Saddle brown
            MinimizeButton.TextColor3 = Color3.fromRGB(255, 248, 220) -- Cornsilk
            MinimizeButton.Font = Enum.Font.Fondamento
            MinimizeButton.TextSize = 18
            MinimizeButton.Parent = MainFrame

            -- Round the minimize button
            local MinimizeCorner = Instance.new("UICorner")
            MinimizeCorner.CornerRadius = UDim.new(0, 15)
            MinimizeCorner.Parent = MinimizeButton

            -- Minimize functionality
            local minimized = false
            MinimizeButton.MouseButton1Click:Connect(
                function()
                    minimized = not minimized
                    if minimized then
                        MainFrame:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
                        MinimizeButton.Text = "+"
                        ToggleButton.Visible = false
                        DecreaseRadius.Visible = false
                        IncreaseRadius.Visible = false
                        RadiusDisplay.Visible = false
                        Watermark.Visible = false
                    else
                        MainFrame:TweenSize(UDim2.new(0, 220, 0, 190), "Out", "Quad", 0.3, true)
                        MinimizeButton.Text = "-"
                        ToggleButton.Visible = true
                        DecreaseRadius.Visible = true
                        IncreaseRadius.Visible = true
                        RadiusDisplay.Visible = true
                        Watermark.Visible = true
                    end
                    playSound("12221967")
                end
            )

            -- Make GUI draggable
            local dragging
            local dragInput
            local dragStart
            local startPos

            local function update(input)
                local delta = input.Position - dragStart
                MainFrame.Position =
                    UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end

            MainFrame.InputBegan:Connect(
                function(input)
                    if
                        input.UserInputType == Enum.UserInputType.MouseButton1 or
                            input.UserInputType == Enum.UserInputType.Touch
                     then
                        dragging = true
                        dragStart = input.Position
                        startPos = MainFrame.Position

                        input.Changed:Connect(
                            function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragging = false
                                end
                            end
                        )
                    end
                end
            )

            MainFrame.InputChanged:Connect(
                function(input)
                    if
                        input.UserInputType == Enum.UserInputType.MouseMovement or
                            input.UserInputType == Enum.UserInputType.Touch
                     then
                        dragInput = input
                    end
                end
            )

            UserInputService.InputChanged:Connect(
                function(input)
                    if input == dragInput and dragging then
                        update(input)
                    end
                end
            )

            -- Ring Parts Logic
            if not getgenv().Network then
                getgenv().Network = {
                    BaseParts = {},
                    Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
                }
                Network.RetainPart = function(Part)
                    if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(workspace) then
                        table.insert(Network.BaseParts, Part)
                        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                        Part.CanCollide = false
                    end
                end
                local function EnablePartControl()
                    LocalPlayer.ReplicationFocus = workspace
                    RunService.Heartbeat:Connect(
                        function()
                            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                            for _, Part in pairs(Network.BaseParts) do
                                if Part:IsDescendantOf(workspace) then
                                    Part.Velocity = Network.Velocity
                                end
                            end
                        end
                    )
                end
                EnablePartControl()
            end

            local radius = 50
            local height = 100
            local rotationSpeed = 10
            local attractionStrength = 1000
            local ringPartsEnabled = false

            local function RetainPart(Part)
                if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
                    if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
                        return false
                    end

                    Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    Part.CanCollide = false
                    return true
                end
                return false
            end

            local parts = {}
            local function addPart(part)
                if RetainPart(part) then
                    if not table.find(parts, part) then
                        table.insert(parts, part)
                    end
                end
            end

            local function removePart(part)
                local index = table.find(parts, part)
                if index then
                    table.remove(parts, index)
                end
            end

            for _, part in pairs(workspace:GetDescendants()) do
                addPart(part)
            end

            workspace.DescendantAdded:Connect(addPart)
            workspace.DescendantRemoving:Connect(removePart)

            RunService.Heartbeat:Connect(
                function()
                    if not ringPartsEnabled then
                        return
                    end

                    local humanoidRootPart =
                        LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local tornadoCenter = humanoidRootPart.Position
                        for _, part in pairs(parts) do
                            if part.Parent and not part.Anchored then
                                local pos = part.Position
                                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                                local newAngle = angle + math.rad(rotationSpeed)
                                local targetPos =
                                    Vector3.new(
                                    tornadoCenter.X + math.cos(newAngle) * math.min(radius, distance),
                                    tornadoCenter.Y +
                                        (height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / height)))),
                                    tornadoCenter.Z + math.sin(newAngle) * math.min(radius, distance)
                                )
                                local directionToTarget = (targetPos - part.Position).unit
                                part.Velocity = directionToTarget * attractionStrength
                            end
                        end
                    end
                end
            )

            -- Button functionality
            ToggleButton.MouseButton1Click:Connect(
                function()
                    ringPartsEnabled = not ringPartsEnabled
                    ToggleButton.Text = ringPartsEnabled and "Ring Parts On" or "Ring Parts Off"
                    ToggleButton.BackgroundColor3 =
                        ringPartsEnabled and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(160, 82, 45)
                    playSound("12221967")
                end
            )

            DecreaseRadius.MouseButton1Click:Connect(
                function()
                    radius = math.max(10, radius - 5)
                    RadiusDisplay.Text = "Radius: " .. radius
                    playSound("12221967")
                end
            )

            IncreaseRadius.MouseButton1Click:Connect(
                function()
                    radius = math.min(100, radius + 5)
                    RadiusDisplay.Text = "Radius: " .. radius
                    playSound("12221967")
                end
            )

            -- Notifications
            StarterGui:SetCore(
                "SendNotification",
                {
                    Title = "Join me Discord !",
                    Text = "For More Op Scripts !",
                    Duration = 5
                }
            )

            -- Get player thumbnail
            local userId = Players:GetUserIdFromNameAsync("NannaDev")
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size420x420
            local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

            StarterGui:SetCore(
                "SendNotification",
                {
                    Title = "Enjoy Super Ring [V3]",
                    Text = "Cracked By .gg/3kZ7dKbJPe",
                    Icon = content,
                    Duration = 5
                }
            )

            -- Chat message (Updated for new chat system)
            local function SendChatMessage(message)
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    local textChannel = TextChatService.TextChannels.RBXGeneral
                    textChannel:SendAsync(message)
                else
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        message,
                        "All"
                    )
                end
            end

            -- Send the chat message
            SendChatMessage("Super Ring Parts Cracked By Projeto LKB Executed! ✨")
            SendChatMessage("Hey Yumm Original Creator Script ChatGpt Is Fire 🔥🔥🔥")
        end
    }
)

Tab2:AddButton(
    {
        Name = "Telekinesis",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/sagtdfhsdfgujh",
                    true
                )
            )()
        end
    }
)

Tab2:AddButton(
    {
        Name = "Fling",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Secret834/script/refs/heads/main/Fling", true))()
        end
    }
)

Tab2:AddButton(
    {
        Name = "Hitbox",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Biom49/Script/refs/heads/main/Hitbox", true))()
        end
    }
)
Tab2:AddButton(
    {
        Name = "Anti-bang",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            game.Workspace.FallenPartsDestroyHeight = -10000
            local originalPos = humanoidRootPart.Position
            humanoidRootPart.CFrame = CFrame.new(Vector3.new(0, -7000, 0))
            wait(0.7)
            humanoidRootPart.CFrame = CFrame.new(originalPos)
            game.Workspace.FallenPartsDestroyHeight = -5000
        end
    }
)

Tab2:AddToggle(
    {
        Name = "Fe Drone",
        Default = false,
        Callback = function(Value)
            getgenv().Active = Value
            getgenv().Deadzone = 0.1
            getgenv().Acceleration = 2
            getgenv().Deceleration = 1
            getgenv().Sensibility = 2.1
            getgenv().Maxspeed = 150
            getgenv().Collision = true
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/TheRealAsu/RbxStuff/refs/heads/main/Unviersal%20Fpv%20drone"
                )
            )()
        end
    }
)

Tab2:AddButton(
    {
        Name = "Fe bot  ",
        Callback = function()
            getgenv().Use_Displayname = true
            getgenv().bots = {"Asu_Bot1", "Asu_Bot2", "Asu_Bot3", "Asu_Bot4", "Asu_Bot5", "Asu_Bot6"} --bots
            getgenv().owner = "TheReal_Asu2"
            getgenv().nbbot = 6
            getgenv().prefix = ";"
            getgenv().botrender = false
            getgenv().printcmd = true

            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/TheRealAsu/RbxTools/refs/heads/main/Bot%20Controller%20Script"
                )
            )()
        end
    }
)

Tab2:AddButton(
    {
        Name = "Snake",
        Callback = function()
            loadstring(game:HttpGet(("https://pastefy.ga/tWBTcE4R/raw"), true))()
        end
    }
)

Tab2:AddButton(
    {
        Name = "WalkFling",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/Vf5POrA6/raw"))()
        end
    }
)




Tab2:AddButton(
    {
        Name = "Hamster ball",
        Callback = function()
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            local Camera = workspace.CurrentCamera

            local SPEED_MULTIPLIER = 30
            local JUMP_POWER = 60
            local JUMP_GAP = 0.3

            local character = game.Players.LocalPlayer.Character

            for i, v in ipairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end

            local ball = character.HumanoidRootPart
            ball.Shape = Enum.PartType.Ball
            ball.Size = Vector3.new(5, 5, 5)
            local humanoid = character:WaitForChild("Humanoid")
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = {character}

            local tc =
                RunService.RenderStepped:Connect(
                function(delta)
                    ball.CanCollide = true
                    humanoid.PlatformStand = true
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end
                    if UserInputService:IsKeyDown("W") then
                        ball.RotVelocity = Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
                    end
                    if UserInputService:IsKeyDown("A") then
                        ball.RotVelocity = Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
                    end
                    if UserInputService:IsKeyDown("S") then
                        ball.RotVelocity = Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
                    end
                    if UserInputService:IsKeyDown("D") then
                        ball.RotVelocity = Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
                    end
                    --ball.RotVelocity = ball.RotVelocity - Vector3.new(0,ball.RotVelocity.Y/50,0)
                end
            )

            UserInputService.JumpRequest:Connect(
                function()
                    local result =
                        workspace:Raycast(ball.Position, Vector3.new(0, -((ball.Size.Y / 2) + JUMP_GAP), 0), params)
                    if result then
                        ball.Velocity = ball.Velocity + Vector3.new(0, JUMP_POWER, 0)
                    end
                end
            )

            Camera.CameraSubject = ball
            humanoid.Died:Connect(
                function()
                    tc:Disconnect()
                end
            )
        end
    }
)

local TabFly =
    Window:MakeTab(
    {
        Name = "Fly",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)
local Section =
    TabFly:AddSection(
    {
        Name = "Fly Controls"
    }
)

local flySpeed = 50
local flying = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

local userInputService = game:GetService("UserInputService")
local moveDirection = Vector3.zero

local flyKeyPressed = false

TabFly:AddTextbox(
    {
        Name = "Fly Speed",
        Default = "50",
        TextDisappear = true,
        Callback = function(Value)
            local newSpeed = tonumber(Value)
            if newSpeed then
                flySpeed = newSpeed
                print("Fly speed réglé sur :", flySpeed)
            else
                warn("Valeur de vitesse invalide :", Value)
            end
        end
    }
)

TabFly:AddBind(
    {
        Name = "fly Key",
        Default = Enum.KeyCode.E,
        Hold = false,
        Callback = function()
            flying = not flying
            if flying then
                print("Vol activé par le keybind")
            else
                humanoidRootPart.Velocity = Vector3.zero
                print("Vol désactivé par le keybind")
            end
        end
    }
)

TabFly:AddToggle(
    {
        Name = "Fly",
        Default = false,
        Callback = function(Value)
            flying = Value
            if flying then
                print("Vol activé par le toggle")
            else
                humanoidRootPart.Velocity = Vector3.zero
                print("Vol désactivé par le toggle")
            end
        end
    }
)

local FlyBypass 


local FlyBypass = false

TabFly:AddToggle(
    {
        Name = "Bypass anticheat",
        Default = false,
        Callback = function(Value)
            FlyBypass = Value
        end
    }
)

game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if FlyBypass then
                humanoid.Sit = true  -- Le joueur reste assis
            else
                humanoid.Sit = false  -- Le joueur peut se lever
            end
        end
    end
end)

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Met à jour le HumanoidRootPart après la mort
end

player.CharacterAdded:Connect(onCharacterAdded)


local function flyStep(deltaTime)
    if flying and humanoidRootPart then
        local camera = workspace.CurrentCamera
        local lookDirection = camera.CFrame.LookVector

        if moveDirection.Magnitude > 0 then
            humanoidRootPart.Velocity =
                (lookDirection * moveDirection.Z + camera.CFrame.RightVector * moveDirection.X +
                Vector3.new(0, moveDirection.Y, 0)) *
                flySpeed
        else
            humanoidRootPart.Velocity = Vector3.new(0, moveDirection.Y, 0) * flySpeed
        end
    end
end

runService.RenderStepped:Connect(flyStep)

userInputService.InputBegan:Connect(
    function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then
                moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, 1) -- Avancer
            elseif input.KeyCode == Enum.KeyCode.S then
                moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, -1) -- Reculer
            elseif input.KeyCode == Enum.KeyCode.A then
                moveDirection = Vector3.new(-1, moveDirection.Y, moveDirection.Z) -- Gauche
            elseif input.KeyCode == Enum.KeyCode.D then
                moveDirection = Vector3.new(1, moveDirection.Y, moveDirection.Z) -- Droite
            elseif input.KeyCode == Enum.KeyCode.Space then
                moveDirection = Vector3.new(moveDirection.X, 1, moveDirection.Z) -- Monter
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                moveDirection = Vector3.new(moveDirection.X, -1, moveDirection.Z) -- Descendre
            end
        end
    end
)

userInputService.InputEnded:Connect(
    function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
                moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, 0) -- Arrêter d'avancer/reculer
            elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
                moveDirection = Vector3.new(0, moveDirection.Y, moveDirection.Z) -- Arrêter d'aller à gauche/droite
            elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z) -- Arrêter de monter/descendre
            end
        end
    end
)



local Tab4 =
    Window:MakeTab(
    {
        Name = "Combat",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Tab4:AddSection(
    {
        Name = "Kill Player"
    }
)

local playerList = {}
local selectedPlayer = nil

local dropdown =
    Tab4:AddDropdown(
    {
        Name = "Player",
        Default = "Select a Player",
        Options = playerList,
        Callback = function(Value)
            selectedPlayer = Value
        end
    }
)

local function updatePlayerList()
    while wait(1) do
        playerList = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        dropdown:Refresh(playerList, true)
    end
end

spawn(updatePlayerList)

Tab4:AddButton(
    {
        Name = "Kill",
        Callback = function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local targetPlayer = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player.Name == selectedPlayer then
                    targetPlayer = player
                    break
                end
            end

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local startTime = tick()
                while tick() - startTime < 1 do
                    if targetPlayer and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame
                        local newPosition = targetPosition * CFrame.new(0, 0, 3)
                        LocalPlayer.Character:SetPrimaryPartCFrame(newPosition)
                        wait(0.1)
                    else
                        break
                    end
                end
            end
        end
    }
)

local Section =
    Tab4:AddSection(
    {
        Name = "Abusive Utility"
    }
)

Tab4:AddButton(
    {
        Name = "Silent Aim",
        Callback = function()
            local player = game.Players.LocalPlayer
            local mouse = player:GetMouse()
            local targetPlayer = nil
            local targeting = false

            local function findClosestPlayer()
                local closestPlayer = nil
                local closestDistance = math.huge

                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if
                        otherPlayer ~= player and otherPlayer.Character and
                            otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                     then
                        local distance =
                            (player.Character.HumanoidRootPart.Position -
                            otherPlayer.Character.HumanoidRootPart.Position).magnitude

                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end

                return closestPlayer
            end

            mouse.Button2Down:Connect(
                function()
                    targeting = true
                    targetPlayer = findClosestPlayer()
                end
            )

            mouse.Button2Up:Connect(
                function()
                    targeting = false
                    targetPlayer = nil
                end
            )

            game:GetService("RunService").RenderStepped:Connect(
                function()
                    if
                        targeting and targetPlayer and targetPlayer.Character and
                            targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                     then
                        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                        local camera = game.Workspace.CurrentCamera

                        local direction = (targetPosition - camera.CFrame.Position).unit
                        local smoothness = 0.1
                        camera.CFrame = CFrame.new(camera.CFrame.Position + (direction * smoothness), targetPosition)
                    end
                end
            )
        end
    }
)

Tab4:AddButton(
    {
        Name = "Aimbot",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Secret834/script/refs/heads/main/Aimbot%20script"))()
        end
    }
)

Tab4:AddButton(
    {
        Name = "Autofire",
        Callback = function()
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")

            local clickInterval = 0.1 -- Temps entre chaque clic (en secondes)
            local isActive = true -- Changez à false pour arrêter le clic

            -- Fonction qui simule le clic
            local function autoclick()
                while isActive do
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    mouse1click()
                    wait(clickInterval)
                end
            end

            -- Exécuter le clic en boucle
            autoclick()
        end
    }
)

Tab4:AddToggle(
    {
        Name = "Kill All",
        Default = false,
        Callback = function(Value)
            getgenv().kill_all = Value
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function teleportBehindPlayer(targetPlayer)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame
                        local newPosition = targetPosition * CFrame.new(0, 0, 3)
                        LocalPlayer.Character:SetPrimaryPartCFrame(newPosition)
                    end
                end
            end

            spawn(
                function()
                    while true do
                        if not getgenv().kill_all then
                            wait(1)
                        end

                        for _, v in pairs(Players:GetPlayers()) do
                            if v ~= LocalPlayer and v.Character then
                                local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    local startTime = tick()
                                    while tick() - startTime < 1 do
                                        if not getgenv().kill_all then
                                            break
                                        end
                                        teleportBehindPlayer(v)
                                        wait(0.1)
                                    end
                                end
                            end
                        end
                        wait(1)
                    end
                end
            )
        end
    }
)

local Tab5 =
    Window:MakeTab(
    {
        Name = "Visual",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Tab5:AddSection(
    {
        Name = "Utility"
    }
)

Tab5:AddButton(
    {
        Name = "Esp",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
        end
    }
)

Tab5:AddButton(
    {
        Name = "Tracer",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Secret834/script/refs/heads/main/Tracer"))()
        end
    }
)

Tab5:AddButton(
    {
        Name = "Xray",
        Callback = function()
            local workspace = game:GetService("Workspace")

            local function setTransparencyForBlocks(transparency)
                for _, object in ipairs(workspace:GetDescendants()) do
                    if object:IsA("Part") then
                        object.Transparency = transparency
                    end
                end
            end

            setTransparencyForBlocks(0.8)
        end
    }
)

Tab5:AddButton(
    {
        Name = "Rtx",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Biom49/Script/refs/heads/main/Rtx"))()
        end
    }
)

Tab5:AddButton(
    {
        Name = "AntiLag",
        Callback = function()
            local decalsyeeted = true
            local g = game
            local w = g.Workspace
            local l = g.Lighting
            local t = w.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            l.GlobalShadows = false
            l.FogEnd = 9e9
            l.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            for i, v in pairs(g:GetDescendants()) do
                if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                    v.TextureID = 10385902758728957
                end
            end
            for i, e in pairs(l:GetChildren()) do
                if
                    e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or
                        e:IsA("BloomEffect") or
                        e:IsA("DepthOfFieldEffect")
                 then
                    e.Enabled = false
                end
            end
        end
    }
)

local Tab6 =
    Window:MakeTab(
    {
        Name = "Client Utility",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

Tab6:AddButton(
    {
        Name = "ChatSpamer",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/8Htx56Ab"))()
        end
    }
)

Tab6:AddButton(
    {
        Name = "Copy game",
        Callback = function()
            loadstring(
                game:HttpGet("https://raw.githubusercontent.com/Sashkandro/RobloxUniversalGameCopier/main/Script", true)
            )()
        end
    }
)

Tab6:AddButton(
    {
        Name = "Invisibility(CLIENT)",
        Callback = function()
            local sizeMultiplier = -100000000000000000000000000000000

            local players = game:GetService("Players")

            local function enlargeCharacter(character)
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Size = part.Size * sizeMultiplier
                    end
                end

                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Size = humanoidRootPart.Size * 1
                end
            end

            local function enlargeAllCharacters()
                for _, player in ipairs(players:GetPlayers()) do
                    if player.Character then
                        enlargeCharacter(player.Character)
                    end
                end
            end

            enlargeAllCharacters()

            players.PlayerAdded:Connect(
                function(player)
                    player.CharacterAdded:Connect(
                        function(character)
                            enlargeCharacter(character)
                        end
                    )
                end
            )

            players.PlayerRemoving:Connect(
                function(player)
                    if player.Character then
                        enlargeCharacter(player.Character)
                    end
                end
            )

            players.LocalPlayer.CharacterAdded:Connect(
                function(character)
                    enlargeCharacter(character)
                end
            )
        end
    }
)

Tab6:AddButton(
    {
        Name = "Give all tool",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local function giveAllToolsToPlayers()
                for _, player in pairs(Players:GetPlayers()) do
                    local backpack = player:FindFirstChildOfClass("Backpack")
                    local character = player.Character
                    for _, tool in pairs(ReplicatedStorage:GetChildren()) do
                        if tool:IsA("Tool") then
                            local hasTool = false
                            if backpack:FindFirstChild(tool.Name) or (character and character:FindFirstChild(tool.Name)) then
                                hasTool = true
                            end
                            if not hasTool then
                                local clonedTool = tool:Clone()
                                clonedTool.Parent = backpack
                            end
                        end
                    end
                end
            end

            giveAllToolsToPlayers()
        end
    }
)

Tab6:AddButton(
    {
        Name = "FlashBack",
        Callback = function()
 --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local flashbacklength = 10000
local flashbackspeed = 0.75

local name = game:GetService("RbxAnalyticsService"):GetSessionId()
local frames, LP, RS, UIS = {}, game:GetService("Players").LocalPlayer, game:GetService("RunService"), game:GetService("UserInputService")

pcall(RS.UnbindFromRenderStep, RS, name)

local function getchar()
   return LP.Character or LP.CharacterAdded:Wait()
end

local function gethrp(c)
   return c:FindFirstChild("HumanoidRootPart") or c.RootPart or c.PrimaryPart or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") or c:FindFirstChildWhichIsA("BasePart")
end

local flashback = {lastinput=false, canrevert=true}

function flashback:Advance(char, hrp, hum, allowinput)
   if #frames > flashbacklength * 60 then
       table.remove(frames, 1)
   end
   if allowinput and not self.canrevert then
       self.canrevert = true
   end
   if self.lastinput then
       hum.PlatformStand = false
       self.lastinput = false
   end
   table.insert(frames, {
       hrp.CFrame,
       hrp.Velocity,
       hum:GetState(),
       hum.PlatformStand,
       char:FindFirstChildOfClass("Tool")
   })
end

function flashback:Revert(char, hrp, hum)
   local num = #frames
   if num == 0 or not self.canrevert then
       self.canrevert = false
       self:Advance(char, hrp, hum)
       return
   end
   for i = 1, flashbackspeed do
       table.remove(frames, num)
       num = num - 1
   end
   self.lastinput = true
   local lastframe = frames[num]
   table.remove(frames, num)
   hrp.CFrame = lastframe[1]
   hrp.Velocity = -lastframe[2]
   hum:ChangeState(lastframe[3])
   hum.PlatformStand = lastframe[4]
   local currenttool = char:FindFirstChildOfClass("Tool")
   if lastframe[5] then
       if not currenttool then
           hum:EquipTool(lastframe[5])
       end
   else
       hum:UnequipTools()
   end
end

local function step()
   local char = getchar()
   local hrp = gethrp(char)
   local hum = char:FindFirstChildWhichIsA("Humanoid")
   if flashback.active then
       flashback:Revert(char, hrp, hum)
   else
       flashback:Advance(char, hrp, hum, true)
   end
end

-- UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LP:FindFirstChildOfClass("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Parent = frame

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = false
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 100)}):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)

    button.MouseButton1Click:Connect(callback)
    return button
end

local flashbackButton = createButton("Flashback", UDim2.new(0, 10, 0, 50), function()
    flashback.active = not flashback.active
    flashbackButton.Text = flashback.active and "Stop Flashback" or "Flashback"
end)

local resetButton = createButton("Reset", UDim2.new(0, 140, 0, 50), function()
    frames = {}
    flashback.active = false
    flashbackButton.Text = "Flashback"
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Flashback System"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = frame

local function animateOutline()
    local colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 0)}
    local index = 1
    while true do
        index = index % #colors + 1
        game:GetService("TweenService"):Create(uiStroke, TweenInfo.new(1), {Color = colors[index]}):Play()
        wait(1)
    end
end

spawn(animateOutline)

RS:BindToRenderStep(name, 1, step)
        end
    }
)

Tab6:AddButton(
    {
        Name = "Anchored Block",
        Callback = function()
            local function anchorBlock(block)
                if
                    block:IsA("BasePart") and not block:IsDescendantOf(game.Players) and
                        not game.Players:FindFirstChild(block.Name)
                 then
                    block.Anchored = true -- Ancre le bloc
                end
            end
            local function anchorAllBlocks()
                for _, block in pairs(workspace:GetDescendants()) do
                    anchorBlock(block)
                end
            end
            anchorAllBlocks()
        end
    }
)

Tab6:AddButton(
    {
        Name = "UnAnchored Block",
        Callback = function()
            local function anchorBlock(block)
                if
                    block:IsA("BasePart") and not block:IsDescendantOf(game.Players) and
                        not game.Players:FindFirstChild(block.Name)
                 then
                    block.Anchored = false -- Ancre le bloc
                end
            end
            local function anchorAllBlocks()
                for _, block in pairs(workspace:GetDescendants()) do
                    anchorBlock(block)
                end
            end
            anchorAllBlocks()
        end
    }
)

Tab6:AddButton(
    {
        Name = "Blackhole",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Secret834/script/refs/heads/main/Blackhole"))()
        end
    }
)

Tab6:AddButton(
    {
        Name = "Freeze Game",
        Callback = function()
            while true do
                print("Crashed")
            end
        end
    }
)

Tab6:AddButton(
    {
        Name = "Multicolor",
        Callback = function()
            local function getRandomColor()
                return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            end

            local function changeBlockColor(block)
                if block:IsA("BasePart") then
                    block.Color = getRandomColor()
                end
            end

            local function changeAllBlocksColor()
                for _, block in pairs(workspace:GetDescendants()) do
                    changeBlockColor(block)
                end
            end

            while true do
                changeAllBlocksColor()
                wait(2)
            end
        end
    }
)

Tab6:AddButton(
    {
        Name = "Teleport Tool(Ctrl-c)",
        Callback = function()
  --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Tp tool(Equip to Click TP)"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
        end
    }
)

Tab6:AddButton(
    {
        Name = "Antifling",
        Callback = function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local Player = Players.LocalPlayer

            RunService.Stepped:Connect(
                function()
                    for _, CoPlayer in pairs(Players:GetChildren()) do
                        if CoPlayer ~= Player and CoPlayer.Character then
                            for _, Part in pairs(CoPlayer.Character:GetChildren()) do
                                if Part.Name == "HumanoidRootPart" then
                                    Part.CanCollide = false
                                end
                            end
                        end
                    end

                    for _, Accessory in pairs(workspace:GetChildren()) do
                        if Accessory:IsA("Accessory") and Accessory:FindFirstChildWhichIsA("Part") then
                            Accessory:FindFirstChildWhichIsA("Part"):Destroy()
                        end
                    end
                end
            )
        end
    }
)

Tab6:AddButton(
    {
        Name = "AntiLagChat",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLag.lua"
                )
            )()
        end
    }
)

local function findRemoteEvents(parent)
    local remoteEvents = {}
    local function recursiveFind(currentParent)
        for _, obj in ipairs(currentParent:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remoteEvents, obj.Name)
            elseif obj:IsA("Folder") then
                recursiveFind(obj)
            end
        end
    end
    recursiveFind(parent)
    return remoteEvents
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function findRemoteEvents(parent)
    local remoteEvents = {}
    local function recursiveFind(currentParent)
        for _, obj in ipairs(currentParent:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remoteEvents, obj.Name)
            elseif obj:IsA("Folder") then
                recursiveFind(obj)
            end
        end
    end
    recursiveFind(parent)
    return remoteEvents
end

local Tab7 =
    Window:MakeTab(
    {
        Name = "Team",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Tab7:AddSection(
    {
        Name = "Team"
    }
)
local teamsService = game:GetService("Teams")

local function getTeamNames()
    local teamNames = {}
    for _, team in pairs(teamsService:GetChildren()) do
        table.insert(teamNames, team.Name)
    end
    return teamNames
end

Tab7:AddDropdown(
    {
        Name = "Team",
        Default = "1",
        Options = getTeamNames(),
        Callback = function(Value)
            selectedTeam = Value
        end
    }
)

Tab7:AddButton(
    {
        Name = "Join",
        Callback = function()
            local player = game.Players.LocalPlayer
            local teamToJoin = teamsService:FindFirstChild(selectedTeam)

            if teamToJoin then
                player.Team = teamToJoin
            end
        end
    }
)

Tab7:AddButton(
    {
        Name = "Delete",
        Callback = function()
            local player = game.Players.LocalPlayer
            local teamToJoin = teamsService:FindFirstChild(selectedTeam)

            if teamToJoin then
                teamToJoin:Destroy()
            end
        end
    }
)

local Tab8 =
    Window:MakeTab(
    {
        Name = "Godmode",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Tab8:AddSection(
    {
        Name = "Godmode Setting"
    }
)

Tab8:AddParagraph("Health Alert", "Health alert and if you are below a certain health point it teleports you to safety")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local alertRunning = false
local Healthalert = 50

-- function
local function Alertgodmode()
    local player = game.Players.LocalPlayer
    local teleportPosition = Vector3.new(1000, 1000, 1000)
    local character = player.Character or player.CharacterAdded:Wait()
    if character then
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local originalPosition = humanoidRootPart.Position
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        local newBlock = Instance.new("Part")
        newBlock.Size = Vector3.new(10, 1, 10)
        newBlock.Position = teleportPosition - Vector3.new(0, 5, 0)
        newBlock.Anchored = true
        newBlock.Parent = workspace
        wait(10)
        humanoidRootPart.CFrame = CFrame.new(originalPosition)
    end
end

Tab8:AddSlider(
    {
        Name = "Health Alert",
        Min = 1,
        Max = 100,
        Default = Healthalert,
        Color = Color3.fromRGB(14, 214, 11),
        Increment = 1,
        ValueName = "Health",
        Callback = function(Value)
            local Healthalert = value
        end
    }
)

Tab8:AddToggle(
    {
        Name = "Godmode Alert(Beta)",
        Default = false,
        Callback = function(value)
            alertRunning = value
        end
    }
)

while alertRunning do
    wait(0.1)
    if humanoid.Health <= Healthalert then
        if value == true then
            Alertgodmode()
        end
    end
end

local Section =
    Tab8:AddSection(
    {
        Name = "Other Godmode"
    }
)

Tab8:AddButton(
    {
        Name = "Godmode #1",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/FwfNEqYz", true))()
        end
    }
)

Tab8:AddButton(
    {
        Name = "Godmode #2",
        Callback = function()
            loadstring(game:HttpGet("https://freenote.biz/raw/Fhpx5r5A8M"))()
        end
    }
)

Tab8:AddButton(
    {
        Name = "Godmode #3",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Biom49/Script/refs/heads/main/Godmode"))()
        end
    }
)

local Gamehub =
    Window:MakeTab(
    {
        Name = "Gamehub ",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Gamehub:AddSection(
    {
        Name = "Admin"
    }
)

Gamehub:AddButton(
    {
        Name = "Nameless admin",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Infiniy yield",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Fe admin",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/ONEReverseCard/My-Scripts/main/Netless%20Server%20Admin.md"
                )
            )()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Fate admin",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Ultimate admin",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Biom49/Script/refs/heads/main/Admin"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "QuirkyCMD FE admin",
        Callback = function()
            loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))()
        end
    }
)

local Section =
    Gamehub:AddSection(
    {
        Name = "Door script"
    }
)

Gamehub:AddButton(
    {
        Name = "Door script #1",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mazzikasjjzjzj/Key/main/DOORS%20%20%5BNEW%5D"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Door script #2",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/QuickKing/byebyebye/refs/heads/main/xxxx"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Door script #3",
        Callback = function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/DOORS-FFJ-Hub-11365"))()
        end
    }
)


Gamehub:AddButton(
    {
        Name = "Door script #4",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/mspaint/main/main.lua"))()
        end
    }
)

local Section =
    Gamehub:AddSection(
    {
        Name = "brookhaven"
    }
)








Gamehub:AddButton(
    {
        Name = "brookhaven #1",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/r4mpage4/BrookHavenRP/refs/heads/main/AutoFarmCandy.lua",
                    true
                )
            )()
        end
    }
)


Gamehub:AddButton(
    {
        Name = "brookhaven #2",
        Callback = function()
            loadstring(
                game:HttpGet("https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/NormalSS.lua")
            )()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "brookhaven #3",
        Callback = function()
            loadstring(
                game:HttpGet("https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/NormalSS.lua")
            )()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "brookhaven #4",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/GYyWRWHJ"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "brookhaven #5",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RFRR1CH4RD/Loader/main/Salvatore.lua"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "brookhaven #6",
        Callback = function()
            oadstring(game:HttpGet("https://raw.githubusercontent.com/RFRR1CH4RD/Loader/main/Salvatore.lua"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "brookhaven #7",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gclich/GHUBV14XZ/main/Ghub_Main_Loader.txt"))()
        end
    }
)

local Section =
    Gamehub:AddSection(
    {
        Name = "Blade ball"
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #1",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/UPD-Blade-Ball-op-autoparry-with-visualizer-8652"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #2",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kidshop4/scriptbladeballk/main/bladeball.lua"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #3",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://paste.gg/p/anonymous/1734a4ee207844b994df2f36157afacd/files/1e79ac12fc8a47ef8263d5e9d43b7137/raw"
                )
            )()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #4",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kidshop4/scriptbladeballk/main/bladeball.lua"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #5",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/main/infernofixed"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Blade ball #6",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/-beta-/main/AutoParry.lua"))()
        end
    }
)

local Section2 =
    Gamehub:AddSection(
    {
        Name = "Lucky block battlegrounds"
    }
)

Gamehub:AddButton(
    {
        Name = "Lucky block battlegrounds #1",
        Callback = function()
            local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/BlacklowDeveloper/Blacklow/refs/heads/main/Ui")))()
            local Window = OrionLib:MakeWindow({Name = "Lucky block battlegrounds", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
            
            OrionLib:MakeNotification({
                Name = "Created by Zakolm",
                Content = "lucky block battlegrounds",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            local Tab = Window:MakeTab({
                Name = "Player",
                Icon = "rbxassetid://4483345998",
                PremiumOnly = false
            })
            
            local Section = Tab:AddSection({
                Name = "Setting player"
            })
            
            Tab:AddSlider({
                Name = "Walkspeed",
                Min = 16,
                Max = 500,
                Default = 16,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = "Sd",
                Callback = function(Value)
                    local player = game.Players.LocalPlayer
                    player.Character.Humanoid.WalkSpeed = Value
                end    
            })
            
            Tab:AddSlider({
                Name = "JumpPower",
                Min = 50,
                Max = 200,
                Default = 50,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = "Jp",
                Callback = function(Value)
                    local player = game.Players.LocalPlayer
                    player.Character.Humanoid.JumpPower = Value
                end    
            })
            
            Tab:AddToggle({
                Name = "No Gravity",
                Default = false,
                Callback = function(Value)
                    if Value then
                        game.Workspace.Gravity = -1
                    else
                        game.Workspace.Gravity = 196.2
                    end        
                end        
            })
            
            Tab:AddButton({
                Name = "Reset",
                Callback = function()
                    local player = game.Players.LocalPlayer
                    player.Character.Humanoid.Health = 0
                end    
            })
            
            
            Tab:AddButton({
                Name = "Gamemode",
                Callback = function()
                    loadstring(game:HttpGet("https://pastebin.com/raw/FwfNEqYz", true))()
                end    
            })
            
            Tab:AddButton({
                Name = "Noclip",
                Callback = function()
                    local Noclip = nil
                    local Clip = nil
                    
                    function noclip()
                        Clip = false
                        local function Nocl()
                            if Clip == false and game.Players.LocalPlayer.Character ~= nil then
                                for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                                    if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                                        v.CanCollide = false
                                    end
                                end
                            end
                            wait(0.21) 
                        end
                        Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
                    end
                    
                    function clip()
                        if Noclip then Noclip:Disconnect() end
                        Clip = true
                    end
                    
                    noclip() 
                end    
            })
            local Tab = Window:MakeTab({
                Name = "Lucky block ",
                Icon = "rbxassetid://4483345998",
                PremiumOnly = false
            })
            
            local Section = Tab:AddSection({
                Name = "Give Lucky block"
            })
            local selectluckyblock = nil
            
            local selectluckyblock 
            
            Tab:AddDropdown({
                Name = "Lucky block",
                Default = "1", 
                Options = {"SpawnDiamondBlock", "SpawnGalaxyBlock", "SpawnLuckyBlock", "SpawnRainbowBlock", "SpawnSuperBlock"},
                Callback = function(Value)
                    selectluckyblock = Value 
                end    
            })
            
            Tab:AddButton({
                Name = "Give",
                Callback = function()
                    if selectluckyblock then 
                        game.ReplicatedStorage:WaitForChild(selectluckyblock):FireServer() 
                    end
                end    
            })
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Lucky block battlegrounds #2",
        Callback = function()
            loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/Biom49/Script/refs/heads/main/Lucky%20block%20battleground2"
                )
            )()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Lucky block battlegrounds #3",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/bruhhwtf/LUCKY-BLOCKS-Battlegrounds-GUI/raw/main/Main"))()
        end
    }
)

Gamehub:AddButton(
    {
        Name = "Lucky block battlegrounds #4",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Secret834/script/refs/heads/main/Luckyblock"))()
        end
    }
)


local Section =
    Gamehub:AddSection(
    {
        Name = "Emergency hamburg"
    }
)

Gamehub:AddButton(
        {
            Name = "Airflow(BEST)",
            Callback = function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/255ac567ced3dcb9e69aa7e44c423f19.lua"))()
            end
        }
)

Gamehub:AddButton(
        {
            Name = "Beanzhub",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/pid4k/scripts/main/BeanzHub.lua", true))()
            end
        }
)


Gamehub:AddButton(
        {
            Name = "Fiber hub ",
            Callback = function()
                OrionLib:MakeNotification({
                    Name = "Copy Link",
                    Content = "Join server for script",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                }) 
                setclipboard("https://discord.gg/eZYwGdBJ")
          end
        }
)



Gamehub:AddButton(
        {
            Name = "Other script(Very bad)",
            Callback = function()
                loadstring(game:HttpGet"https://raw.githubusercontent.com/Marco8642/science/main/emergency%20hamburg")
          end
        }
)


local Section =
    Gamehub:AddSection(
    {
        Name = "Rival script"
    }
)


Gamehub:AddButton(
        {
            Name = "Venox rival v2)",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/venoxcc/universalscripts/refs/heads/main/rivals/venoxware"))()
            end
        }
)


Gamehub:AddButton(
        {
            Name = "8 bit",
            Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/8bits4ya/rivals-v3/refs/heads/main/main.lua"))()
            end
        }
)

Gamehub:AddButton(
        {
            Name = "Ronix Hub(Lite)",
            Callback = function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/51246f83a9c77b825354d5d151c63c50.lua"))()
            end
        }
)


Gamehub:AddButton(
        {
            Name = "Ronix Hub",
            Callback = function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/47fc2ea07fef3d78fb68ca87ab2b7503.lua"))()
           end
        }
)
Gamehub:AddButton(
        {
            Name = "Vanta Hub",
            Callback = function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/212c1198a1beacf31150a8cf339ba288.lua"))()
            end
        }
)

local Tab9 =
    Window:MakeTab(
    {
        Name = "Developer",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Section =
    Tab9:AddSection(
    {
        Name = "RemoteEvent"
    }
)

local remoteEvents = findRemoteEvents(ReplicatedStorage)
local selectedEventName = remoteEvents[1] or nil

Tab9:AddDropdown(
    {
        Name = "Remote Event",
        Default = selectedEventName,
        Options = remoteEvents,
        Callback = function(value)
            selectedEventName = value
        end
    }
)

Tab9:AddButton(
    {
        Name = "Execute",
        Callback = function()
            if selectedEventName then
                local remoteEvent = ReplicatedStorage:FindFirstChild(selectedEventName)
                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                    remoteEvent:FireServer()
                end
            end
        end
    }
)

Tab9:AddButton(
    {
        Name = "Simple Spy",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
            end)
            if not success then
                OrionLib:MakeNotification({
                    Name = "⚠️Exploit Not supported⚠️",
                    Content = "Your executor does not support",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    }
)


Tab9:AddButton(
    {
        Name = "Unc Test",
        Callback = function()
loadstring(game:HttpGet("https://github.com/ltseverydayyou/uuuuuuu/blob/main/UNC%20test?raw=true"))()
        end
    }
)
Tab9:AddButton(
    {
        Name = "Https Logger(Only On good Executor)",
        Callback = function()
            if not getgenv().OriginalRequest then
                getgenv().OriginalRequest = request or http_request
            end
            
            local SkibDiddyHttpSpy = Instance.new("ScreenGui")
            local MainUI = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local UICorner_2 = Instance.new("UICorner")
            local ScrollingFrame = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local bottombar = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")
            local injection = Instance.new("Frame")
            local TextButton_2 = Instance.new("TextButton")
            local UICorner_4 = Instance.new("UICorner")
            local status = Instance.new("Frame")
            local UICorner_5 = Instance.new("UICorner")
            SkibDiddyHttpSpy.Name = "SkibDiddy HttpSpy"
            SkibDiddyHttpSpy.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            SkibDiddyHttpSpy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            MainUI.Name = "MainUI"
            MainUI.Parent = SkibDiddyHttpSpy
            MainUI.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            MainUI.BackgroundTransparency = 0.100
            MainUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
            MainUI.BorderSizePixel = 0
            MainUI.Position = UDim2.new(0.32458666, 0, 0.324929982, 0)
            MainUI.Size = UDim2.new(0, 470, 0, 278)
            TextLabel.Parent = MainUI
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.BorderSizePixel = 0
            TextLabel.Size = UDim2.new(1, 0, 0.100000001, 0)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "SkibDiddy HawkTuah Spy v1"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14.000
            TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextWrapped = true
            TextButton.Parent = TextLabel
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.BackgroundTransparency = 1.000
            TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextButton.BorderSizePixel = 0
            TextButton.Position = UDim2.new(0.940891981, 0, 0, 0)
            TextButton.Size = UDim2.new(0.059107963, 0, 1, 0)
            TextButton.Font = Enum.Font.SourceSans
            TextButton.Text = "×"
            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.TextScaled = true
            TextButton.TextSize = 14.000
            TextButton.TextWrapped = true
            UICorner.Parent = TextButton
            UICorner_2.Parent = MainUI
            ScrollingFrame.Parent = MainUI
            ScrollingFrame.Active = true
            ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrollingFrame.BackgroundTransparency = 1.000
            ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.Position = UDim2.new(0, 0, 0.100000001, 0)
            ScrollingFrame.Size = UDim2.new(1, 0, 0.800000012, 0)
            UIListLayout.Parent = ScrollingFrame
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            bottombar.Name = "bottombar"
            bottombar.Parent = MainUI
            bottombar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bottombar.BackgroundTransparency = 1.000
            bottombar.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bottombar.BorderSizePixel = 0
            bottombar.Position = UDim2.new(0, 0, 0.899999976, 0)
            bottombar.Size = UDim2.new(1, 0, 0.100000001, 0)
            UICorner_3.Parent = bottombar
            injection.Name = "injection"
            injection.Parent = bottombar
            injection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            injection.BackgroundTransparency = 1.000
            injection.BorderColor3 = Color3.fromRGB(0, 0, 0)
            injection.BorderSizePixel = 0
            injection.Position = UDim2.new(0.639999986, 0, 0.125, 0)
            injection.Size = UDim2.new(0.349999994, 0, 0.75, 0)
            TextButton_2.Parent = injection
            TextButton_2.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            TextButton_2.BackgroundTransparency = 0.100
            TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextButton_2.BorderSizePixel = 0
            TextButton_2.Position = UDim2.new(0.200000003, 0, 0, 0)
            TextButton_2.Size = UDim2.new(0.800000012, 0, 1, 0)
            TextButton_2.Font = Enum.Font.Roboto
            TextButton_2.Text = "Attach"
            TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton_2.TextScaled = true
            TextButton_2.TextSize = 14.000
            TextButton_2.TextWrapped = true
            UICorner_4.Parent = TextButton_2
            status.Name = "status"
            status.Parent = injection
            status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            status.BackgroundTransparency = 0.500
            status.BorderColor3 = Color3.fromRGB(0, 0, 0)
            status.BorderSizePixel = 0
            status.Position = UDim2.new(0.075000003, 0, 0.25, 0)
            status.Size = UDim2.new(0.0649999976, 0, 0.5, 0)
            UICorner_5.CornerRadius = UDim.new(0, 360)
            UICorner_5.Parent = status
            local function QUXCXRK_fake_script()
                local script = Instance.new('LocalScript', TextButton)
                Instance.new("UIDragDetector", script.Parent.Parent.Parent)
                script.Parent.MouseButton1Click:Connect(function()
                    script.Parent.Parent.Parent.Parent:Destroy()
                    task.spawn(function()
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://18755588842"
                        sound.Parent = game.ContentProvider
                        sound:Play()
                        task.wait(1)
                        sound:Destroy()
                    end)
                end)
                script.Parent.MouseEnter:Connect(function()
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://18755583152"
                    sound.Parent = game.ContentProvider
                    sound:Play()
                    task.wait(1)
                    sound:Destroy()
                end)
            end
            coroutine.wrap(QUXCXRK_fake_script)()
            local function AKAWDCZ_fake_script()
                local script = Instance.new('LocalScript', TextButton_2)
                local UIStroke = Instance.new("UIStroke", script.Parent)
                UIStroke.Thickness = 3
                UIStroke.Transparency = 0.5
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Color = Color3.fromRGB(10,10,20)
                script.Parent.FontFace = Font.fromEnum(Enum.Font.Roboto)
                script.Parent.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://18755588842"
                        sound.Parent = game.ContentProvider
                        sound:Play()
                        task.wait(1)
                        sound:Destroy()
                    end)
                    local function addItem(text, ltype)
                        local item = Instance.new("TextButton", script.Parent.Parent.Parent.Parent.ScrollingFrame)
                        item.BackgroundTransparency = 1
                        item.Size = UDim2.new(1,0,0.025,0)
                        item.TextColor3 = Color3.new(1,1,1)
                        item.TextScaled = true
                        item.Text = "Log at "..tostring(os.date("%X")).." - Log type: "..ltype.." (Click to copy code)"
                        item.MouseButton1Click:Connect(function()
                            task.spawn(function()
                                local sound = Instance.new("Sound")
                                sound.SoundId = "rbxassetid://18755588842"
                                sound.Parent = game.ContentProvider
                                sound:Play()
                                task.wait(1)
                                sound:Destroy()
                            end)
                            setclipboard(text)
                        end)
                        item.MouseEnter:Connect(function()
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://18755583152"
                            sound.Parent = game.ContentProvider
                            sound:Play()
                            task.wait(1)
                            sound:Destroy()
                        end)
                    end
                    local function parseValue(v)
                        return v:gsub("'", ("'"):byte()):gsub("`", ("`"):byte())
                    end
                    local function parseTable2(...)
                        local output = ""
                        for i,v in pairs(...) do
                            if typeof(v) == "string" then
                                v = parseValue(v)
                            end
                            if typeof(v) == "table" then
                                output=output.."['"..tostring(i).."']="..parseTable2(v)..",\n\t"
                            else
                                output=output.."['"..tostring(i).."']='"..tostring(v).."',\n\t"
                            end
                        end
                        return "{\n\t"..output.."}"
                    end
                    local function parseTable(...)
                        local output = ""
                        for i,v in pairs(...) do
                            if typeof(v) == "string" then
                                print()
                                v = parseValue(v)
                            end
                            if typeof(v) == "table" then
                                output=output..tostring(i).."="..parseTable2(v)..",\n\t"
                            else
                                output=output..tostring(i).."='"..tostring(v).."',\n\t"
                            end
                        end
                        return "{\n\t"..output.."}"
                    end
                    getgenv().request = function(...)
                        addItem("request("..parseTable(...)..")", "HttpRequest ("..(script.Name)..")")
                        if (...).Url:find("webhook") then
                            addItem((...).Url, "Webhook Flagged")
                        end
                        if (...).Url:find("ipinfo") then
                            addItem((...).Url, "Ip Logger Flagged")
                        end
                        if (...).Url:find("key") then
                            addItem((...).Url, "Possible Key system Url Flagged")
                        end
                        return getgenv().OriginalRequest(...)
                    end
                    getgenv().http_request = function(...)
                        addItem("http_request("..parseTable(...)..")", "HttpRequest ("..(script.Name)..")")
                        if (...).Url:find("webhook") then
                            addItem((...).Url, "Webhook Flagged")
                        end
                        if (...).Url:find("ipinfo") then
                            addItem((...).Url, "Ip Logger Flagged")
                        end
                        if (...).Url:find("key") then
                            addItem((...).Url, "Possible Key system Url Flagged")
                        end
                        return getgenv().OriginalRequest(...)
                    end
                    getgenv().http.request = function(...)
                        addItem("http.request("..parseTable(...)..")", "HttpRequest ("..(script.Name)..")")
                        if (...).Url:find("webhook") then
                            addItem((...).Url, "Webhook Flagged")
                        end
                        if (...).Url:find("ipinfo") then
                            addItem((...).Url, "Possible Ip Logger Flagged")
                        end
                        if (...).Url:find("key") then
                            addItem((...).Url, "Possible Key system Url Flagged")
                        end
                        return getgenv().OriginalRequest(...)
                    end
                    if not getgenv().RealLoadstring then
                        getgenv().RealLoadstring = loadstring
                    end
                    local realLoadstring = getgenv().RealLoadstring
                    getgenv().loadstring = function(...)
                        addItem(..., "Function Trace ("..(script.Name)..")")
                        return realLoadstring(...)
                    end
                    getgenv().InjectionTester = function()
                        script.Parent.Parent.status:FindFirstChild("StatusValue").Value = 1
                    end
                end)
                script.Parent.MouseEnter:Connect(function()
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://18755583152"
                    sound.Parent = game.ContentProvider
                    sound:Play()
                    task.wait(1)
                    sound:Destroy()
                end)
            end
            coroutine.wrap(AKAWDCZ_fake_script)()
            local function YJOJ_fake_script()
                local script = Instance.new('LocalScript', status)
                local StatusValue = Instance.new("IntValue", script.Parent)
                StatusValue.Name = "StatusValue"
                StatusValue.Value = 0
                while task.wait(1) do
                    if getgenv then
                        if getgenv().InjectionTester then
                            local suc, err = pcall(function()
                                getgenv().InjectionTester()
                                if StatusValue.Value == 1 then
                                    script.Parent.BackgroundColor3 = Color3.new(0,1,0)
                                else
                                    script.Parent.BackgroundColor3 = Color3.new(1,0,0)
                                end
                                StatusValue.Value = 0
                            end)
                            if not suc then
                                warn(err)
                                script.Parent.BackgroundColor3 = Color3.new(1,0,0)
                            end
                        else
                            script.Parent.BackgroundColor3 = Color3.new(1,0,0)
                        end
                    else
                        script.Parent.BackgroundColor3 = Color3.new(1,0,0)
                    end
                end
            end
            coroutine.wrap(YJOJ_fake_script)()
            local function MVFWNHF_fake_script()
                local script = Instance.new('LocalScript', MainUI)
                local UIStroke = Instance.new("UIStroke", script.Parent)
                UIStroke.Thickness = 3
                UIStroke.Transparency = 0.5
                UIStroke.Color = Color3.fromRGB(10,10,20)
                script.Parent.Parent.Parent = (game.CoreGui or game:GetService("CoreGui"))
            end
            coroutine.wrap(MVFWNHF_fake_script)()
            if not success then
                OrionLib:MakeNotification({
                    Name = "⚠️Exploit Not supported⚠️",
                    Content = "Your executor does not support",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                
            end
        end
    }
)


Tab9:AddButton(
    {
        Name = "Emote Logger",
        Callback = function()
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.315, 0, 0.4, 0)
frame.Position = UDim2.new(0.350, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Draggable = true
frame.Active = true

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1.0017, 0, 0, 30)
topBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -365, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Animation Logger"
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 20
titleLabel.Parent = topBar

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = frame
scrollFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = scrollFrame
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

local loggedAnimations = {}
local isCopyingAsLinkEnabled = false
local originalColor = Color3.new(0.2, 0.2, 0.2)
local toggleColor = Color3.new(0, 1, 0)

local function logAnimation(animationName, animationId)
    if loggedAnimations[animationId] then
        return
    end
    
    loggedAnimations[animationId] = true
    
    local numericId = tonumber(animationId:match("%d+"))

    local logEntry = Instance.new("TextButton")
    logEntry.Size = UDim2.new(1, -10, 0, 60)
    logEntry.BackgroundColor3 = originalColor
    local linkStatus = isCopyingAsLinkEnabled and "Enabled" or "Disabled"
    logEntry.Text = string.format("%s\nAnimation ID: %d\nCopy as link: %s", animationName, numericId, linkStatus)
    logEntry.TextWrapped = true
    logEntry.Font = Enum.Font.SourceSans
    logEntry.TextColor3 = Color3.new(1, 1, 1)
    logEntry.TextSize = 22
    logEntry.Parent = scrollFrame

    logEntry.MouseButton1Click:Connect(function()
        if isCopyingAsLinkEnabled then
            local link = "https://www.roblox.com/library/" .. numericId
            setclipboard(link)
        else
            setclipboard(tostring(numericId))
        end
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y)
end

logLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y)
end)

local function onAnimationPlayed(animationTrack)
    local animation = animationTrack.Animation
    if animation then
        local animationId = animation.AnimationId
        local animationName = animation.Name or "Unknown Animation"
        logAnimation(animationName, animationId, isCopyingAsLinkEnabled)
    end
end

local function trackPlayerAnimations()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.AnimationPlayed:Connect(onAnimationPlayed)
end

trackPlayerAnimations()

local xButton = Instance.new("TextButton")
xButton.Size = UDim2.new(0, 30, 0, 30)
xButton.Position = UDim2.new(1, -30, 0, 0)
xButton.BackgroundColor3 = Color3.new(1, 0, 0)
xButton.Text = "X"
xButton.TextColor3 = Color3.new(1, 1, 1)
xButton.TextSize = 24
xButton.Font = Enum.Font.SourceSans
xButton.BackgroundTransparency = 1
xButton.Parent = topBar

xButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.new(0, 0, 1)
minimizeButton.Text = "–"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 24
minimizeButton.Font = Enum.Font.SourceSans
minimizeButton.BackgroundTransparency = 1
minimizeButton.Parent = topBar

local additionalGUI = Instance.new("Frame")
additionalGUI.Size = UDim2.new(0.5, 0, 1, 0)
additionalGUI.Position = UDim2.new(-0.53, 0, 0, 0)
additionalGUI.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
additionalGUI.BorderSizePixel = 0
additionalGUI.Visible = false
additionalGUI.Parent = frame

local settingsTopBar = Instance.new("Frame")
settingsTopBar.Size = UDim2.new(1, 0, 0, 30)
settingsTopBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
settingsTopBar.BorderSizePixel = 0
settingsTopBar.Parent = additionalGUI

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 0, 30)
settingsLabel.Position = UDim2.new(0, 0, 0, 0)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings"
settingsLabel.Font = Enum.Font.SourceSans
settingsLabel.TextColor3 = Color3.new(1, 1, 1)
settingsLabel.TextSize = 20
settingsLabel.Parent = additionalGUI

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.95, 0, 0, 30)
clearButton.Position = UDim2.new(0.023, 0, 0, 40)
clearButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
clearButton.Text = "Clear All"
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.TextSize = 18
clearButton.Font = Enum.Font.SourceSans
clearButton.Parent = additionalGUI

local optionalSettingToggle = Instance.new("TextButton")
optionalSettingToggle.Size = UDim2.new(0.95, 0, 0, 30)
optionalSettingToggle.Position = UDim2.new(0.023, 0, 0, 80)
optionalSettingToggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
optionalSettingToggle.Text = "Copy as link"
optionalSettingToggle.TextColor3 = Color3.new(1, 1, 1)
optionalSettingToggle.TextSize = 18
optionalSettingToggle.Font = Enum.Font.SourceSans
optionalSettingToggle.Parent = additionalGUI

local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(0.002, 0, 0, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://11932591062"
toggleButton.Parent = topBar

toggleButton.MouseButton1Click:Connect(function()
    additionalGUI.Visible = not additionalGUI.Visible
end)

local isMinimized = false
local originalSize = frame.Size
local originalTitlePosition = titleLabel.Position

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeButton.Text = "+"
        frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 30)
scrollFrame.Visible = false
        additionalGUI.Visible = false
        toggleButton.Visible = false
        titleLabel.Position = UDim2.new(originalTitlePosition.X.Scale, originalTitlePosition.X.Offset - 20, originalTitlePosition.Y.Scale, originalTitlePosition.Y.Offset)
    else
        minimizeButton.Text = "–"
        frame.Size = originalSize
        scrollFrame.Visible = true
        toggleButton.Visible = true
        titleLabel.Position = originalTitlePosition
    end
end)

clearButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    loggedAnimations = {}
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

local function toggleOptionalSetting()
    isCopyingAsLinkEnabled = not isCopyingAsLinkEnabled
    optionalSettingToggle.BackgroundColor3 = isCopyingAsLinkEnabled and toggleColor or originalColor
    print("Copying as link " .. (isCopyingAsLinkEnabled and "enabled" or "disabled"))
end

optionalSettingToggle.MouseButton1Click:Connect(toggleOptionalSetting)

local function onAnimationPlayed(animationTrack)
    local animation = animationTrack.Animation
    if animation then
        local animationId = animation.AnimationId
        local animationName = animation.Name or "Unknown Animation"
        logAnimation(animationName, animationId)
    end
end

local function trackPlayerAnimations()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.AnimationPlayed:Connect(onAnimationPlayed)
end

trackPlayerAnimations()
        end
    }
)

Tab9:AddButton(
    {
        Name = "Sound logger",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/Charleseeeeeeeeeeeeeee/Charlesssss/refs/heads/main/SoundyGrabber'))()
            end)
            if not success then
                OrionLib:MakeNotification({
                    Name = "⚠️Exploit Not supported⚠️",
                    Content = "Your executor does not support"..err,
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    }
)


Tab9:AddButton(
    {
        Name = "Hydroxide(value changer,remoteEvent ect )",
        Callback = function()
            local success, err = pcall(function()
                local owner = "Upbolt"
                local branch = "revision"
                
                local function webImport(file)
                    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
                end
                
                webImport("init")
                webImport("ui/main")
            end)
            if not success then
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "An error occurred: " .. err .. ". The error code please send to the discord.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    }
)


local Section =
    Tab9:AddSection(
    {
        Name = "Kick"
    }
)

local MessageKick = "Kick message"

Tab9:AddTextbox(
    {
        Name = "Message",
        Default = "Kick message",
        TextDisappear = true,
        Callback = function(Value)
            MessageKick = Value
        end
    }
)

Tab9:AddButton(
    {
        Name = "Kick",
        Callback = function()
            local Player = game.Players.LocalPlayer
            Player:Kick(MessageKick)
        end
    }
)

Tab9:AddButton(
    {
        Name = "Kick(Fake message)",
        Callback = function()
            local Player = game.Players.LocalPlayer
            Player:Kick("Rate Limite")
        end
    }
)

Tab9:AddButton(
    {
        Name = "ResetLocal(ServerHop)",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local gameId = game.PlaceId
            TeleportService:Teleport(gameId, player)
        end
    }
)

local TabInfo =
    Window:MakeTab(
    {
        Name = "Info",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    }
)

local Credit =
    TabInfo:AddSection(
    {
        Name = "Credit"
    }
)

Credit:AddParagraph("Developer", "Zaklom")
Credit:AddParagraph("Ui", "Zaklom")
