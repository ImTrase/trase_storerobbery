fx_version 'cerulean'
game 'gta5'

author 'Trase'
description 'An advanced and unique store robbery for your FiveM server.'
lua54 'yes'
version '1.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client/client.lua'

server_scripts {
    'server/versions.lua',
    'server/server.lua'
}

files {
    'modules/**/client.lua',
    'modules/**/server.lua',
    'locales/*.json'
}

escrow_ignore {
    'modules/**/*.lua',
    'locales/*.json',
    'config.lua',
    'config.server.lua',
    'server/versions.lua',
}