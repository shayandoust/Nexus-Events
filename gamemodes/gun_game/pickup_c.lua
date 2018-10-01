-- TODO: Need Humane Labs coordinates

ReachedDest = false
PickupInService = false

RegisterNetEvent("Gamemode:SpawnPickup:4")

AddEventHandler("Gamemode:SpawnPickup:4", function()
    local PickupVehModel = GetHashKey("rumpo")
    local PickupDriverModel = GetHashKey("a_m_y_stlat_01")
    local PickupVeh = nil
    local PickupDriver = nil
    local PickupVehBlip = nil

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(1, 2), 0, 0, 0)
    local X_, Y_, Z_ = table.unpack(vector)

    if not DoesEntityExist(PickupVeh) then
        RequestModel(PickupVehModel)
        RequestModel(PickupDriverModel)

        while not HasModelLoaded(PickupVehModel) or HasModelLoaded(PickupVehModel) do
            Wait(0)
        end

        PickupVeh = CreateVehicle(PickupVehModel, X_, Y_, Z_, 0, true, false)
        PickupDriver = CreatePedInsideVehicle(PickupVeh, 26, PickupDriverModel, -1 , true, false)

        SetEntityAsMissionEntity(PickupVeh, true, true)
        SetVehicleEngineOn(PickupVeh, true)
        SetAmbientVoiceName(PickupDriver, "A_M_M_EASTSA_02_LATINO_FULL_01")

        if not DoesBlipExit(PickupVehBlip) then
            PickupVehBlip = AddBlipForEntity(PickupVeh)
            SetBlipSprite(PickupVehBlip, 198)
            SetBlipFlashes(PickupVehBlip, true)
        end

        Wait(1000)

        SetModelAsNoLongerNeeded(PickupDriverModel)
        PickupInService = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 38) then
            local PickupDriver_ = GetPedInVehicleSeat(Vehicle, -1)
            SetBlockingOfNonTemporaryEvents(Vehicle, true)

            if not IsPedInVehicle(PlayerPedId(), Vehicle, false) then
                TaskEnterVehicle(PlayerPedId(), Vehicle, -1, 2, -1, 0)
                PickupInService = true
            end
        end

        if PickupInService and not ReachedDest then
            if IsPedInVehicle(PlayerPedId(), Vehicle, true) then
                -- todo
            end
        end
    end
end)