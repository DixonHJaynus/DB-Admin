--[[
    DB-Admin | Server Reports
    Submit, webhooks, claim, unclaim, status, notes
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- SUBMIT REPORT
-- ============================================================================
RegisterNetEvent('dbadmin:server:submitReport', function(category, title, message, nearbyPlayers, coords)
    local src = source
    local playerName = GetPlayerName(src)
    local playerId = GetPlayerIdentifiers(src)[1] or 'unknown'

    local player = RSGCore.Functions.GetPlayer(src)
    local charname = 'Unknown'
    if player and player.PlayerData.charinfo then
        charname = string.format('%s %s', player.PlayerData.charinfo.firstname or '', player.PlayerData.charinfo.lastname or '')
    end

    local nearbyJson = json.encode(nearbyPlayers or {})
    local coordsStr  = coords and string.format('%.2f, %.2f, %.2f', coords.x, coords.y, coords.z) or ''

    local insertId = MySQL.insert.await(
        'INSERT INTO dbadmin_reports (reporter_id, reporter_name, reporter_charname, category, title, message, nearby_players, coords) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { playerId, playerName, charname, category, title, message, nearbyJson, coordsStr }
    )

    TriggerClientEvent('dbadmin:client:reportSubmitted', src)

    -- notify all admins
    for _, p in pairs(RSGCore.Functions.GetRSGPlayers()) do
        local pSrc = p.PlayerData.source
        if IsAdmin(pSrc) then
            TriggerClientEvent('dbadmin:client:newReportNotification', pSrc, { category = category, title = title, reporter = playerName })
        end
    end

    SendReportWebhook(insertId, category, title, message, playerName, charname, coordsStr, nearbyPlayers)
    print(string.format('[DB-Admin] Report #%d by %s: [%s] %s', insertId or 0, playerName, category, title))
end)

-- ============================================================================
-- WEBHOOKS
-- ============================================================================
function SendReportWebhook(reportId, category, title, message, playerName, charname, coords, nearbyPlayers)
    local key = category:sub(1,1):upper() .. category:sub(2)
    local url = Config.Reports.Webhooks[key] or ''
    if url == '' then url = Config.Reports.Webhooks.Main end
    if url == '' or url == 'YOUR_WEBHOOK_URL_HERE' then return end

    local nearbyStr = 'None'
    if nearbyPlayers and #nearbyPlayers > 0 then
        local parts = {}
        for _, p in ipairs(nearbyPlayers) do parts[#parts + 1] = string.format('[%d] %s (%dm)', p.id, p.name, p.distance) end
        nearbyStr = table.concat(parts, '\n')
    end

    local mentionStr = ''
    if Config.Reports.Discord.EnableRoleMention then
        local mentions = {}
        for _, roleId in ipairs(Config.Reports.Discord.RolesToMention) do
            if roleId ~= 'YOUR_DISCORD_ROLE_ID_HERE' then mentions[#mentions + 1] = '<@&' .. roleId .. '>' end
        end
        if #mentions > 0 then mentionStr = table.concat(mentions, ' ') end
    end

    PerformHttpRequest(url, function() end, 'POST', json.encode({
        content  = mentionStr ~= '' and mentionStr or nil,
        username = 'DB-Admin Reports',
        embeds   = {{
            title       = string.format('New Report #%d', reportId or 0),
            description = string.format('**Category:** %s\n**Title:** %s', category:upper(), title),
            color       = Config.Reports.WebhookColors[category] or 3447003,
            fields      = {
                { name = 'Reporter',       value = playerName .. ' (' .. charname .. ')', inline = true },
                { name = 'Location',       value = coords or 'N/A',                       inline = true },
                { name = 'Message',        value = message,                                inline = false },
                { name = 'Nearby Players', value = nearbyStr,                              inline = false },
            },
            footer    = { text = 'DB-Admin Reports' },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }},
    }), { ['Content-Type'] = 'application/json' })
end

function SendStatusWebhook(reportId, status, adminName)
    local url = Config.Reports.Webhooks.Main
    if url == '' or url == 'YOUR_WEBHOOK_URL_HERE' then return end

    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username = 'DB-Admin Reports',
        embeds   = {{
            title       = string.format('Report #%d - Status Update', reportId),
            description = string.format('**Status:** %s\n**By:** %s', status:upper(), adminName),
            color       = Config.Reports.WebhookColors[status] or 3447003,
            footer      = { text = 'DB-Admin Reports' },
            timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }},
    }), { ['Content-Type'] = 'application/json' })
end

-- ============================================================================
-- CALLBACKS
-- ============================================================================
RSGCore.Functions.CreateCallback('dbadmin:server:getReports', function(source, cb, filter)
    if not IsAdmin(source) then return cb({}) end

    local query  = 'SELECT * FROM dbadmin_reports'
    local params = {}
    if filter and filter ~= 'all' then
        query = query .. ' WHERE status = ?'
        params = { filter }
    end
    query = query .. ' ORDER BY created_at DESC LIMIT 50'

    cb(MySQL.query.await(query, params) or {})
end)

RSGCore.Functions.CreateCallback('dbadmin:server:getReportDetails', function(source, cb, reportId)
    if not IsAdmin(source) then return cb(nil) end

    local reports = MySQL.query.await('SELECT * FROM dbadmin_reports WHERE id = ?', { reportId })
    if not reports or #reports == 0 then return cb(nil) end

    local report = reports[1]
    report.notes = MySQL.query.await('SELECT * FROM dbadmin_report_notes WHERE report_id = ? ORDER BY created_at ASC', { reportId }) or {}
    cb(report)
end)

-- ============================================================================
-- ACTIONS
-- ============================================================================
RegisterNetEvent('dbadmin:server:claimReport', function(data)
    local src = source
    if not IsAdmin(src) then return end

    local adminName = GetPlayerName(src)
    local adminId   = GetPlayerIdentifiers(src)[1] or 'unknown'

    MySQL.update('UPDATE dbadmin_reports SET status = ?, claimed_by = ?, claimed_by_id = ? WHERE id = ? AND status = ?', {
        'claimed', adminName, adminId, data.reportId, 'open',
    })

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Report claimed!', type = 'success' })
    DBAdmin.Log(src, 'claim_report', nil, nil, 'Report #' .. data.reportId)
    SendStatusWebhook(data.reportId, 'claimed', adminName)
end)

RegisterNetEvent('dbadmin:server:unclaimReport', function(data)
    local src = source
    if not IsAdmin(src) then return end

    MySQL.update('UPDATE dbadmin_reports SET status = ?, claimed_by = NULL, claimed_by_id = NULL WHERE id = ?', { 'open', data.reportId })

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Report unclaimed!', type = 'success' })
    DBAdmin.Log(src, 'unclaim_report', nil, nil, 'Report #' .. data.reportId)
    SendStatusWebhook(data.reportId, 'open', GetPlayerName(src))
end)

RegisterNetEvent('dbadmin:server:updateReportStatus', function(data)
    local src = source
    if not IsAdmin(src) then return end

    if data.status == 'resolved' then
        MySQL.update('UPDATE dbadmin_reports SET status = ?, resolved_at = ? WHERE id = ?', { data.status, os.date('%Y-%m-%d %H:%M:%S'), data.reportId })
    else
        MySQL.update('UPDATE dbadmin_reports SET status = ? WHERE id = ?', { data.status, data.reportId })
    end

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Status: ' .. data.status, type = 'success' })
    DBAdmin.Log(src, 'update_report', nil, nil, 'Report #' .. data.reportId .. ' -> ' .. data.status)
    SendStatusWebhook(data.reportId, data.status, GetPlayerName(src))
end)

RegisterNetEvent('dbadmin:server:addReportNote', function(reportId, note)
    local src = source
    if not IsAdmin(src) then return end

    MySQL.insert('INSERT INTO dbadmin_report_notes (report_id, author_name, author_id, note) VALUES (?, ?, ?, ?)', {
        reportId, GetPlayerName(src), GetPlayerIdentifiers(src)[1] or 'unknown', note,
    })

    TriggerClientEvent('ox_lib:notify', src, { title = 'DB-Admin', description = 'Note added!', type = 'success' })
    DBAdmin.Log(src, 'add_note', nil, nil, 'Report #' .. reportId)
end)