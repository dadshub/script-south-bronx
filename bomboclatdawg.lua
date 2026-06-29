if getgenv().Multifarm then return end
getgenv().Multifarm = true

if LPH_OBFUSCATED == nil then
    local assert = assert
    local type   = type
    local G      = getgenv()
    local function encnum(toEncrypt, ...)
        assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
        return toEncrypt
    end
    local function encstr(toEncrypt, ...)
        assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
        return toEncrypt
    end
    local function jit(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
        return f
    end
    local function novirt(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
        return f
    end
    local function noupv(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
        return f
    end
    local function crash(...)
        assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
        game:Shutdown()
        while true do end
    end
    rawset(G, "LPH_ENCNUM",        encnum)
    rawset(G, "LPH_NUMENC",        encnum)
    rawset(G, "LPH_ENCSTR",        encstr)
    rawset(G, "LPH_STRENC",        encstr)
    rawset(G, "LPH_JIT",           jit)
    rawset(G, "LPH_JIT_MAX",       jit)
    rawset(G, "LPH_NO_VIRTUALIZE", novirt)
    rawset(G, "LPH_NO_UPVALUES",   noupv)
    rawset(G, "LPH_CRASH",         crash)
end

local LoadStart = os.clock()

local ok, val = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/k7gi/poopo/refs/heads/main/thegoat.lua"))()
end)

if not ok or val ~= "ImKindaGay" then
    return
end

repeat task.wait() until game:IsLoaded()
if not game:GetService("Players").LocalPlayer.Character then
    game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
end

local fireproximityprompt = fireproximityprompt
local Players             = cloneref(game:GetService("Players")) or game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local LogService          = cloneref(game:GetService("LogService"))
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local MemoryStoreService  = cloneref(game:GetService("MemoryStoreService")) or game:GetService("MemoryStoreService")
local Workspace           = game:GetService("Workspace")
local TeleportService     = game:GetService("TeleportService")
local RPC             = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RPC")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")

local Player         = Players.LocalPlayer
repeat task.wait() until Player.Character
local PlayerGui      = Player:WaitForChild("PlayerGui")
local Character      = Player.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

local function GetHumanoid()
    local c = Player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function EquipTool(tool)
    local h = GetHumanoid()
    if h and tool then h:EquipTool(tool) end
end
local function UnequipTools()
    local h = GetHumanoid()
    if h then h:UnequipTools() end
end
local Random = Random.new()

if getgenv().AutoRejoinerEnabled then
    task.spawn(function()
        local IntroUI = PlayerGui:WaitForChild("IntroUI", 30)
        if not IntroUI then return end
        local SurfaceGui = IntroUI:FindFirstChild("SurfaceGui")
        if not SurfaceGui then return end
        local Frame = SurfaceGui:FindFirstChild("Frame")
        if not Frame then return end
        local PlayButton = Frame:FindFirstChild("Play")
        if not PlayButton then return end
        task.wait(15)
        repeat
            pcall(function()
                getconnections(PlayButton.MouseButton1Click)[1]:Fire()
            end)
            task.wait(0.25)
        until not PlayerGui:FindFirstChild("IntroUI")
    end)
end

print("doing emulator...")
loadstring(game:HttpGet("https://pastefy.app/1Z1uZck7/raw"))()

repeat task.wait() until HyphonReady == true

-- ========================================
-- LIBRARY
-- ========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"))()
Library.MenuKeybind = tostring(Enum.KeyCode.Z)

-- ========================================
-- SAVEMANAGER & THEMEMANAGER
-- ========================================

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"))()
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("ExileConfigs")  -- Change to your desired config folder name

local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"))()
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("ExileThemes")  -- Change to your desired themes folder name

-- ========================================
-- CONFIGURATION
-- ========================================

local Configuration = {
    Main_Settings = {
        ["Autofarming"]       = false,
        ["Auto Anti Death"]   = true,
        ["Auto Rejoiner"]     = true,
        ["Performance Saver"] = false,
    },
    Statistics = {
        ["Times Rejoined"]    = 0,
        ["Runtime"]           = 0,
        ["Cash Made"]         = 0,
        ["Chips Fed"]         = 0,
        ["Cards Swiped"]      = 0,
        ["Marshmallows Sold"] = 0,
    },
    Goal_Settings = {
        ["Enabled"]       = false,
        ["Target Amount"] = 250000,
    },
    Webhook_Settings = {
        ["Send Webhooks"]     = false,
        ["Webhook Intervals"] = 5,
        ["Webhook Url"]       = "",
    },
    State = {
        ["Status"]      = "Idle",
        ["BikeSitting"] = false,
        ["BikeSpawned"] = false,
        ["IsHealing"]   = false,
        ["Apartment"]   = nil,
    },

}

local Locations = {
    SafeZone      = Vector3.new(-478.840, 24.000,  389.200),
    HotChipsMan   = Vector3.new( -41.000,  3.000,  -25.000),
    FakeID        = Vector3.new(217.841, 4.727, -331.714),
    BuyMarsh      = Vector3.new(510.817, 4.581, 601.048),
    BuyPotato     = Vector3.new(-759.197, 3.489, -194.846),
    ApplyForCard  = Vector3.new( -49.210,  4.000, -310.810),
    CollectCard   = Vector3.new( -39.090,  5.392, -329.700),
    SkiMask       = Vector3.new(-366.980,  3.528, -320.630),
    Healing       = Vector3.new(-769.000,  6.000,  654.000),
    Clipboard     = Vector3.new(-477.803, 4.855, -435.559),
    PotatoCutter  = Vector3.new(-456.320,  3.870, -466.840),
    PlasticBagLab = Vector3.new(-456.280,  3.654, -472.670),
    FlourBowl     = Vector3.new(-494.640,  3.579, -518.580),
}

local Labatory = Workspace.Map.Locations["The Laboratory"]

local Stove, CookPrompt, StoveTimer
local AvailablePot, PotPrompt, PotTimer

for _, Object in pairs(getgc(true)) do
    if typeof(Object) == "table" and typeof(rawget(Object, "Homeless")) == "table" then
        if rawget(Object.Homeless, "MaxDistance") then
            Object.Homeless.MaxDistance = 9e9
        end
    end
end

local function GetCommaValue(n)
    local s = tostring(math.floor(n))
    while true do
        local result, count = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = result
        if count == 0 then break end
    end
    return s
end

local function FormatRuntime(seconds)
    return string.format("%02d:%02d:%02d",
        math.floor(seconds / 3600),
        math.floor((seconds % 3600) / 60),
        seconds % 60
    )
end

local function GetCurrentCashAmount()
    local ok, n = pcall(function()
        return tonumber((PlayerGui.Main.Money.Amount.Text:gsub("%D+", ""))) or 0
    end)
    return (ok and n) or 0
end

local function GetCurrentCash()
    local n = GetCurrentCashAmount()
    if n > 0 then return "$" .. GetCommaValue(n) end
    return "N/A"
end

local function GetCharName()
    local ok, result = pcall(function()
        return Player.Character.Head:WaitForChild("NameTag", 5).MainFrame.NameLabel.Text
    end)
    return (ok and result) or "N/A"
end

local function GetETA()
    if not Configuration.Goal_Settings["Enabled"] then return "N/A" end
    local runtime    = Configuration.Statistics["Runtime"]
    local cashMade   = Configuration.Statistics["Cash Made"]
    if runtime <= 0 or cashMade <= 0 then return "N/A" end
    local remaining = Configuration.Goal_Settings["Target Amount"] - GetCurrentCashAmount()
    if remaining <= 0 then return "Goal Reached" end
    return FormatRuntime(math.floor(remaining / (cashMade / runtime)))
end

local function WaitForReady()
    repeat task.wait() until Configuration.Main_Settings["Autofarming"]
end

local function DoRejoin()
    if not Configuration.Main_Settings["Auto Rejoiner"] then return end
    Configuration.Main_Settings["Autofarming"] = false
    Configuration.Statistics["Times Rejoined"] += 1
    queue_on_teleport([[
        queue_on_teleport("task.wait(15)\ngetgenv().AutoRejoinerEnabled = true\nloadstring(game:HttpGet('https://pastefy.app/drlp4KfE/raw'))()")
    ]])
    TeleportService:Teleport(10179538382)
end

local function ScavengeInventory()
    UnequipTools()
    local Backpack = Player:WaitForChild("Backpack")
    local Potato, Flour, Water, Gelatin, SugarBlockBag = 0, 0, 0, 0, 0
    for _, Object in next, Backpack:GetChildren() do
        if Object.Name == "Potato"          then Potato       += 1 end
        if Object.Name == "Flour"           then Flour        += 1 end
        if Object.Name == "Water"           then Water        += 1 end
        if Object.Name == "Gelatin"         then Gelatin      += 1 end
        if Object.Name == "Sugar Block Bag" then SugarBlockBag += 1 end
    end
    return Potato, Flour, Water, Gelatin, SugarBlockBag
end

local function FindAvailableApartments()
    local Available, Owned = {}, {}
    local Apartments       = { "WH1", "BH3", "BH2", "BH4", "BH1", "LT1" }
    local CasinoApartments = { "Home 1", "Home 2", "Home 3", "Home 4" }
    for _, Object in next, Workspace:WaitForChild("Map").APTS:GetChildren() do
        if Object:IsA("Model") and (table.find(Apartments, tostring(Object)) or table.find(CasinoApartments, tostring(Object))) then
            local Board = Object:FindFirstChild("Board", true)
            if Board then
                local Text = Board.name.SurfaceGui.TextLabel.Text
                if Text == "VACANT" then
                    table.insert(Available, Object)
                elseif Text == Player.Name then
                    table.insert(Owned, Object)
                end
            end
        end
    end
    if #Owned >= 1 then return Owned, "Owned" end
    return Available, "Not Owned"
end

local function FindAvailableATMs()
    for _, ATM in next, Workspace:WaitForChild("Map").ATMS:GetChildren() do
        if ATM:FindFirstChild("ATMScreen").Transparency == 0 then
            return ATM
        end
    end
end

local function FindAvailableHomeless()
    local Available = {}
    for _, Object in next, Workspace.Folders.HomelessPeople:GetChildren() do
        if Object:IsA("Model") then
            local Leg = Object:FindFirstChild("RightLowerLeg")
            if Leg and math.floor(Leg.Rotation.X) == 90 then
                table.insert(Available, Object)
            end
        end
    end
    return Available
end

local function SpawnAndSitOnBike()
    local BikeName     = string.format("%s's Car", Player.Name)
    local ExistingBike = Workspace:FindFirstChild(BikeName)

    if ExistingBike and ExistingBike:FindFirstChild("DriveSeat") and ExistingBike.DriveSeat.Occupant then
        Configuration.State["Status"]      = "[ BIKE ] : Already on bike"
        Configuration.State["BikeSitting"] = true
        Configuration.State["BikeSpawned"] = true
        return true
    end

    Configuration.State["Status"] = "[ BIKE ] : Spawning bike..."
    local Bike = Workspace:FindFirstChild(BikeName)

    if not Bike then
        RPC:FireServer(buffer.fromstring("\001"), "Spawn", "DirtBike")
        local SpawnStart = os.clock()
        repeat task.wait(0.1) until Workspace:FindFirstChild(BikeName) or (os.clock() - SpawnStart) > 4
        Bike = Workspace:FindFirstChild(BikeName)
    end

    if not Bike then
        Configuration.State["Status"] = "[ BIKE ] : Bike not found after spawn!"
        return false
    end

    local DriveSeat = Bike:WaitForChild("DriveSeat")

    Configuration.SpawningBike = true

    UnequipTools()
    Configuration.State["RespawnPending"] = true
    HumanoidRootPart.CFrame = CFrame.new(67^2, 10^10, 67^2)
    Player.CharacterAdded:Wait()
    Character        = Player.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local TargetCFrame = DriveSeat.CFrame * CFrame.new(3, 1, 0)
    task.wait(2)
    for _ = 1, 5 do
        HumanoidRootPart.CFrame = TargetCFrame
        task.wait(0.05)
    end
    task.wait(2.5)

    Configuration.SpawningBike = false

    if (HumanoidRootPart.Position - Bike:FindFirstChildWhichIsA("Part", true).Position).Magnitude > 25 then
        Configuration.State["RespawnPending"] = false
        Configuration.State["Status"] = "[ BIKE ] : Failed to teleport to bike!"
        return false
    end

    local Prompt = DriveSeat:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not Prompt then
        local Attachment = DriveSeat:FindFirstChild("Attachment")
        if Attachment then Prompt = Attachment:FindFirstChild("ProximityPrompt") end
    end

    if Prompt then
        Prompt.HoldDuration          = 0
        Prompt.RequiresLineOfSight   = false
        Prompt.MaxActivationDistance = 9e9
        fireproximityprompt(Prompt)
    end

    task.wait(1)
    Configuration.State["RespawnPending"] = false
    Configuration.State["Status"]      = "[ BIKE ] : Sitting on bike!"
    Configuration.State["BikeSitting"] = true
    Configuration.State["BikeSpawned"] = true
    return true
end

local function DirtBikeTeleport(TargetPosition)
    local c = Player.Character
    if not c then return false end

    local h = c:FindFirstChild("Humanoid")
    if not h then return false end

    if not h.SeatPart then
        Configuration.State["Status"] = "[ BIKE ] : Not on bike, attempting to re-sit..."
        if not SpawnAndSitOnBike() then return false end
        task.wait(0.3)
    end

    local DriveSeat = h.SeatPart
    if not DriveSeat or DriveSeat.Name ~= "DriveSeat" then return false end

    local Vehicle = DriveSeat.Parent
    if not Vehicle then return false end

    Vehicle:PivotTo(CFrame.new(TargetPosition))
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = false end
    end
    task.wait(0.51)
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = true end
    end

    return true
end

local function cekDarah(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    
    hum.HealthChanged:Connect(function(hp)
        if not Configuration.Main_Settings["Auto Anti Death"] then return end
        if Configuration.State["RespawnPending"] then return end
        
        if hp > 0 and hp < 95 then
            Configuration.State["Status"] = "[ ANTI-DEATH ] : Taking damage, teleporting to safe zone!"
            DirtBikeTeleport(Locations.Healing)

        end
    end)
end

if Player.Character then
    cekDarah(Player.Character)
end

local function StartMarshmallowFarm()
    WaitForReady()
    Configuration.State["Status"] = "[ APARTMENTS ] : Finding an apartment."
    local Apartments, Ownership = FindAvailableApartments()
    if #Apartments == 0 then
        Configuration.State["Status"] = "[ APARTMENTS ] : None available."
        return false
    end

    local Apartment = Ownership == "Owned" and Apartments[1] or Apartments[Random:NextInteger(1, #Apartments)]
    local IsHome    = tostring(Apartment):match("Home")
    if IsHome then
        Configuration.State["Apartment"] = Workspace.Map.Locations.Apartments:FindFirstChild(tostring(Apartment))
    else
        Configuration.State["Apartment"] = Workspace.Map.Houses:FindFirstChild(tostring(Apartment))
    end


    if Ownership == "Not Owned" then
        local Board  = Apartment:FindFirstChild("Board", true)
        local Prompt = Board.backboard.ProximityPrompt
        Prompt.MaxActivationDistance = 9e9
        WaitForReady()
        DirtBikeTeleport(Board.backboard.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Purchasing apartment."
        fireproximityprompt(Prompt)
        task.wait(2)
        local BoardText = Board.name.SurfaceGui.TextLabel.Text
        if BoardText ~= tostring(Player) then
            return StartMarshmallowFarm()
        end
    end

    local Lock       = Apartment.Door.DoorLock
    local KnobPrompt = Apartment.Door.Interact.Attachment.ProximityPrompt

    if math.abs(Lock.Part.Rotation.Y) > 5 and math.abs(Lock.Part.Rotation.Y - 90) > 5 then
        WaitForReady()
        KnobPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Closing door."
        task.wait(0.5)
        local CloseAttempts = 0
        repeat
            fireproximityprompt(KnobPrompt)
            task.wait(1)
            CloseAttempts += 1
        until math.abs(Lock.Part.Rotation.Y) < 5 or CloseAttempts >= 10
        task.wait(0.5)
    end

    if Lock.Part.Rotation.X ~= 90 then
        WaitForReady()
        local LockPrompt = Lock.Part.ProximityPrompt
        LockPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Locking door."
        task.wait(0.5)
        local LockAttempts = 0
        repeat
            fireproximityprompt(LockPrompt)
            task.wait(0.5)
            LockAttempts += 1
        until Lock.Part.Rotation.X == 90 or LockAttempts >= 10
        if Lock.Part.Rotation.X ~= 90 then
            return StartMarshmallowFarm()
        end
    end

    Configuration.State["Status"] = "[ APARTMENTS ] : Apartment secured."
    return true
end

local function PurchaseMarshmallowIngredients()
    WaitForReady()
    local _, _, Water, Gelatin, SugarBlockBag = ScavengeInventory()
    if Water >= 1 and Gelatin >= 1 and SugarBlockBag >= 1 then
        return true
    end
    local MarshRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    DirtBikeTeleport(Locations.BuyMarsh)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Buying ingredients."
    task.wait(0.5)
    if Water < 1         then MarshRemote:FireServer("Water")           task.wait(0.5) end
    if Gelatin < 1       then MarshRemote:FireServer("Gelatin")         task.wait(0.5) end
    if SugarBlockBag < 1 then MarshRemote:FireServer("Sugar Block Bag") task.wait(0.5) end
    return true
end

local function PourWater()
    WaitForReady()
    local AptObj = Configuration.State["Apartment"]
    if tostring(AptObj):match("Home") then
        Stove = AptObj:FindFirstChild("Cooking Pot")
    else
        Stove = AptObj:WaitForChild("Interior"):FindFirstChild("Cooking Pot")
    end
    CookPrompt = Stove:FindFirstChild("Attachment").ProximityPrompt
    StoveTimer  = Stove:FindFirstChild("Timer").TextLabel

    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Pouring water."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Water"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Water")
        or PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 0
        or Safety >= 10
    local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
    if notif == "You do not have permission to cook in this apartment." then
        return false
    end
    return true
end

local function AddSugarAndGelatin()
    WaitForReady()
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Adding sugar."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag")
        or Safety >= 5

    Configuration.State["Status"] = "[ MARSHMALLOW ] : Adding gelatin."
    Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Gelatin"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Gelatin")
        or PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Let")
        or Safety >= 5
end

local function BagMarshmallowAndSell()
    WaitForReady()
    Configuration.State["Status"] = "[ WAITING ] : Waiting for marshmallow to finish."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until StoveTimer and StoveTimer.Text == "0"
    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Bagging."
    repeat
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag"))
        task.wait(0.5)
        fireproximityprompt(CookPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
    until Player:WaitForChild("Backpack"):FindFirstChild("Small Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Medium Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Large Marshmallow Bag")

    repeat WaitForReady() DirtBikeTeleport(Locations.BuyMarsh) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")

    Configuration.State["Status"] = "[ MARSHMALLOW ] : Selling."
    local LamontBell   = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")
    local LamontPrompt = LamontBell.UpperTorso.ProximityPrompt
    UnequipTools()
    for _, Object in next, Player:WaitForChild("Backpack"):GetChildren() do
        if tostring(Object):find("Marshmallow") then
            WaitForReady()
            DirtBikeTeleport(Locations.BuyMarsh)
            EquipTool(Player:WaitForChild("Backpack"):FindFirstChild(tostring(Object)))
            task.wait(0.5)
            fireproximityprompt(LamontPrompt)
            task.wait(0.5)
        end
    end
    Configuration.Statistics["Marshmallows Sold"] += 1
end

local function BuySkiMask()
    WaitForReady()
    local CurrentChar = Player.Character
    if not CurrentChar then return end
    if CurrentChar:FindFirstChild("SkiMask") then
        return
    end

    if not Player:WaitForChild("Backpack"):FindFirstChild("SkiMask") then
        Configuration.State["Status"] = "[ SETUP ] : Buying ski mask."
        local SkiMaskRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
        DirtBikeTeleport(Locations.SkiMask)
        task.wait(0.5)
        repeat
            SkiMaskRemote:FireServer("SkiMask")
            task.wait(0.5)
        until Player:WaitForChild("Backpack"):FindFirstChild("SkiMask")
    end

    EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("SkiMask"))
    task.wait(0.05)
    RPC:FireServer(buffer.fromstring("\005"), Player.Character:WaitForChild("SkiMask"))
    task.wait(0.05)
    UnequipTools()
end

local function PurchasePotatoIngredients()
    WaitForReady()
    local Potato, Flour = ScavengeInventory()
    if Potato >= 1 and Flour >= 1 then
        return true
    end
    local PotatoRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Buying ingredients."
    DirtBikeTeleport(Locations.BuyPotato)
    task.wait(0.5)
    if Flour < 1  then PotatoRemote:FireServer("Flour")  task.wait(0.5) end
    if Potato < 1 then PotatoRemote:FireServer("Potato") task.wait(0.5) end
    return true
end

local function StartPotatoJob()
    WaitForReady()
    local Clipboard       = Labatory.Prompts.Clipboard
    local ClipboardPrompt = Clipboard.ProximityPrompt
    ClipboardPrompt.MaxActivationDistance = 9e9
    DirtBikeTeleport(Locations.Clipboard)
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Claiming task."
    task.wait(0.5)
    local Attempts = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.Clipboard)
        task.wait(0.25)
        fireproximityprompt(ClipboardPrompt)
        task.wait(0.5)
        Attempts += 1
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Task:")
        or PlayerGui:WaitForChild("Main").BasicNotification.Text == "You have already began your task."
end

local function CutPotato()
    WaitForReady()
    local PotatoCutter = Labatory["Cutting Boards"]:FindFirstChild("Potato Cutter").Model.Union
    local CutterPrompt = PotatoCutter.Attachment.ProximityPrompt
    CutterPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Cutting potato."
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PotatoCutter)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Potato"))
        task.wait(0.25)
        fireproximityprompt(CutterPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
        local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Potato")
        or notif == "You are at the wrong step."
        or Safety >= 20
end

local function BagPotato()
    WaitForReady()
    local PlasticBag = Labatory.Prompts["Plastic Bag"]
    local BagPrompt  = PlasticBag.Attachment.ProximityPrompt
    BagPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Bagging potato."
    if Player:WaitForChild("Backpack"):FindFirstChild("Potato") then
        return
    end
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PlasticBagLab)
        task.wait(0.25)
        fireproximityprompt(BagPrompt)
        task.wait(0.5)
        Safety += 1
        if Safety >= 15 then
            break
        end
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Head")
end

local function MixFlourAndPotato()
    WaitForReady()
    local Bowl       = Labatory.Bowls:FindFirstChildOfClass("UnionOperation")
    local BowlPrompt = Bowl.ProximityPrompt
    BowlPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Mixing flour and potato."
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.FlourBowl)
        task.wait(0.25)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Flour"))
        task.wait(0.25)
        fireproximityprompt(BowlPrompt)
        task.wait(0.5)
        UnequipTools()
        Safety += 1
        if Safety >= 15 then
            break
        end
    until not Player:WaitForChild("Backpack"):FindFirstChild("Flour") or Safety >= 15
    task.wait(3.5)
