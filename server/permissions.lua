--[[
    DB-Admin | Server Permissions
    Manage ACE permissions and groups on players
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- HELPERS
-- ============================================================================
local function GetPlayerLicense(src)
    local identifiers = GetPlayerIdentifiers(src)
    return identifiers and identifiers[1] or nil
end

-- Restore permissions on join (re-applies ACE perms to keep them active across restarts)
local function RestorePermissions(src)
    local license = GetPlayerLicense(src)
    if not license then return end

    local perms = MySQL.query.await('SELECT * FROM dbadmin_permissions WHERE identifier = ? AND active = 1', { license })
    if not perms or #perms == 0 then return end

    for _, p in ipairs(perms) do
        if p.permission_type == 'group' then
            ExecuteCommand(string.format('add_principal identifier.%s group.%s', license, p.permission))
        else
            ExecuteCommand(string.format('add_ace identifier.%s %s allow', license, p.permission))
        end
    end

    print(string.format('[DB-Admin] Restored %d permission(s) for %s', #perms, GetPlayerName(src) or license))
end

-- ============================================================================
-- ON PLAYER JOIN: Restore permissions
-- ============================================================================
AddEventHandler('playerJoining', function()
    local src = source
    Wait(2000) -- give the player time to fully load
    RestorePermissions(src)
end)

-- ============================================================================
-- GRANT PERMISSION
-- ============================================================================
RegisterNetEvent('dbadmin:server:grantPermission', function(data)
    local src = source
    if not HasPermission(src, 'admin') then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'You need admin to manage permissions.', type = 'error' })
    end

    local targetId = tonumber(data.targetId)
    local target   = RSGCore.Functions.GetPlayer(targetId)
    if not target then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Target not found.', type = 'error' })
    end

    local license = GetPlayerLicense(targetId)
    if not license then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Target license not found.', type = 'error' })
    end

    local targetName = GetPlayerName(targetId)
    local adminName  = GetPlayerName(src)
    local adminId    = GetPlayerLicense(src) or 'unknown'

    -- check if perm already exists
    local existing = MySQL.query.await('SELECT id FROM dbadmin_permissions WHERE identifier = ? AND permission = ? AND permission_type = ? AND active = 1', {
        license, data.value, data.type,
    })
    if existing and #existing > 0 then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Player already has this permission.', type = 'error' })
    end

    -- apply via ACE
    if data.type == 'group' then
        ExecuteCommand(string.format('add_principal identifier.%s group.%s', license, data.value))
    else
        ExecuteCommand(string.format('add_ace identifier.%s %s allow', license, data.value))
    end

    -- save to db
    MySQL.insert('INSERT INTO dbadmin_permissions (identifier, player_name, permission_type, permission, granted_by, granted_by_id) VALUES (?, ?, ?, ?, ?, ?)', {
        license, targetName, data.type, data.value, adminName, adminId,
    })

    TriggerClientEvent('ox_lib:notify', src, {
        title       = 'DB-Admin',
        description = string.format('Granted %s "%s" to %s', data.type, data.value, targetName),
        type        = 'success',
    })

    TriggerClientEvent('ox_lib:notify', targetId, {
        title       = 'DB-Admin',
        description = 'You have been granted a new permission. Please rejoin if it does not take effect.',
        type        = 'inform',
    })

    DBAdmin.Log(src, 'grant_permission', tostring(targetId), targetName, data.type .. ': ' .. data.value)
end)

-- ============================================================================
-- REVOKE PERMISSION
-- ============================================================================
RegisterNetEvent('dbadmin:server:revokePermission', function(data)
    local src = source
    if not HasPermission(src, 'admin') then return end

    local permId = tonumber(data.permId)
    if not permId then return end

    local rows = MySQL.query.await('SELECT * FROM dbadmin_permissions WHERE id = ? AND active = 1', { permId })
    if not rows or #rows == 0 then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Permission not found.', type = 'error' })
    end

    local perm = rows[1]
    local adminName = GetPlayerName(src)

    -- remove ACE
    if perm.permission_type == 'group' then
        ExecuteCommand(string.format('remove_principal identifier.%s group.%s', perm.identifier, perm.permission))
    else
        ExecuteCommand(string.format('remove_ace identifier.%s %s allow', perm.identifier, perm.permission))
    end

    -- mark inactive in db
    MySQL.update('UPDATE dbadmin_permissions SET active = 0, revoked_by = ?, revoked_at = ? WHERE id = ?', {
        adminName, os.date('%Y-%m-%d %H:%M:%S'), permId,
    })

    TriggerClientEvent('ox_lib:notify', src, {
        title       = 'DB-Admin',
        description = string.format('Revoked "%s" from %s', perm.permission, perm.player_name),
        type        = 'success',
    })

    -- notify target if online
    if data.targetId then
        local targetId = tonumber(data.targetId)
        if targetId and GetPlayerName(targetId) then
            TriggerClientEvent('ox_lib:notify', targetId, {
                title       = 'DB-Admin',
                description = 'A permission has been revoked from you.',
                type        = 'inform',
            })
        end
    end

    DBAdmin.Log(src, 'revoke_permission', perm.identifier, perm.player_name, perm.permission_type .. ': ' .. perm.permission)
end)

-- ============================================================================
-- CALLBACKS
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:getPlayerPermissions', function(source, cb, targetId)
    if not HasPermission(source, 'admin') then return cb({}) end

    local license = GetPlayerLicense(tonumber(targetId))
    if not license then return cb({}) end

    local perms = MySQL.query.await('SELECT * FROM dbadmin_permissions WHERE identifier = ? AND active = 1 ORDER BY created_at DESC', { license })
    cb(perms or {})
end)

RSGCore.Functions.CreateCallback('dbadmin:server:getAllPermissions', function(source, cb)
    if not HasPermission(source, 'admin') then return cb({}) end

    local perms = MySQL.query.await('SELECT * FROM dbadmin_permissions WHERE active = 1 ORDER BY created_at DESC LIMIT 100')
    cb(perms or {})
end)