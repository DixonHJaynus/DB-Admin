--[[
    DB-Admin | Self Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

local godmode   = false
local invisible = false

function OpenAdminOptionsMenu()
    local items = {}
    local function add(id, title, desc, icon, fn, stayOpen)
        items[#items + 1] = {
            actionId = id, title = title, description = desc,
            icon = icon, fn = fn, stayOpen = stayOpen,
        }
    end

    add('to_marker', 'Teleport to Marker', 'Teleport to your map waypoint', '📍', function()
        TriggerEvent('dbadmin:client:goToMarker')
    end)

    add('revive', 'Self Revive', 'Revive yourself', '💊', function()
        TriggerEvent('dbadmin:client:selfRevive')
    end)

    add('invisible',
        invisible and 'Go Visible' or 'Go Invisible',
        invisible and 'You are currently invisible' or 'Become invisible to others',
        '👻',
        function() TriggerEvent('dbadmin:client:toggleInvisible') end
    )

    add('godmode',
        godmode and 'Disable God Mode' or 'Enable God Mode',
        godmode and 'God Mode is currently ON' or 'God Mode is currently OFF',
        '🛡️',
        function() TriggerEvent('dbadmin:client:toggleGodMode') end
    )

    add('noclip', 'NoClip Toggle', 'Toggle txAdmin NoClip', '✈️', function()
        ExecuteCommand('txAdmin:menu:noClipToggle')
    end)

    -- ✅ stays open
    add('ids', 'Toggle Player IDs', 'Show/hide overhead player IDs', '🔢', function()
        ExecuteCommand('txAdmin:menu:togglePlayerIDs')
        OpenAdminOptionsMenu()
    end, true)

    -- ✅ stays open
    if Config.EnablePlayerBlips then
        add('blips', 'Toggle Player Blips', 'Show all players on the map', '📡', function()
            TriggerEvent('dbadmin:client:togglePlayerBlips')
            OpenAdminOptionsMenu()
        end, true)
    end

    DBAdmin.UI.Open('Self Actions', items, {
        subtitle = 'Personal Admin Tools',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end

RegisterNetEvent('dbadmin:client:adminOptions', function()
    OpenAdminOptionsMenu()
end)

RegisterNetEvent('dbadmin:client:goToMarker', function()
    local waypoint = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    if not DoesBlipExist(waypoint) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'No waypoint set!', type = 'error' })
    end
    local coords  = GetBlipCoords(waypoint)
    local ped     = cache.ped
    local groundZ = coords.z
    for i = 0, 1000, 25 do
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, i + 0.0, false, false, false)
        Wait(50)
        local found, z = GetGroundZFor_3dCoord(coords.x, coords.y, i + 0.0, false)
        if found then groundZ = z; break end
    end
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, groundZ + 1.0, false, false, false)
    DBAdmin.Notify({ title = 'DB-Admin', description = 'Teleported to marker!', type = 'success' })
    TriggerServerEvent('dbadmin:server:log', 'teleport_marker', nil, nil,
        string.format('%.2f, %.2f, %.2f', coords.x, coords.y, groundZ))
end)

RegisterNetEvent('dbadmin:client:selfRevive', function()
    local ped    = cache.ped
    local coords = GetEntityCoords(ped)
    if IsEntityDead(ped) then
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    end
    SetEntityHealth(ped, GetEntityMaxHealth(ped), 0)
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100)
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100)
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 2, 100)
    ClearPedBloodDamage(ped)
    DBAdmin.Notify({ title = 'DB-Admin', description = 'You have been revived!', type = 'success' })
    TriggerServerEvent('dbadmin:server:log', 'self_revive')
end)

RegisterNetEvent('dbadmin:client:toggleInvisible', function()
    invisible = not invisible
    SetEntityVisible(cache.ped, not invisible)
    DBAdmin.Notify({
        title = 'DB-Admin',
        description = invisible and 'You are now invisible.' or 'You are now visible.',
        type = 'inform'
    })
    TriggerServerEvent('dbadmin:server:log', 'toggle_invisible', nil, nil, tostring(invisible))
end)

RegisterNetEvent('dbadmin:client:toggleGodMode', function()
    godmode = not godmode
    if godmode then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'God Mode ENABLED.', type = 'inform' })
        TriggerServerEvent('dbadmin:server:log', 'godmode_on')
        CreateThread(function()
            while godmode do
                Wait(0)
                SetPlayerInvincible(cache.ped, true)
            end
            SetPlayerInvincible(cache.ped, false)
        end)
    else
        SetPlayerInvincible(cache.ped, false)
        DBAdmin.Notify({ title = 'DB-Admin', description = 'God Mode DISABLED.', type = 'inform' })
        TriggerServerEvent('dbadmin:server:log', 'godmode_off')
    end
end)