---Holds Playing animation
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
            if particle then
                Play.Ptfx(particle)
            end
        end

        local loop = cfg.animDuration
        local move = 1
        if cfg.animLoop then
            loop = -1
        end
        if cfg.animMovement then
            move = 51
        end
        TaskPlayAnim(PlayerPedId(), dance.dict, dance.anim, 1.5, 1.5, loop, move, 0, false, false, false)
        RemoveAnimDict(dance.dict)
        cfg.animActive = true
        p:resolve({passed = true})
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
        end
        TaskStartScenarioInPlace(PlayerPedId(), scene.scene, 0, true)
        cfg.sceneActive = true
        p:resolve({passed = true})
        return
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
            Load.PropCreation(PlayerPedId(), props.propTwo, props.propBoneTwo, props.propPlacemenTwo)
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