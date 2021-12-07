---Load table functions
Load = {}

Load.Dict = function(dict)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

Load.Model = function(model)
    local hashModel = GetHashKey(model)
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

Load.Walk = function(walk)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimSet(walk)
        Wait(50)
    until HasAnimSetLoaded(walk) or timeout
end

Load.Ptfx = function(asset)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestNamedPtfxAsset(asset)
        Wait(50)
    until HasNamedPtfxAssetLoaded(asset) or timeout
    UseParticleFxAssetNextCall(asset)
end

Load.PropRemoval = function(type)
    if type == 'global' then
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(PlayerPedId(), v) then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
            end
        end
    else
        if cfg.propActive then
            for k, v in pairs(cfg.propsEntities) do
                DeleteObject(v)
                table.remove(cfg.propsEntities, k)
            end
            cfg.propActive = false
        end
    end
end

Load.Cancel = function()
    if cfg.animActive then
        ClearPedTasks(PlayerPedId())
        cfg.animActive = false
    elseif cfg.sceneActive then
        ClearPedTasks(PlayerPedId())
    end
end