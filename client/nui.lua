RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    SendNUIMessage({panelStatus = cfg.panelStatus})
end)