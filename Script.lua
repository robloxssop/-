local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

local win = DiscordLib:Window("KUY")
local serv = win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
local mainChannel = serv:Channel("Main")

local selectedPacks = {}
local selectedSlots = {}

local slotList = {}
for i = 1, 20 do table.insert(slotList, tostring(i)) end

local packList = {
    "Bronze","Silver","Gold","Platinum","Diamond","Toxic","Shadow","Infernal",
    "Corrupted","Cosmic","Eclipse","Hades","Heaven","Chaos","Ordain",
    "Alpha","Omega","Genesis","Abyssal"
}

mainChannel:Label("Bas PATHOMPONG")
mainChannel:Seperator()

mainChannel:Toggle("Auto Spin", false, function(val)
    shared.autoSpin = val
    if val then
        task.spawn(function()
            while shared.autoSpin do
                pcall(function()
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if remote and remote:FindFirstChild("SpinWheel") then
                        remote.SpinWheel:FireServer("spin")
                    end
                end)
                task.wait(math.random(1.1, 1.5))
            end
        end)
    end
end)
mainChannel:Seperator()

mainChannel:Label("Auto Collect Slot")

local slotDropdown = mainChannel:Dropdown("Slots", slotList, function(selected)
    local slot = tonumber(selected)
    local found = false
    for i, v in ipairs(selectedSlots) do
        if v == slot then
            table.remove(selectedSlots, i)
            found = true
            break
        end
    end
    if not found then
        table.insert(selectedSlots, slot)
        table.sort(selectedSlots)
    end

    if #selectedSlots > 0 then
        pcall(function() slotDropdown:SetText("Selected: " .. table.concat(selectedSlots, ", ")) end)
    else
        pcall(function() slotDropdown:SetText("Slots") end)
    end
    DiscordLib:Notification("Slot", (found and "Removed " or "Added ") .. slot, "OK")
end)

mainChannel:Button("Select All Slots", function()
    selectedSlots = {}
    for i = 1, 20 do table.insert(selectedSlots, i) end
    pcall(function() slotDropdown:SetText("Selected: " .. table.concat(selectedSlots, ", ")) end)
    DiscordLib:Notification("Slots", "All 20 slots selected", "OK")
end)

mainChannel:Button("Clear All Slots", function()
    selectedSlots = {}
    pcall(function() slotDropdown:SetText("Slots") end)
    DiscordLib:Notification("Slots", "All slots cleared", "OK")
end)

mainChannel:Button("Show Selected Slots", function()
    if #selectedSlots > 0 then
        DiscordLib:Notification("Selected Slots", table.concat(selectedSlots, ", "), "OK")
    else
        DiscordLib:Notification("Selected Slots", "None", "OK")
    end
end)

mainChannel:Toggle("Auto Collect", false, function(val)
    shared.autoCollect = val
    if val and #selectedSlots == 0 then
        DiscordLib:Notification("Error", "No slots selected", "OK")
        shared.autoCollect = false
        return
    end
    if val then
        task.spawn(function()
            while shared.autoCollect do
                for _, slot in ipairs(selectedSlots) do
                    if not shared.autoCollect then break end
                    pcall(function()
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote and remote:FindFirstChild("CollectSlot") then
                            remote.CollectSlot:FireServer(slot)
                        end
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

local packDropdown = mainChannel:Dropdown("Packs", packList, function(selected)
    local found = false
    for i, v in ipairs(selectedPacks) do
        if v == selected then
            table.remove(selectedPacks, i)
            found = true
            break
        end
    end
    if not found then
        table.insert(selectedPacks, selected)
    end

    if #selectedPacks > 0 then
        pcall(function() packDropdown:SetText("Selected: " .. table.concat(selectedPacks, ", ")) end)
    else
        pcall(function() packDropdown:SetText("Packs") end)
    end
    DiscordLib:Notification("Pack", (found and "Removed " or "Added ") .. selected, "OK")
end)

mainChannel:Button("Select All Packs", function()
    selectedPacks = {}
    for _, pack in ipairs(packList) do table.insert(selectedPacks, pack) end
    pcall(function() packDropdown:SetText("Selected: " .. table.concat(selectedPacks, ", ")) end)
    DiscordLib:Notification("Packs", "All packs selected", "OK")
end)

mainChannel:Button("Clear All Packs", function()
    selectedPacks = {}
    pcall(function() packDropdown:SetText("Packs") end)
    DiscordLib:Notification("Packs", "All packs cleared", "OK")
end)

mainChannel:Button("Show Selected Packs", function()
    if #selectedPacks > 0 then
        DiscordLib:Notification("Selected Packs", table.concat(selectedPacks, ", "), "OK")
    else
        DiscordLib:Notification("Selected Packs", "None", "OK")
    end
end)

mainChannel:Toggle("Auto Buy", false, function(val)
    shared.autoBuy = val
    if val and #selectedPacks == 0 then
        DiscordLib:Notification("Error", "No packs selected", "OK")
        shared.autoBuy = false
        return
    end
    if val then
        task.spawn(function()
            local idx = 1
            while shared.autoBuy do
                local pack = selectedPacks[idx]
                pcall(function()
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if remote and remote:FindFirstChild("BuyPack") then
                        remote.BuyPack:FireServer(pack)
                    end
                end)
                idx = idx % #selectedPacks + 1
                task.wait(0.3)
            end
        end)
    end
end)

mainChannel:Toggle("Auto Open", false, function(val)
    shared.autoOpen = val
    if val and #selectedPacks == 0 then
        DiscordLib:Notification("Error", "No packs selected", "OK")
        shared.autoOpen = false
        return
    end
    if val then
        task.spawn(function()
            local idx = 1
            while shared.autoOpen do
                local pack = selectedPacks[idx]
                pcall(function()
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if remote and remote:FindFirstChild("OpenPack") then
                        remote.OpenPack:FireServer(pack)
                    end
                end)
                idx = idx % #selectedPacks + 1
                task.wait(0.3)
            end
        end)
    end
end)

mainChannel:Seperator()

mainChannel:Toggle("Anti AFK", false, function(val)
    shared.antiAFK = val
    if val then
        task.spawn(function()
            local vu = game:GetService("VirtualUser")
            local player = game.Players.LocalPlayer
            while shared.antiAFK do
                pcall(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:Move(Vector3.new(0,0,0), true)
                        player.Character.Humanoid.Jump = true
                        task.wait(0.5)
                        player.Character.Humanoid.Jump = false
                    end
                end)
                task.wait(45)
            end
        end)
    end
end)

mainChannel:Seperator()
mainChannel:Colorpicker("UI Color", Color3.fromRGB(255,0,0), function(c) print(c) end)

print("UI Loaded")
