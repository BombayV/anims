---Holds Playing animation
---@class Play
Play = {}

---Checks for sex of ped
---@param sex string
---@return string
local function checkSex(sex)
    local pedModel = GetEntityModel(PlayerPedId())
    for i= 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end
    return 'female'
end

---Plays an animation
---@param dance table
---@param particle table
---@param prop table
---@param p string Promise
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
            Play.Ptfx(particle)
        end

        local loop = cfg.animDuration
        local move = 1
        if cfg.animLoop then
            loop = -1
        else
            SetTimeout(cfg.animDuration, function() Load.Cancel() end)
        end
        if cfg.animMovement then
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
---@param p string Promise
Play.Scene = function(scene, p)
    if scene then
        local sex = checkSex(sex)
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
---@param p string Promise
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
---@param p string Promise
Play.Walk = function(walks, p)
    if walks then
        Load.Walk(walks.style)
        SetPedMovementClipset(PlayerPedId(), walks.style, cfg.walkingTransition)
        RemoveAnimSet(walks.style)
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
---@param particles table
Play.Ptfx = function(particles)
    if particles then
        Load.Ptfx(particles.asset)
        UseParticleFxAssetNextCall(particles.asset)
        Load.PtfxCreation(PlayerPedId(), cfg.propsEntities[1] or cfg.propsEntities[2] or nil, particles.name, particles.asset, particles.placement, particles.rgb)
    end
end

Play.Shared = function(shared, p)
    if shared then
        local closePed = Load.GetPlayer()
        if closePed then
            TriggerServerEvent('anims:requestAnimation', GetPlayerServerId(NetworkGetEntityOwner(closePed)), shared)
        end
        p:resolve({passed = true})
        return
    end
    p:reject({passed = false})
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

    end
end

RegisterNetEvent('anims:requestShared', function(shared, targetId, owner)
    if type(shared) == "table" and targetId then
        Load.Cancel()
        Wait(500)

        local targetPlayer = Load.GetPlayer()
        if targetPlayer then
            local ped = PlayerPedId()
            if not owner then
                local targetHeading = GetEntityHeading(targetPlayer)
                local targetCoords = GetOffsetFromEntityInWorldCoords(targetPlayer, 0.0, shared[3] + 0.0, 0.0)

                SetEntityHeading(ped, targetHeading - 180.1)
                SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, 0)
            end

            Load.Dict(shared[1])
            print(json.encode(shared), shared[4])
            TaskPlayAnim(PlayerPedId(), shared[1], shared[2], 2.0, 2.0, shared[4] or 3000, 1, 0, false, false, false)
            RemoveAnimDict(shared[1])
        end
    end
end)