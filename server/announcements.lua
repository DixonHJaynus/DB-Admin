--[[
    DB-Admin | Server Announcements
    Send announcements to all or specific players
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- SEND ANNOUNCEMENT
-- ============================================================================
RegisterNetEvent('dbadmin:server:sendAnnouncement', function(data)
    local src = source
    if not (HasPermission(src, 'admin') or HasPermission(src, 'moderator')) then return end

    if not data or not data.message or data.message == '' then
        return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Message cannot be empty.', type = 'error' })
    end

    local annType  = data.type or 'info'
    local message  = data.message
    local target   = data.target or 'all'

    local adminName = GetPlayerName(src)
    local adminId   = GetPlayerIdentifiers(src)[1] or 'unknown'

    -- send to target(s)
    if target == 'all' then
        TriggerClientEvent('dbadmin:client:receiveAnnouncement', -1, { type = annType, message = message })
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Announcement sent to everyone!', type = 'success' })
    else
        local targetId = tonumber(target)
        if not targetId or not GetPlayerName(targetId) then
            return TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Target player not found.', type = 'error' })
        end
        TriggerClientEvent('dbadmin:client:receiveAnnouncement', targetId, { type = annType, message = message })
        TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'PM sent to ' .. GetPlayerName(targetId), type = 'success' })
    end

    -- save to db
    MySQL.insert('INSERT INTO dbadmin_announcements (admin_id, admin_name, type, message, target) VALUES (?, ?, ?, ?, ?)', {
        adminId, adminName, annType, message, tostring(target),
    })

    -- discord webhook
    SendAnnouncementWebhook(adminName, annType, message, target)

    -- log
    DBAdmin.Log(src, 'send_announcement', tostring(target), nil, '[' .. annType .. '] ' .. message)
end)

-- ============================================================================
-- HISTORY CALLBACK
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:getAnnouncementHistory', function(source, cb)
    if not (HasPermission(source, 'admin') or HasPermission(source, 'moderator')) then return cb({}) end

    local history = MySQL.query.await('SELECT * FROM dbadmin_announcements ORDER BY created_at DESC LIMIT 25')
    cb(history or {})
end)

-- ============================================================================
-- DISCORD WEBHOOK
-- ============================================================================
function SendAnnouncementWebhook(adminName, annType, message, target)
    local url = Config.Announcements.Webhook
    if not url or url == '' then return end

    local targetLabel = (target == 'all') and 'Everyone' or ('Player ID: ' .. target)
    local color = 3447003
    if annType == 'warning' then color = 16776960
    elseif annType == 'alert' then color = 16711680
    elseif annType == 'success' then color = 65280 end

    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username = 'DB-Admin Announcements',
        embeds   = {{
            title       = '📢 Announcement: ' .. annType:upper(),
            description = message,
            color       = color,
            fields      = {
                { name = 'Sent By', value = adminName,    inline = true },
                { name = 'Target',  value = targetLabel,  inline = true },
            },
            footer    = { text = 'DB-Admin Announcements' },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }},
    }), { ['Content-Type'] = 'application/json' })
end
