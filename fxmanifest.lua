fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/config_server.lua',
    'server/main.lua',
    'server/commands.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

