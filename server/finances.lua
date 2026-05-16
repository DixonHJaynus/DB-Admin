--[[
    DB-Admin | Server Finances
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('dbadmin:server:manageMoney', function(targetId, action, moneyType, amount)
    local src = source
    if not IsAdmin(src) then return end

    local player = RSGCore.Functions.GetPlayer(targetId)
    if not player then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player not found!', type = 'error' })
    end

    local success = false
    if action == 'add' then
        success = player.Functions.AddMoney(moneyType, amount, 'admin-add')
    elseif action == 'remove' then
        success = player.Functions.RemoveMoney(moneyType, amount, 'admin-remove')
    end

    local targetName = GetPlayerName(targetId)

    if success then
        local label = action == 'add' and 'Added' or 'Removed'
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = string.format('%s $%d %s %s %s!', label, amount, moneyType, action == 'add' and 'to' or 'from', targetName), type = 'success' })
        TriggerClientEvent('ox_lib:notify', targetId, { title = 'DB-Admin', description = string.format('$%d %s %s by an admin.', amount, moneyType, action == 'add' and 'added' or 'removed'), type = 'inform' })
        DBAdmin.Log(src, 'manage_money', tostring(targetId), targetName, action .. ' ' .. moneyType .. ' $' .. amount)
    else
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Failed to modify money!', type = 'error' })
    end
end)