local InitPos = {3615.9, 3789.83, 29.2}
Sessionised = true

RegisterNetEvent("Gamemode:Start:4")
RegisterNetEvent("Gamemode:Session:4")

AddEventHandler("Gamemode:Init:4", function(GamemodeData)
    local x,y,z = table.unpack(InitPos)

    SetEntityCoords(PlayerPedId(), 199.32, -935.56, 32.0, 0.0, 0.0, 0.0, 0)
    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, 3615.9, 3799.83, 29.2 + 35)
    SetCamRot(view1, -20.0, 0.0, 180.0)
    SetCamFov(view1, 45.0)
    RenderScriptCams(true, 1, 500,  true,  true)
    AnimatedShakeCam(view1,"shake_cam_all@", "light", "", 1)
   
    Wait(10000)
    
    DestroyCam(view1, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    SetFocusEntity(GetPlayerPed(PlayerId()))

    StartMain()

end)

AddEventHandler("Gamemode:Start:4", function()
    Sessionised = true
    StartMain()
end)


local GunLevels = {}

local WeaponLevels = {
    "WEAPON_PISTOL",
    "WEAPON_SMG",
    "WEAPON_RPG",
    "WEAPON_COMBATMG"
}

function StartMain()
    Wait(2500)
    RenderScriptCams(false, 1, 500,  true,  true)

    Citizen.CreateThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
        local bx,by,bz = table.unpack(InitPos)
        local Blip = AddBlipForCoord(bx, by, bz)

        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")
        SetBlipAlpha(Blip, 0)
        UpdateGunLevel(2)

        while true do
            Citizen.Wait(0)
            if not IsEntityInArea(IsPedInAnyVehicle(PlayerPedId(), true) and GetVehiclePedIsIn(PlayerPedId(), false) or PlayerPedId(), 290.91, -858.1, 20.23, 107.82, -1003.69, 47.8, 1, 1, 1) then
                if not end_time then end_time = GetNetworkTime() + 30000 end

                if (end_time - GetNetworkTime()) > 0 then
                    GUI.MissionText("Go to the ~y~shootout.", 1, 1)
                    Scaleform.Render2D(ShardS)
                    GUI.DrawTimerBar(0.13, "LEAVING AREA", ((end_time - GetNetworkTime()) / 1000), 1)
                    SetBlipAlpha(Blip, 255)
                end
            else
                SetBlipAlpha(Blip, 0)
                end_time = nil
            end
        end
    end)


    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            GUI.DrawBar(0.13, "YOUR SCORE", GunLevel, nil, 1)
        end
    end)
end

function UpdateGunLevel(GunLevel)
    local OldWeapon = WeaponLevels[GunLevel - 1]
    local NewWeapon = WeaponLevels[GunLevel]
    local ped = PlayerPedId()

    if OldWeapon then 
        RemoveWeaponFromPed(ped, GetHashKey(OldWeapon))
    end

    GiveWeaponToPed(ped, GetHashKey(NewWeapon), 1000, false, true)
end

RegisterNetEvent("gun_game:UpGunLevel")
AddEventHandler("gun_game:UpGunLevel", function(GunLevel)
    GUI.DrawGameNotification("~g~Level up!~s~ Your gun level is now: ~g~"..GunLevel, true)
    UpdateGunLevel(GunLevel)
end)

RegisterNetEvent("gun_game:UpdateLevels")
AddEventHandler("gun_game:UpdateLevels", function(GunData)
    local top3 = {}
    GunLevels = GunData

    table.sort(GunLevels)
    
    for k, v in pairs(GunLevels) do
        print(k, v)
        table.insert(top3, {sid = k, score = v})
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        TriggerServerEvent("Gamemode:Heartbeat:4", PlayerId())
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        SetEntityCoords(PlayerPedId(), 3615.9, 3789.83, 29.2, 0.0, 0.0, 0.0, 0)
        N_0xd8295af639fd9cb8(PlayerPedId())

        view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(view1, 3615.9, 3799.83, 29.2 + 35)
        SetCamRot(view1, -20.0, 0.0, 180.0)
        SetCamFov(view1, 45.0)
        RenderScriptCams(true, 1, 500,  true,  true)
        AnimatedShakeCam(view1,"shake_cam_all@", "light", "", 1)
       
        Wait(10000)
        DestroyCam(view1, 0)
        RenderScriptCams(0, 0, 1, 1, 1)
        SetFocusEntity(GetPlayerPed(PlayerId()))

        Wait(100000)
    end    
end)