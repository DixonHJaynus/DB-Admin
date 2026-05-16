--[[
    DB-Admin | Announcements Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- ANNOUNCEMENTS MAIN
-- ============================================================================
RegisterNetEvent('dbadmin:client:announcementsMenu', function()
    local items = {
        {
            actionId = 'custom', title = 'Custom Announcement',
            description = 'Write a custom message to all',
            icon = '✏️',
            fn = function() OpenCustomAnnouncementDialog() end,
        },
        {
            actionId = 'tmpl', title = 'Quick Templates',
            description = 'Use pre-defined messages',
            icon = '📋',
            fn = function() OpenTemplateMenu() end,
        },
        {
            actionId = 'pm', title = 'Private Message',
            description = 'Send a message to a single player',
            icon = '✉️',
            fn = function() OpenPMPlayerSelect() end,
        },
        {
            actionId = 'history', title = 'Announcement History',
            description = 'View recent announcements',
            icon = '🕐',
            fn = function() OpenAnnouncementHistory() end,
        },
    }

    DBAdmin.UI.Open('Announcements', items, {
        subtitle = 'Server-Wide Messaging',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end)

-- ============================================================================
-- CUSTOM
-- ============================================================================
function OpenCustomAnnouncementDialog()
    local typeOptions = {}
    for _, t in ipairs(Config.Announcements.Types) do
        typeOptions[#typeOptions + 1] = { value = t.value, label = t.label }
    end

    local input = DBAdmin.Input('Custom Announcement', {
        { type = 'select',   label = 'Type',    options = typeOptions, required = true, default = 'info' },
        { type = 'textarea', label = 'Message', required = true, max = 500 },
    })
    if not input then
        TriggerEvent('dbadmin:client:announcementsMenu')
        return
    end

    if not input[2] or input[2] == '' then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Message cannot be empty!', type = 'error' })
        TriggerEvent('dbadmin:client:announcementsMenu')
        return
    end

    TriggerServerEvent('dbadmin:server:sendAnnouncement', {
        type    = input[1],
        message = input[2],
        target  = 'all',
    })
end

-- ============================================================================
-- TEMPLATES
-- ============================================================================
function OpenTemplateMenu()
    if not Config.Announcements.Templates or #Config.Announcements.Templates == 0 then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No templates configured.', type = 'error' })
        TriggerEvent('dbadmin:client:announcementsMenu')
        return
    end

    local items = {}
    for _, tpl in ipairs(Config.Announcements.Templates) do
        items[#items + 1] = {
            actionId    = 'tpl_' .. tpl.label,
            title       = tpl.label,
            description = tpl.message,
            icon        = '💬',
            fn          = function()
                local typeOptions = {}
                for _, t in ipairs(Config.Announcements.Types) do
                    typeOptions[#typeOptions + 1] = { value = t.value, label = t.label }
                end

                local input = DBAdmin.Input('Send: ' .. tpl.label, {
                    { type = 'select',   label = 'Type',    options = typeOptions, required = true, default = 'info' },
                    { type = 'textarea', label = 'Message', default = tpl.message, required = true },
                })
                if not input then
                    OpenTemplateMenu()
                    return
                end

                TriggerServerEvent('dbadmin:server:sendAnnouncement', {
                    type    = input[1],
                    message = input[2],
                    target  = 'all',
                })
            end,
        }
    end

    DBAdmin.UI.Open('Announcement Templates', items, {
        subtitle = 'Click to send',
        showBack = true,
        onBack   = function() TriggerEvent('dbadmin:client:announcementsMenu') end,
    })
end

-- ============================================================================
-- PRIVATE MESSAGE - PLAYER SELECT
-- ============================================================================
function OpenPMPlayerSelect()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
        if not players or #players == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No players online!', type = 'error' })
            TriggerEvent('dbadmin:client:announcementsMenu')
            return
        end

        local items = {}
        for _, v in pairs(players) do
            items[#items + 1] = {
                actionId = 'pm_' .. v.id,
                title    = '[' .. v.id .. '] ' .. v.name,
                icon     = '👤',
                fn       = function() OpenPMDialog(v.id, v.name) end,
            }
        end

        DBAdmin.UI.Open('Send PM', items, {
            subtitle = 'Select recipient',
            showBack = true,
            onBack   = function() TriggerEvent('dbadmin:client:announcementsMenu') end,
        })
    end)
end

-- ============================================================================
-- PM DIALOG
-- ============================================================================
function OpenPMDialog(targetId, targetName)
    local typeOptions = {}
    for _, t in ipairs(Config.Announcements.Types) do
        typeOptions[#typeOptions + 1] = { value = t.value, label = t.label }
    end

    local input = DBAdmin.Input('PM to: ' .. targetName, {
        { type = 'select',   label = 'Type',    options = typeOptions, required = true, default = 'info' },
        { type = 'textarea', label = 'Message', required = true, max = 500 },
    })
    if not input then
        OpenPMPlayerSelect()
        return
    end

    TriggerServerEvent('dbadmin:server:sendAnnouncement', {
        type    = input[1],
        message = input[2],
        target  = targetId,
    })
end

-- ============================================================================
-- HISTORY
-- ============================================================================
function OpenAnnouncementHistory()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getAnnouncementHistory', function(history)
        if not history or #history == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No announcements logged.', type = 'inform' })
            TriggerEvent('dbadmin:client:announcementsMenu')
            return
        end

        local items = {}
        for _, a in ipairs(history) do
            local targetLabel = (a.target == 'all') and 'Everyone' or 'PM: ' .. a.target
            items[#items + 1] = {
                actionId    = 'h_' .. a.id,
                title       = '[' .. a.type:upper() .. '] ' .. (a.created_at or ''),
                description = 'By ' .. a.admin_name .. ' → ' .. targetLabel .. '\n' .. a.message,
                icon        = '💬',
                fn          = function() end,
            }
        end

        DBAdmin.UI.Open('Announcement History', items, {
            subtitle = 'Recent ' .. #history .. ' messages',
            showBack = true,
            onBack   = function() TriggerEvent('dbadmin:client:announcementsMenu') end,
        })
    end)
end

-- ============================================================================
-- RECEIVE ANNOUNCEMENT (display)
-- ============================================================================
RegisterNetEvent('dbadmin:client:receiveAnnouncement', function(data)
    local color = { r = 50, g = 150, b = 255 }
    for _, t in ipairs(Config.Announcements.Types) do
        if t.value == data.type then color = t.color; break end
    end

    DBAdmin.Notify({
        title       = '📢 ' .. data.type:upper(),
        description = data.message,
        type        = data.type == 'alert' and 'error'
                      or (data.type == 'warning' and 'warning'
                      or (data.type == 'success' and 'success' or 'inform')),
        duration    = Config.Announcements.Duration,
        position    = 'top',
    })

    DisplayAnnouncementText(data.message, color, Config.Announcements.Duration)
end)

-- ============================================================================
-- ON-SCREEN BANNER
-- ============================================================================
function DisplayAnnouncementText(text, color, duration)
    CreateThread(function()
        local endTime = GetGameTimer() + duration
        while GetGameTimer() < endTime do
            Wait(0)
            SetTextScale(0.55, 0.55)
            SetTextFontForCurrentCommand(1)
            SetTextColor(color.r, color.g, color.b, 255)
            SetTextCentre(true)
            SetTextDropshadow(2, 0, 0, 0, 255)
            DisplayText(CreateVarString(10, 'LITERAL_STRING', '📢 ' .. text), 0.5, 0.10)
        end
    end)
end
