fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/config_server.lua',
    'server/main.lua',
    'server/commands.lua',
    'jrp_inv/config.lua',
    'jrp_inv/items.lua',
    'jrp_inv/server.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'client/main.lua',
    'client/cmds/cl_car',
    'client/cl_commands.lua',
    'jrp_inv/inventory.lua'
}

dependencies {
    'menuv',
}

