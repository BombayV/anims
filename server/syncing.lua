local currentlyPlaying = {}

RegisterNetEvent('anims:resolveAnimation', function(target, shared, accepted)
    local playerId <const> = source
    if type(shared) ~= "table" and tonumber(playerId) ~= tonumber(target) then
        return false
    end
    if playerId and target then
        if accepted then
            TriggerClientEvent('anims:requestShared', target, shared.first, target, true)
            TriggerClientEvent('anims:requestShared', playerId, shared.second, tonumber(playerId))
        else
            TriggerClientEvent('anims:notify', target, 'info', 'Player denied your request...')
            TriggerClientEvent('anims:notify', playerId, 'info', 'Request denied')
        end
    end
end)

RegisterNetEvent('anims:awaitConfirmation', function(target, shared)
    local playerId <const> = source
    if playerId > 0 then
        if target and type(shared) == "table" then
            TriggerClientEvent('anims:awaitConfirmation', target, playerId, shared)
        end
    end
end)

RegisterNetEvent('anims:syncParticles', function(particles, nearbyPlayers, prop)
    local playerId <const> = source
    if type(particles) ~= "table" or type(nearbyPlayers) ~= "table" then
        error('Table was not successful')
    end
    if playerId > 0 then
        currentlyPlaying[playerId] = nearbyPlayers
        for i = 1, #nearbyPlayers do
            TriggerClientEvent('anims:syncPlayerParticles', nearbyPlayers[i], playerId, particles, prop)
        end
    end
end)

RegisterNetEvent('anims:syncRemoval', function()
    local playerId <const> = source
    if playerId > 0 then
        local nearbyPlayers = currentlyPlaying and currentlyPlaying[playerId]
        if nearbyPlayers then
            for i = 1, #nearbyPlayers do
                if nearbyPlayers[i] ~= playerId then
                    TriggerClientEvent('anims:syncRemoval', nearbyPlayers[i])
                end
            end
            currentlyPlaying[playerId] = {}
        end
    end
end)