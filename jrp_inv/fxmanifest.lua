fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Inventory'
version '0.1.0'
lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
    '@menuv/menuv.lua',
	'cl_inv.lua',
    'item_events.lua',
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'items.lua',
    'config.lua',
}

dependencies {
    'menuv',
    'oxmysql',
}
