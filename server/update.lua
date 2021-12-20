local function checkVersion(e, latest, headers)
    local versionData = json.decode(LoadResourceFile('anims', 'update.json'))
    print(e)
    print(latest)
    print(headers)
    if versionData then
        local version = versionData.version
        if version ~= latest.version and version < latest.version then
            print('^2Anims are outdated!\n^1Get your update from https://github.com/BombayV/anims')
        else
            print('^2Anims are updated!')
        end
    else
        print('You removed the JSON file smh. Goodbye to updates :sadge:')
    end
end

local function updateStatus()
    SetTimeout(10 * 60000, updateStatus)

    PerformHttpRequest('https://raw.githubusercontent.com/BombayV/anims/main/version.json', checkVersion, "GET")
end

updateStatus()