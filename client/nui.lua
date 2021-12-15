---Begins animation depending on data type
---@param data table Animation Data
---@param p string Promise
local function animType(data, p)
    if data then
        if data.dance then
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
            if IsControlJustReleased(0, cfg.cancelKey) then
                Load.Cancel()
                break
            end
            Wait(16)
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

--#region NUI callbacks
RegisterNUICallback('changeCfg', function(data, cb)
    if data then
        if data.type == 'movement' then
            cfg.animMovement = not data.state
        elseif data.type == 'loop' then
            print(data.state)
            cfg.animLoop = not data.state
        elseif data.type == 'settings' then
            cfg.animDuration = data.duration or cfg.animDuration
            cfg.cancelKey = data.cancel or cfg.cancelKey
            cfg.defaultEmote = data.currentEmote or cfg.defaultEmote
            cfg.defaultEmoteKey = data.key or cfg.defaultEmoteKey
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

--#region -- commands
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

if cfg.keyActive then
    RegisterKeyMapping(cfg.commandName, cfg.keySuggestion, 'keyboard', cfg.keyLetter)
end
--#endregion