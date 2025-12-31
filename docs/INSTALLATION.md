# Installation Guide

This guide will walk you through the installation process for daphne-car-lock.

## Prerequisites

Before installing daphne-car-lock, make sure you have:

- A FiveM server (Lua 5.4 support)
- Access to your server's file system
- daphne-core installed (see below)
- daphne-notification installed (see below)

## Step 1: Install Dependencies

### daphne-core

daphne-car-lock requires daphne-core for framework abstraction.

1. Navigate to your `resources` folder
2. Clone the daphne-core repository:

```bash
cd resources
git clone https://github.com/daphne-studio/daphne-core.git
```

3. Or download the ZIP file from [GitHub](https://github.com/daphne-studio/daphne-core) and extract it to your `resources` folder

### daphne-notification

daphne-car-lock requires daphne-notification for notifications.

1. Navigate to your `resources` folder
2. Clone the daphne-notification repository:

```bash
cd resources
git clone https://github.com/daphne-studio/daphne-notification.git
```

3. Build the React application:

```bash
cd daphne-notification
npm install
npm run build
```

4. Or download the pre-built release from [GitHub](https://github.com/daphne-studio/daphne-notification) and extract it to your `resources` folder

## Step 2: Install daphne-car-lock

1. Clone or download daphne-car-lock to your `resources` folder:

```bash
cd resources
git clone <repository-url> daphne-car-lock
```

2. Or download the ZIP file and extract it to your `resources` folder

## Step 3: Configure server.cfg

Add the following lines to your `server.cfg` file. The order is important:

```lua
# Dependencies
ensure daphne-core
ensure daphne-notification

# daphne-car-lock
ensure daphne-car-lock
```

**Important**: Make sure daphne-core and daphne-notification are started BEFORE daphne-car-lock.

## Step 4: Configure daphne-car-lock

Open `config.lua` in the daphne-car-lock folder and customize the settings:

```lua
Config = {}

-- Key configuration
Config.LockKey = 'L'  -- Change this to your preferred key

-- Maximum distance to interact with vehicles (in meters)
Config.MaxDistance = 3.0

-- Sound configuration
Config.SoundVolume = 0.5

-- Notification duration (in milliseconds)
Config.NotificationDuration = 3000

-- Debug mode
Config.Debug = false  -- Set to true for debugging

-- Messages (all in English)
Config.Messages = {
    VehicleUnlocked = 'Vehicle unlocked',
    VehicleLocked = 'Vehicle locked',
    NoKeys = 'You do not have the keys to this vehicle',
    NoVehicleNearby = 'No vehicle nearby',
    VehicleNotFound = 'Vehicle not found',
}
```

For more configuration options, see the [Configuration Guide](CONFIGURATION.md).

## Step 5: Start the Server

Start your FiveM server or restart it if it's already running.

### Automatic Restart

If your server is already running, you can restart the resources:

```bash
restart daphne-core
restart daphne-notification
restart daphne-car-lock
```

Or from the server console:

```
restart daphne-core
restart daphne-notification
restart daphne-car-lock
```

## Step 6: Verify Installation

1. Join your server
2. When you spawn, check the console (F8) for `[daphne-car-lock]` messages
3. Try locking/unlocking a vehicle by pressing the L key
4. Check for notifications appearing in the top-right corner

**Automatic Key Distribution**:

By default, daphne-car-lock automatically gives keys to players when they spawn. If you use a vehicle distribution system (like `/car` command), keys will also be automatically refreshed.

To verify automatic key distribution:
1. Use `/car` command to receive a vehicle
2. Check console for `Refreshed keys for player` message
3. Try locking/unlocking the vehicle

To disable automatic key distribution, see [Configuration Guide](CONFIGURATION.md).

## Troubleshooting

### Resource not starting

**Problem**: daphne-car-lock doesn't start

**Solutions**:
1. Check that daphne-core is started: `ensure daphne-core`
2. Check that daphne-notification is started: `ensure daphne-notification`
3. Check the server console for error messages
4. Verify the resource is in the correct location: `resources/daphne-car-lock`

### Keys not being given to players

**Problem**: Players don't receive keys to their vehicles

**Solutions**:
1. Enable debug mode in `config.lua`: `Config.Debug = true`
2. Check the server console for error messages
3. Verify daphne-core is working correctly
4. Check that vehicle data is stored correctly in your framework's database

### Notifications not appearing

**Problem**: No notifications are shown

**Solutions**:
1. Verify daphne-notification is installed and started
2. Check the daphne-notification console for errors
3. Ensure the notification position is visible in daphne-notification config
4. Check the browser console (F12) for JavaScript errors

### Vehicle not locking/unlocking

**Problem**: Pressing U doesn't lock/unlock vehicles

**Solutions**:
1. Check the key binding in `config.lua`: `Config.LockKey = 'L'`
2. Ensure you're within 3.0 meters of the vehicle (default distance)
3. Make sure you're not inside the vehicle
4. Enable debug mode to see console messages
5. Verify you have the keys to the vehicle

### Performance issues

**Problem**: High CPU usage or lag

**Solutions**:
1. Check the `monitor resources` command for CPU usage
2. Ensure you're using the latest version
3. Check for conflicting resources
4. Report the issue on [Discord](https://discord.gg/daphne)

## Uninstallation

If you need to remove daphne-car-lock:

1. Remove the resource from `server.cfg`:
   ```
   # ensure daphne-car-lock
   ```

2. Delete the `resources/daphne-car-lock` folder

3. Restart the server or the resources

## Updates

To update daphne-car-lock:

1. Backup your `config.lua` file
2. Pull the latest changes from the repository or download the new version
3. Restore your `config.lua` (or merge with the new version)
4. Restart the resource: `restart daphne-car-lock`

## Next Steps

- [Configure the resource](CONFIGURATION.md)
- [Explore the API](API.md)
- [Join our Discord](https://discord.gg/daphne) for support

## Support

If you encounter any issues not covered in this guide:

1. Check the [Configuration Guide](CONFIGURATION.md) for more options
2. Review the [API Reference](API.md) for integration examples
3. Join [Daphne Studio's Discord Server](https://discord.gg/daphne) for community support
4. Open an issue on [GitHub](https://github.com/daphne-studio/daphne-car-lock/issues)

## Additional Resources

- [daphne-core Documentation](https://github.com/daphne-studio/daphne-core)
- [daphne-notification Documentation](https://github.com/daphne-studio/daphne-notification)
- [FiveM Documentation](https://docs.fivem.net/)

