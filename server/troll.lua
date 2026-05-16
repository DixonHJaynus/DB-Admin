--[[
    DB-Admin | Server Troll
]]

RegisterNetEvent('dbadmin:server:trollWildAttack', function(data)
    local src = source
    if not (HasPermission(src, 'admin') or HasPermission(src, 'troll')) then return end

    local name = GetPlayerName(data.targetId)
    if not name then return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player not found!', type = 'error' }) end

    TriggerClientEvent('dbadmin:client:wildAttack', data.targetId)
    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Wild attack sent to ' .. name .. '!', type = 'success' })
    DBAdmin.Log(src, 'troll_wildattack', tostring(data.targetId), name)
end)

RegisterNetEvent('dbadmin:server:trollSetFire', function(data)
    local src = source
    if not (HasPermission(src, 'admin') or HasPermission(src, 'troll')) then return end

    local name = GetPlayerName(data.targetId)
    if not name then return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player not found!', type = 'error' }) end

    TriggerClientEvent('dbadmin:client:setOnFire', data.targetId)
    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Set ' .. name .. ' on fire!', type = 'success' })
    DBAdmin.Log(src, 'troll_fire', tostring(data.targetId), name)
end)