--[[
    DB-Admin | Server Player Actions
    Info, revive, inventory, goto, bring, freeze, spectate, give item, kick, ban
]]

local RSGCore = exports['rsg-core']:GetCoreObject()
local frozenPlayers = {}

-- ============================================================================
-- PLAYER INFO CALLBACK
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:getPlayerInfo', function(source, cb, data)
    if not IsAdmin(source) then return cb(nil) end

    local targetId = data.id
    local player = RSGCore.Functions.GetPlayer(targetId)
    if not player then return cb(nil) end

    local char  = player.PlayerData.charinfo or {}
    local money = player.PlayerData.money or {}

    cb({
        firstname  = char.firstname or 'N/A',
        lastname   = char.lastname or 'N/A',
        job        = player.PlayerData.job and player.PlayerData.job.label or 'None',
        grade      = player.PlayerData.job and player.PlayerData.job.grade and player.PlayerData.job.grade.name or 'N/A',
        cash       = money.cash or 0,
        bank       = money.bank or 0,
        bloodmoney = money.bloodmoney or 0,
        citizenid  = player.PlayerData.citizenid or 'N/A',
        serverid   = targetId,
        ping       = GetPlayerPing(targetId),
    })
end)

-- ============================================================================
-- REVIVE PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:revivePlayer', function(data)
    local src = source
    if not IsAdmin(src) then return end
    TriggerClientEvent('rsg-medic:client:playerRevive', data.id)
    DBAdmin.Log(src, 'revive_player', tostring(data.id), GetPlayerName(data.id))
end)

-- ============================================================================
-- OPEN INVENTORY
-- ============================================================================
RegisterNetEvent('dbadmin:server:openInventory', function(data)
    local src = source
    if not IsAdmin(src) then return end

    local player = RSGCore.Functions.GetPlayer(data.id)
    if not player then return end

    TriggerClientEvent('rsg-inventory:client:openInventory', src, player.PlayerData.items, data.id)
    DBAdmin.Log(src, 'open_inventory', tostring(data.id), GetPlayerName(data.id))
end)

-- ============================================================================
-- GO TO PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:goToPlayer', function(data)
    local src = source
    if not IsAdmin(src) then return end

    local targetPed = GetPlayerPed(data.id)
    if not targetPed then return end

    local coords = GetEntityCoords(targetPed)
    TriggerClientEvent('dbadmin:client:goToCoords', src, { x = coords.x, y = coords.y, z = coords.z })
    DBAdmin.Log(src, 'goto_player', tostring(data.id), GetPlayerName(data.id))
end)

-- ============================================================================
-- BRING PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:bringPlayer', function(data)
    local src = source
    if not IsAdmin(src) then return end

    local adminPed = GetPlayerPed(src)
    local coords = GetEntityCoords(adminPed)

    TriggerClientEvent('dbadmin:client:bringHere', data.id, { x = coords.x, y = coords.y, z = coords.z })

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player teleported to you!', type = 'success' })
    DBAdmin.Log(src, 'bring_player', tostring(data.id), GetPlayerName(data.id))
end)

-- ============================================================================
-- FREEZE PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:freezePlayer', function(data)
    local src = source
    if not IsAdmin(src) then return end

    local isFrozen = frozenPlayers[data.id] or false
    frozenPlayers[data.id] = not isFrozen

    TriggerClientEvent('dbadmin:client:freezeToggle', data.id, not isFrozen)

    local status = not isFrozen and 'frozen' or 'unfrozen'
    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = data.name .. ' ' .. status .. '!', type = 'success' })
    DBAdmin.Log(src, 'freeze_player', tostring(data.id), data.name, status)
end)

-- ============================================================================
-- SPECTATE PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:spectatePlayer', function(data)
    local src = source
    if not IsAdmin(src) then return end
    TriggerClientEvent('dbadmin:client:spectatePlayer', src, data.id)
    DBAdmin.Log(src, 'spectate_player', tostring(data.id), GetPlayerName(data.id))
end)

