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

RegisterNetEvent('anims:syncParticles', function(particles, nearbyPlayers)
    local playerId <const> = source
    if type(particles) ~= "table" or type(nearbyPlayers) ~= "table" then
        return false
    end
    if playerId > 0 then
        for i = 1, #nearbyPlayers do
            TriggerClientEvent('anims:syncPlayerParticles', nearbyPlayers[i], playerId, particles)
        end
    end
end)