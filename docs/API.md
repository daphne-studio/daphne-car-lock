# API Reference

This document provides complete API documentation for daphne-car-lock, including exports, events, and usage examples.

## Table of Contents

- [Server Exports](#server-exports)
- [Client Events](#client-events)
- [Server Events](#server-events)
- [State Bags](#state-bags)
- [Usage Examples](#usage-examples)

---

## Server Exports

### GiveKey

Give a key to a player for a specific vehicle.

**Signature**:

```lua
exports['daphne-car-lock']:GiveKey(playerId, plate)
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| playerId | number | Player ID (server ID) |
| plate | string | Vehicle plate number |

**Returns**:

| Type | Description |
|------|-------------|
| boolean | `true` if key was given successfully, `false` if already exists |

**Example**:

```lua
-- Give key to player for vehicle
local success = exports['daphne-car-lock']:GiveKey(playerId, 'ABC 123')
if success then
    print('Key given successfully')
else
    print('Player already has the key')
end
```

---

### RemoveKey

Remove a key from a player for a specific vehicle.

**Signature**:

```lua
exports['daphne-car-lock']:RemoveKey(playerId, plate)
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| playerId | number | Player ID (server ID) |
| plate | string | Vehicle plate number |

**Returns**:

| Type | Description |
|------|-------------|
| boolean | `true` if key was removed successfully |

**Example**:

```lua
-- Remove key from player
local success = exports['daphne-car-lock']:RemoveKey(playerId, 'ABC 123')
if success then
    print('Key removed successfully')
end
```

---

### HasKey

Check if a player has a key to a specific vehicle.

**Signature**:

```lua
exports['daphne-car-lock']:HasKey(playerId, plate)
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| playerId | number | Player ID (server ID) |
| plate | string | Vehicle plate number |

**Returns**:

| Type | Description |
|------|-------------|
| boolean | `true` if player has the key, `false` otherwise |

**Example**:

```lua
-- Check if player has key
if exports['daphne-car-lock']:HasKey(playerId, 'ABC 123') then
    print('Player has the key')
else
    print('Player does not have the key')
end
```

---

### GetOwnedVehicles

Get all vehicles for which a player has keys.

**Signature**:

```lua
exports['daphne-car-lock']:GetOwnedVehicles(playerId)
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| playerId | number | Player ID (server ID) |

**Returns**:

| Type | Description |
|------|-------------|
| table | Array of vehicle plates (strings) |

**Example**:

```lua
-- Get player's owned vehicles
local ownedVehicles = exports['daphne-car-lock']:GetOwnedVehicles(playerId)
for _, plate in ipairs(ownedVehicles) do
    print('Player has key for: ' .. plate)
end
```

---

## Client Events

### daphne-car-lock:server:CheckKey

Check if the local player has a key to a specific vehicle.

**Note**: This event is automatically called by the client when the player presses the lock key. You typically don't need to call this manually.

**Signature**:

```lua
TriggerServerEvent('daphne-car-lock:server:CheckKey', plate, callback)
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| plate | string | Vehicle plate number |
| callback | function | Callback function that receives a boolean result |

**Callback Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| hasKey | boolean | `true` if player has the key, `false` otherwise |

**Example**:

```lua
-- Check if player has key
TriggerServerEvent('daphne-car-lock:server:CheckKey', 'ABC 123', function(hasKey)
    if hasKey then
        print('Player has the key')
    else
        print('Player does not have the key')
    end
end)
```

---

## Server Events

### QBCore:Client:OnPlayerLoaded

Triggered by QBCore when a player loads.

**Note**: This event is automatically listened to by daphne-car-lock. You don't need to manually trigger it.

### esx:playerLoaded

Triggered by ESX when a player loads.

**Note**: This event is automatically listened to by daphne-car-lock. You don't need to manually trigger it.

### playerSpawned

Triggered by FiveM when a player spawns.

**Note**: This event is automatically listened to by daphne-car-lock. You don't need to manually trigger it.

---

## State Bags

daphne-car-lock uses state bags to store player-owned vehicles.

### Player State Bag

Each player has a state bag that stores their owned vehicles:

```
daphne_car_lock_owned_vehicles
```

**Format**:

```lua
{
    "ABC 123",
    "XYZ 789",
    ...
}
```

**Access**:

```lua
-- Get player's owned vehicles
local stateBag = Entity(playerId).state
local ownedVehicles = stateBag.daphne_car_lock_owned_vehicles or {}

-- Iterate through owned vehicles
for _, plate in ipairs(ownedVehicles) do
    print('Plate: ' .. plate)
end
```

**Note**: While you can access this state bag directly, it's recommended to use the exported functions for better compatibility and future updates.

---

## Usage Examples

### Example 1: Custom Garage System

Integrate with a custom garage system to automatically give keys when a vehicle is purchased.

```lua
-- Server-side: In your garage purchase handler
RegisterNetEvent('mygarage:server:BuyVehicle', function(plate)
    local playerId = source

    -- Give key to player
    exports['daphne-car-lock']:GiveKey(playerId, plate)

    -- Show notification
    exports['daphne-notification']:NotifySuccess(playerId, 'Vehicle purchased and key received', 5000)
end)
```

---

### Example 2: Vehicle Rental System

Manage temporary keys for rental vehicles.

```lua
-- Server-side: Rental system
local rentalTimers = {}

-- Start rental
RegisterNetEvent('rentals:server:StartRental', function(playerId, plate, duration)
    -- Give key
    exports['daphne-car-lock']:GiveKey(playerId, plate)

    -- Set timer to remove key after duration
    rentalTimers[plate] = SetTimeout(duration * 60000, function()
        exports['daphne-car-lock']:RemoveKey(playerId, plate)
        exports['daphne-notification']:NotifyInfo(playerId, 'Rental expired - key removed', 5000)
    end)
end)

-- End rental early
RegisterNetEvent('rentals:server:EndRental', function(playerId, plate)
    -- Remove key
    exports['daphne-car-lock']:RemoveKey(playerId, plate)

    -- Clear timer if exists
    if rentalTimers[plate] then
        ClearTimeout(rentalTimers[plate])
        rentalTimers[plate] = nil
    end
end)
```

---

### Example 3: Police Impound System

Remove keys when a vehicle is impounded and restore when released.

```lua
-- Server-side: Impound system
local impoundedVehicles = {}

-- Impound vehicle
RegisterNetEvent('police:server:ImpoundVehicle', function(plate, ownerId)
    -- Remove key from owner
    exports['daphne-car-lock']:RemoveKey(ownerId, plate)

    -- Store impound data
    impoundedVehicles[plate] = {
        ownerId = ownerId,
        impoundTime = os.time()
    }

    print('Vehicle ' .. plate .. ' impounded')
end)

-- Release vehicle
RegisterNetEvent('police:server:ReleaseVehicle', function(plate)
    local data = impoundedVehicles[plate]

    if data and data.ownerId then
        -- Restore key to owner
        exports['daphne-car-lock']:GiveKey(data.ownerId, plate)

        -- Remove from impound list
        impoundedVehicles[plate] = nil

        print('Vehicle ' .. plate .. ' released to owner ' .. data.ownerId)
    end
end)
```

---

### Example 4: Vehicle Sharing System

Allow players to share vehicle keys with others.

```lua
-- Server-side: Vehicle sharing
RegisterNetEvent('vehicle-sharing:server:ShareKey', function(targetId, plate)
    local playerId = source

    -- Check if player has the key
    if exports['daphne-car-lock']:HasKey(playerId, plate) then
        -- Give key to target player
        local success = exports['daphne-car-lock']:GiveKey(targetId, plate)

        if success then
            -- Notify both players
            exports['daphne-notification']:NotifySuccess(playerId, 'Key shared successfully', 3000)
            exports['daphne-notification']:NotifySuccess(targetId, 'You received a vehicle key', 3000)
        else
            exports['daphne-notification']:NotifyInfo(playerId, 'Player already has the key', 3000)
        end
    else
        exports['daphne-notification']:NotifyError(playerId, 'You do not have this key', 3000)
    end
end)

-- Revoke shared key
RegisterNetEvent('vehicle-sharing:server:RevokeKey', function(targetId, plate)
    local playerId = source

    -- Check if player has the key (owner check)
    if exports['daphne-car-lock']:HasKey(playerId, plate) then
        -- Remove key from target player
        exports['daphne-car-lock']:RemoveKey(targetId, plate)

        -- Notify both players
        exports['daphne-notification']:NotifySuccess(playerId, 'Key revoked successfully', 3000)
        exports['daphne-notification']:NotifyInfo(targetId, 'Your vehicle key has been revoked', 3000)
    end
end)
```

---

### Example 5: Dealership Integration

Automatically manage keys for purchased vehicles.

```lua
-- Server-side: Dealership
RegisterNetEvent('dealership:server:PurchaseVehicle', function(plate, price)
    local playerId = source

    -- Check player money (using daphne-core)
    local playerData = exports['daphne_core']:GetPlayerData(playerId)

    if playerData and playerData.money and playerData.money.cash >= price then
        -- Remove money
        exports['daphne_core']:RemoveMoney(playerId, 'cash', price)

        -- Give key
        exports['daphne-car-lock']:GiveKey(playerId, plate)

        -- Success notification
        exports['daphne-notification']:NotifySuccess(playerId, 'Vehicle purchased! Key received.', 5000)
    else
        -- Error notification
        exports['daphne-notification']:NotifyError(playerId, 'Insufficient funds', 3000)
    end
end)

-- Sell vehicle back
RegisterNetEvent('dealership:server:SellVehicle', function(plate, sellPrice)
    local playerId = source

    -- Check if player owns the vehicle
    if exports['daphne-car-lock']:HasKey(playerId, plate) then
        -- Remove key
        exports['daphne-car-lock']:RemoveKey(playerId, plate)

        -- Add money
        exports['daphne_core']:AddMoney(playerId, 'cash', sellPrice)

        -- Success notification
        exports['daphne-notification']:NotifySuccess(playerId, 'Vehicle sold! Key removed.', 5000)
    else
        exports['daphne-notification']:NotifyError(playerId, 'You do not own this vehicle', 3000)
    end
end)
```

---

### Example 6: Key Management UI

Create a simple command to list owned vehicles.

```lua
-- Server-side: Key management command
RegisterCommand('mykeys', function(source, args, rawCommand)
    local playerId = source

    -- Get owned vehicles
    local ownedVehicles = exports['daphne-car-lock']:GetOwnedVehicles(playerId)

    if #ownedVehicles > 0 then
        exports['daphne-notification']:NotifyInfo(playerId, 'You have ' .. #ownedVehicles .. ' vehicle keys:', 5000)

        for i, plate in ipairs(ownedVehicles) do
            -- Send plate info (using notification or other method)
            exports['daphne-notification']:NotifyInfo(playerId, i .. '. ' .. plate, 5000)
        end
    else
        exports['daphne-notification']:NotifyInfo(playerId, 'You do not have any vehicle keys', 3000)
    end
end, false)
```

---

## Best Practices

### 1. Always Check Ownership

Before giving keys to other players, verify the player owns the vehicle:

```lua
if exports['daphne-car-lock']:HasKey(playerId, plate) then
    -- Player owns the vehicle
end
```

### 2. Use Notifications

Always notify players about key changes:

```lua
-- Success
exports['daphne-notification']:NotifySuccess(playerId, 'Key added', 3000)

-- Info
exports['daphne-notification']:NotifyInfo(playerId, 'Key removed', 3000)

-- Error
exports['daphne-notification']:NotifyError(playerId, 'Action failed', 3000)
```

### 3. Handle Failures Gracefully

Always handle API failures gracefully:

```lua
local success = exports['daphne-car-lock']:GiveKey(playerId, plate)
if success then
    -- Handle success
else
    -- Handle failure (e.g., key already exists)
    exports['daphne-notification']:NotifyInfo(playerId, 'Key already exists', 3000)
end
```

### 4. Use Server-Side Validation

Always validate ownership on the server side:

```lua
-- Server-side validation
RegisterNetEvent('myresource:server:DoSomething', function(plate)
    local playerId = source

    if exports['daphne-car-lock']:HasKey(playerId, plate) then
        -- Proceed with action
    else
        -- Deny action
        exports['daphne-notification']:NotifyError(playerId, 'You do not own this vehicle', 3000)
    end
end)
```

---

## Next Steps

- [Installation Guide](INSTALLATION.md) - Get started with installation
- [Configuration Guide](CONFIGURATION.md) - Customize the system
- [Documentation Index](README.md) - Explore more resources

---

## Support

For help with the API:

1. Review the [Usage Examples](#usage-examples)
2. Check the [Best Practices](#best-practices)
3. Join [Daphne Studio's Discord Server](https://discord.gg/daphne)
4. Open an issue on [GitHub](https://github.com/daphne-studio/daphne-car-lock/issues)