end

local function CookPotatoChips()
    WaitForReady()
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Starting cook."
    AvailablePot = nil
    for _, Object in next, Labatory.Pots:GetChildren() do
        if AvailablePot then break end
        if Object:IsA("UnionOperation") then
            local Safety = 0
            repeat
                WaitForReady()
                DirtBikeTeleport(Object.Position)
                fireproximityprompt(Object.ProximityPrompt)
                task.wait(0.05)
                Safety += 1
            until PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 0 or Safety >= 120
            local Notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
            if Notif == "This pot is in use." then
                repeat task.wait() until PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 1
            elseif Notif == "You have 120 seconds to retrieve your product out of the pot when its done." then
                AvailablePot = Object
                PotTimer     = Object.Timer.TextLabel
                PotPrompt    = Object.ProximityPrompt
            end
        end
    end
    return AvailablePot ~= nil
end

local function ClaimPotatoChipsAndSell()
    WaitForReady()
    Configuration.State["Status"] = "[ WAITING ] : Waiting for potato chips to finish."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until PotTimer and PotTimer.Text == "0"

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Claiming from pot."
    repeat
        WaitForReady()
        DirtBikeTeleport(AvailablePot.Position)
        fireproximityprompt(PotPrompt)
        task.wait(0.5)
    until Player:WaitForChild("Backpack"):FindFirstChild("Potato Chips")

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Converting to hot chips."
    repeat WaitForReady() DirtBikeTeleport(Locations.HotChipsMan) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")

    local PoorGuy       = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")
    local PoorGuyPrompt = PoorGuy.UpperTorso.ProximityPrompt
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.HotChipsMan)
        fireproximityprompt(PoorGuyPrompt)
        UnequipTools()
        task.wait(0.05)
    until Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips")

    task.wait(3)

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Giving to homeless."
    local AvailableHomeless = FindAvailableHomeless()
    if #AvailableHomeless == 0 then return false end

    for _, HomelessRef in next, AvailableHomeless do
        if not Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips") then break end
        local HomelessName = tostring(HomelessRef)
        repeat WaitForReady() DirtBikeTeleport(HomelessRef:FindFirstChild("UpperTorso").Position) task.wait(0.05)
        until Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local Homeless   = Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local UpperTorso = Homeless:FindFirstChild("UpperTorso")
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips"))
        task.wait(0.25)
        fireproximityprompt(UpperTorso.ProximityPrompt)
        task.wait(0.5)
        UnequipTools()
    end

    Configuration.Statistics["Chips Fed"] += 1
    return true
