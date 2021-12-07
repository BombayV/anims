---Begins animation depending on data type
---@param data table
local function animType(data, p)
    if data then
        if data.dance then
            Play.Animation(data.dance, data.particle, data.prop)
            p:resolve({passed = true})
            return
        elseif data.scene then
            Play.Scene(data.scene)
            p:resolve({passed = true})
            return
        elseif data.expression then
            Play.Expression(data.expression)
            p:resolve({passed = true})
            return
        elseif data.walk then
            Play.Walk(data.walk)
            p:resolve({passed = true})
            return
        end
    end
    p:resolve({passed = false})
end

---Begins cancel key thread
local function enableCancel()
    CreateThread(function()
        while animActive do
            if IsControlJustReleased(0, cfg.cancelKey) then
                StopAnimation()
                break
            end
            Wait(16)
        end
    end)
end

RegisterNUICallback('changeCfg', function(data, cb)
    if data.type == 'movement' then
        cfg.animMovement = not data.state
    elseif data.type == 'loop' then
        print(data.state)
        cfg.animLoop = not data.state
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
    Play.Notification(data.type, data.message)
    cb({})
end)

RegisterNUICallback('fetchStorage', function(data, cb)
    for _, v in pairs(data) do
        if v == 'loop' then
            cfg.animLoop = true
        elseif v == 'movement' then
            cfg.animMovement = true
        end
    end
    cb({})
end)

RegisterNUICallback('beginAnimation', function(data, cb)
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

RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1500)
    SendNUIMessage({action = 'panelStatus',panelStatus = cfg.panelStatus})
end)