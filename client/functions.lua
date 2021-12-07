Play = {}

local function checkSex(sex)
    local pedModel = GetEntityModel(PlayerPedId())
    for i= 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end
    return 'female'
end

Play.Animation = function(dance, particle, prop)
    if dance then
        if cfg.animActive then
            Load.Cancel()
        end
        Load.Dict(dance.dict)
        if particle then
            if prop then

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

    end
end

Play.Scene = function(scene)
    local sex = checkSex(sex)
    if not scene.sex == 'both' and not (sex == scene.sex) then
        Play.Notification('info', 'Sex does not allow this animation')
    end
    TaskStartScenarioInPlace(PlayerPedId(), scene.scene, 0, true)
    cfg.sceneActive = true
    print('test')
end

Play.Expression = function(expression)
    SetFacialIdleAnimOverride(PlayerPedId(), expression.expressions, 0)
end

Play.Walk = function(walks)
    Load.Walk(walks.style)
    SetPedMovementClipset(PlayerPedId(), walks.style, 0.2)
    RemoveAnimSet(walks.style)
end

Play.Prop = function()

end

Play.Ptfx = function()

end

Play.Notification = function(type, message)
    if cfg.useTnotify then
        exports['t-notify']:Alert({
            style  =  type or 'info',
            message  =  message or 'No message'
        })
    else

    end
end