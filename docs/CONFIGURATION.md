# Configuration Guide

This guide explains all configuration options available in daphne-car-lock.

## Config File Location

The configuration file is located at:

```
daphne-car-lock/config.lua
```

## Configuration Options

### Lock Key

The key used to lock/unlock vehicles.

```lua
Config.LockKey = 'L'
```

**Default**: `'L'`

**Options**:
- Any valid FiveM key name (e.g., 'U', 'L', 'K', 'F7')
- See [FiveM Control Names](https://docs.fivem.net/docs/scripting-reference/controls/) for available keys

**Notes**:
- This key is case-insensitive
- You can change this to any key that doesn't conflict with other resources
- 'L' key is recommended to avoid conflicts with the Use key (E)

**Example**:

```lua
-- Use 'K' for Lock
Config.LockKey = 'K'

-- Change to F7 for a special key
Config.LockKey = 'F7'
```

---

### Maximum Distance

The maximum distance (in meters) from which a player can interact with a vehicle.

```lua
Config.MaxDistance = 3.0
```

**Default**: `3.0`

**Options**:
- Any positive number (in meters)
- Recommended range: 2.0 - 5.0

**Notes**:
- Smaller values require players to be closer to vehicles
- Larger values may lead to accidental lock/unlock of wrong vehicles
- Distance is measured in 3D space

**Example**:

```lua
-- Make players get closer (2.5 meters)
Config.MaxDistance = 2.5

-- Allow interaction from further away (4.0 meters)
Config.MaxDistance = 4.0
```

---

### Auto Give Keys

Automatically give keys to players when they receive vehicles through commands like `/car`.

```lua
Config.AutoGiveKeys = true
```

**Default**: `true`

**Options**:
- `true` - Enable automatic key distribution
- `false` - Disable automatic key distribution

**Notes**:
- When enabled, the `/car` command will automatically refresh player keys
- Useful for integration with vehicle distribution systems
- Players must manually manage keys if disabled

**Example**:

```lua
-- Enable automatic key distribution
Config.AutoGiveKeys = true

-- Disable automatic key distribution
Config.AutoGiveKeys = false
```

**How It Works**:

When a player uses the `/car` command (or similar vehicle distribution commands), this system will automatically give them the keys if `Config.AutoGiveKeys` is enabled. This eliminates the need for manual key management after receiving a vehicle.

**Integration Example**:

If you have a vehicle distribution system that uses the `/car` command:

```lua
-- Your vehicle distribution script
RegisterCommand('givecar', function(source, args)
    -- Give vehicle to player using your system
    -- daphne-car-lock will automatically handle keys if AutoGiveKeys is enabled
end)
```

The `/car` command in daphne-car-lock will refresh the player's keys from the database, ensuring they have access to all their owned vehicles.

---

### Sound Volume

The volume level for the lock sound effect.

```lua
Config.SoundVolume = 0.5
```

**Default**: `0.5`

**Options**:
- Range: `0.0` (muted) to `1.0` (maximum volume)
- Recommended range: 0.3 - 0.7

**Notes**:
- Uses GTA V's built-in car lock sound
- The sound is played on the client side

**Example**:

```lua
-- Louder sound
Config.SoundVolume = 0.7

-- Quieter sound
Config.SoundVolume = 0.3
```

---

### Notification Duration

How long notifications remain on screen (in milliseconds).

```lua
Config.NotificationDuration = 3000
```

**Default**: `3000` (3 seconds)

**Options**:
- Any positive integer (in milliseconds)
- Recommended range: 2000 - 5000

**Notes**:
- This affects all notifications from daphne-car-lock
- daphne-notification has its own configuration for position and style

**Example**:

```lua
-- Shorter notifications (2 seconds)
Config.NotificationDuration = 2000

-- Longer notifications (5 seconds)
Config.NotificationDuration = 5000
```

---

### Debug Mode

Enable debug logging for troubleshooting.

```lua
Config.Debug = false
```

**Default**: `false`

**Options**:
- `true` - Enable debug logging
- `false` - Disable debug logging

**Notes**:
- Debug messages appear in the server console
- Debug messages appear in the client console (F8)
- Should be disabled on production servers for better performance

**Example**:

```lua
-- Enable debug mode for troubleshooting
Config.Debug = true

-- Disable debug mode (recommended for production)
Config.Debug = false
```

---

### Messages

All notification messages displayed to players.

```lua
Config.Messages = {
    VehicleUnlocked = 'Vehicle unlocked',
    VehicleLocked = 'Vehicle locked',
    NoKeys = 'You do not have the keys to this vehicle',
    NoVehicleNearby = 'No vehicle nearby',
    VehicleNotFound = 'Vehicle not found',
}
```

**Language**: English

#### Vehicle Unlocked

```lua
VehicleUnlocked = 'Vehicle unlocked'
```

**When shown**: When a player successfully unlocks a vehicle

#### Vehicle Locked

```lua
VehicleLocked = 'Vehicle locked'
```

**When shown**: When a player successfully locks a vehicle

#### No Keys

```lua
NoKeys = 'You do not have the keys to this vehicle'
```

**When shown**: When a player tries to lock/unlock a vehicle they don't own

#### No Vehicle Nearby

```lua
NoVehicleNearby = 'No vehicle nearby'
```

**When shown**: When no vehicle is found within the maximum distance

#### Vehicle Not Found

```lua
VehicleNotFound = 'Vehicle not found'
```

**When shown**: When vehicle data cannot be retrieved from daphne-core

**Customization Example**:

```lua
Config.Messages = {
    VehicleUnlocked = 'Vehicle unlocked',
    VehicleLocked = 'Vehicle locked',
    NoKeys = 'You do not have the keys to this vehicle',
    NoVehicleNearby = 'No vehicle nearby',
    VehicleNotFound = 'Vehicle not found',

    -- You can add custom messages here
    -- However, the core messages should remain in English
}
```

---

## Complete Configuration Example

Here's a complete example with all options customized:

```lua
Config = {}

-- Key configuration
-- Default key to lock/unlock vehicles
Config.LockKey = 'U'

-- Maximum distance to interact with vehicles (in meters)
Config.MaxDistance = 3.0

-- Sound configuration
Config.SoundVolume = 0.5

-- Notification duration (in milliseconds)
Config.NotificationDuration = 3000

-- Debug mode
-- Enable for console logging and debugging
Config.Debug = false

-- Messages (all in English)
Config.Messages = {
    -- Success messages
    VehicleUnlocked = 'Vehicle unlocked',
    VehicleLocked = 'Vehicle locked',

    -- Error messages
    NoKeys = 'You do not have the keys to this vehicle',
    NoVehicleNearby = 'No vehicle nearby',
    VehicleNotFound = 'Vehicle not found',
}
```

---

## Framework-Specific Configuration

### QBCore/Qbox

No additional configuration is required. The system automatically integrates with QBCore/Qbox via daphne-core.

### ESX Legacy

No additional configuration is required. The system automatically integrates with ESX Legacy via daphne-core.

### ND_Core

No additional configuration is required. The system automatically integrates with ND_Core via daphne-core.

---

## Testing Your Configuration

After making changes to the configuration:

1. Restart the resource:
   ```
   restart daphne-car-lock
   ```

2. Test each changed setting:
   - **Lock key**: Press the configured key near a vehicle
   - **Max distance**: Try locking/unlocking from different distances
   - **Sound volume**: Check if the sound volume is appropriate
   - **Notification duration**: Observe how long notifications stay on screen
   - **Debug mode**: Check console for debug messages

3. Monitor server performance:
   ```
   monitor resources
   ```

4. Check player feedback and adjust as needed

---

## Performance Considerations

### Debug Mode

Always disable `Config.Debug` on production servers:

```lua
Config.Debug = false  -- Recommended for production
```

Debug mode adds console logging overhead and should only be enabled during development or troubleshooting.

### Notification Duration

Shorter notification durations (2000-3000ms) are better for:

- High-frequency actions
- Players who prefer quick feedback
- Competitive gameplay

Longer notification durations (4000-5000ms) are better for:

- Roleplay servers
- New players who need more time to read
- Important notifications

---

## Troubleshooting Configuration Issues

### Key Not Working

**Problem**: Pressing the key doesn't lock/unlock vehicles

**Solutions**:
1. Verify the key name is correct (case-insensitive)
2. Check for key conflicts with other resources
3. Ensure you're within the maximum distance
4. Make sure you're not inside a vehicle
5. Enable debug mode to see console messages

### Distance Issues

**Problem**: Can't lock/unlock from expected distance

**Solutions**:
1. Measure distance in-game (use a measuring tool or estimate)
2. Adjust `Config.MaxDistance` value
3. Remember distance is measured in 3D space
4. Check debug console for distance readings

### Notifications Too Long/Short

**Problem**: Notification duration is not appropriate

**Solutions**:
1. Adjust `Config.NotificationDuration` (in milliseconds)
2. Test with different values to find the sweet spot
3. Consider player feedback

---

## Advanced Configuration

### Multiple Lock Keys

To support multiple keys, you can modify the client code to listen for multiple keys. However, this requires code modifications and is not recommended for most use cases.

### Context-Aware Locking

The current system locks the nearest vehicle. To implement context-aware locking (e.g., only lock the vehicle the player is looking at), you would need to modify the client-side code in `client/client.lua`.

### Custom Sound Effects

The system uses GTA V's built-in `CAR_LOCK_SOUNDS` from the `HUD_MINI_GAME_SOUNDSET`. To use custom sounds:

1. Add your sound file to `shared/sounds/`
2. Modify the `PlayLockSound()` function in `client/client.lua`
3. Update `fxmanifest.lua` to include the sound file

---

## Next Steps

- [Installation Guide](INSTALLATION.md) - If you haven't installed yet
- [API Reference](API.md) - For advanced customization
- [Documentation Index](README.md) - For more resources

---

## Support

If you need help with configuration:

1. Check the [troubleshooting section](#troubleshooting-configuration-issues)
2. Review the [Installation Guide](INSTALLATION.md)
3. Join [Daphne Studio's Discord Server](https://discord.gg/daphne)
4. Open an issue on [GitHub](https://github.com/daphne-studio/daphne-car-lock/issues)

