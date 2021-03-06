--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentCenter
local CurrentKills
local Sessionised = false

RegisterNetEvent("Gamemode:Start:4")
RegisterNetEvent("Gamemode:Session:4")
RegisterNetEvent("Gamemode:FetchCoords:4")
RegisterNetEvent("Gamemode:End:4")
RegisterNetEvent("Gamemode:Init:4")
RegisterNetEvent("Gamemode:Join:4")

AddEventHandler("Gamemode:End:4", function(winner, xp) 
    Citizen.CreateThread(function()
        Sessionised = false
        print(winner, winnername)
        CurrentCenter = {}
        SpawnManager.removeAllSpawnPoints()
        SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
        SpawnManager.forceRespawn()
        --[[ if winner == PlayerServerId then
            local start = GetGameTimer()

            while GetGameTimer() - start < 5000 do 
                Wait(0)
                DrawGameEndScreen(true)
            end
        else
            local start = GetGameTimer()

            while GetGameTimer() - start < 5000 do 
                Wait(0)
                DrawGameEndScreen(false, winnername)
            end
        end ]]
        if winner == PlayerServerId then Scaleform.RenderEndScreen(xp, xp/10, true) else Scaleform.RenderEndScreen(xp, xp/10, false) end
        SpawnManager.forceRespawn()
        Misc.SpectatorMode(false)
    end) 
end)

AddEventHandler("Gamemode:FetchCoords:4", function(Coords, Center)
    --CoordsX, CoordsY, CoordsZ = table.unpack(Misc.SplitString(Coords, ","))
    print(Center)
    CenterX, CenterY, CenterZ = table.unpack(Misc.SplitString(Center, ","))
    SpawnManager.removeAllSpawnPoints()
    for i,spawnpoint in pairs(Coords) do
        print(table.unpack(Misc.SplitString(spawnpoint, ",")))
        local spawnx,spawny,spawnz = table.unpack(Misc.SplitString(spawnpoint, ","))
        --print(tonumber(spawnx),tonumber(spawny),tonumber(spawnz))
        SpawnManager.addSpawnPoint({x=tonumber(spawnx), y=tonumber(spawny), z=tonumber(spawnz), heading = 0.0, model=1657546978})
    end
    --print("Spawnpoints: "..json.encode(Coords))
    --print(CoordsX, CoordsY, CoordsZ)
    --print(CenterX, CenterY, CenterZ)

    CurrentCenter = vector3(tonumber(CenterX),tonumber(CenterY),tonumber(CenterZ))
    --SetEntityCoords(PlayerPedId(), tonumber(CoordsX), tonumber(CoordsY), tonumber(CoordsZ), 0.0, 0.0, 0.0, 0)
    SpawnManager.forceRespawn()
end)

AddEventHandler("Gamemode:Init:4", function()
    -- this removes the initial spawn, no matter what.
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:4")

    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId())

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
    end
    FreezeEntityPosition(PlayerPedId(), false)
    --Wait(10000)
    TriggerEvent("gun_game:UpGunLevel", 1)
    StartGunGame()
end)

AddEventHandler("Gamemode:Join:4", function()
    Misc.SpectatorMode(true)
end)

local GunLevels = {}

local WeaponLevels = {
    "WEAPON_SMG",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_COMBATMG",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_MG",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_SNSPISTOL",
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_FLAREGUN",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_KNIFE",
    "WEAPON_UNARMED",
    -- needs more guns here, also normally a gun game should have progressively worse guns instead of the opposite as done here :D
}

