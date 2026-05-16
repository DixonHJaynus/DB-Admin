--[[
    DB-Admin | Players Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

local isSpectating      = false
local lastSpectateCoord = nil

-- ============================================================================
-- PLAYER LIST
-- ============================================================================
RegisterNetEvent('dbadmin:client:playerList', function()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
        if not players or #players == 0 then
            return DBAdmin.Notify({ title = 'DB-Admin', description = 'No players online!', type = 'error' })
        end

        local items = {}
        for _, v in pairs(players) do
            items[#items + 1] = {
                actionId    = 'p_' .. v.id,
                title       = '[' .. v.id .. '] ' .. v.name,
                description = 'Character: ' .. (v.charname or 'N/A') .. ' | Job: ' .. (v.job or 'None'),
                icon        = '👤',
                fn          = function()
                    OpenPlayerActionsMenu(v.id, v.name)
                end,
            }
        end

        DBAdmin.UI.Open('Online Players', items, {
            subtitle = #players .. ' player(s) connected',
            showBack = true,
            onBack   = function() DBAdmin.OpenMainMenu() end,
        })
    end)
end)

-- ============================================================================
-- PER-PLAYER ACTIONS MENU
-- ============================================================================
function OpenPlayerActionsMenu(targetId, targetName)
    local items = {}
    local function add(id, title, desc, icon, fn, style)
        items[#items + 1] = {
            actionId = id, title = title, description = desc,
            icon = icon, fn = fn, style = style,
        }
    end

    add('info', 'Player Info', 'View detailed player information', '📋', function()
        TriggerEvent('dbadmin:client:playerInfo', { id = targetId, name = targetName })
    end)

    add('revive', 'Revive Player', 'Revive this player', '💊', function()
        TriggerServerEvent('dbadmin:server:revivePlayer', { id = targetId })
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Revive sent to ' .. targetName, type = 'success' })
    end)

    add('giveitem', 'Give Item', 'Give an item to this player', '🎁', function()
        OpenGiveItemDialog(targetId, targetName)
    end)

    add('inv', 'View Inventory', 'Open player inventory', '🎒', function()
        TriggerServerEvent('dbadmin:server:openInventory', { id = targetId })
    end)

    add('goto', 'Go To Player', 'Teleport to this player', '📍', function()
        TriggerServerEvent('dbadmin:server:goToPlayer', { id = targetId })
    end)

    add('bring', 'Bring Player', 'Teleport player to you', '🪝', function()
        TriggerServerEvent('dbadmin:server:bringPlayer', { id = targetId })
    end)

    add('freeze', 'Freeze / Unfreeze', 'Toggle player freeze', '❄️', function()
        TriggerServerEvent('dbadmin:server:freezePlayer', { id = targetId, name = targetName })
    end)

    add('spectate', 'Spectate', 'Watch this player', '👁️', function()
        TriggerServerEvent('dbadmin:server:spectatePlayer', { id = targetId })
    end)

    add('kick', 'Kick Player', 'Remove from server with reason', '👢', function()
        OpenKickDialog(targetId, targetName)
    end, 'danger')

    add('ban', 'Ban Player', 'Permanently or temporarily ban', '🔨', function()
        OpenBanDialog(targetId, targetName)
    end, 'danger')

    DBAdmin.UI.Open(targetName, items, {
        subtitle = 'ID: ' .. targetId,
        showBack = true,
        onBack   = function() TriggerEvent('dbadmin:client:playerList') end,
    })
end

-- ============================================================================
-- PLAYER INFO
-- ============================================================================
RegisterNetEvent('dbadmin:client:playerInfo', function(data)
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayerInfo', function(info)
        if not info then
            return DBAdmin.Notify({ title = 'DB-Admin', description = 'Could not get info.', type = 'error' })
        end

        local items = {
            { actionId = 'i1', title = 'Name: ' .. info.firstname .. ' ' .. info.lastname,    icon = '👤', fn = function() end },
            { actionId = 'i2', title = 'Job: ' .. info.job,                                    icon = '💼', fn = function() end },
            { actionId = 'i3', title = 'Grade: ' .. tostring(info.grade),                     icon = '⭐', fn = function() end },
            { actionId = 'i4', title = 'Cash: $' .. tostring(info.cash),                      icon = '💵', fn = function() end },
            { actionId = 'i5', title = 'Bank: $' .. tostring(info.bank),                      icon = '🏦', fn = function() end },
            { actionId = 'i6', title = 'Blood Money: $' .. tostring(info.bloodmoney),         icon = '🩸', fn = function() end },
            { actionId = 'i7', title = 'CitizenID: ' .. info.citizenid,                       icon = '🆔', fn = function() end },
            { actionId = 'i8', title = 'Server ID: ' .. tostring(info.serverid),              icon = '🖥️', fn = function() end },
            { actionId = 'i9', title = 'Ping: ' .. tostring(info.ping) .. 'ms',              icon = '📶', fn = function() end },
        }

        DBAdmin.UI.Open(data.name, items, {
            subtitle = 'Player Information',
            showBack = true,
            onBack   = function() OpenPlayerActionsMenu(data.id, data.name) end,
        })
    end, data)
end)

