local DiscordLib = loadstring(game:HttpGet "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord")()

local win = DiscordLib:Window("KUY")
local serv = win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")

local mainChannel = serv:Channel("Main")

local selectedPacks = {}
local selectedSlots = {}

local slotList = {}
for i = 1, 20 do
    table.insert(slotList, tostring(i))
end

local packList = {"Bronze", "Silver", "Gold", "Platinum", "Diamond", "Toxic", "Shadow", "Infernal", "Corrupted", "Cosmic", "Eclipse", "Hades", "Heaven", "Chaos", "Ordain", "Alpha", "Omega", "Genesis", "Abyssal"}

mainChannel:Label("Bas PATHOMPONG")
mainChannel:Seperator()

mainChannel:Toggle("Auto Spin", false, function(val)
    shared.autoSpin = val
    if val then
        task.spawn(function()
            while shared.autoSpin do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinWheel"):FireServer("spin")
                end)
                task.wait(math.random(1.1, 1.5))
            end
        end)
    end
end)

mainChannel:Seperator()

mainChannel:Label("Auto Collect Slot")

local slotDisplay = mainChannel:Label("Selected: None")

mainChannel:Dropdown("Slots", slotList, function(selected)
    local slot = tonumber(selected)
    local index = table.find(selectedSlots, slot)
    if index then
        table.remove(selectedSlots, index)
    else
        table.insert(selectedSlots, slot)
        table.sort(selectedSlots)
    end
    
    if #selectedSlots > 0 then
        slotDisplay:SetText("Selected: " .. table.concat(selectedSlots, ", "))
    else
        slotDisplay:SetText("Selected: None")
    end
end)

mainChannel:Button("Select All Slots", function()
    selectedSlots = {}
    for i = 1, 20 do
        table.insert(selectedSlots, i)
    end
    slotDisplay:SetText("Selected: " .. table.concat(selectedSlots, ", "))
end)

mainChannel:Button("Clear All Slots", function()
    selectedSlots = {}
    slotDisplay:SetText("Selected: None")
end)

mainChannel:Toggle("Auto Collect", false, function(val)
    shared.autoCollect = val
    if val then
        if #selectedSlots == 0 then
            DiscordLib:Notification("Error", "No slots selected", "OK")
            shared.autoCollect = false
            return
        end
        task.spawn(function()
            while shared.autoCollect do
                for _, slot in ipairs(selectedSlots) do
                    if not shared.autoCollect then break end
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CollectSlot"):FireServer(slot)
                    end)
                    task.wait(0.1)
                end
                task.wait(1)
            end
        end)
    end
end)

mainChannel:Seperator()

mainChannel:Label("Auto Buy / Open Pack")

local packDisplay = mainChannel:Label("Selected: None")

mainChannel:Dropdown("Packs", packList, function(selected)
    local index = table.find(selectedPacks, selected)
    if index then
        table.remove(selectedPacks, index)
    else
        table.insert(selectedPacks, selected)
    end
    
    if #selectedPacks > 0 then
        packDisplay:SetText("Selected: " .. table.concat(selectedPacks, ", "))
    else
        packDisplay:SetText("Selected: None")
    end
end)

mainChannel:Button("Select All Packs", function()
    selectedPacks = {}
    for _, pack in ipairs(packList) do
        table.insert(selectedPacks, pack)
    end
    packDisplay:SetText("Selected: " .. table.concat(selectedPacks, ", "))
end)

mainChannel:Button("Clear All Packs", function()
    selectedPacks = {}
    packDisplay:SetText("Selected: None")
end)

mainChannel:Toggle("Auto Buy", false, function(val)
    shared.autoBuy = val
    if val then
        if #selectedPacks == 0 then
            DiscordLib:Notification("Error", "No packs selected", "OK")
            shared.autoBuy = false
            return
        end
        task.spawn(function()
            local index = 1
            while shared.autoBuy do
                local currentPack = selectedPacks[index]
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyPack"):FireServer(currentPack)
                end)
                index = index % #selectedPacks + 1
                task.wait(0.3)
            end
        end)
    end
end)

mainChannel:Toggle("Auto Open", false, function(val)
    shared.autoOpen = val
    if val then
        if #selectedPacks == 0 then
            DiscordLib:Notification("Error", "No packs selected", "OK")
            shared.autoOpen = false
            return
        end
        task.spawn(function()
            local index = 1
            while shared.autoOpen do
                local currentPack = selectedPacks[index]
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("OpenPack"):FireServer(currentPack)
                end)
                index = index % #selectedPacks + 1
                task.wait(0.3)
            end
        end)
    end
end)

mainChannel:Seperator()

mainChannel:Colorpicker("UI Color", Color3.fromRGB(255, 0, 0), function(color)
    print(color)
end)

mainChannel:Seperator()

mainChannel:Button("Kill All", function()
    DiscordLib:Notification("Kill All", "Killed all players", "OK")
end)

mainChannel:Button("Get Max Level", function()
    DiscordLib:Notification("Max Level", "Max level achieved", "OK")
end)

if not table.find then
    function table.find(tbl, val)
        for i, v in ipairs(tbl) do
            if v == val then return i end
        end
        return nil
    end
end
