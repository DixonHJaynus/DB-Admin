--[[
    DB-Admin | Server Main
    Permissions, player list callback, logging
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- GLOBAL TABLE (must exist before DBAdmin.Log is defined)
-- ============================================================================
DBAdmin = {}

-- ============================================================================
-- PERMISSION HELPERS (global for all server files)
-- ============================================================================
function HasPermission(source, permType)
    local permKey = Config.Permissions[permType or 'admin']
    if not permKey then return false end
    return IsPlayerAceAllowed(source, permKey)
end

function IsAdmin(source)
    -- always allow rcon/owner (principal: identifier.console)
    if IsPlayerAceAllowed(source, 'command') then
        return true
    end
    for _, perm in pairs(Config.Permissions) do
        if IsPlayerAceAllowed(source, perm) then return true end
    end
    return false
end

-- ============================================================================
-- PERMISSION CALLBACK
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:checkPermissions', function(source, cb)
    cb({
        isAdmin     = IsAdmin(source),
        admin       = HasPermission(source, 'admin'),
        moderator   = HasPermission(source, 'moderator'),
        developer   = HasPermission(source, 'developer'),
        troll       = HasPermission(source, 'troll'),
        reports     = HasPermission(source, 'reports'),
        finances    = HasPermission(source, 'finances'),
    })
end)

-- ============================================================================
-- PLAYER LIST CALLBACK (used by multiple menus)
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:getPlayers', function(source, cb)
    if not IsAdmin(source) then return cb({}) end

    local players = {}
    local rsgPlayers = RSGCore.Functions.GetRSGPlayers()

    for _, player in pairs(rsgPlayers) do
        local src      = player.PlayerData.source
        local ped      = GetPlayerPed(src)
        local coords   = GetEntityCoords(ped)
        local charInfo = player.PlayerData.charinfo or {}

        players[#players + 1] = {
            id        = src,
            name      = GetPlayerName(src),
            charname  = string.format('%s %s', charInfo.firstname or '', charInfo.lastname or ''),
            job       = player.PlayerData.job and player.PlayerData.job.label or 'None',
            citizenid = player.PlayerData.citizenid,
            coords    = { x = coords.x, y = coords.y, z = coords.z },
        }
    end

    cb(players)
end)

-- ============================================================================
-- LOGGING (accepts source as first param)
-- ============================================================================
function DBAdmin.Log(src, action, targetId, targetName, details)
    local adminName = 'Console'
    local adminId   = 'console'

    if src and src > 0 then
        adminName = GetPlayerName(src) or 'Unknown'
        local identifiers = GetPlayerIdentifiers(src)
        adminId = identifiers and identifiers[1] or 'unknown'
    end

    MySQL.insert('INSERT INTO dbadmin_logs (admin_id, admin_name, action, target_id, target_name, details) VALUES (?, ?, ?, ?, ?, ?)', {
        adminId, adminName, action, targetId or '', targetName or '', details or '',
    })

    print(string.format('[DB-Admin] %s (%s) | %s | Target: %s | %s',
        adminName, adminId, action, targetId or 'N/A', details or ''))
end

-- ============================================================================
-- NET EVENT FOR CLIENT-TRIGGERED LOGS
-- ============================================================================
RegisterNetEvent('dbadmin:server:log', function(action, targetId, targetName, details)
    local src = source
    DBAdmin.Log(src, action, targetId, targetName, details)
end)

-- ============================================================================
-- INIT
-- ============================================================================
CreateThread(function()
    print('[DB-Admin] ^2Admin menu loaded successfully!^0')
end)