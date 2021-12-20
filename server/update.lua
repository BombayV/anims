local function checkVersion(e, latest, _)
    local versionData = json.decode(LoadResourceFile('anims', 'update.json'))
    local latest = json.decode(latest)
    if e ~= 200 then
        return print('Error: Anims could not verify with Github')
    end
    if versionData then
        local version = versionData.version
        if version ~= latest.version and version < latest.version then
            print('^1Anims are outdated!')
            print('^3What is new: ^7' .. latest.new)
            print('^3Necessary?: ^7' .. latest.update)
            print('^2Get your update from: ^7https://github.com/BombayV/anims')
        elseif version > latest.version then
            print('^3Your version is above latest. Sus stuff you got here.^7')
        else
            print('^2Anims are updated!^7')
        end
    else
        print('You removed the JSON file smh. Goodbye to updates :sadge:')
    end
end

local function updateStatus()
    SetTimeout(10 * 60000, updateStatus)

    PerformHttpRequest('https://raw.githubusercontent.com/BombayV/anims/main/update.json', checkVersion, "GET")
end

updateStatus()