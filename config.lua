Config = {}

-- Key configuration
-- Default key to lock/unlock vehicles
-- Note: 'L' key is recommended to avoid conflicts with Use key (E)
Config.LockKey = 'L'

-- Maximum distance to interact with vehicles (in meters)
Config.MaxDistance = 3.0

-- Sound configuration
Config.SoundVolume = 0.5

-- Notification duration (in milliseconds)
Config.NotificationDuration = 3000

-- Automatic key distribution
-- When enabled, automatically gives keys to players when they receive vehicles
-- This is useful for /car commands and other vehicle distribution systems
Config.AutoGiveKeys = true

-- Debug mode
-- Enable for console logging and debugging
Config.Debug = false

-- Messages
Config.Messages = {
    -- Success messages
    VehicleUnlocked = 'Vehicle unlocked',
    VehicleLocked = 'Vehicle locked',
    KeyReceived = 'You received keys to this vehicle',

    -- Error messages
    NoKeys = 'You do not have the keys to this vehicle',
    NoVehicleNearby = 'No vehicle nearby',
    VehicleNotFound = 'Vehicle not found',
}

