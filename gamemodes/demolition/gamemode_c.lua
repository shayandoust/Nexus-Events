--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentKills = 0
local Sessionised = false
local CurrentCenter = {}
local end_time

RegisterNetEvent("Gamemode:Start:7")
RegisterNetEvent("Gamemode:Session:7")
RegisterNetEvent("Gamemode:FetchCoords:7")
RegisterNetEvent("Gamemode:End:7")
RegisterNetEvent("Gamemode:Init:7")
RegisterNetEvent("Gamemode:Join:7")
RegisterNetEvent("demolition:UpdateKills")

AddEventHandler("Gamemode:Join:7", function()
    Misc.SpectatorMode(true) 
end)

AddEventHandler("Gamemode:End:7", function(winner, xp)
    Sessionised = false
    SpawnManager.removeAllSpawnPoints()
    SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
    SpawnManager.forceRespawn()
    EndDemolition(winner, xp)
end)

AddEventHandler("Gamemode:Init:7", function()
    -- this removes the initial spawn, no matter what.
    --SpawnManager.removeAllSpawnPoints()
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:7")

    --[[ N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId()) ]]
    Wait(1000)
    print("CREATING CAMERA")
    view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, tonumber(CurrentCenter.x), tonumber(CurrentCenter.y), tonumber(CurrentCenter.z) + 20)
    SetCamRot(view1, -20.0, 0.0, 180.0)
    SetCamFov(view1, 45.0)
    RenderScriptCams(true, 1, 500,  true,  true)
    AnimatedShakeCam(view1,"shake_cam_all@", "light", "", 1)
   
    Wait(10000)
    DestroyCam(view1, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    FreezeEntityPosition(PlayerPedId(), true)
    local start = GetGameTimer()
    -- we could play a sound or smth on the countdown as well
    print("DRAWING COUNTDOWN")
    while (GetGameTimer() - start) < 10000 do 
        Wait(0)
        HideHudAndRadarThisFrame()
        SetFollowPedCamViewMode(4)
        -- would be better if we were to freeze the player's cam, anyone knows how?
        --FreezePedCameraRotation(PlayerPedId())
        if (GetGameTimer() - start) < 7000 then
            --print("to start")
            GUI.DrawText("The Game Will Start Shortly", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) < 8000 and GetGameTimer() - start > 7000 then
            --print("3")
            GUI.DrawText("3", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) < 9000 and GetGameTimer() - start > 8000 then
            --print("2")
            GUI.DrawText("2", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) > 9000 then
            --print("1")
            GUI.DrawText("1", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        end
    end
    print("STARTING GAMEMODE")
    FreezeEntityPosition(PlayerPedId(), false)
    StartDemolition()
end)

AddEventHandler("Gamemode:FetchCoords:7", function(Coords)
    for i,v in ipairs(Coords) do
        local Coord = {}
         Coord.x, Coord.y, Coord.z = table.unpack(Misc.SplitString(v, ","))
         print("adding spawnpoint")
        SpawnManager.addSpawnPoint({x = tonumber(Coord.x), y = tonumber(Coord.y), z = tonumber(Coord.z), heading = 0.0, model=1657546978})
    end
    local r = math.random(1, #Coords)
    CurrentCenter.x, CurrentCenter.y, CurrentCenter.z = table.unpack(Misc.SplitString(Coords[r], ","))
    SpawnManager.forceRespawn()
end)

AddEventHandler("demolition:UpdateKills", function(kills, timer) CurrentKills = kills if timer then end_time = GetNetworkTime()+timer end end)

AddEventHandler("Gamemode:Spawn:7", function()
    if Sessionised then
        RequestModel(GetHashKey(ChosenDemolitionModel))
        while not HasModelLoaded(GetHashKey(ChosenDemolitionModel)) do
            RequestModel(GetHashKey(ChosenDemolitionModel))
            Citizen.Wait(0)
        end
        local veh = CreateVehicle(GetHashKey(ChosenDemolitionModel), GetEntityCoords(PlayerPedId(), true), 0.0, true, true)
        SetModelAsNoLongerNeeded(GetHashKey(ChosenDemolitionModel))
        SetPedIntoVehicle(PlayerPedId(), veh, -1)
        SetPlayerInvincible(PlayerId(), true)
        SetEntityInvincible(veh, true)
        SetVehicleDoorsLocked(veh, 4)
    end
end)

function StartDemolition()
    RequestModel(GetHashKey(ChosenDemolitionModel))
    while not HasModelLoaded(GetHashKey(ChosenDemolitionModel)) do
        RequestModel(GetHashKey(ChosenDemolitionModel))
        Citizen.Wait(0)
    end
    local veh = CreateVehicle(GetHashKey(ChosenDemolitionModel), GetEntityCoords(PlayerPedId(), true), 0.0, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(ChosenDemolitionModel))
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityInvincible(veh, true)
    SetVehicleDoorsLocked(veh, 4)
    SetPlayerVehicleDamageModifier(PlayerId(), 1000.0)
    for i=0,255 do
        local ped = GetPlayerPed(i)
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(ped) and DoesEntityExist(vehicle) then
            SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
            SetEntityNoCollisionEntity(PlayerPedId(), vehicle, true)
            SetEntityNoCollisionEntity(GetVehiclePedIsIn(PlayerPedId(), false), vehicle, true)
            SetEntityNoCollisionEntity(GetVehiclePedIsIn(PlayerPedId(), false), ped, true)
        end
    end
    Citizen.CreateThread(function()
        local lastvehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        while Sessionised do 
            Wait(0)
            --GUI.DrawBar(0.13, "LEVEL", GunLevels[tostring(GetPlayerServerId(PlayerId()))], nil, 3)

            if lastvehicle ~= GetVehiclePedIsIn(PlayerPedId(),false) then
                for i=0,255 do
                    local ped = GetPlayerPed(i)
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    if DoesEntityExist(ped) and DoesEntityExist(vehicle) then
                        SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
                        SetEntityNoCollisionEntity(PlayerPedId(), vehicle, true)
                        SetEntityNoCollisionEntity(GetVehiclePedIsIn(PlayerPedId(), false), vehicle, true)
                        SetEntityNoCollisionEntity(GetVehiclePedIsIn(PlayerPedId(), false), ped, true)
                    end
                end
            end

            if not end_time then end_time = GetNetworkTime() + 600000 end

            if (end_time - GetNetworkTime()) > 0 then
                GUI.MissionText("Destroy as many vehicles as possible!", 1, 1)
                GUI.DrawBar(0.13, "KILLS", CurrentKills, nil, 2)
                GUI.DrawTimerBar(0.13, "GAME END", ((end_time - GetNetworkTime()) / 1000), 1)
            else
                end_time = nil
            end
            if IsPedInAnyVehicle(PlayerPedId(), false) and IsControlPressed(0, 60) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                SetVehicleBoostActive(vehicle, 1, 0)
			    SetVehicleForwardSpeed(vehicle, 80.0)
			    StartScreenEffect("RaceTurbo", 0, 0)
			    SetVehicleBoostActive(vehicle, 0, 0)
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do
                    Citizen.Wait(0)
                end
                for i=1, 16 do
                    Citizen.CreateThread(function()
                        local bone = "exhaust_"..i
                        if i == 1 then
                            bone = "exhaust"
                        end
                        if GetEntityBoneIndexByName(vehicle, bone) == -1 then
                            return
                        end
                        local coords = GetWorldPositionOfEntityBone(vehicle, bone)
                        local loopAmount = 25
                        local particleEffects = {}

                        for x=0,loopAmount do
                            UseParticleFxAssetNextCall("core")
                            local particle = StartParticleFxLoopedOnEntityBone("ent_dst_elec_fire_sp", vehicle, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(vehicle, bone), 2.0, false, false, false)
                            SetParticleFxLoopedEvolution(particle, "ent_dst_elec_fire_sp", RPM, 0)
                            table.insert(particleEffects, 1, particle)
                            Citizen.Wait(0)
                        end
                        Citizen.Wait(10)
                        for _,particle in pairs(particleEffects) do
                            StopParticleFxLooped(particle, true)
                        end
                    end)
                end
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while Sessionised do
            SetDiscordRichPresenceAssetSmallText('Demolition')
            SetRichPresence('Demolition: '..CurrentKills.." Kills")
            Citizen.Wait(20000)
        end
    end)
end

function EndDemolition(winner, xp)
   Scaleform.RenderEndScreen(xp, xp/10, winner == PlayerServerId)
   SetPlayerInvincible(PlayerId(), false)
   SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false), 1, 1)
   DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
   Sessionised = false
   Misc.SpectatorMode(false)
end