end

local function PurchaseFakeID()
    WaitForReady()
    Configuration.State["Status"] = "[ CARDS ] : Buying fake ID."
    repeat WaitForReady() DirtBikeTeleport(Locations.FakeID) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")

    local FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
    local BuyIDPrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityPrompt
    repeat
        WaitForReady()
        repeat DirtBikeTeleport(Locations.FakeID) task.wait(0.05)
        until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
        FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
        BuyIDPrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityPrompt
        DirtBikeTeleport(Locations.FakeID)
        local SkiMask = Player.Character and Player.Character:FindFirstChild("White Ski Mask")
            or Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask")
        if SkiMask then
            EquipTool(SkiMask)
            task.wait(0.25)
        end
        fireproximityprompt(BuyIDPrompt)
        UnequipTools()
        task.wait(4)
    until Player:WaitForChild("Backpack"):FindFirstChild("Fake ID")
end

local function ApplyForCard()
    WaitForReady()
    Configuration.State["Status"] = "[ CARDS ] : Applying for credit card."
    repeat DirtBikeTeleport(Locations.ApplyForCard) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Bank Teller")

    local BankTeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Bank Teller")
    local BankPrompt = BankTeller.UpperTorso.Attachment.ProximityPrompt
    local Safety     = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.ApplyForCard)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Fake ID"))
        task.wait(0.5)
        fireproximityprompt(BankPrompt)
        task.wait(0.5)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Fake ID") or Safety >= 15

    if Safety >= 15 then
        WaitForReady()
        Configuration.State["Status"] = "[ CARDS ] : Claiming card early."
        local Card       = Workspace:WaitForChild("CardPickup")
        local CardPrompt = Card.Attachment.ProximityPrompt
        for _ = 1, 10 do
            DirtBikeTeleport(Card.Position)
            fireproximityprompt(CardPrompt)
            task.wait(0.05)
            UnequipTools()
        end
    end
