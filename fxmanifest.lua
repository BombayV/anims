fx_version 'cerulean'

game 'gta5'

lua54 'yes'

description 'A simple NUI animations panel developed by Entity Evolution'

version '0.5.0'

client_scripts {
    'cfg.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/fonts/*.ttf',
    'html/css/style.css',
    'html/js/*.js',
    'html/js/modules/*.js',
    'anims.json'
}
