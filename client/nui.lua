--#region Functions

---Begins animation depending on data type
---@param data table Animation Data
---@param p string Promise
local function animType(data, p)
    if data then
        if data.dance then
            print('passed')
            Play.Animation(data.dance, data.particle, data.prop, p)
        elseif data.scene then
            Play.Scene(data.scene, p)
        elseif data.expression then
            Play.Expression(data.expression, p)
        elseif data.walk then
            Play.Walk(data.walk, p)
        end
    end
end

---Begins cancel key thread
local function enableCancel()
    CreateThread(function()
        while cfg.animActive or cfg.sceneActive do
            if IsControlJustPressed(0, cfg.cancelKey) then
                Load.Cancel()
                break
            end
            Wait(10)
        end
    end)
end

---Finds an emote by command
---@param emoteName table
local function findEmote(emoteName)
    if emoteName then
        local name = emoteName:upper()
        SendNUIMessage({action = 'findEmote', name = name})
    end
end
--#endregion

--#region NUI callbacks
RegisterNUICallback('changeCfg', function(data, cb)
    if data then
        if data.type == 'movement' then
            cfg.animMovement = not data.state
        elseif data.type == 'loop' then
            print(data.state)
            cfg.animLoop = not data.state
        elseif data.type == 'settings' then
            print('Start: ', data.duration, cfg.animDuration)
            cfg.animDuration = tonumber(data.duration) or cfg.animDuration
            cfg.cancelKey = tonumber(data.cancel) or cfg.cancelKey
            cfg.defaultEmote = data.emote or cfg.defaultEmote
            cfg.defaultEmoteKey = tonumber(data.key) or cfg.defaultEmoteKey
            print('End: ', data.duration, cfg.animDuration)
        end
    end
    cb({})
end)

RegisterNUICallback('cancelAnimation', function(_, cb)
    Load.Cancel()
    cb({})
end)

RegisterNUICallback('removeProps', function(_, cb)
    Load.PropRemoval('global')
    cb({})
end)

RegisterNUICallback('exitPanel', function(_, cb)
    if cfg.panelStatus then
        cfg.panelStatus = false
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(1500)
        SendNUIMessage({action = 'panelStatus',panelStatus = cfg.panelStatus})
    end
    cb({})
end)

RegisterNUICallback('sendNotification', function(data, cb)
    if data then
        Play.Notification(data.type, data.message)
    end
    cb({})
end)

RegisterNUICallback('fetchStorage', function(data, cb)
    if data then
        for _, v in pairs(data) do
            if v == 'loop' then
                cfg.animLoop = true
            elseif v == 'movement' then
                cfg.animMovement = true
            end
        end
    end
    cb({})
end)

RegisterNUICallback('beginAnimation', function(data, cb)
    Load.Cancel()
    local animState = promise.new()
    animType(data, animState)
    local result = Citizen.Await(animState)
    if result.passed then
        enableCancel()
        cb({e = true})
        return
    end
    cb({e = false})
end)
--#endregion

--#region Commands
RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1500)
    SendNUIMessage({action = 'panelStatus',panelStatus = cfg.panelStatus})
end)

RegisterCommand(cfg.commandNameEmote, function(_, args)
    if args and args[1] then
        return findEmote(args[1])
    end
    Play.Notification('info', 'No emote name set...')
end)

RegisterCommand(cfg.defaultCommand, function()
    if cfg.defaultEmote then
        findEmote(cfg.defaultEmote)
    end
end)

if cfg.defaultEmoteUseKey then
    CreateThread(function()
        while cfg.defaultEmoteKey do
            if IsControlJustPressed(0, cfg.defaultEmoteKey) then
                findEmote(cfg.defaultEmote)
            end
            Wait(10)
        end
    end)
end

if cfg.keyActive then
    RegisterKeyMapping(cfg.commandName, cfg.keySuggestion, 'keyboard', cfg.keyLetter)
end
--#endregion

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        Load.Cancel()
    end
end)