end

local function ClaimAndUseCard()
    WaitForReady()

    local function HasCard()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack and backpack:FindFirstChild("Card") then return true end
        local char = Player.Character
        if char and char:FindFirstChild("Card") then return true end
        return false
    end

    if HasCard() then
        Configuration.State["Status"] = "[ CARDS ] : Card already owned, going to ATM."
    else
        Configuration.State["Status"] = "[ CARDS ] : Claiming card."
        local Card = Workspace:WaitForChild("CardPickup")
        local Safety = 0
        repeat
            WaitForReady()
            DirtBikeTeleport(Card.Position)
            local CardPrompt = Card.Attachment.ProximityPrompt
            fireproximityprompt(CardPrompt)
            task.wait(0.5)
            Safety += 1
        until HasCard()
            or PlayerGui:WaitForChild("Main").BasicNotification.Text == "You are not on the wait list for a card."
            or Safety >= 10

        if not HasCard()
            and PlayerGui:WaitForChild("Main").BasicNotification.Text == "You are not on the wait list for a card." then
            return false
        end
    end

    -- Now use the card at an ATM
    repeat
        local AvailableATM = FindAvailableATMs()
        if not AvailableATM then
            return false
        end

        local ATMPrompt = AvailableATM.Attachment.ProximityPrompt
        WaitForReady()
        Configuration.State["Status"] = "[ CARDS ] : Using card at ATM."
        local OldATM = PlayerGui:FindFirstChild("ATM")
        if OldATM then OldATM:Destroy() end
        repeat
            WaitForReady()
            DirtBikeTeleport(AvailableATM.Position)
            fireproximityprompt(ATMPrompt)
            task.wait(0.05)
        until PlayerGui:FindFirstChild("ATM")
        EquipTool(Player:FindFirstChild("Backpack"):FindFirstChild("Card"))
        task.wait(0.5)
        replicatesignal(PlayerGui:WaitForChild("ATM").Frame.Swipe.MouseButton1Click)
        Configuration.State["Status"] = "[ CARDS ] : Swiping card."
        task.wait(0.5)
        UnequipTools()
    until not HasCard()
    Configuration.Statistics["Cards Swiped"] += 1