function StartGunGame()
    --Wait(2500)
    RenderScriptCams(false, 1, 500,  true,  true)

    Citizen.CreateThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")

        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")
        UpdateGunLevel(1)

        while Sessionised do
            Citizen.Wait(0)
            local pCoords = GetEntityCoords(PlayerPedId(), true)
            if Misc.Distance(pCoords.x,CurrentCenter.x,pCoords.y,CurrentCenter.y) > 300.0  then
                if not end_time then end_time = GetNetworkTime() + 30000 end

                if (end_time - GetNetworkTime()) > 0 then
                    GUI.MissionText("Go to the ~b~shootout.", 1, 1)
                    Scaleform.Render2D(ShardS)
                    GUI.DrawTimerBar(0.13, "LEAVING AREA", ((end_time - GetNetworkTime()) / 1000), 1)
                    --SetBlipAlpha(Blip, 255)
                else
                    ExplodePedHead(PlayerPedId(), 0x1D073A89)
                    SpawnManager.forceRespawn()
                end
            else
                SetBlipAlpha(Blip, 0)
                end_time = nil
            end
        end
    end)


    Citizen.CreateThread(function()
        --print('should guiiiiii', Sessionised)
        while Sessionised do
            --print(json.encode(GunLevels))
            Citizen.Wait(0)
            GUI.DrawBar(0.13, "LEVEL", GunLevels[tostring(GetPlayerServerId(PlayerId()))], nil, 3)
            GUI.DrawBar(0.13, "KILLS", CurrentKills, nil, 4)
        end
    end)
    Citizen.CreateThread(function()
        while Sessionised do
            Citizen.Wait(0)
            SetCanAttackFriendly(GetPlayerPed(-1), true, false)
            NetworkSetFriendlyFireOption(true)
        end
    end)
    Citizen.CreateThread(function()
        while Sessionised do
            Citizen.Wait(0)
            DrawMarker(1, CurrentCenter.x, CurrentCenter.y, CurrentCenter.z - 300, 0, 0, 0, 0, 0, 0, 600.0, 600.0, 500.0, 0, 0, 255, 200, 0, 0, 0, 0)
        end
    end)
    Citizen.CreateThread(function()
        while Sessionised do
            Citizen.Wait(0)
            local CurrentWeapon = WeaponLevels[GunLevels[tostring(PlayerServerId)]]
            if CurrentWeapon then
                if GetBestPedWeapon(PlayerPedId(),0) ~= GetHashKey(CurrentWeapon) then
                    print("Giving weapon: "..CurrentWeapon)
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    GiveWeaponToPed(PlayerPedId(), GetHashKey(CurrentWeapon), 1000, false, true)
                end
            end
        end
    end)
    Citizen.CreateThread(function()
        while Sessionised do
            SetDiscordRichPresenceAssetSmallText('Gun Game')
            SetRichPresence('Gun Game: '..CurrentKills.." Kills")
            Citizen.Wait(20000)
        end
    end)
end

function UpdateGunLevel(GunLevel)
    local NewWeapon = WeaponLevels[GunLevel]
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    GiveWeaponToPed(ped, GetHashKey(NewWeapon), 1000, false, true)
end

--[[ function DrawGameEndScreen(win, winner)
    print(win, winner)
    local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    if win then
        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~y~YOU WIN!", "You were the first to reach the maximum level!")
    else
        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~YOU LOSE!", winner.." won the game.")
    end
    Scaleform.Render2D(ShardS)
end ]]

RegisterNetEvent("gun_game:UpGunLevel")
AddEventHandler("gun_game:UpGunLevel", function(GunLevel)
    GUI.DrawGameNotification("~g~Level up!~s~ Your gun level is now: ~g~"..GunLevel, true)
    UpdateGunLevel(GunLevel)
end)

RegisterNetEvent("gun_game:DownGunLevel")
AddEventHandler("gun_game:DownGunLevel", function(GunLevel)
    print("gun_game:DownGunLevel")
    GUI.DrawGameNotification("~r~Suicide!~s~ Your gun level is now: ~r~"..GunLevel, true)
    UpdateGunLevel(GunLevel)
end)

RegisterNetEvent("gun_game:UpdateLevels")
AddEventHandler("gun_game:UpdateLevels", function(GunData, PlayersList)
    print("Received GunData: "..json.encode(GunData).." And PlayersList "..json.encode(PlayersList))
    for i,v in ipairs(PlayersList) do
        if v.serverId == PlayerServerId then
            CurrentKills = v.kills
            print("Current Kills set to "..tostring(v.kills))
        end
    end   
    local top3 = {}
    GunLevels = GunData
    table.sort(GunLevels)
    
    for k, v in pairs(GunLevels) do
        print(k, v)
        table.insert(top3, {sid = k, score = v})
    end
end)