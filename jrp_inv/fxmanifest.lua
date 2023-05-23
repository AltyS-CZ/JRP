fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Inventory'
version '0.0.1'
lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
    '@menuv/menuv.lua',
	'cl_inv.lua',
}
server_scripts {
    'server.lua',
    'items.lua',
    'config.lua'
}

dependencies {
    'menuv',
    'JRP',
}
