fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Custom Economy Framework'
version '0.0.9'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}


server_scripts {
    'sv_cmds/sv_car.lua',
    'sv_cmds/sv_getpos.lua',
    'sv_cmds/sv_tpm.lua',
    'sv_cmds/sv_dv.lua',
}

client_scripts {
    'cl_cmds/cl_car.lua',
    'cl_cmds/cl_tpm.lua',
    'cl_cmds/cl_dv.lua'
}


