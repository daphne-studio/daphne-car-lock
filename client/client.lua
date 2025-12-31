-- Client-side car lock system
-- Handles lock/unlock operations, sound effects, and notifications

local isProcessing = false

-- Debug function
local function DebugPrint(message)
    if Config.Debug then
        print('[daphne-car-lock] ' .. message)
    end
end

-- Play lock sound effect
local function PlayLockSound()
    local soundId = GetSoundId()
    PlaySoundFrontend(soundId, 'CAR_LOCK_SOUNDS', 'HUD_MINI_GAME_SOUNDSET', false)
    ReleaseSoundId(soundId)
end

-- Find nearest vehicle within distance
local function GetNearestVehicle(distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicles = GetGamePool('CVehicle')
    local nearestVehicle = nil
    local nearestDistance = distance

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleCoords = GetEntityCoords(vehicle)
        local dist = #(playerCoords - vehicleCoords)

        if dist < nearestDistance then
            nearestVehicle = vehicle
            nearestDistance = dist
        end
    end

    return nearestVehicle
end

-- Lock/unlock vehicle
local function ToggleVehicleLock(vehicle, newState)
    SetVehicleDoorsLocked(vehicle, newState and 2 or 1) -- 2 = locked, 1 = unlocked

    -- Play light animation
    SetVehicleLights(vehicle, 2)
    Wait(150)
    SetVehicleLights(vehicle, 0)
end

-- Handle lock key press
local function HandleLockKeyPress()
    if isProcessing then
        return
    end

    isProcessing = true

    local playerPed = PlayerPedId()

    -- Check if player is in a vehicle
    if IsPedInAnyVehicle(playerPed, false) then
        isProcessing = false
        return
    end

    -- Find nearest vehicle
    local vehicle = GetNearestVehicle(Config.MaxDistance)

    if not vehicle or not DoesEntityExist(vehicle) then
        exports['daphne-notification']:NotifyError(Config.Messages.NoVehicleNearby, Config.NotificationDuration)
        isProcessing = false
        return
    end

    -- Get vehicle data from daphne-core
    local vehicleData = exports['daphne_core']:GetVehicle(vehicle)

    if not vehicleData or not vehicleData.plate then
        exports['daphne-notification']:NotifyError(Config.Messages.VehicleNotFound, Config.NotificationDuration)
        isProcessing = false
        return
    end

    DebugPrint('Vehicle found: ' .. vehicleData.plate)

    -- Check with server if player has the key
    TriggerServerEvent('daphne-car-lock:server:CheckKey', vehicleData.plate, function(hasKey)
        if hasKey then
            -- Get current lock state
            local isLocked = GetVehicleDoorLockStatus(vehicle) == 2

            -- Toggle lock
            ToggleVehicleLock(vehicle, not isLocked)
            PlayLockSound()

            -- Show notification
            if isLocked then
                exports['daphne-notification']:NotifySuccess(Config.Messages.VehicleUnlocked, Config.NotificationDuration)
                DebugPrint('Vehicle unlocked: ' .. vehicleData.plate)
            else
                exports['daphne-notification']:NotifyInfo(Config.Messages.VehicleLocked, Config.NotificationDuration)
                DebugPrint('Vehicle locked: ' .. vehicleData.plate)
            end
        else
            exports['daphne-notification']:NotifyError(Config.Messages.NoKeys, Config.NotificationDuration)
            DebugPrint('Player does not have keys: ' .. vehicleData.plate)
        end

        isProcessing = false
    end)
end

-- Register key command
RegisterCommand('+toggleVehicleLock', HandleLockKeyPress, false)

-- Set up key mapping
RegisterKeyMapping('+toggleVehicleLock', 'Toggle Vehicle Lock', 'keyboard', Config.LockKey)

-- Client initialization
CreateThread(function()
    DebugPrint('Client initialized')

    -- Wait for daphne-core to be ready
    repeat
        Wait(100)
    until GetResourceState('daphne-core') == 'started'

    DebugPrint('daphne-core is ready')
end)

