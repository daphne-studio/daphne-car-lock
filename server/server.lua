-- Server-side car lock system
-- Handles key management and daphne-core integration

-- Debug function
local function DebugPrint(message)
    if Config.Debug then
        print('[daphne-car-lock] ' .. message)
    end
end

-- Load utility functions
-- Note: We use the resource name directly since utils.lua exports functions
local function NotifyPlayer(playerId, type, message)
    if type == 'success' then
        exports['daphne-notification']:NotifySuccess(playerId, message, Config.NotificationDuration)
    elseif type == 'error' then
        exports['daphne-notification']:NotifyError(playerId, message, Config.NotificationDuration)
    elseif type == 'info' then
        exports['daphne-notification']:NotifyInfo(playerId, message, Config.NotificationDuration)
    elseif type == 'warning' then
        exports['daphne-notification']:NotifyWarning(playerId, message, Config.NotificationDuration)
    end
end

local function GetPlayerOwnedVehicles(playerId)
    return exports['daphne-car-lock']:GetPlayerOwnedVehicles(playerId)
end

local function PlayerHasKey(playerId, plate)
    return exports['daphne-car-lock']:HasKey(playerId, plate)
end

local function AddVehicleToPlayer(playerId, plate)
    return exports['daphne-car-lock']:AddVehicleToPlayer(playerId, plate)
end

local function RemoveVehicleFromPlayer(playerId, plate)
    return exports['daphne-car-lock']:RemoveVehicleFromPlayer(playerId, plate)
end

local function FindVehicleByPlate(plate)
    return exports['daphne-car-lock']:FindVehicleByPlate(plate)
end

-- Notify player using daphne-notification
local function NotifyPlayer(playerId, type, message)
    if type == 'success' then
        exports['daphne-notification']:NotifySuccess(playerId, message, Config.NotificationDuration)
    elseif type == 'error' then
        exports['daphne-notification']:NotifyError(playerId, message, Config.NotificationDuration)
    elseif type == 'info' then
        exports['daphne-notification']:NotifyInfo(playerId, message, Config.NotificationDuration)
    elseif type == 'warning' then
        exports['daphne-notification']:NotifyWarning(playerId, message, Config.NotificationDuration)
    end
end

-- Get player's owned vehicles from state bag
local function GetPlayerOwnedVehicles(playerId)
    local stateBag = Entity(playerId).state
    local ownedVehicles = stateBag.daphne_car_lock_owned_vehicles or {}

    return ownedVehicles
end

-- Check if player has key to vehicle
local function PlayerHasKey(playerId, plate)
    local ownedVehicles = GetPlayerOwnedVehicles(playerId)

    for _, vehiclePlate in ipairs(ownedVehicles) do
        if vehiclePlate == plate then
            return true
        end
    end

    return false
end

-- Add vehicle to player's owned vehicles
local function AddVehicleToPlayer(playerId, plate)
    local stateBag = Entity(playerId).state
    local ownedVehicles = stateBag.daphne_car_lock_owned_vehicles or {}

    -- Check if vehicle is already in the list
    for _, vehiclePlate in ipairs(ownedVehicles) do
        if vehiclePlate == plate then
            return false -- Already exists
        end
    end

    -- Add vehicle to list
    table.insert(ownedVehicles, plate)
    stateBag.daphne_car_lock_owned_vehicles = ownedVehicles

    DebugPrint('Added vehicle to player ' .. playerId .. ': ' .. plate)

    return true
end

-- Remove vehicle from player's owned vehicles
local function RemoveVehicleFromPlayer(playerId, plate)
    local stateBag = Entity(playerId).state
    local ownedVehicles = stateBag.daphne_car_lock_owned_vehicles or {}

    -- Remove vehicle from list
    local newOwnedVehicles = {}
    for _, vehiclePlate in ipairs(ownedVehicles) do
        if vehiclePlate ~= plate then
            table.insert(newOwnedVehicles, vehiclePlate)
        end
    end

    stateBag.daphne_car_lock_owned_vehicles = newOwnedVehicles

    DebugPrint('Removed vehicle from player ' .. playerId .. ': ' .. plate)

    return true
end

-- Find vehicle by plate (server-side)
local function FindVehicleByPlate(plate)
    -- Get all vehicles from the vehicle pool
    local vehicles = GetGamePool('CVehicle')

    for _, vehicle in ipairs(vehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)

        if vehiclePlate == plate then
            return vehicle
        end
    end

    return nil
end

