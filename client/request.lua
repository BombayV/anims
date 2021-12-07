local remove = table.remove
local insert = table.insert

---Load table functions
Load = {}

---Loads dictionary
---@param dict string
Load.Dict = function(dict)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

---Loads model/prop
---@param model string
Load.Model = function(model)
    local hashModel = GetHashKey(model)
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

---Loads animset/walk
---@param walk string
Load.Walk = function(walk)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimSet(walk)
        Wait(50)
    until HasAnimSetLoaded(walk) or timeout
end

---Loads particle effects
---@param asset string
Load.Ptfx = function(asset)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestNamedPtfxAsset(asset)
        Wait(50)
    until HasNamedPtfxAssetLoaded(asset) or timeout
end

---Creates a ptfx at location
---@param ped number
---@param prop number
---@param name string
---@param placement table
Load.PtfxCreation = function(ped, prop, name, placement)
    local ptfxSpawn = ped
    if prop then
        ptfxSpawn = prop
    end
    local newPtfx = StartNetworkedParticleFxLoopedOnEntityBone(name, ptfxSpawn, placement[1], placement[2], placement[3], placement[4], placement[4], placement[5], GetEntityBoneIndexByName(name, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(newPtfx, 1.0, 1.0, 1.0)
    insert(cfg.ptfxEntities, newPtfx)
    cfg.ptfxActive = true
end

---Removes existing particle effects
Load.PtfxRemoval = function()
    if cfg.ptfxEntities then
        for k, v in pairs(cfg.ptfxEntities) do
            StopParticleFxLooped(v, false)
            remove(cfg.ptfxEntities, k)
        end
    end
end

---Creates a prop at location
---@param ped number
---@param prop string
---@param bone number
---@param placement table
Load.PropCreation = function(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(GetHashKey(prop1), coords.x, coords.y, coords.z + 0.2,  true,  true, true)
    if newProp then
        AttachEntityToEntity(newProp, Player, GetPedBoneIndex(ped, bone), placement[1], placement[2], placement[3], placement[4], placement[5], placement[6], true, true, false, true, 1, true)
        insert(cfg.propsEntities, newProp)
        cfg.propActive = true
    end
    SetModelAsNoLongerNeeded(prop)
end

---Removes props
---@param type string
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
                remove(cfg.propsEntities, k)
            end
            cfg.propActive = false
        end
    end
end

---Cancels currently playing animations
Load.Cancel = function()
    if cfg.animActive then
        ClearPedTasks(PlayerPedId())
        cfg.animActive = false
    elseif cfg.sceneActive then
        if cfg.sceneForcedEnd then
            ClearPedTasksImmediately(PlayerPedId())
        else
            ClearPedTasks(PlayerPedId())
        end
        cfg.sceneActive = false
    end

    if cfg.propActive then
       Load.PropRemoval()
       cfg.propActive = false
    end
    if cfg.ptfxActive then
        Load.PtfxRemoval()
        cfg.ptfxActive = false
    end
end