end

local AutofarmRunning = false

local function MainAutofarmController()
    if AutofarmRunning then return end
    AutofarmRunning = true

    while Configuration.Main_Settings["Autofarming"] do
        WaitForReady()

        BuySkiMask()

        local ApartmentOk = StartMarshmallowFarm()
        if not ApartmentOk then task.wait(5) continue end

        PurchaseMarshmallowIngredients()

        local WaterOk = PourWater()
        if not WaterOk then
            repeat StartMarshmallowFarm() WaterOk = PourWater() until WaterOk
        end

        PurchasePotatoIngredients()
        StartPotatoJob()
        CutPotato()
        BagPotato()
        MixFlourAndPotato()
        CookPotatoChips()

        PurchaseFakeID()
        ApplyForCard()

        AddSugarAndGelatin()

        DirtBikeTeleport(Locations.SafeZone)
        Configuration.State["Status"] = "[ WAITING ] : Waiting for card application result."
        repeat task.wait() until
            PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 0
            or PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Bag")

        local cardNotif = PlayerGui:WaitForChild("Main").BasicNotification.Text
        if cardNotif:match("successful") then
            Configuration.State["Status"] = "[ WAITING ] : Card approved, waiting 35s..."
            task.wait(35)
            ClaimAndUseCard()
        end
        BagMarshmallowAndSell()
        ClaimPotatoChipsAndSell()

        AvailablePot = nil
        PotPrompt    = nil
        PotTimer     = nil
        Stove        = nil
        CookPrompt   = nil
        StoveTimer   = nil
    end

    AutofarmRunning = false
