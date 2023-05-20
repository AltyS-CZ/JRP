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
    'inv_cfg.lua',
    'money.lua',
    'sv_items.lua'
    --'sv_shops.lua -- COMING SOON
}

client_scripts {
    'client/main.lua',
    'cl_car',
    --'client/cl_shops.lua', -- COMING SOON
    'client/cl_commands.lua'
}

