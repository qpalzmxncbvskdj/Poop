local action = game.PlaceId
if action ~= 104965156633249 then
    print('wrong game dumbass')
    return
end
print('loaded')

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall
local oldIndex = mt.__index
local oldNewindex = mt.__newindex

local noop = function() end

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == LocalPlayer and typeof(method) == "string" and method:lower() == "kick" then
        return
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, key)
    if self == LocalPlayer and typeof(key) == "string" and key:lower() == "kick" then
        return noop
    end
    return oldIndex(self, key)
end)

mt.__newindex = newcclosure(function(self, key, value)
    if self == LocalPlayer and typeof(key) == "string" and key:lower() == "kick" then
        return
    end
    return oldNewindex(self, key, value)
end)

setreadonly(mt, true)
LocalPlayer.Kick = noop

local playerMT = getmetatable(LocalPlayer)
if playerMT and typeof(playerMT.__index) == "function" then
    local oldPlayerIndex = playerMT.__index
    playerMT.__index = newcclosure(function(self, key)
        if typeof(key) == "string" and key:lower() == "kick" then
            return noop
        end
        return oldPlayerIndex(self, key)
    end)
end

task.spawn(function()
    while true do
        local success, result = pcall(function()
            return LocalPlayer.Kick
        end)
        if not success or result ~= noop then
            LocalPlayer.Kick = noop
        end
        task.wait(2)
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local chargeStart = ReplicatedStorage:FindFirstChild("PoopChargeStart")
local poopEvent = ReplicatedStorage:FindFirstChild("PoopEvent")
local poopResponseChosen = ReplicatedStorage:FindFirstChild("PoopResponseChosen")

local Rayfield = loadstring(game:HttpGet('\104\116\116\112\115\58\47\47\115\105\114\105\117\115\46\109\101\110\117\47\114\97\121\102\105\101\108\100'))()
if not Rayfield then
    print('Failed to load Rayfield UI')
    return
end

local Window = Rayfield:CreateWindow({
    Name = "Xeric - Poop 💩",
    LoadingTitle = "Poop 💩 - Xeric",
    LoadingSubtitle = "by fluflu",
	Theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "xeric",
        FileName = "Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Xeric Hub",
        Subtitle = "Xeric Hub Key System",
        Note = "get key here: \104\116\116\112\115\58\47\47\100\105\115\99\111\114\100\46\103\103\47\88\115\75\120\103\102\99\82\106\113",
        FileName = "xerichubkey",
        SaveKey = true,
        GrabKeyFromSite = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\120\101\114\105\99\104\117\98\47\107\101\121\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\97\57\102\50\100\52\101\56\98\49\99\51\103\53\104\55\106\57\107\48\108\49\109\50\110\51\112\52\113\53\114\47\52\99\56\101\54\103\49\97\57\100\51\107\55\108\50\109\48\112\54\113\53\114\56\116\49\117\50\118\57\119\55\120\47\98\50\110\55\118\57\99\48\106\51\108\53\116\49\109\56\112\54\114\52\119\50\121\51\107\48\122\53\117\57\97\47\110\49\113\50\119\51\101\52\114\53\116\54\121\55\117\56\105\57\111\48\112\49\97\50\115\51\100\52\102\55\47\106\56\107\49\108\50\109\51\110\52\98\53\118\54\99\55\120\56\122\57\97\48\115\49\100\50\102\51\103\52\104\47\117\55\121\54\116\53\114\52\101\51\119\50\113\49\122\57\120\56\99\55\118\54\98\53\110\52\109\51\108\50\47\107\57\106\56\104\55\103\54\102\53\100\52\115\51\97\50\112\49\111\48\105\57\117\56\121\55\116\54\114\53\47\101\52\119\51\113\50\122\49\120\48\99\57\118\56\98\55\110\54\109\53\108\52\107\51\106\50\104\49\103\48\47\109\57\110\56\98\55\118\54\99\53\120\52\122\51\97\50\115\49\100\48\102\57\103\56\104\55\106\54\107\53\47\122\56\107\49\109\50\110\51\113\52\119\53\101\54\114\55\116\56\121\57\117\48\105\49\111\50\112\51\97\52\115\47\52\102\53\103\54\104\55\106\56\107\57\108\48\122\49\120\50\99\51\118\52\98\53\110\54\109\55\113\56\119\57\47\101\49\114\50\116\51\121\52\117\53\105\54\111\55\112\56\97\57\115\48\100\49\102\50\103\51\104\52\106\53\47\107\54\108\55\122\56\120\57\99\48\118\49\98\50\110\51\109\52\113\53\119\54\101\55\114\56\116\57\121\48\47\97\49\115\50\100\51\102\52\103\53\104\54\106\55\107\56\108\57\122\48\120\49\99\50\118\51\98\52\110\53\109\47\119\54\101\55\114\56\116\57\121\48\117\49\105\50\111\51\112\52\97\53\115\54\100\55\102\56\103\57\104\47\106\48\107\49\108\50\122\51\120\52\99\53\118\54\98\55\110\56\109\57\113\48\119\49\101\50\114\51\116\52\47\121\53\117\54\105\55\111\56\112\57\97\48\115\49\100\50\102\51\103\52\104\53\106\54\107\55\108\56\122\57\47\120\48\99\49\118\50\98\51\110\52\109\53\113\54\119\55\101\56\114\57\116\48\121\49\117\50\105\51\111\52\112\47\107\101\121",
        Key = {"\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\120\101\114\105\99\104\117\98\47\107\101\121\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\97\57\102\50\100\52\101\56\98\49\99\51\103\53\104\55\106\57\107\48\108\49\109\50\110\51\112\52\113\53\114\47\52\99\56\101\54\103\49\97\57\100\51\107\55\108\50\109\48\112\54\113\53\114\56\116\49\117\50\118\57\119\55\120\47\98\50\110\55\118\57\99\48\106\51\108\53\116\49\109\56\112\54\114\52\119\50\121\51\107\48\122\53\117\57\97\47\110\49\113\50\119\51\101\52\114\53\116\54\121\55\117\56\105\57\111\48\112\49\97\50\115\51\100\52\102\55\47\106\56\107\49\108\50\109\51\110\52\98\53\118\54\99\55\120\56\122\57\97\48\115\49\100\50\102\51\103\52\104\47\117\55\121\54\116\53\114\52\101\51\119\50\113\49\122\57\120\56\99\55\118\54\98\53\110\52\109\51\108\50\47\107\57\106\56\104\55\103\54\102\53\100\52\115\51\97\50\112\49\111\48\105\57\117\56\121\55\116\54\114\53\47\101\52\119\51\113\50\122\49\120\48\99\57\118\56\98\55\110\54\109\53\108\52\107\51\106\50\104\49\103\48\47\109\57\110\56\98\55\118\54\99\53\120\52\122\51\97\50\115\49\100\48\102\57\103\56\104\55\106\54\107\53\47\122\56\107\49\109\50\110\51\113\52\119\53\101\54\114\55\116\56\121\57\117\48\105\49\111\50\112\51\97\52\115\47\52\102\53\103\54\104\55\106\56\107\57\108\48\122\49\120\50\99\51\118\52\98\53\110\54\109\55\113\56\119\57\47\101\49\114\50\116\51\121\52\117\53\105\54\111\55\112\56\97\57\115\48\100\49\102\50\103\51\104\52\106\53\47\107\54\108\55\122\56\120\57\99\48\118\49\98\50\110\51\109\52\113\53\119\54\101\55\114\56\116\57\121\48\47\97\49\115\50\100\51\102\52\103\53\104\54\106\55\107\56\108\57\122\48\120\49\99\50\118\51\98\52\110\53\109\47\119\54\101\55\114\56\116\57\121\48\117\49\105\50\111\51\112\52\97\53\115\54\100\55\102\56\103\57\104\47\106\48\107\49\108\50\122\51\120\52\99\53\118\54\98\55\110\56\109\57\113\48\119\49\101\50\114\51\116\52\47\121\53\117\54\105\55\111\56\112\57\97\48\115\49\100\50\102\51\103\52\104\53\106\54\107\55\108\56\122\57\47\120\48\99\49\118\50\98\51\110\52\109\53\113\54\119\55\101\56\114\57\116\48\121\49\117\50\105\51\111\52\112\47\107\101\121"}
    }
})

