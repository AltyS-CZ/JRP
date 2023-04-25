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
    'server/jobs.lua',
    --'server/cfg_shops.lua', -- Shops not ready yet
    --'server/sv_shops.lua' -- Shops not ready yet
}

client_scripts {
    'client/main.lua',
    --'client/cl_shops.lua', -- Shops not ready yet
    'client/cl_commands.lua'
}