-- Get player's owned vehicles from database via daphne-core
local function GetPlayerVehiclesFromDatabase(playerId)
    local success, playerData = pcall(function()
        return exports['daphne_core']:GetPlayerData(playerId)
    end)

    if not success or not playerData then
        DebugPrint('Failed to get player data for ' .. playerId)
        return {}
    end

    DebugPrint('Player data type: ' .. type(playerData))

    -- Check if player has inventory with vehicles
    -- Note: This depends on the framework's vehicle storage system
    -- For QBCore/Qbox: playerData.vehicles
    -- For ESX: playerData.accounts (if stored there)
    -- For ND_Core: playerData.vehicles

    local vehicles = {}

    -- Try to get vehicles from different locations based on framework
    -- Handle nested PlayerData structure
    local dataToCheck = playerData
    if playerData.PlayerData then
        dataToCheck = playerData.PlayerData
    end

    if dataToCheck.vehicles then
        vehicles = dataToCheck.vehicles
    elseif dataToCheck.inventory then
        -- Check inventory for vehicle items
        for _, item in ipairs(dataToCheck.inventory) do
            if item.name == 'vehicle' or item.type == 'vehicle' then
                table.insert(vehicles, item)
            end
        end
    end

    DebugPrint('Found ' .. #vehicles .. ' vehicles for player ' .. playerId)

    return vehicles
end

-- Give keys to player on spawn
local function GiveKeysToPlayer(playerId)
    local vehicles = GetPlayerVehiclesFromDatabase(playerId)

    if #vehicles == 0 then
        DebugPrint('No vehicles found for player ' .. playerId)
        return
    end

    local keysGiven = 0

    for _, vehicle in ipairs(vehicles) do
        -- Extract plate from vehicle data
        local plate = nil

        if vehicle.plate then
            plate = vehicle.plate
        elseif vehicle.props and vehicle.props.plate then
            plate = vehicle.props.plate
        end

        if plate then
            -- Add to state bag
            local success = AddVehicleToPlayer(playerId, plate)

            if success then
                keysGiven = keysGiven + 1
                DebugPrint('Gave key to player ' .. playerId .. ' for vehicle ' .. plate)
            end
        end
    end

    DebugPrint('Total keys given to player ' .. playerId .. ': ' .. keysGiven)
end

-- Check if player has key to vehicle
RegisterNetEvent('daphne-car-lock:server:CheckKey', function(plate, callback)
    local playerId = source

    local hasKey = PlayerHasKey(playerId, plate)

    -- Debug logging
    if Config.Debug then
        if hasKey then
            DebugPrint('Player ' .. playerId .. ' has key for ' .. plate)
        else
            DebugPrint('Player ' .. playerId .. ' does NOT have key for ' .. plate)
        end
    end

    callback(hasKey)
end)

-- Handle player spawning
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local playerId = source
    DebugPrint('Player ' .. playerId .. ' loaded (QBCore)')
    GiveKeysToPlayer(playerId)
end)

RegisterNetEvent('esx:playerLoaded', function()
    local playerId = source
    DebugPrint('Player ' .. playerId .. ' loaded (ESX)')
    GiveKeysToPlayer(playerId)
end)

RegisterNetEvent('playerSpawned', function()
    local playerId = source
    DebugPrint('Player ' .. playerId .. ' spawned')
    GiveKeysToPlayer(playerId)
end)

-- Manual key management exports
-- Give key to player
exports('GiveKey', function(playerId, plate)
    return AddVehicleToPlayer(playerId, plate)
end)

-- Remove key from player
exports('RemoveKey', function(playerId, plate)
return RemoveVehicleFromPlayer(playerId, plate)
end)

-- Check if player has key
exports('HasKey', function(playerId, plate)
    return PlayerHasKey(playerId, plate)
end)

-- Get player's owned vehicles
exports('GetOwnedVehicles', function(playerId)
    return GetPlayerOwnedVehicles(playerId)
end)

-- Handle /car command for automatic key distribution
-- This allows other scripts to automatically give keys when distributing vehicles
-- Example: When a player receives a vehicle from /car command
RegisterCommand('vehicle', function(source, args)
    if not Config.AutoGiveKeys then
        DebugPrint('AutoGiveKeys is disabled')
        return
    end

    local playerId = source

    -- Check if player has the target vehicle
    -- This is useful when combined with vehicle distribution systems
    -- The /car command should pass vehicle information
    if #args > 0 then
        -- If arguments are provided, it might be vehicle info
        -- However, we don't know the exact format used by the /car script
        -- So we just refresh the player's keys from database
        GiveKeysToPlayer(playerId)
        DebugPrint('Refreshed keys for player ' .. playerId)

        -- Show notification
        NotifyPlayer(playerId, 'info', Config.Messages.KeyReceived)
    else
        DebugPrint('/car command called without arguments, refreshing keys')
    end
end, false)

-- Server initialization
CreateThread(function()
    DebugPrint('Server initialized')

    -- Wait for daphne-core to be ready
    repeat
        Wait(100)
    until GetResourceState('daphne-core') == 'started'

    -- Wait for daphne-notification to be ready
    repeat
        Wait(100)
    until GetResourceState('daphne-notification') == 'started'

    DebugPrint('daphne-core is ready')
    DebugPrint('daphne-notification is ready')

    -- Wait a bit more to ensure daphne-core is fully initialized
    -- This is important because GetPlayerData might not be ready immediately
    Wait(1000)

    DebugPrint('daphne-core is fully initialized')

    -- Give keys to already connected players
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerIdNum = tonumber(playerId)
        if playerIdNum then
            GiveKeysToPlayer(playerIdNum)
        end
    end

    DebugPrint('Gave keys to ' .. #players .. ' existing players')
end)