-- ============================================================================
-- GIVE ITEM
-- ============================================================================
RegisterNetEvent('dbadmin:server:giveItem', function(targetId, itemName, amount)
    local src = source
    if not IsAdmin(src) then return end

    local player = RSGCore.Functions.GetPlayer(targetId)
    if not player then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player not found!', type = 'error' })
    end

    local success = player.Functions.AddItem(itemName, amount)
    if success then
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = string.format('Gave %dx %s!', amount, itemName), type = 'success' })
        TriggerClientEvent('ox_lib:notify', targetId, { title = 'DB-Admin', description = string.format('You received %dx %s from an admin.', amount, itemName), type = 'inform' })
    else
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Failed to give item!', type = 'error' })
    end

    DBAdmin.Log(src, 'give_item', tostring(targetId), GetPlayerName(targetId), itemName .. ' x' .. amount)
end)

-- ============================================================================
-- KICK PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:kickPlayer', function(targetId, reason)
    local src = source
    if not IsAdmin(src) then return end

    local name = GetPlayerName(targetId)
    DropPlayer(targetId, 'Kicked by admin: ' .. reason)

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Kicked ' .. name .. '!', type = 'success' })
    DBAdmin.Log(src, 'kick_player', tostring(targetId), name, reason)
end)

-- ============================================================================
-- BAN PLAYER
-- ============================================================================
RegisterNetEvent('dbadmin:server:banPlayer', function(targetId, duration, reason)
    local src = source
    if not IsAdmin(src) then return end

    local targetName  = GetPlayerName(targetId)
    local identifiers = GetPlayerIdentifiers(targetId)
    local targetLicense = identifiers[1] or 'unknown'
    local adminName   = GetPlayerName(src)
    local adminId     = GetPlayerIdentifiers(src)[1] or 'unknown'

    local durationSec = tonumber(duration) or 99999999999
    local permanent   = durationSec >= 99999999999
    local expiresAt   = nil

    if not permanent then
        expiresAt = os.date('%Y-%m-%d %H:%M:%S', os.time() + durationSec)
    end

    MySQL.insert('INSERT INTO dbadmin_bans (banned_id, banned_name, banned_by, banned_by_id, reason, permanent, expires_at) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        targetLicense, targetName, adminName, adminId, reason, permanent and 1 or 0, expiresAt,
    })

    local banMsg = permanent
        and string.format('Permanently banned.\nReason: %s\nBy: %s', reason, adminName)
        or  string.format('Banned until %s.\nReason: %s\nBy: %s', expiresAt, reason, adminName)

    DropPlayer(targetId, banMsg)
    DBAdmin.Log(src, 'ban_player', tostring(targetId), targetName, reason .. ' | Duration: ' .. duration)
end)

-- ============================================================================
-- BAN CHECK ON CONNECT
-- ============================================================================
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    deferrals.update('Checking ban status...')

    local identifiers = GetPlayerIdentifiers(src)
    local license = identifiers[1] or 'unknown'

    local bans = MySQL.query.await('SELECT * FROM dbadmin_bans WHERE banned_id = ? AND active = 1', { license })

    if bans and #bans > 0 then
        for _, ban in ipairs(bans) do
            if ban.permanent == 1 then
                return deferrals.done(string.format('Permanently banned.\nReason: %s\nBy: %s', ban.reason, ban.banned_by))
            end

            if ban.expires_at then
                local y, mo, d, h, mi, s = ban.expires_at:match('(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)')
                if y then
                    local expiry = os.time({ year = tonumber(y), month = tonumber(mo), day = tonumber(d), hour = tonumber(h), min = tonumber(mi), sec = tonumber(s) })
                    if os.time() < expiry then
                        return deferrals.done(string.format('Banned until %s.\nReason: %s\nBy: %s', ban.expires_at, ban.reason, ban.banned_by))
                    else
                        MySQL.update('UPDATE dbadmin_bans SET active = 0 WHERE id = ?', { ban.id })
                    end
                end
            end
        end
    end

    deferrals.done()
end)