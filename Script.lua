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

-- ==================== TOGGLE ลบ Notification ====================
mainChannel:Toggle("Remove Notification", false, function(val)
    shared.removeNotif = val
    
    if val then
        if shared.notifConnection then
            shared.notifConnection:Disconnect()
        end
        
        shared.notifConnection = task.spawn(function()
            while shared.removeNotif do
                pcall(function()
                    local pgui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if pgui then
                        local notif = pgui:FindFirstChild("Notification")
                        if notif then
                            notif:Destroy()
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        
        DiscordLib:Notification("Remove Notification", "Enabled", "OK")
    else
        if shared.notifConnection then
            shared.notifConnection:Disconnect()
            shared.notifConnection = nil
        end
        DiscordLib:Notification("Remove Notification", "Disabled", "OK")
    end
end)

mainChannel:Seperator()

mainChannel:Toggle("Auto Spin", false, function(val)
    shared.autoSpin = val
    if val then
        task.spawn(function()
            while shared.autoSpin do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local spinWheelGui = player.PlayerGui:FindFirstChild("SpinWheel")
                    
                    if spinWheelGui then
                        local main = spinWheelGui:FindFirstChild("Main")
                        if main then
                            local spin = main:FindFirstChild("Spin")
                            if spin then
                                local spinAmount = spin:FindFirstChild("SpinAmount")
                                local text = spinAmount and spinAmount.Text or ""

                                local proximityPrompt = workspace:FindFirstChild("Map") 
                                    and workspace.Map:FindFirstChild("SpinWheel") 
                                    and workspace.Map.SpinWheel:FindFirstChild("Holder") 
                                    and workspace.Map.SpinWheel.Holder:FindFirstChild("ProximityPrompt")
                                
                                if proximityPrompt then
                                    pcall(function() fireproximityprompt(proximityPrompt) end)
                                end

                                if text == "Claim!" then
                                    task.wait(0.5)
                                    pcall(function() firesignal(spin.MouseButton1Click) end)
                                    pcall(function() spin:Activate() end)
                                    task.wait(0.5)
                                    
                                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                    if remotes and remotes:FindFirstChild("SpinWheel") then
                                        pcall(function() remotes.SpinWheel:FireServer("spin") end)
                                    end
                                    
                                elseif text == "Spin (1)" then
                                    task.wait(0.3)
                                    pcall(function() firesignal(spin.MouseButton1Click) end)
                                    pcall(function() spin:Activate() end)
                                    
                                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                    if remotes and remotes:FindFirstChild("SpinWheel") then
                                        pcall(function() remotes.SpinWheel:FireServer("spin") end)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(3)
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
        if shared.antiAFKConnection then
            shared.antiAFKConnection:Disconnect()
            shared.antiAFKConnection = nil
        end

        task.spawn(function()
            local Players = game:GetService("Players")
            local VirtualUser = game:GetService("VirtualUser")
            local VirtualInputManager = game:GetService("VirtualInputManager")
            
            local player = Players.LocalPlayer
            local lastActivity = tick()

            local idledConnection = player.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end)

            shared.antiAFKConnection = idledConnection

            DiscordLib:Notification("Anti AFK", "Enabled - Universal Mode", "OK")

            while shared.antiAFK do
                pcall(function()
                    local now = tick()
                    if now - lastActivity > (35 + math.random(0,20)) then
                        
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(math.random(-10,10), math.random(-10,10)))
                        
                        if VirtualInputManager then
                            VirtualInputManager:SendMouseMoveEvent(math.random(100,500), math.random(100,400))
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                            task.wait(0.08)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                        end
                        
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local root = player.Character.HumanoidRootPart
                            local hum = player.Character:FindFirstChild("Humanoid")
                            
                            if hum then
                                hum:MoveTo(root.Position + root.CFrame.LookVector * math.random(2,5))
                                task.wait(0.2)
                                hum.Jump = true
                                task.wait(0.15)
                            end
                            
                            if workspace.CurrentCamera then
                                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(math.random(-8,8)), 0)
                            end
                        end
                        
                        lastActivity = now
                    end
                end)
                
                task.wait(5 + math.random(0,3))
            end
        end)
        
    else
        if shared.antiAFKConnection then
            shared.antiAFKConnection:Disconnect()
            shared.antiAFKConnection = nil
        end
        DiscordLib:Notification("Anti AFK", "Disabled", "OK")
    end
end)

mainChannel:Seperator()
mainChannel:Colorpicker("UI Color", Color3.fromRGB(255,0,0), function(c) 
    print(c)
end)

print("Loaded")
