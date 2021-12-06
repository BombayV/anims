---Begins animation depending on data type
---@param data table
local function animType(data)

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

RegisterNUICallback('beginAnimation', function(data, cb)
    if cfg.panelStatus then
        cfg.panelStatus = false
        local animState = promise.new()
        animType(data)
        Citizen.Await(animState)
        if animState.passed then
            enableCancel()
            cb({e = true})
        end
    end
    cb({e = false})
end)

RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatues
    SendNUIMessage({panelStatus = cfg.panelStatus})
end)