-- ============================================================================
-- GIVE ITEM (NUI: searchable list + form)
-- ============================================================================
function OpenGiveItemDialog(targetId, targetName)
    local items = RSGCore.Shared.Items
    local list  = {}

    for _, item in pairs(items) do
        local label = item.label or item.name
        list[#list + 1] = {
            actionId    = 'gi_' .. item.name,
            title       = label,
            description = 'Item: ' .. item.name,
            icon        = '🎒',
            fn          = function()
                OpenGiveItemQuantity(targetId, targetName, item.name, label)
            end,
        }
    end

    table.sort(list, function(a, b) return a.title < b.title end)

    DBAdmin.UI.Open('Give Item to ' .. targetName, list, {
        subtitle   = 'Search and select an item',
        showBack   = true,
        searchable = true,
        onBack     = function() OpenPlayerActionsMenu(targetId, targetName) end,
    })
end

function OpenGiveItemQuantity(targetId, targetName, itemName, itemLabel)
    DBAdmin.UI.OpenForm('Give: ' .. itemLabel, {
        id          = 'giveitem',
        submitLabel = 'Give Item',
        fields = {
            { key = 'qty', type = 'number', label = 'Quantity', default = 1, min = 1, placeholder = 'How many?' },
        },
    }, {
        subtitle = 'To: ' .. targetName,
        showBack = true,
        onBack   = function() OpenGiveItemDialog(targetId, targetName) end,
        onSubmit = function(values)
            local amount = tonumber(values.qty)
            if not amount or amount < 1 then
                DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid quantity!', type = 'error' })
                OpenGiveItemDialog(targetId, targetName)
                return
            end
            TriggerServerEvent('dbadmin:server:giveItem', targetId, itemName, amount)
            OpenPlayerActionsMenu(targetId, targetName)
        end,
        onCancel = function()
            OpenGiveItemDialog(targetId, targetName)
        end,
    })
end
-- ============================================================================
-- KICK DIALOG
-- ============================================================================
function OpenKickDialog(targetId, targetName)
    local input = DBAdmin.Input('Kick: ' .. targetName, {
        { type = 'input', label = 'Reason', required = true },
    })
    if not input then
        OpenPlayerActionsMenu(targetId, targetName)
        return
    end

    TriggerServerEvent('dbadmin:server:kickPlayer', targetId, input[1])
end

-- ============================================================================
-- BAN DIALOG
-- ============================================================================
function OpenBanDialog(targetId, targetName)
    local input = DBAdmin.Input('Ban: ' .. targetName, {
        {
            type = 'select', label = 'Type', required = true,
            options = {
                { value = 'permanent', label = 'Permanent' },
                { value = 'temporary', label = 'Temporary' },
            }
        },
        {
            type = 'select', label = 'Duration (if temp)', required = true,
            options = {
                { value = '3600',        label = '1 Hour' },
                { value = '21600',       label = '6 Hours' },
                { value = '43200',       label = '12 Hours' },
                { value = '86400',       label = '1 Day' },
                { value = '259200',      label = '3 Days' },
                { value = '604800',      label = '7 Days' },
                { value = '2678400',     label = '1 Month' },
                { value = '8035200',     label = '3 Months' },
                { value = '16070400',    label = '6 Months' },
                { value = '32140800',    label = '1 Year' },
                { value = '99999999999', label = 'Max' },
            }
        },
        { type = 'input', label = 'Reason', required = true },
    })
    if not input then
        OpenPlayerActionsMenu(targetId, targetName)
        return
    end

    if input[1] == 'permanent' then
        TriggerServerEvent('dbadmin:server:banPlayer', targetId, '99999999999', input[3])
    else
        TriggerServerEvent('dbadmin:server:banPlayer', targetId, input[2], input[3])
    end
    DBAdmin.Notify({ title = 'DB-Admin', description = targetName .. ' has been banned.', type = 'inform' })
end

-- ============================================================================
-- SPECTATE
-- ============================================================================
RegisterNetEvent('dbadmin:client:spectatePlayer', function(targetServerId)
    local targetPlayer = GetPlayerFromServerId(targetServerId)
    local targetPed    = GetPlayerPed(targetPlayer)

    if not isSpectating then
        isSpectating = true
        SetEntityVisible(cache.ped, false)
        SetEntityCollision(cache.ped, false, false)
        SetEntityInvincible(cache.ped, true)
        NetworkSetEntityInvisibleToNetwork(cache.ped, true)
        lastSpectateCoord = GetEntityCoords(cache.ped)
        NetworkSetInSpectatorMode(true, targetPed)
    else
        isSpectating = false
        NetworkSetInSpectatorMode(false, targetPed)
        NetworkSetEntityInvisibleToNetwork(cache.ped, false)
        SetEntityCollision(cache.ped, true, true)
        SetEntityCoords(cache.ped, lastSpectateCoord)
        SetEntityVisible(cache.ped, true)
        SetEntityInvincible(cache.ped, false)
        lastSpectateCoord = nil
    end
end)

-- ============================================================================
-- HANDLERS (server -> client)
-- ============================================================================
RegisterNetEvent('dbadmin:client:bringHere', function(coords)
    SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z + 1.0, false, false, false)
    DBAdmin.Notify({ title = 'DB-Admin', description = 'Teleported by an admin.', type = 'inform' })
end)

RegisterNetEvent('dbadmin:client:freezeToggle', function(freeze)
    FreezeEntityPosition(cache.ped, freeze)
    DBAdmin.Notify({
        title = 'DB-Admin',
        description = freeze and 'You have been frozen.' or 'You have been unfrozen.',
        type = 'inform'
    })
end)

RegisterNetEvent('dbadmin:client:goToCoords', function(coords)
    SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z + 1.0, false, false, false)
    DBAdmin.Notify({ title = 'DB-Admin', description = 'Teleported to player!', type = 'success' })
end)