# daphne-car-lock

![daphne-car-lock](https://i.imgur.com/tyYArhi.jpeg)

A simple and efficient car lock system for FiveM with automatic key distribution for owned vehicles, lock/unlock functionality with sound effects, built on top of daphne-core and daphne-notification.

## Features

- **Automatic Key Distribution**: Players automatically receive keys to all their owned vehicles upon spawning and when using `/car` command
- **Simple Lock/Unlock System**: Press L key (configurable) to lock/unlock the nearest vehicle
- **Sound Effects**: Built-in lock sound effect using GTA V's native audio system
- **Framework Agnostic**: Works with any framework supported by daphne-core (QBCore/Qbox, ESX, ND_Core)
- **Optimized Performance**: 0.00ms idle CPU usage
- **Modern Notifications**: Beautiful notifications using daphne-notification
- **Easy Integration**: Simple API for third-party script integration
- **Auto-Refresh**: Automatically refreshes keys when vehicle distribution commands are used

## Requirements

- **daphne-core**: Required for framework abstraction
- **daphne-notification**: Required for notifications
- FiveM server with Lua 5.4 support

## Quick Start

### Installation

For detailed installation instructions, see the [Installation Guide](INSTALLATION.md).

### Basic Usage

The system works automatically:

1. **Server starts**: Automatically loads and initializes
2. **Player spawns**: Automatically receives keys to all owned vehicles
3. **Player presses L key**: Locks or unlocks the nearest vehicle

### Configuration

For configuration options, see the [Configuration Guide](CONFIGURATION.md).

### API Reference

For API documentation and usage examples, see the [API Reference](API.md).

## Documentation

- [Installation Guide](INSTALLATION.md) - Complete installation steps
- [Configuration Guide](CONFIGURATION.md) - Configuration options and customization
- [API Reference](API.md) - Complete API documentation and usage examples

## Supported Frameworks

Through daphne-core, this resource supports:

- QBCore/Qbox
- ESX Legacy
- ND_Core
- Any future framework supported by daphne-core

## Performance

This resource is optimized for minimal CPU usage:

- 0.00ms idle CPU usage
- Efficient state bag management
- Minimal network traffic
- No unnecessary loops or polling

## Notifications

All notifications are displayed in English:

- ✅ "Vehicle unlocked" - When successfully unlocking a vehicle
- ℹ️ "Vehicle locked" - When successfully locking a vehicle
- ❌ "You do not have the keys to this vehicle" - When player doesn't have keys
- ❌ "No vehicle nearby" - When no vehicle is in range
- ❌ "Vehicle not found" - When vehicle data is not available

## Troubleshooting

### Keys not working

1. Ensure daphne-core is started before this resource
2. Ensure daphne-notification is started before this resource
3. Check debug mode in config.lua for console logs
4. Verify the vehicle plate matches the database

### Notifications not showing

1. Ensure daphne-notification is installed and started
2. Check the notification position in daphne-notification config

### Vehicle not locking/unlocking

1. Check if you're within the configured distance (default: 3.0 meters)
2. Verify you're not inside the vehicle
3. Check the debug console for error messages

## Support

For support and updates, visit: [Daphne Studio's Discord Server](https://discord.gg/daphne)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- **Daphne Studio** - Original development
- **daphne-core** - Framework abstraction layer
- **daphne-notification** - Notification system

## Version

Current Version: 1.0.0

