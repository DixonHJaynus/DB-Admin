--[[
    DB-Admin | Reports Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()
local lastReportTime = 0

-- ============================================================================
-- /report COMMAND (player-facing)
-- ============================================================================
if Config.Reports.EnableCommand then
    RegisterCommand(Config.Reports.Command, function()
        OpenReportSubmitDialog()
    end, false)
end

function OpenReportSubmitDialog()
    local now = GetGameTimer() / 1000
    if (now - lastReportTime) < Config.Reports.Cooldown then
        local remaining = math.ceil(Config.Reports.Cooldown - (now - lastReportTime))
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Wait ' .. remaining .. 's before another report.', type = 'error' })
    end

    local catOptions = {}
    for _, cat in ipairs(Config.Reports.Categories) do
        catOptions[#catOptions + 1] = { value = cat.value, label = cat.label }
    end

    local input = DBAdmin.Input('Submit Report', {
        { type = 'select',   label = 'Category', options = catOptions, required = true },
        { type = 'input',    label = 'Title',    required = true },
        { type = 'textarea', label = 'Message',  required = true },
    })
    if not input then return end

    local nearby = {}
    local myCoords = GetEntityCoords(cache.ped)
    for _, p in ipairs(GetActivePlayers()) do
        local sid = GetPlayerServerId(p)
        if sid ~= DBAdmin.serverId then
            local ped = GetPlayerPed(p)
            if DoesEntityExist(ped) then
                local dist = #(myCoords - GetEntityCoords(ped))
                if dist <= Config.Reports.NearbyDistance then
                    nearby[#nearby + 1] = { id = sid, name = GetPlayerName(p), distance = math.floor(dist) }
                end
            end
        end
    end

    local coords = GetEntityCoords(cache.ped)
    TriggerServerEvent('dbadmin:server:submitReport', input[1], input[2], input[3], nearby, {
        x = coords.x, y = coords.y, z = coords.z,
    })
    lastReportTime = now
end

-- ============================================================================
-- STAFF REPORTS MENU
-- ============================================================================
RegisterNetEvent('dbadmin:client:reportsMenu', function()
    local items = {
        { actionId = 'rall',  title = 'All Reports',      icon = '📜', fn = function() OpenReportsList('all') end },
        { actionId = 'ropen', title = 'Open Reports',     icon = '🟢', fn = function() OpenReportsList('open') end },
        { actionId = 'rcla',  title = 'Claimed Reports',  icon = '🟡', fn = function() OpenReportsList('claimed') end },
        { actionId = 'rres',  title = 'Resolved Reports', icon = '✅', fn = function() OpenReportsList('resolved') end },
        { actionId = 'rclo',  title = 'Closed Reports',   icon = '⬛', fn = function() OpenReportsList('closed') end },
        { actionId = 'rsub',  title = 'Submit Report',    icon = '✏️', fn = function() OpenReportSubmitDialog() end },
    }

    DBAdmin.UI.Open('Reports', items, {
        subtitle = 'Player Report Management',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end)

-- ============================================================================
-- LIST REPORTS
-- ============================================================================
function OpenReportsList(filter)
    RSGCore.Functions.TriggerCallback('dbadmin:server:getReports', function(reports)
        if not reports or #reports == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No reports found.', type = 'inform' })
            TriggerEvent('dbadmin:client:reportsMenu')
            return
        end

        local statusIcons = { open = '🟢', claimed = '🟡', resolved = '✅', closed = '⬛' }
        local catIcons    = { bug = '🐛', player = '👤', question = '❓' }

        local items = {}
        for _, r in ipairs(reports) do
            items[#items + 1] = {
                actionId    = 'r' .. r.id,
                title       = (statusIcons[r.status] or '') .. ' [#' .. r.id .. '] ' .. r.title,
                description = 'By ' .. r.reporter_name .. ' | ' .. r.status .. ' | ' .. (r.created_at or ''),
                icon        = catIcons[r.category] or '📋',
                fn          = function()
                    OpenReportDetail(r.id, filter)
                end,
            }
        end

        DBAdmin.UI.Open('Reports - ' .. filter:upper(), items, {
            subtitle = #reports .. ' report(s)',
            showBack = true,
            onBack   = function() TriggerEvent('dbadmin:client:reportsMenu') end,
        })
    end, filter)
end

-- ============================================================================
-- REPORT DETAIL
-- ============================================================================
function OpenReportDetail(reportId, filter)
    RSGCore.Functions.TriggerCallback('dbadmin:server:getReportDetails', function(report)
        if not report then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'Report not found!', type = 'error' })
            return
        end

        local items = {
            { actionId = 'd1', title = 'Title: ' .. report.title,                       icon = '📝', fn = function() end },
            { actionId = 'd2', title = 'Category: ' .. report.category,                 icon = '🏷️', fn = function() end },
            { actionId = 'd3', title = 'Status: ' .. report.status,                     icon = 'ℹ️', fn = function() end },
            { actionId = 'd4', title = 'Reporter: ' .. report.reporter_name,            icon = '👤', fn = function() end },
            { actionId = 'd5', title = 'Character: ' .. (report.reporter_charname or 'N/A'), icon = '🎭', fn = function() end },
            { actionId = 'd6', title = 'Message: ' .. report.message,                   icon = '💬', fn = function() end },
            { actionId = 'd7', title = 'Location: ' .. (report.coords or 'N/A'),       icon = '📍', fn = function() end },
            { actionId = 'd8', title = 'Created: ' .. (report.created_at or 'N/A'),    icon = '🕐', fn = function() end },
            { actionId = 'd9', title = 'Claimed By: ' .. (report.claimed_by or 'None'), icon = '🛡️', fn = function() end },
        }

        if report.nearby_players and report.nearby_players ~= '' then
            local nearby = json.decode(report.nearby_players)
            if nearby and #nearby > 0 then
                local parts = {}
                for _, p in ipairs(nearby) do
                    parts[#parts + 1] = '[' .. p.id .. '] ' .. p.name .. ' (' .. p.distance .. 'm)'
                end
                items[#items + 1] = { actionId = 'dnear', title = 'Nearby: ' .. table.concat(parts, ', '), icon = '👥', fn = function() end }
            end
        end

        if report.notes then
            for i, note in ipairs(report.notes) do
                items[#items + 1] = {
                    actionId    = 'note' .. i,
                    title       = 'Note #' .. i .. ' by ' .. note.author_name,
                    description = '[' .. (note.created_at or '') .. '] ' .. note.note,
                    icon        = '📌',
                    fn          = function() end,
                }
            end
        end

        -- ACTIONS
        if report.status == 'open' then
            items[#items + 1] = {
                actionId = 'aclaim', title = 'Claim Report', icon = '🔒',
                fn = function()
                    TriggerServerEvent('dbadmin:server:claimReport', { reportId = report.id })
                    OpenReportsList(filter)
                end,
                style = 'success',
            }
        end

        if report.status == 'claimed' then
            items[#items + 1] = {
                actionId = 'aunc', title = 'Unclaim Report', icon = '🔓',
                fn = function()
                    TriggerServerEvent('dbadmin:server:unclaimReport', { reportId = report.id })
                    OpenReportsList(filter)
                end,
            }
            items[#items + 1] = {
                actionId = 'ares', title = 'Mark Resolved', icon = '✅',
                fn = function()
                    TriggerServerEvent('dbadmin:server:updateReportStatus', { reportId = report.id, status = 'resolved' })
                    OpenReportsList(filter)
                end,
                style = 'success',
            }
        end

        if report.status ~= 'closed' then
            items[#items + 1] = {
                actionId = 'aclose', title = 'Close Report', icon = '⬛',
                fn = function()
                    TriggerServerEvent('dbadmin:server:updateReportStatus', { reportId = report.id, status = 'closed' })
                    OpenReportsList(filter)
                end,
                style = 'danger',
            }
        end

        items[#items + 1] = {
            actionId = 'anote', title = 'Add Staff Note', icon = '📝',
            fn = function()
                local input = DBAdmin.Input('Add Note', {
                    { type = 'textarea', label = 'Note', required = true },
                })
                if input then
                    TriggerServerEvent('dbadmin:server:addReportNote', report.id, input[1])
                    Wait(300)
                    OpenReportDetail(report.id, filter)
                else
                    OpenReportDetail(report.id, filter)
                end
            end,
        }

        if report.coords and report.coords ~= '' then
            items[#items + 1] = {
                actionId = 'atp', title = 'Teleport to Location', icon = '📍',
                fn = function()
                    local parts = {}
                    for part in string.gmatch(report.coords, '[^,]+') do
                        parts[#parts + 1] = tonumber(part:match('^%s*(.-)%s*$'))
                    end
                    if #parts >= 3 then
                        SetEntityCoordsNoOffset(cache.ped, parts[1], parts[2], parts[3] + 1.0, false, false, false)
                        DBAdmin.Notify({ title = 'DB-Admin', description = 'Teleported!', type = 'success' })
                    end
                end,
            }
        end

        DBAdmin.UI.Open('Report #' .. report.id, items, {
            subtitle = report.title,
            showBack = true,
            onBack   = function() OpenReportsList(filter) end,
        })
    end, reportId)
end

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================
RegisterNetEvent('dbadmin:client:reportSubmitted', function()
    DBAdmin.Notify({ title = 'DB-Admin', description = 'Report submitted!', type = 'success' })
end)

RegisterNetEvent('dbadmin:client:newReportNotification', function(reportData)
    if DBAdmin.isAdmin then
        DBAdmin.Notify({
            title       = 'New Report',
            description = '[' .. reportData.category .. '] ' .. reportData.title .. ' - by ' .. reportData.reporter,
            type        = 'inform',
            duration    = 8000,
        })
    end
end)