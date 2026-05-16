--[[
    DB-Admin | Troll Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- TROLL MENU (player select)
-- ============================================================================
RegisterNetEvent('dbadmin:client:trollMenu', function()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
        if not players or #players == 0 then
            return DBAdmin.Notify({ title = 'DB-Admin', description = 'No players online!', type = 'error' })
        end

        local items = {}
        for _, v in pairs(players) do
            items[#items + 1] = {
                actionId    = 't_' .. v.id,
                title       = '[' .. v.id .. '] ' .. v.name,
                description = 'Choose a troll action',
                icon        = '👤',
                fn          = function()
                    OpenTrollActions(v.id, v.name)
                end,
            }
        end

        DBAdmin.UI.Open('Troll', items, {
            subtitle = 'Select a victim',
            showBack = true,
            onBack   = function() DBAdmin.OpenMainMenu() end,
        })
    end)
end)

-- ============================================================================
-- TROLL ACTIONS
-- ============================================================================
function OpenTrollActions(targetId, targetName)
    local items = {
        {
            actionId = 'wild',
            title    = 'Wild Attack',
            description = 'Send wild animals after this player',
            icon     = '🐺',
            style    = 'danger',
            fn = function()
                TriggerServerEvent('dbadmin:server:trollWildAttack', { targetId = targetId })
            end,
        },
        {
            actionId = 'fire',
            title    = 'Set On Fire',
            description = 'Set this player on fire',
            icon     = '🔥',
            style    = 'danger',
            fn = function()
                TriggerServerEvent('dbadmin:server:trollSetFire', { targetId = targetId })
            end,
        },
    }

    DBAdmin.UI.Open('Troll: ' .. targetName, items, {
        subtitle = 'Server ID: ' .. targetId,
        showBack = true,
        onBack   = function() TriggerEvent('dbadmin:client:trollMenu') end,
    })
end

-- ============================================================================
-- CLIENT HANDLERS
-- ============================================================================
RegisterNetEvent('dbadmin:client:wildAttack', function()
    local ped     = cache.ped
    local coords  = GetEntityCoords(ped)
    local animals = Config.Troll.WildAttack.Animals
    local count   = Config.Troll.WildAttack.Count
    local dist    = Config.Troll.WildAttack.Distance

    for i = 1, count do
        local hash  = animals[math.random(#animals)]
        local angle = (i / count) * 360.0
        local rad   = angle * math.pi / 180.0
        local sx    = coords.x + math.cos(rad) * dist
        local sy    = coords.y + math.sin(rad) * dist

        RequestModel(hash)
        local timeout = 0
        while not HasModelLoaded(hash) and timeout < 50 do Wait(100); timeout = timeout + 1 end
        if HasModelLoaded(hash) then
            local animal = CreatePed(hash, sx, sy, coords.z, 0.0, true, true, false, false)
            TaskCombatPed(animal, ped, 0, 0)
            SetPedKeepTask(animal, true)
            Citizen.InvokeNative(0x3C70D1DB1C2D061A, animal, ped)
            SetModelAsNoLongerNeeded(hash)
            SetTimeout(60000, function()
                if DoesEntityExist(animal) then DeleteEntity(animal) end
            end)
        end
    end
end)

RegisterNetEvent('dbadmin:client:setOnFire', function()
    StartEntityFire(cache.ped)
    SetTimeout(Config.Troll.FireDuration, function()
        StopEntityFire(cache.ped)
        ClearPedBloodDamage(cache.ped)
    end)
end)