end

local function SendWebhook()
    if Configuration.Webhook_Settings["Webhook Url"] == "" then return end

    local charName    = GetCharName()
    local currentCash = GetCurrentCash()
    local runtime     = Configuration.Statistics["Runtime"]

    local payload = HttpService:JSONEncode({
        username = "Autofarm Webhook",
        embeds = {{
            title = "Autofarm Webhook : ||" .. Player.Name .. "|| : " .. charName,
            color = 65280,
            fields = {
                { name = "[ 💳 ] Cards Swiped",      value = GetCommaValue(Configuration.Statistics["Cards Swiped"]),      inline = true },
                { name = "[ 🍟 ] Chips Fed",          value = GetCommaValue(Configuration.Statistics["Chips Fed"]),          inline = true },
                { name = "[ 🧂 ] Marshmallows Sold",  value = GetCommaValue(Configuration.Statistics["Marshmallows Sold"]), inline = true },
                { name = "[ 💰 ] Cash Made",          value = GetCommaValue(Configuration.Statistics["Cash Made"]),          inline = true },
                { name = "[ 💸 ] Current Cash",       value = currentCash,                                                   inline = true },
                { name = "[ 🕐 ] Autofarm Runtime",   value = FormatRuntime(runtime),                                        inline = true },
                { name = "[ ⌛ ] ETA Until Goal",     value = GetETA(),                                                      inline = true },
                { name = "[ 🔄️ ] Times Rejoined",    value = GetCommaValue(Configuration.Statistics["Times Rejoined"]),    inline = true },
            },
        }},
    })

    local req = syn and syn.request or http and http.request or request
    pcall(req, {
        Url     = Configuration.Webhook_Settings["Webhook Url"],
        Method  = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body    = payload,
    })
