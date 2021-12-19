RegisterNetEvent('anims:requestAnimation', function(target, shared)
    local playerId <const> = source
    if type(shared) ~= "table" and tonumber(playerId) ~= tonumber(target) then
        return false
    end
    if playerId and target then
        TriggerClientEvent('anims:requestShared', playerId, shared.first, target, true)
        TriggerClientEvent('anims:requestShared', target, shared.second, tonumber(playerId))
    end
end)