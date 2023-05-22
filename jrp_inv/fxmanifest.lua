fx_version 'cerulean'
game 'gta5'

author 'JaxDanger'
description 'Inventory for JRP FW'
version '0.0.1'
lua54 'yes'

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
    'menuv'
}
