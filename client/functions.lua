---Holds Playing animation
---@class Play
Play = {}

---Checks for sex of ped
---@return string
local function checkSex()
    local pedModel = GetEntityModel(PlayerPedId())
    for i = 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end
    return 'female'
end

---Notify a person with default notificaiont
---@param message string
local function notify(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

---Plays an animation
---@param dance table
---@param particle table
---@param prop table
---@param p table Promise
Play.Animation = function(dance, particle, prop, p)
    if dance then
        if cfg.animActive then
            Load.Cancel()
        end
        Load.Dict(dance.dict)
        if prop then
            Play.Prop(prop)
        end

        if particle then
            local nearbyPlayers = {}
            local players = GetActivePlayers()
            if #players > 1 then
                for i = 1, #players do
                    nearbyPlayers[i] = GetPlayerServerId(players[i])
                end
                cfg.ptfxOwner = true
                TriggerServerEvent('anims:syncParticles', particle, nearbyPlayers)
            else
                Play.Ptfx(PlayerPedId(), particle)
            end
        end

        local loop = cfg.animDuration
        local move = 1
        if cfg.animLoop and not cfg.animDisableLoop then
            loop = -1
        else
            if dance.duration then
                SetTimeout(dance.duration, function() Load.Cancel() end)
            else
                SetTimeout(cfg.animDuration, function() Load.Cancel() end)
            end
        end
        if cfg.animMovement and not cfg.animDisableMovement then
            move = 51
        end
        TaskPlayAnim(PlayerPedId(), dance.dict, dance.anim, 1.5, 1.5, loop, move, 0, false, false, false)
        RemoveAnimDict(dance.dict)
        cfg.animActive = true
        if p then
            p:resolve({passed = true})
        end
        return
    end
    p:reject({passed = false})
end

---Plays a scene
---@param scene table
---@param p table Promise
Play.Scene = function(scene, p)
    if scene then
        local sex = checkSex()
        if not scene.sex == 'both' and not (sex == scene.sex) then
            Play.Notification('info', 'Sex does not allow this animation')
        else
            if scene.sex == 'position' then
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
                TaskStartScenarioAtPosition(PlayerPedId(), scene.scene, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), 0, 1, false)
            else
                TaskStartScenarioInPlace(PlayerPedId(), scene.scene, 0, true)
            end
            cfg.sceneActive = true
            p:resolve({passed = true})
            return
        end
    end
    p:reject({passed = false})
end

---Changes the facial expression
---@param expression table
---@param p table Promise
Play.Expression = function(expression, p)
    if expression then
        SetFacialIdleAnimOverride(PlayerPedId(), expression.expressions, 0)
        p:resolve({passed = true})
        return
    end
    p:reject({passed = false})
end

---Changes the walking anim of a ped
---@param walks table
---@param p table Promise
Play.Walk = function(walks, p)
    if walks then
        Load.Walk(walks.style)
        SetPedMovementClipset(PlayerPedId(), walks.style, cfg.walkingTransition)
        RemoveAnimSet(walks.style)
        SetResourceKvp('savedWalk', walks.style)
        p:resolve({passed = true})
        return
    end
    p:reject({passed = false})
end

---Creates a prop(s)
---@param props table
Play.Prop = function(props)
    if props then
        if props.prop then
            Load.Model(props.prop)
            Load.PropCreation(PlayerPedId(), props.prop, props.propBone, props.propPlacement)
        end
        if props.propTwo then
            Load.Model(props.propTwo)
            Load.PropCreation(PlayerPedId(), props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
    end
end

---Creates a particle effect
---@param ped number
---@param particles table
Play.Ptfx = function(ped, particles)
    if particles then
        Load.Ptfx(particles.asset)
        UseParticleFxAssetNextCall(particles.asset)
        local attachedProp
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(ped, v) then
                attachedProp = v
                break
            end
        end
        if not attachedProp and not cfg.ptfxEntitiesTwo[NetworkGetEntityOwner(ped)] and not cfg.ptfxOwner and ped == PlayerPedId() then
            attachedProp = cfg.propsEntities[1] or cfg.propsEntities[2]
        end
        Load.PtfxCreation(ped, attachedProp or nil, particles.name, particles.asset, particles.placement, particles.rgb)
    end
end

---Tries to send event to server for animation
---@param shared table
---@param p table
Play.Shared = function(shared, p)
    if shared then
        local closePed = Load.GetPlayer()
        if closePed then
            local targetId = NetworkGetEntityOwner(closePed)
            Play.Notification('info', 'Request sent to ' .. GetPlayerName(targetId))
            TriggerServerEvent('anims:awaitConfirmation', GetPlayerServerId(targetId), shared)
            p:resolve({passed = true, shared = true})
        end
    end
    p:resolve({passed = false, nearby = true})
end

---Creates a notifications
---@param type string
---@param message string
Play.Notification = function(type, message)
    if cfg.useTnotify then
        exports['t-notify']:Alert({
            style  =  type or 'info',
            message  =  message or 'Something went wrong...'
        })
    else
        notify(message)
    end
end

---Plays shared animation if accepted
---@param shared table
---@param targetId number
---@param owner any
RegisterNetEvent('anims:requestShared', function(shared, targetId, owner)
    if type(shared) == "table" and targetId then
        if cfg.animActive or cfg.sceneActive then
            Load.Cancel()
        end
        Wait(350)

        local targetPlayer = Load.GetPlayer()
        if targetPlayer then
            SetTimeout(shared[4] or 3000, function() cfg.sharedActive = false end)
            cfg.sharedActive = true
            local ped = PlayerPedId()
            if not owner then
                local targetHeading = GetEntityHeading(targetPlayer)
                local targetCoords = GetOffsetFromEntityInWorldCoords(targetPlayer, 0.0, shared[3] + 0.0, 0.0)

                SetEntityHeading(ped, targetHeading - 180.1)
                SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, 0)
            end

            Load.Dict(shared[1])
            TaskPlayAnim(PlayerPedId(), shared[1], shared[2], 2.0, 2.0, shared[4] or 3000, 1, 0, false, false, false)
            RemoveAnimDict(shared[1])
        end
    end
end)

---Loads shared confirmation for target
---@param target number
---@param shared table
RegisterNetEvent('anims:awaitConfirmation', function(target, shared)
    if not cfg.sharedActive then
        Load.Confirmation(target, shared)
    else
        TriggerServerEvent('anims:resolveAnimation', target, shared, false)
    end
end)

---Just notification function but for
---server to send to target
---@param type string
---@param message string
RegisterNetEvent('anims:notify', function(type, message)
    Play.Notification(type, message)
end)

exports('Play', function()
    return Play
end)

RegisterNetEvent('anims:syncPlayerParticles', function(syncPlayer, particle)
    local mainPed = GetPlayerPed(GetPlayerFromServerId(syncPlayer))
    if mainPed > 0 and type(particle) == "table" then
        Play.Ptfx(mainPed, particle)
    end
end)

RegisterNetEvent('anims:syncRemoval', function(syncPlayer)
    local targetParticles = cfg.ptfxEntitiesTwo[tonumber(syncPlayer)]
    if targetParticles then
        StopParticleFxLooped(targetParticles, false)
        cfg.ptfxEntitiesTwo[syncPlayer] = nil
    end
end)
