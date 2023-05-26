fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.6'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/server.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'menuv',
    'jrp_commands',
    'jrp_inv',
}



