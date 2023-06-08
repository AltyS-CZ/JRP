fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.8'
lua54 'yes'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/server.lua',
    'sv_cmds/sv_car.lua',
    'sv_cmds/sv_dv.lua',
    'sv_cmds/sv_getpos.lua',
    'sv_cmds/sv_tpm.lua',
    'server/health.lua',
    'sv_cmds/sv_setjob.lua',
    'sv_cmds/sv_job.lua',
}

client_scripts {
    'client/main.lua',
    'cl_cmds/cl_car.lua',
    'cl_cmds/cl_dv.lua',
    'cl_cmds/cl_tpm.lua',
    'client/health.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}


dependencies {
    'oxmysql',
}



