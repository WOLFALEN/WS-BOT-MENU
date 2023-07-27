local lastvehic = nil
local inZone = false
local mustFadeOut = false

local AllWeapons = {
    "WEAPON_KNIFE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_CARBINERIFLE",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_SMG",
    "WEAPON_ASSAULTSMG",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_RPG",
    "WEAPON_RAILGUN",
    "WEAPON_STINGER",
    "WEAPON_MINIGUN",
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_BZGAS",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    "WEAPON_SNOWBALL",
    "WEAPON_FLASHLIGHT",
    "WEAPON_MACHETE",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_SWITCHBLADE",
    "WEAPON_REVOLVER",
    "WEAPON_DBSHOTGUN",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_AUTOSHOTGUN",
    "WEAPON_BATTLEAXE",
    "WEAPON_POOLCUE",
    "WEAPON_PIPEBOMB",
    "WEAPON_SWEEPER",
    "WEAPON_WRENCH",
}


function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

local timers = {
    health = 0,
    armour = 0,
    bus = 0,
    invincibility = 0,
}

local cooldowns = {
    health = 0,
    armour = 0,
    bus = 60,
    invincibility = 5
}



function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function setInvincibility()
    timers.invincibility = cooldowns.invincibility
end

RMenu.Add('combat', 'main', RageUI.CreateMenu("~r~Xen Game Modes","",0,100)) ------ change this to whatever you want
RMenu:Get('combat', 'main'):SetSubtitle("By WOLF STUDIO")------ change this to whatever you want
RMenu.Add('combat', 'mode', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "mode", "~b~Select a location to mode to", nil, nil))
RMenu.Add('combat', 'modes', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "modes", "~b~Select a location to modes to", nil, nil))
RMenu.Add('combat', 'modess', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "modes", "~b~Select a location to modes to", nil, nil))