end

-- ========================================
-- GUI
-- ========================================

local KeybindList = Library:KeybindList("Keybinds")

local Window = Library:Window({
    Name = "Exile",
    SubName = "Multifarm - South Bronx",
    Logo = "95259225424429", -- Replace with your logo asset ID
})

-- ========================================
-- MAIN TAB
-- ========================================

Window:Category("Main")
local MainPage = Window:Page({
    Name = "Main",
    Icon = "gamepad-2",
})

-- Main Settings (Left)
local MainSettingsSection = MainPage:Section({
    Name = "Main Settings",
    Icon = "settings",
    Side = 1,
})

MainSettingsSection:Toggle({
    Name = "Autofarming",
    Flag = "Autofarming",
    Default = Configuration.Main_Settings["Autofarming"],
    Callback = function(Value)
        Configuration.Main_Settings["Autofarming"] = Value
        if Value then
            task.spawn(function()
                repeat task.wait(0.5) until SpawnAndSitOnBike() or not Configuration.Main_Settings["Autofarming"]
                if Configuration.Main_Settings["Autofarming"] then
                    MainAutofarmController()
                end
            end)
        end
    end,
})

MainSettingsSection:Toggle({
    Name = "Auto Anti Death",
    Flag = "AutoAntiDeath",
    Default = Configuration.Main_Settings["Auto Anti Death"],
    Callback = function(Value)
        Configuration.Main_Settings["Auto Anti Death"] = Value
    end,
})

MainSettingsSection:Label("currently its a issue")

MainSettingsSection:Toggle({
    Name = "Auto Rejoiner",
    Flag = "AutoRejoiner",
    Default = Configuration.Main_Settings["Auto Rejoiner"],
    Callback = function(Value)
        Configuration.Main_Settings["Auto Rejoiner"] = Value
    end,
})

MainSettingsSection:Toggle({
    Name = "Performance Saver",
    Flag = "PerformanceSaver",
    Default = Configuration.Main_Settings["Performance Saver"],
    Callback = function(Value)
        Configuration.Main_Settings["Performance Saver"] = Value
        if setfpscap then setfpscap(Value and 15 or 1000) end
        RunService:Set3dRenderingEnabled(not Value)
    end,
})

MainSettingsSection:Button({
    Name = "Purchase DirtBike ($35000)",
    Icon = "shopping-cart",
    Callback = function()
        RPC:FireServer(buffer.fromstring("\001"), "Purchase", "DirtBike")
    end,
})

-- Goal Settings (Right)
local GoalSettingsSection = MainPage:Section({
    Name = "Goal Settings",
    Icon = "target",
    Side = 2,
})

GoalSettingsSection:Label("How this system works:")
GoalSettingsSection:Label("Make the target amount > kick client.")

GoalSettingsSection:Toggle({
    Name = "Enabled",
    Flag = "GoalEnabled",
    Default = Configuration.Goal_Settings["Enabled"],
    Callback = function(Value)
        Configuration.Goal_Settings["Enabled"] = Value
    end,
})

local TargetAmountSlider = GoalSettingsSection:Slider({
    Name = "Target Amount",
    Flag = "TargetAmount",
    Min = 0,
    Max = 1750000,
    Default = Configuration.Goal_Settings["Target Amount"],
    Suffix = " dollars",
    Callback = function(Value)
        Configuration.Goal_Settings["Target Amount"] = Value
    end,
})

GoalSettingsSection:Textbox({
    Flag = "TargetAmountInput",
    Placeholder = "250000",
    Finished = true,
    Callback = function(Value)
        local Number = tonumber(Value)
        if Number then
            Configuration.Goal_Settings["Target Amount"] = Number
            TargetAmountSlider:Set(Number)
        end
    end,
})

-- Statistics (Left)
local StatisticsSection = MainPage:Section({
    Name = "Statistics",
    Icon = "chart-bar",
    Side = 1,
})

local StatusLabel = StatisticsSection:Label("[📊] Status: Idle")

local TimesRejoinedLabel = StatisticsSection:Label("[🔄️] Times Rejoined: 0")
local RuntimeLabel = StatisticsSection:Label("[⏰] Runtime: 00:00:00")
local CashMadeLabel = StatisticsSection:Label("[💸] Cash Made: 0")
local ChipsFedLabel = StatisticsSection:Label("[🍟] Chips Fed: 0")
local CardsSwipedLabel = StatisticsSection:Label("[💳] Cards Swiped: 0")
local MarshmallowsSoldLabel = StatisticsSection:Label("[🧂] Marshmallows Sold: 0")

-- Webhook Settings (Right)
local WebhookSettingsSection = MainPage:Section({
    Name = "Webhook Settings",
    Icon = "webhook",
    Side = 2,
})

WebhookSettingsSection:Toggle({
    Name = "Send Webhooks",
    Flag = "SendWebhooks",
    Default = Configuration.Webhook_Settings["Send Webhooks"],
    Callback = function(Value)
        Configuration.Webhook_Settings["Send Webhooks"] = Value
    end,
})

WebhookSettingsSection:Slider({
    Name = "Webhook Intervals",
    Flag = "WebhookIntervals",
    Min = 1,
    Max = 10,
    Default = Configuration.Webhook_Settings["Webhook Intervals"],
    Suffix = "m",
    Callback = function(Value)
        Configuration.Webhook_Settings["Webhook Intervals"] = Value
    end,
})

