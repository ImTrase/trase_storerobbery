fx_version 'cerulean'
game 'gta5'

author 'Trase'
description 'An advanced and unique store robbery for your FiveM server.'
lua54 'yes'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client/client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

files {
    'modules/**/client.lua',
    'modules/**/server.lua',
    'locales/*.json'
}