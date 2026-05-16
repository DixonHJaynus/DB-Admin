--[[
    DB-Admin | Client Main (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

DBAdmin = DBAdmin or {}
DBAdmin.isAdmin     = false
DBAdmin.permissions = {
    admin = false, moderator = false, developer = false,
    troll = false, reports = false, finances = false,
}
DBAdmin.serverId = GetPlayerServerId(PlayerId())

local function RefreshPermissions(cb)
    RSGCore.Functions.TriggerCallback('dbadmin:server:checkPermissions', function(perms)
        if perms then
            DBAdmin.isAdmin     = perms.isAdmin or false
            DBAdmin.permissions = perms
        end
        if cb then cb() end
    end)
end

local function HasPerm(key)
    if not DBAdmin.permissions then return false end
    return DBAdmin.permissions.admin or DBAdmin.permissions[key]
end

function DBAdmin.HasPerm(key)
    return HasPerm(key)
end

function DBAdmin.OpenMainMenu()
    if not DBAdmin.isAdmin then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No admin permissions.', type = 'error' })
        return
    end

    local items = {}
    local function add(id, title, desc, icon, fn, stayOpen, style)
        items[#items + 1] = {
            actionId = id, title = title, description = desc,
            icon = icon, fn = fn, stayOpen = stayOpen, style = style,
        }
    end

    add('self', 'Self', 'Teleport, god mode, noclip & more', '🧍', function()
        TriggerEvent('dbadmin:client:adminOptions')
    end)

    if HasPerm('moderator') or HasPerm('reports') then
        add('reports', 'Reports', 'View and manage player reports', '📋', function()
            TriggerEvent('dbadmin:client:reportsMenu')
        end)
    end

    if HasPerm('moderator') then
        add('players', 'Player Actions', 'Manage online players', '👥', function()
            TriggerEvent('dbadmin:client:playerList')
        end)
    end

    if HasPerm('finances') then
        add('finances', 'Finances', 'Add or remove player money', '💰', function()
            TriggerEvent('dbadmin:client:financesMenu')
        end)
    end

    if HasPerm('moderator') then
        add('announcements', 'Announcements', 'Send messages to players', '📢', function()
            TriggerEvent('dbadmin:client:announcementsMenu')
        end)
    end

    if DBAdmin.permissions.admin then
        add('permissions', 'Permissions', 'Manage admin permissions', '🔑', function()
            TriggerEvent('dbadmin:client:permissionsMenu')
        end)
    end

    if DBAdmin.permissions.admin then
        add('server', 'Server Controls', 'Weather and server settings', '🌦️', function()
            TriggerEvent('dbadmin:client:serverControlsMenu')
        end)
    end

    if HasPerm('developer') then
        add('dev', 'Developer Tools', 'Coords, hashes, spawners', '🛠️', function()
            TriggerEvent('dbadmin:client:devToolsMenu')
        end)
    end

    if HasPerm('troll') then
        add('troll', 'Troll', 'Permission-gated troll actions', '🤪', function()
            TriggerEvent('dbadmin:client:trollMenu')
        end, false, 'danger')
    end

    DBAdmin.UI.Open('DB-ADMIN', items, {
        subtitle = 'Administrator Console',
        showBack = false,
        hint     = 'ESC to close',
    })
end

RegisterCommand(Config.OpenCommand, function()
    RefreshPermissions(function()
        DBAdmin.OpenMainMenu()
    end)
end, false)

CreateThread(function()
    while true do
        Wait(0)
        if RSGCore.Shared and RSGCore.Shared.Keybinds and RSGCore.Shared.Keybinds[Config.OpenKey] then
            if IsControlJustReleased(0, RSGCore.Shared.Keybinds[Config.OpenKey]) then
                ExecuteCommand(Config.OpenCommand)
            end
        end
    end
end)

CreateThread(function()
    Wait(2000)
    RefreshPermissions()
end)

RegisterNetEvent('dbadmin:client:permissionsUpdate', function(perms)
    if perms then
        DBAdmin.isAdmin     = perms.isAdmin or false
        DBAdmin.permissions = perms
    end
end)