fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.6'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/server.lua',
    'sv_cmds/sv_car.lua',
    'sv_cmds/sv_dv.lua',
    'sv_cmds/sv_getpos.lua',
    'sv_cmds/sv_tpm.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'cl_cmds/cl_car.lua',
    'cl_cmds/cl_dv.lua',
    'cl_cmds/cl_tpm.lua',
}

dependencies {
    'oxymsql',
}



