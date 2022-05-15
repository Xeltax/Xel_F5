fx_version 'adamant'

game 'gta5'

description 'Xel_F5'

version 'legacy'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@es_extended/locale.lua',
    'src/RageUI.lua',
    'src/Menu.lua',
    'src/MenuController.lua',
    'src/components/*.lua',
    'src/elements/*.lua',
    'src/items/*.lua',
    
    "client.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
	"server.lua"
}