local MainTab = Window:CreateTab("Main", nil)
local GameFeaturesSection = MainTab:CreateSection("Game Features")

local autoFarmRunning = false
local autoFarmSpeed = 0.2
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(state)
        autoFarmRunning = state
    end
})

MainTab:CreateSlider({
    Name = "Auto Farm Speed",
    Range = {0.2, 2.0},
    Increment = 0.1,
    CurrentValue = 0.2,
    Callback = function(value)
        autoFarmSpeed = value
    end
})

task.spawn(function()
    while true do
        if autoFarmRunning and chargeStart and poopEvent then
            pcall(function()
                chargeStart:FireServer()
                poopEvent:FireServer()
            end)
            task.wait(autoFarmSpeed)
        end
        task.wait(0.1)
    end
end)

local autoSellRunning = false
local autoSellTask
local sellInterval = 0.2
MainTab:CreateToggle({
    Name = "Auto Sell All",
    CurrentValue = false,
    Callback = function(state)
        autoSellRunning = state
        if autoSellTask then
            task.cancel(autoSellTask)
            autoSellTask = nil
        end
        if state and poopResponseChosen then
            autoSellTask = task.spawn(function()
                while autoSellRunning do
                    pcall(function()
                        local args = {"2. [I want to sell my inventory.]"}
                        poopResponseChosen:FireServer(unpack(args))
                    end)
                    task.wait(sellInterval > 0 and sellInterval or 1)
                end
            end)
        end
    end
})

MainTab:CreateSlider({
    Name = "Sell All Interval",
    Range = {0.2, 60},
    Increment = 0.1,
    CurrentValue = 0.2,
    Callback = function(value)
        sellInterval = value
    end
})

local antiLagRunning = false
local antiLagConnection
MainTab:CreateToggle({
    Name = "Anti-Lag",
    CurrentValue = false,
    Callback = function(state)
        antiLagRunning = state
    end
})

task.spawn(function()
    while true do
        if antiLagRunning then
            if not antiLagConnection then
                antiLagConnection = Workspace.ChildAdded:Connect(function(obj)
                    if antiLagRunning and obj.Name:lower():find("poop") then
                        pcall(function() obj:Destroy() end)
                    end
                end)
            end
        elseif antiLagConnection then
            antiLagConnection:Disconnect()
            antiLagConnection = nil
        end
        task.wait(0.1)
    end
end)

local neverLoseStreakRunning = false
local neverLoseStreakMt = getrawmetatable(game)
setreadonly(neverLoseStreakMt, false)
local originNamecall = neverLoseStreakMt.__namecall
neverLoseStreakMt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if neverLoseStreakRunning and game.PlaceId == 104965156633249 and self.Name == 'ResetStreak' and method == 'FireServer' then
        return nil
    end
    return originNamecall(self, ...)
end)
setreadonly(neverLoseStreakMt, true)

MainTab:CreateToggle({
    Name = "Never Lose Streak",
    CurrentValue = false,
    Callback = function(state)
        neverLoseStreakRunning = state
    end
})

Rayfield:LoadConfiguration()
