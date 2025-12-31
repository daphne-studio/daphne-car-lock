fx_version 'cerulean'
game 'gta5'

author 'Daphne Studio'
description 'Simple car lock system with automatic key distribution using daphne-core'
version '1.0.0'

lua54 'yes'

shared_script {
    'config.lua'
}

client_script {
    'client/client.lua'
}

server_script {
    'server/server.lua'
}

dependencies {
    'daphne-core',
    'daphne-notification'
}