RageUI.CreateWhile(1.0, RMenu:Get('combat', 'main'), 170, function()
    RageUI.IsVisible(RMenu:Get('combat', 'main'), true, true, true, function()
        if not inZone then
            if Config.TeleportMenu == true then
                RageUI.Button("~b~Teleport Menu", "Death Match Mod", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','teleport'))
            end



            if Config.modessMenu == true then
                RageUI.Button("~r~Ground Attack", "Select", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','modess'))
            end

            if Config.WeaponMenu == true then
                RageUI.Button("~y~Weapon Spawner", "Select to open the weapon spawner", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        -- loop through all weapons and give them to the player
                        for k,v in pairs(AllWeapons) do
                            local weaponHash = GetHashKey(v)
                            GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 999, false, true)
                        end
                    end
                end, RMenu:Get('combat','weapons'))
            end            

            if Config.VehicleSpawnMenu == true then
                RageUI.Button("~y~Vehicle Spawner", "Select to open the vehicle spawner", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','vehicles'))
            end

            if Config.Suicide == true then
                RageUI.Button("~r~Suicide", "~r~Select to kill yourself", { }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        SetEntityHealth(PlayerPedId(), 0)
                        Notify("~g~You ~r~Died")
                    end
            end, nil)
        end
        else
            Notify("~r~You cannot use this menu in this area!")
        end
    end, function()
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'vehicles'),true,true,true,function()
        for name, values in ipairs(Config.Vehicles) do
            RageUI.Button(tostring(values.name), string.format("Select to spawn a %s", values.name),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if (values.name == "Bus" and timers.bus <= 0) or values.name ~= "Bus" then
                        if values.name == "Bus" then
                            timers.bus = cooldowns.bus
                        end
                        RequestModel(GetHashKey(values.id))
                        while not HasModelLoaded(GetHashKey(values.id)) do
                            Citizen.Wait(100)
                        end
                        local playerPed = PlayerPedId()
                        local pos = GetEntityCoords(playerPed)
                        local vehicle = CreateVehicle(GetHashKey(values.id), pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                        SetPedIntoVehicle(playerPed, vehicle, -1)
                        if lastvehic ~= nil then
                            SetEntityAsMissionEntity(lastvehic, true, true)
                            DeleteVehicle(lastvehic)
                        end
                        lastvehic = vehicle
                    else
                        notify(string.format("~r~You cannot spawn another bus for %ss",timers.bus))
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'modes'), true, true, true, function()
        for _, values in ipairs(Config.modes) do
            RageUI.Button(tostring(values.name), string.format("Select modes to %s", values.name), {}, true, function(_, _, Selected)
                if (Selected) then
                    if (values.name == "Join Demoltion Derby") then
                        local playerPed = PlayerPedId()
                        PlaySoundFrontend(-1,Config.OnPlayerFocuse.data[1], Config.OnPlayerFocuse.data[2])
                        cFromTop()
                        setInvincibility()
                        SetEntityCoords(playerPed, 1733.5120, 3302.2363, 41.2235, 0, 0, 0, false)
                        SetEntityHeading(playerPed, 8.8199)
                    elseif (values.name == "/minigame leave to exit") then
                        local playerPed = PlayerPedId()
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)  

    RageUI.IsVisible(RMenu:Get('combat', 'modess'), true, true, true, function()
        for _, values in ipairs(Config.modess) do
            RageUI.Button(tostring(values.name), string.format("Select modess to %s", values.name), {}, true, function(_, _, Selected)
                if (Selected) then
                    if (values.name == "Ground Attack (10 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds10() 
                    elseif (values.name == "Ground Attack (20 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds20() 
                    elseif (values.name == "Ground Attack (30 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds30() 
                    elseif (values.name == "Ground Attack (50 M)") then
                         local playerPed = PlayerPedId()
                         SpawnEnemyPeds50() 
                    elseif (values.name == "Ground Attack (100 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds100() 
                    elseif (values.name == "Ground Attack (200 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds200() 
                    elseif (values.name == "Ground Attack (300 M)") then
                        local playerPed = PlayerPedId()
                        SpawnEnemyPeds300() 
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)    

    RageUI.IsVisible(RMenu:Get('combat', 'mode'), true, true, true, function()
        for _, values in ipairs(Config.mode) do
            RageUI.Button(tostring(values.name), string.format("Select mode to %s", values.name), {}, true, function(_, _, Selected)
                if (Selected) then
                    if (values.name == "Join Death Match") then
                        local playerPed = PlayerPedId()
                        TriggerEvent('ardi:display', true, 'selection')
                    elseif (values.name == "Exit Death Match") then
                        local playerPed = PlayerPedId()
                        TriggerEvent('ardi:quitffa')
                    elseif (values.name == "Death Match ScoreBoard") then
                        local playerPed = PlayerPedId()
                        TriggerEvent('ardi:get:all:stats')
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)
end)

Citizen.CreateThread(function()
    while true do
        for k,_ in pairs(timers) do
            timers[k] = timers[k]-1
        end
        -- checking of distance to redzone
        local pos = GetEntityCoords(PlayerPedId())
        dist = #(vector3(-227.3,-2622.93,6.05)-pos)
        if dist <= 140 then
            inZone = true ------- change to false and set line 191 to true if you want the menu to open in a specific location! 
        else
            inZone = false
        end
        if timers.invincibility > 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 190)
            SetEntityAlpha(GetPlayerPed(-1), 190)
        elseif timers.invincibility == 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 255)
            SetEntityAlpha(GetPlayerPed(-1), 255)
            HudWeaponWheelIgnoreControlInput(false)
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        while timers.invincibility > 0 do
            HudWeaponWheelIgnoreControlInput(true)
            Wait(0)
        end
        Wait(400)
    end
end)

RegisterNetEvent("K9:cl_combatSetEntityAlpha")
AddEventHandler("K9:cl_combatSetEntityAlpha", function(entity, value)
    SetEntityAlpha(entity, value)
end)

function cFromTop()
    cam  = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,10000.0, -90.0, 0.0, -168.0, 45.0, true, 2)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,1500.00, -90.0, 0.0, -168.0, 45.0, true, 2)
    RenderScriptCams(1, 1, 0, 0, 0)
    Wait(0) -- Needed to load map
    SetFocusPosAndVel(GetCamCoord(cam), 0.0, 0.0, 0.0)
    SetCamActiveWithInterp(cam2, cam, 10000, 1, 1)
    Wait(0)
    SetFocusPosAndVel(GetCamCoord(cam2), 0.0, 0.0, 0.0)
    Wait(10000)
    cFromTopEnd()
end

function cFromTopEnd()
    c = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,4000.0, -90.0, 0.0, -168.0, 45.0, true, 2)
    SetCamActiveWithInterp(c, cam2, 2000, 1, 1)
    FinalEnd()
end

function FinalEnd()
    DoScreenFadeOut(500)
    SetFocusEntity(GetPlayerPed(-1))
    inProgress = false
    RenderScriptCams(0, 1, 2000, 1, 0)
    Wait(2000)
    DoScreenFadeIn(500)
    PlaySoundFrontend(-1,Config.OnPlayerFocus.data[1], Config.OnPlayerFocus.data[2])
    DestroyAllCams(true)
    isOnEndScreen = false
    cam,cam2,cam3,cam4,cam5,cam6,cam7,cam8,cam9 = nil
end
---------------------------------

function SpawnEnemyPeds10(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 10
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds20(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 20
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds30(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 30
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds50(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 50
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds100(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 100
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds200(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 200
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end

function SpawnEnemyPeds300(numPeds, distance)
    local pedModels = {"s_m_m_ups_01", "s_m_m_fibsec_01", "s_m_m_marine_01"} -- add more ped models here
    local distance = 300
    for i = 1, 6 do -- spawn numPeds peds
        local pedModel = pedModels[math.random(#pedModels)] -- choose a random ped model from the table
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local x, y, z = playerPos.x + (math.random(-distance, distance)), playerPos.y + (math.random(-distance, distance)), playerPos.z + 1.0
        local spawnedPed = CreatePed(28, pedModel, x, y, z, GetEntityHeading(playerPed), true, false)
        AddRelationshipGroup('Merryweather')
        SetPedArmour(spawnedPed, 200)
        SetPedAsEnemy(spawnedPed, true)
        SetPedRelationshipGroupHash(spawnedPed, 'Merryweather')
        GiveWeaponToPed(spawnedPed, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
        TaskCombatPed(spawnedPed, GetPlayerPed(-1))
        SetPedAccuracy(spawnedPed, 300)
        SetPedDropsWeaponsWhenDead(spawnedPed, false)
    end
end