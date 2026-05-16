--[[
    DB-Admin | Permissions Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- PERMISSIONS MAIN
-- ============================================================================
RegisterNetEvent('dbadmin:client:permissionsMenu', function()
    local items = {
        {
            actionId = 'manage', title = 'Manage Online Player',
            description = 'Add or remove perms on a connected player',
            icon = '👤',
            fn = function() OpenPermPlayerSelect() end,
        },
        {
            actionId = 'viewall', title = 'View All Granted Permissions',
            description = 'Browse permissions granted via DB-Admin',
            icon = '📜',
            fn = function() OpenViewAllPerms() end,
        },
    }

    DBAdmin.UI.Open('Permissions', items, {
        subtitle = 'Permission Manager',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end)

-- ============================================================================
-- PLAYER SELECT
-- ============================================================================
function OpenPermPlayerSelect()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
        if not players or #players == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No players online!', type = 'error' })
            TriggerEvent('dbadmin:client:permissionsMenu')
            return
        end

        local items = {}
        for _, v in pairs(players) do
            items[#items + 1] = {
                actionId = 'pp_' .. v.id,
                title    = '[' .. v.id .. '] ' .. v.name,
                icon     = '👤',
                fn       = function() OpenPermPlayerActions(v.id, v.name) end,
            }
        end

        DBAdmin.UI.Open('Select Player', items, {
            subtitle = 'Manage permissions for...',
            showBack = true,
            onBack   = function() TriggerEvent('dbadmin:client:permissionsMenu') end,
        })
    end)
end

-- ============================================================================
-- PER-PLAYER PERM ACTIONS
-- ============================================================================
function OpenPermPlayerActions(targetId, targetName)
    local items = {
        {
            actionId = 'view', title = 'View Current Permissions',
            description = 'See active perms for this player',
            icon = '👁️',
            fn = function() OpenViewPlayerPerms(targetId, targetName) end,
        },
        {
            actionId = 'group', title = 'Grant Permission Group',
            description = 'Assign admin/moderator/etc',
            icon = '🛡️',
            style = 'success',
            fn = function() OpenGrantGroup(targetId, targetName) end,
        },
        {
            actionId = 'ace', title = 'Grant Individual Permission',
            description = 'Assign a specific dbadmin.* perm',
            icon = '🔑',
            style = 'success',
            fn = function() OpenGrantAce(targetId, targetName) end,
        },
        {
            actionId = 'revoke', title = 'Revoke Permission',
            description = 'Remove a permission from this player',
            icon = '🚫',
            style = 'danger',
            fn = function() OpenRevokePerm(targetId, targetName) end,
        },
    }

    DBAdmin.UI.Open(targetName, items, {
        subtitle = 'Permission Actions',
        showBack = true,
        onBack   = function() OpenPermPlayerSelect() end,
    })
end

-- ============================================================================
-- VIEW PLAYER PERMS
-- ============================================================================
function OpenViewPlayerPerms(targetId, targetName)
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayerPermissions', function(perms)
        if not perms or #perms == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = targetName .. ' has no DB-Admin perms.', type = 'inform' })
            OpenPermPlayerActions(targetId, targetName)
            return
        end

        local items = {}
        for _, p in ipairs(perms) do
            items[#items + 1] = {
                actionId    = 'vp_' .. p.id,
                title       = (p.permission_type == 'group' and 'Group: ' or 'Ace: ') .. p.permission,
                description = 'Granted by ' .. p.granted_by .. ' on ' .. (p.created_at or 'N/A'),
                icon        = p.permission_type == 'group' and '👥' or '🔑',
                fn          = function() end,
            }
        end

        DBAdmin.UI.Open(targetName .. "'s Perms", items, {
            subtitle = #perms .. ' active',
            showBack = true,
            onBack   = function() OpenPermPlayerActions(targetId, targetName) end,
        })
    end, targetId)
end

-- ============================================================================
-- GRANT GROUP
-- ============================================================================
function OpenGrantGroup(targetId, targetName)
    local groupOptions = {}
    for _, g in ipairs(Config.PermissionGroups) do
        groupOptions[#groupOptions + 1] = { value = g.value, label = g.label }
    end

    local input = DBAdmin.Input('Grant Group: ' .. targetName, {
        { type = 'select', label = 'Group', options = groupOptions, required = true },
    })
    if not input then
        OpenPermPlayerActions(targetId, targetName)
        return
    end

    local confirm = DBAdmin.Alert({
        header   = 'Confirm',
        content  = 'Grant **' .. input[1] .. '** group to **' .. targetName .. '**?',
        centered = true,
        cancel   = true,
    })
    if confirm ~= 'confirm' then
        OpenPermPlayerActions(targetId, targetName)
        return
    end

    TriggerServerEvent('dbadmin:server:grantPermission', {
        targetId = targetId,
        type     = 'group',
        value    = input[1],
    })
    OpenPermPlayerActions(targetId, targetName)
end

-- ============================================================================
-- GRANT ACE PERMISSION
-- ============================================================================
function OpenGrantAce(targetId, targetName)
    local aceOptions = {}
    for _, a in ipairs(Config.AvailablePermissions) do
        aceOptions[#aceOptions + 1] = { value = a.value, label = a.label }
    end

    local input = DBAdmin.Input('Grant Permission: ' .. targetName, {
        { type = 'select', label = 'Permission', options = aceOptions, required = true },
    })
    if not input then
        OpenPermPlayerActions(targetId, targetName)
        return
    end

    local confirm = DBAdmin.Alert({
        header   = 'Confirm',
        content  = 'Grant permission **' .. input[1] .. '** to **' .. targetName .. '**?',
        centered = true,
        cancel   = true,
    })
    if confirm ~= 'confirm' then
        OpenPermPlayerActions(targetId, targetName)
        return
    end

    TriggerServerEvent('dbadmin:server:grantPermission', {
        targetId = targetId,
        type     = 'ace',
        value    = input[1],
    })
    OpenPermPlayerActions(targetId, targetName)
end

-- ============================================================================
-- REVOKE PERMISSION
-- ============================================================================
function OpenRevokePerm(targetId, targetName)
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayerPermissions', function(perms)
        if not perms or #perms == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No perms to revoke.', type = 'inform' })
            OpenPermPlayerActions(targetId, targetName)
            return
        end

        local revokeOptions = {}
        for _, p in ipairs(perms) do
            revokeOptions[#revokeOptions + 1] = {
                value = tostring(p.id),
                label = (p.permission_type == 'group' and '[Group] ' or '[Ace] ') .. p.permission,
            }
        end

        local input = DBAdmin.Input('Revoke from: ' .. targetName, {
            { type = 'select', label = 'Permission', options = revokeOptions, required = true },
        })
        if not input then
            OpenPermPlayerActions(targetId, targetName)
            return
        end

        local confirm = DBAdmin.Alert({
            header   = 'Confirm Revoke',
            content  = 'Are you sure you want to revoke this permission?',
            centered = true,
            cancel   = true,
        })
        if confirm ~= 'confirm' then
            OpenPermPlayerActions(targetId, targetName)
            return
        end

        TriggerServerEvent('dbadmin:server:revokePermission', {
            permId   = tonumber(input[1]),
            targetId = targetId,
        })
        OpenPermPlayerActions(targetId, targetName)
    end, targetId)
end

-- ============================================================================
-- VIEW ALL PERMS
-- ============================================================================
function OpenViewAllPerms()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getAllPermissions', function(perms)
        if not perms or #perms == 0 then
            DBAdmin.Notify({ title = 'DB-Admin', description = 'No permissions on record.', type = 'inform' })
            TriggerEvent('dbadmin:client:permissionsMenu')
            return
        end

        local items = {}
        for _, p in ipairs(perms) do
            items[#items + 1] = {
                actionId    = 'all_' .. p.id,
                title       = (p.permission_type == 'group' and 'Group: ' or 'Ace: ') .. p.permission,
                description = p.player_name .. ' | by ' .. p.granted_by .. ' | ' .. (p.created_at or ''),
                icon        = p.permission_type == 'group' and '👥' or '🔑',
                fn          = function() end,
            }
        end

        DBAdmin.UI.Open('All Active Permissions', items, {
            subtitle = #perms .. ' total',
            showBack = true,
            onBack   = function() TriggerEvent('dbadmin:client:permissionsMenu') end,
        })
    end)
end