WebhookSettingsSection:Textbox({
    Flag = "WebhookUrl",
    Placeholder = "https://discord.com/api/webhooks/...",
    Finished = true,
    Callback = function(Value)
        Configuration.Webhook_Settings["Webhook Url"] = Value
    end,
})

WebhookSettingsSection:Button({
    Name = "Send Test Webhook",
    Icon = "send",
    Callback = function()
        SendWebhook()
    end,
})

-- ========================================
-- SETTINGS PAGE
-- ========================================

local SettingsPage = Library:CreateSettingsPage(Window, KeybindList)

-- Build ThemeManager section (adds theme selection and customization)
ThemeManager:BuildThemeSection(SettingsPage)  -- [3†L88]

-- Build SaveManager section (adds config save/load/delete UI)
SaveManager:BuildConfigSection(SettingsPage)  -- [2†L36-L44]

-- ========================================
-- NOTIFICATIONS
-- ========================================

Library:Notification({
    Title = "Exile Multifarm",
    Description = string.format("Script loaded in: %.4f seconds.", os.clock() - LoadStart),
    Duration = 5,
    Icon = "95259225424429",
})

Library:Notification({
    Title = "Exile Multifarm",
    Description = string.format("Place Version: %d", game.PlaceVersion),
    Duration = 5,
    Icon = "95259225424429",
})

-- ========================================
-- AUTO REJOINER
-- ========================================

if getgenv().AutoRejoinerEnabled then
    getgenv().AutoRejoinerEnabled = nil
    Configuration.Statistics["Times Rejoined"] += 1
    Configuration.Main_Settings["Autofarming"] = true
    task.spawn(function()
        repeat task.wait(0.5) until not PlayerGui:FindFirstChild("IntroUI")
        task.wait(2)
        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Z, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        repeat task.wait(0.5) until SpawnAndSitOnBike() or not Configuration.Main_Settings["Autofarming"]
        if Configuration.Main_Settings["Autofarming"] then
            MainAutofarmController()
        end
    end)
end

-- ========================================
-- STUCK DETECTION
-- ========================================

task.spawn(function()
    local LastCash       = 0
    local LastCashTime   = os.clock()
    local LastStatus     = ""
    local LastStatusTime = os.clock()
    task.wait(60)
    LastCash   = GetCurrentCashAmount()
    LastStatus = Configuration.State["Status"]
    while task.wait(30) do
        if not Configuration.Main_Settings["Autofarming"] then
            LastCashTime   = os.clock()
            LastStatusTime = os.clock()
            LastCash       = GetCurrentCashAmount()
            LastStatus     = Configuration.State["Status"]
            continue
        end
        local now         = os.clock()
        local currentCash = GetCurrentCashAmount()
        local currentStatus = Configuration.State["Status"]
        if currentCash ~= LastCash then
            LastCash     = currentCash
            LastCashTime = now
        end
        if currentStatus ~= LastStatus then
            LastStatus     = currentStatus
            LastStatusTime = now
        end
        if (now - LastCashTime) >= 300 or (now - LastStatusTime) >= 300 then
            DoRejoin()
            return
        end
    end
end)

-- ========================================
-- DEATH HANDLER
-- ========================================

local function ConnectDeathHandler(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    humanoid.Died:Connect(function()
        if Configuration.State["RespawnPending"] then return end
        if Configuration.Main_Settings["Autofarming"] and Configuration.Main_Settings["Auto Rejoiner"] then
            task.wait(3)
            DoRejoin()
        end
    end)
end

ConnectDeathHandler(Player.Character)
Player.CharacterAdded:Connect(ConnectDeathHandler)

-- ========================================
-- STATISTICS UPDATE
-- ========================================

task.spawn(function()
    local StartTime = os.clock()
    task.wait(2)
    local StartCash = GetCurrentCashAmount()
    while task.wait(1) do
        local Elapsed = math.floor(os.clock() - StartTime)
        Configuration.Statistics["Runtime"]   = Elapsed
        Configuration.Statistics["Cash Made"] = GetCurrentCashAmount() - StartCash

        -- Update labels using :SetText()
        StatusLabel:SetText("[📊] Status: " .. Configuration.State["Status"])

        TimesRejoinedLabel:SetText(string.format("[🔄️] Times Rejoined: %d", Configuration.Statistics["Times Rejoined"]))
        RuntimeLabel:SetText(string.format("[⏰] Runtime: %02d:%02d:%02d",
            math.floor(Elapsed / 3600),
            math.floor((Elapsed % 3600) / 60),
            Elapsed % 60
        ))
        local cashMade = Configuration.Statistics["Cash Made"]
        local cashMadeStr = (cashMade < 0 and "-" or "") .. GetCommaValue(math.abs(cashMade))
        CashMadeLabel:SetText("[💸] Cash Made: " .. cashMadeStr)
        ChipsFedLabel:SetText(string.format("[🍟] Chips Fed: %d", Configuration.Statistics["Chips Fed"]))
        CardsSwipedLabel:SetText(string.format("[💳] Cards Swiped: %d", Configuration.Statistics["Cards Swiped"]))
        MarshmallowsSoldLabel:SetText(string.format("[🧂] Marshmallows Sold: %d", Configuration.Statistics["Marshmallows Sold"]))
    end
end)

-- ========================================
-- WEBHOOK LOOP
-- ========================================

task.spawn(function()
    while true do
        task.wait(Configuration.Webhook_Settings["Webhook Intervals"] * 60)
        if Configuration.Webhook_Settings["Send Webhooks"] then
            SendWebhook()
        end
    end
end)

-- ========================================
-- ANTI-AFK
-- ========================================

Player.Idled:Connect(function()
    if Configuration.Main_Settings["Autofarming"] then
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)
