fx_version 'cerulean'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'db-admin'
description 'DB-Admin Menu - Comprehensive Admin Panel for RedM'
author 'DB-Admin'
version '2.0.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/ui.lua',
    'client/main.lua',
    'client/self.lua',
    'client/players.lua',
    'client/reports.lua',
    'client/finances.lua',
    'client/devtools.lua',
    'client/server_controls.lua',
    'client/troll.lua',
    'client/blips.lua',
    'client/announcements.lua',
    'client/permissions.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/players.lua',
    'server/reports.lua',
    'server/finances.lua',
    'server/devtools.lua',
    'server/server_controls.lua',
    'server/troll.lua',
    'server/blips.lua',
    'server/announcements.lua',
    'server/permissions.lua',
}

dependencies {
    'rsg-core',
    'ox_lib',
    'oxmysql',
    'weathersync',
}