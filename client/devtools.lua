--[[
    DB-Admin | Developer Tools Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

local doorOverlayActive = false
local entityHashActive  = false

-- ============================================================================
-- DEV TOOLS MAIN MENU
-- ============================================================================
RegisterNetEvent('dbadmin:client:devToolsMenu', function()
    OpenDevToolsMenu()
end)

function OpenDevToolsMenu()
    local items = {
        {
            actionId = 'coords', title = 'Copy Coordinates', icon = '📍',
            description = 'Vector1, Vector2, Vector3, Vector4, Heading',
            fn = function() TriggerEvent('dbadmin:client:coordsHelper') end,
        },
        {
            actionId = 'ehash',
            title = entityHashActive and 'Disable Entity Hash Viewer' or 'Enable Entity Hash Viewer',
            icon  = '🔍',
            fn    = function()
                entityHashActive = not entityHashActive
                DBAdmin.Notify({
                    title = 'DB-Admin',
                    description = entityHashActive and 'Entity Hash Viewer ENABLED' or 'Entity Hash Viewer DISABLED',
                    type = 'inform'
                })
            end,
        },
        {
            actionId = 'doors',
            title = doorOverlayActive and 'Disable Door ID Overlay' or 'Enable Door ID Overlay',
            icon  = '🚪',
            fn    = function()
                doorOverlayActive = not doorOverlayActive
                DBAdmin.Notify({
                    title = 'DB-Admin',
                    description = doorOverlayActive and 'Door ID Overlay ENABLED' or 'Door ID Overlay DISABLED',
                    type = 'inform'
                })
            end,
        },
        { actionId = 'animspawn', title = 'Animal Spawner', icon = '🐻', fn = function() OpenAnimalSpawner() end },
        { actionId = 'horse', title = 'Horse Manager', icon = '🐴', fn = function() OpenHorseManagerMenu() end },
        { actionId = 'wagon', title = 'Wagon Spawner', icon = '🛒', fn = function() OpenWagonsMenu() end },
    }

    DBAdmin.UI.Open('Developer Tools', items, {
        subtitle = 'Dev & Build Tools',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end

-- ============================================================================
-- COORDINATES HELPER
-- ============================================================================
RegisterNetEvent('dbadmin:client:coordsHelper', function()
    local coords  = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)

    local formats = {
        vector1 = string.format('vector1(%.4f)', coords.x),
        vector2 = string.format('vector2(%.4f, %.4f)', coords.x, coords.y),
        vector3 = string.format('vector3(%.4f, %.4f, %.4f)', coords.x, coords.y, coords.z),
        vector4 = string.format('vector4(%.4f, %.4f, %.4f, %.4f)', coords.x, coords.y, coords.z, heading),
        heading = string.format('%.4f', heading),
    }

    local items = {}
    for _, fmt in ipairs(Config.CoordFormats) do
        local val = formats[fmt.key]
        items[#items + 1] = {
            actionId    = 'cp_' .. fmt.key,
            title       = fmt.label,
            description = val,
            icon        = '📋',
            fn          = function()
                lib.setClipboard(val)
                DBAdmin.Notify({ title = 'DB-Admin', description = fmt.label .. ' copied!', type = 'success' })
                TriggerServerEvent('dbadmin:server:log', 'copy_coords', nil, nil, fmt.label .. ' = ' .. val)
            end,
        }
    end

    items[#items + 1] = {
        actionId = 'cp_all', title = 'Copy All Formats', icon = '📜',
        description = 'Print every format to F8 console',
        fn = function()
            print('============================================')
            print('[DB-Admin] All Coordinate Formats:')
            print('============================================')
            for _, fmt in ipairs(Config.CoordFormats) do
                print('  ' .. fmt.label .. ': ' .. formats[fmt.key])
            end
            print('============================================')
            DBAdmin.Notify({ title = 'DB-Admin', description = 'All coords printed to F8!', type = 'success' })
            TriggerServerEvent('dbadmin:server:log', 'copy_all_coords', nil, nil, formats.vector4)
        end,
    }

    DBAdmin.UI.Open('Copy Coordinates', items, {
        subtitle = 'Click to copy to clipboard',
        showBack = true,
        onBack   = function() OpenDevToolsMenu() end,
    })
end)

-- ============================================================================
-- ENTITY HASH OVERLAY
-- ============================================================================
CreateThread(function()
    while true do
        if entityHashActive then
            Wait(0)
            local hit, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if not hit then
                local camCoords = GetGameplayCamCoord()
                local camRot    = GetGameplayCamRot(0)
                local radX = camRot.x * math.pi / 180.0
                local radZ = camRot.z * math.pi / 180.0
                local num  = math.abs(math.cos(radX))
                local dir  = vector3(-math.sin(radZ) * num, math.cos(radZ) * num, math.sin(radX))
                local dest = camCoords + dir * 50.0

                local ray = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, dest.x, dest.y, dest.z, -1, cache.ped, 0)
                local _, hitBool, _, _, hitEntity = GetShapeTestResult(ray)
                if hitBool then entity = hitEntity; hit = true end
            end

            if hit and entity and DoesEntityExist(entity) then
                local eCoords = GetEntityCoords(entity)
                local model   = GetEntityModel(entity)
                local eType   = GetEntityType(entity)
                local typeStr = ({ [1] = 'Ped', [2] = 'Vehicle', [3] = 'Object' })[eType] or 'Unknown'
                local text    = string.format('Model: %s | Type: %s', model, typeStr)

                local onScreen, sx, sy = GetScreenCoordFromWorldCoord(eCoords.x, eCoords.y, eCoords.z + 1.0)
                if onScreen then
                    SetTextScale(0.35, 0.35)
                    SetTextFontForCurrentCommand(1)
                    SetTextColor(255, 255, 255, 215)
                    SetTextCentre(true)
                    SetTextDropshadow(1, 1, 1, 1, 255)
                    DisplayText(CreateVarString(10, 'LITERAL_STRING', text), sx, sy)
                end
            end
        else
            Wait(500)
        end
    end
end)

-- ============================================================================
-- DOOR OVERLAY
-- ============================================================================
CreateThread(function()
    while true do
        if doorOverlayActive then
            Wait(0)
            local myCoords = GetEntityCoords(cache.ped)
            for _, doorData in pairs(Config.DoorHashes) do
                local dCoords = vector3(doorData[4], doorData[5], doorData[6])
                if #(myCoords - dCoords) < 50.0 then
                    local text = string.format('%s | %s', doorData[3], doorData[1])
                    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(dCoords.x, dCoords.y, dCoords.z + 0.5)
                    if onScreen then
                        SetTextScale(0.30, 0.30)
                        SetTextFontForCurrentCommand(1)
                        SetTextColor(255, 200, 50, 215)
                        SetTextCentre(true)
                        SetTextDropshadow(1, 1, 1, 1, 255)
                        DisplayText(CreateVarString(10, 'LITERAL_STRING', text), sx, sy)
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

-- ============================================================================
-- ANIMAL SPAWNER
-- ============================================================================
function OpenAnimalSpawner()
    local items = {}
    for _, animal in ipairs(Config.CommonAnimals) do
        items[#items + 1] = {
            actionId = 'an_' .. tostring(animal.hash),
            title    = animal.label,
            icon     = '🐾',
            fn       = function() SpawnEntity(animal.hash, animal.label) end,
        }
    end
    items[#items + 1] = {
        actionId = 'an_custom', title = 'Custom Animal Hash', icon = '⌨️',
        fn = function()
            local input = DBAdmin.Input('Custom Animal', {
                { type = 'input', label = 'Model Name', required = true },
            })
            if input then SpawnEntity(GetHashKey(input[1]), input[1]) end
            OpenAnimalSpawner()
        end,
    }

    DBAdmin.UI.Open('Animal Spawner', items, {
        showBack = true,
        onBack   = function() OpenDevToolsMenu() end,
    })
end

-- ============================================================================
-- SPAWN HELPERS (RedM-compatible)
-- ============================================================================
function SpawnEntity(hash, label)
    if not IsModelValid(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid model!', type = 'error' })
    end

    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(50)
        timeout = timeout + 1
    end

    if not HasModelLoaded(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to load model!', type = 'error' })
    end

    local coords  = GetEntityCoords(cache.ped)
    local forward = GetEntityForwardVector(cache.ped)
    local spawn   = coords + forward * 3.0
    local heading = GetEntityHeading(cache.ped) + 180.0

    local ped = CreatePed(hash, spawn.x, spawn.y, spawn.z, heading, true, false, false, false)

    if not ped or ped == 0 then
        SetModelAsNoLongerNeeded(hash)
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to create ped!', type = 'error' })
    end

    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, 0, ped, 0, 0, 0, false, false, true, true)

    SetEntityAsMissionEntity(ped, true, true)
    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true, true)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedFleeAttributes(ped, 0, false)

    SetModelAsNoLongerNeeded(hash)

    DBAdmin.Notify({ title = 'DB-Admin', description = 'Spawned: ' .. (label or 'Entity'), type = 'success' })
    TriggerServerEvent('dbadmin:server:log', 'spawn_entity', nil, nil, label or tostring(hash))
end

-- ============================================================================
-- WAGON SPAWNER & EDITOR (merged into devtools)
-- ============================================================================

local lastWagon = nil

function OpenWagonsMenu()
    local items = {
        {
            actionId = 'wspawn', title = 'Spawn Wagon', icon = '🛒',
            description = 'Browse and spawn a wagon',
            fn = function() OpenWagonList() end,
        },
        {
            actionId = 'wedit', title = 'Edit Last Spawned',
            description = lastWagon and ('Currently: ' .. lastWagon.label) or 'Spawn one first',
            icon = '🛠️',
            fn = function()
                if lastWagon and DoesEntityExist(lastWagon.entity) then
                    OpenWagonEditor()
                else
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'No wagon spawned yet!', type = 'error' })
                    OpenWagonsMenu()
                end
            end,
        },
        {
            actionId = 'wnearest', title = 'Edit Nearest Wagon',
            description = 'Use any wagon within 20m', icon = '🎯',
            fn = function() PickNearestWagon() end,
        },
        {
            actionId = 'wdelete', title = 'Delete Last Spawned',
            description = 'Remove your spawned wagon', icon = '🗑️', style = 'danger',
            fn = function()
                if lastWagon and DoesEntityExist(lastWagon.entity) then
                    DeleteEntity(lastWagon.entity)
                    lastWagon = nil
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'Wagon deleted.', type = 'success' })
                else
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'Nothing to delete.', type = 'error' })
                end
                OpenWagonsMenu()
            end,
        },
    }

    DBAdmin.UI.Open('Wagon Spawner', items, {
        subtitle = 'Spawn and customize',
        showBack = true,
        onBack   = function() OpenDevToolsMenu() end,
    })
end

function OpenWagonList()
    local items = {}
    for i, w in ipairs(Config.Wagons or {}) do
        items[#items + 1] = {
            actionId = 'sw_' .. i,
            title    = w.label,
            description = 'Click to spawn',
            icon     = '🛒',
            fn       = function() SpawnWagon(w.model, w.label) end,
        }
    end

    if #items == 0 then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No wagons in config!', type = 'error' })
        OpenWagonsMenu()
        return
    end

    DBAdmin.UI.Open('Spawn a Wagon', items, {
        subtitle   = 'Searchable list',
        showBack   = true,
        searchable = true,
        onBack     = function() OpenWagonsMenu() end,
    })
end

function SpawnWagon(modelName, label)
    local hash = GetHashKey(modelName)
    if not IsModelValid(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid wagon: ' .. modelName, type = 'error' })
    end

    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(50); timeout = timeout + 1
    end
    if not HasModelLoaded(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to load model.', type = 'error' })
    end

    local coords  = GetEntityCoords(cache.ped)
    local forward = GetEntityForwardVector(cache.ped)
    local spawn   = coords + forward * 6.0
    local heading = GetEntityHeading(cache.ped)

    local wagon = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, heading, true, false)
    SetModelAsNoLongerNeeded(hash)

    if not wagon or wagon == 0 then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to create wagon.', type = 'error' })
    end

    SetEntityAsMissionEntity(wagon, true, true)
    SetEntityVisible(wagon, true)
    SetVehicleOnGroundProperly(wagon)

    lastWagon = {
        entity = wagon, hash = hash, label = label, components = {},
    }

    DBAdmin.Notify({ title = 'DB-Admin', description = 'Spawned: ' .. label, type = 'success' })
    TriggerServerEvent('dbadmin:server:log', 'spawn_wagon', nil, nil, label)

    Wait(500)
    OpenWagonEditor()
end

function PickNearestWagon()
    local myCoords = GetEntityCoords(cache.ped)
    local nearest, nearestDist = nil, 99999.0

    for _, v in ipairs(GetGamePool('CVehicle')) do
        if DoesEntityExist(v) then
            local d = #(myCoords - GetEntityCoords(v))
            if d < nearestDist and d < 20.0 then
                nearestDist = d
                nearest = v
            end
        end
    end

    if nearest then
        lastWagon = {
            entity = nearest, hash = GetEntityModel(nearest),
            label = 'Selected Wagon', components = {},
        }
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Selected (' .. math.floor(nearestDist) .. 'm)', type = 'success' })
        OpenWagonEditor()
    else
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No wagon nearby!', type = 'error' })
        OpenWagonsMenu()
    end
end

function OpenWagonEditor()
    if not lastWagon or not DoesEntityExist(lastWagon.entity) then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No wagon to edit!', type = 'error' })
        OpenWagonsMenu()
        return
    end

    local items = {
        {
            actionId = 'wtp', title = 'Teleport to Wagon', icon = '📍',
            fn = function()
                local c = GetEntityCoords(lastWagon.entity)
                SetEntityCoords(cache.ped, c.x + 2.0, c.y, c.z, false, false, false, false)
                OpenWagonEditor()
            end,
        },
        {
            actionId = 'wenter', title = 'Enter Driver Seat', icon = '🪑',
            fn = function()
                TaskWarpPedIntoVehicle(cache.ped, lastWagon.entity, -1)
                OpenWagonEditor()
            end,
        },
    }

    for _, comp in ipairs(Config.WagonComponents or {}) do
        local current = lastWagon.components[comp.slot]
        local currentLabel = 'None'
        if current then
            for _, opt in ipairs(comp.options) do
                if opt.model and GetHashKey(opt.model) == current.hash then
                    currentLabel = opt.label
                    break
                end
            end
        end

        items[#items + 1] = {
            actionId = 'wcmp_' .. comp.slot,
            title    = comp.label,
            description = 'Currently: ' .. currentLabel,
            icon     = '🔧',
            fn       = function() OpenWagonComponentSelector(comp) end,
        }
    end

    items[#items + 1] = {
        actionId = 'wclearall', title = 'Clear All Components', icon = '🧹', style = 'danger',
        fn = function()
            for _, c in pairs(lastWagon.components) do
                if c.entity and DoesEntityExist(c.entity) then DeleteEntity(c.entity) end
            end
            lastWagon.components = {}
            DBAdmin.Notify({ title = 'DB-Admin', description = 'Cleared all.', type = 'success' })
            OpenWagonEditor()
        end,
    }

    DBAdmin.UI.Open('Wagon Editor', items, {
        subtitle = lastWagon.label or 'Editing',
        showBack = true,
        onBack   = function() OpenWagonsMenu() end,
    })
end

function OpenWagonComponentSelector(comp)
    local items = {}
    for i, opt in ipairs(comp.options) do
        items[#items + 1] = {
            actionId = 'wopt_' .. i,
            title    = opt.label,
            description = (not opt.model) and 'Remove this component' or 'Attach this component',
            icon     = (not opt.model) and '❌' or '📦',
            fn       = function()
                AttachWagonComp(comp, opt)
                OpenWagonEditor()
            end,
        }
    end

    DBAdmin.UI.Open('Set: ' .. comp.label, items, {
        subtitle = 'Choose component',
        showBack = true,
        onBack   = function() OpenWagonEditor() end,
    })
end

function AttachWagonComp(comp, opt)
    local wagon = lastWagon.entity
    if not wagon or not DoesEntityExist(wagon) then return end

    if lastWagon.components[comp.slot] then
        local old = lastWagon.components[comp.slot].entity
        if old and DoesEntityExist(old) then DeleteEntity(old) end
        lastWagon.components[comp.slot] = nil
    end

    if not opt.model then
        DBAdmin.Notify({ title = 'DB-Admin', description = comp.label .. ' cleared.', type = 'success' })
        return
    end

    local hash = GetHashKey(opt.model)
    if not IsModelValid(hash) then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid prop: ' .. opt.model, type = 'error' })
        return
    end

    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(50); timeout = timeout + 1
    end
    if not HasModelLoaded(hash) then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to load prop!', type = 'error' })
        return
    end

    local wc = GetEntityCoords(wagon)
    local prop = CreateObject(hash, wc.x, wc.y, wc.z + 1.0, true, false, false)
    SetModelAsNoLongerNeeded(hash)

    if not prop or prop == 0 then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to create prop!', type = 'error' })
        return
    end

    local boneIndex = GetEntityBoneIndexByName(wagon, comp.bone)
    if boneIndex == -1 then boneIndex = 0 end

    AttachEntityToEntity(prop, wagon, boneIndex,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        false, false, false, false, 2, true)

    SetEntityAsMissionEntity(prop, true, true)

    lastWagon.components[comp.slot] = { entity = prop, hash = hash }
    DBAdmin.Notify({ title = 'DB-Admin', description = comp.label .. ' = ' .. opt.label, type = 'success' })
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and lastWagon then
        for _, c in pairs(lastWagon.components or {}) do
            if c.entity and DoesEntityExist(c.entity) then DeleteEntity(c.entity) end
        end
        if lastWagon.entity and DoesEntityExist(lastWagon.entity) then
            DeleteEntity(lastWagon.entity)
        end
    end
end)

-- ============================================================================
-- HORSE SPAWNER & EQUIPMENT EDITOR (MetaPed tag system)
-- ============================================================================

local lastHorse = nil
local currentEquipment = {
    saddle = 0, blanket = 0, saddlebag = 0, stirrups = 0, bedroll = 0,
    mane = 0, tail = 0, horn = 0, mask = 0, mustache = 0,
}

-- ============================================================================
-- META PED HELPERS
-- ============================================================================
local function IsPedReadyToRender(ped)
    return Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, ped)
end

local function UpdatePedVariation(ped)
    Citizen.InvokeNative(0x704C908E9C405136, ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
    local timeout = 0
    while not IsPedReadyToRender(ped) and timeout < 100 do
        Wait(10); timeout = timeout + 1
    end
end

local function ApplyHorseComponent(horse, hash)
    if not hash or hash == 0 or not horse or not DoesEntityExist(horse) then return end
    local h = hash
    if h < 0 then h = h + 4294967296 end
    Citizen.InvokeNative(0xD3A7B003ED343FD9, horse, h, true, true, true)
    Wait(100)
    UpdatePedVariation(horse)
end

local function RemoveHorseComponent(horse, hash)
    if not hash or hash == 0 or not horse or not DoesEntityExist(horse) then return end
    local h = hash
    if h < 0 then h = h + 4294967296 end
    Citizen.InvokeNative(0xD710A5007C2AC539, horse, h, 0)
    Wait(100)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, horse, 0, 1, 1, 1, 0)
    UpdatePedVariation(horse)
end

local function ResetEquipment()
    currentEquipment = {
        saddle = 0, blanket = 0, saddlebag = 0, stirrups = 0, bedroll = 0,
        mane = 0, tail = 0, horn = 0, mask = 0, mustache = 0,
    }
end

-- ============================================================================
-- HORSE MANAGER MENU
-- ============================================================================
function OpenHorseManagerMenu()
    local items = {
        {
            actionId = 'hspawn', title = 'Spawn Horse', icon = '🐴',
            description = 'Browse and spawn an admin horse',
            fn = function() OpenAdminHorseMenu() end,
        },
        {
            actionId = 'hedit', title = 'Edit Equipment',
            description = lastHorse and ('Currently: ' .. lastHorse.label) or 'Spawn a horse first',
            icon = '🛠️',
            fn = function()
                if lastHorse and DoesEntityExist(lastHorse.entity) then
                    OpenHorseEquipmentMenu()
                else
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'No horse spawned yet!', type = 'error' })
                    OpenHorseManagerMenu()
                end
            end,
        },
        {
            actionId = 'hdelete', title = 'Delete Horse',
            description = 'Remove your spawned horse',
            icon = '🗑️', style = 'danger',
            fn = function()
                if lastHorse and DoesEntityExist(lastHorse.entity) then
                    DeleteEntity(lastHorse.entity)
                    lastHorse = nil
                    ResetEquipment()
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'Horse deleted.', type = 'success' })
                else
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'Nothing to delete.', type = 'error' })
                end
                OpenHorseManagerMenu()
            end,
        },
    }

    DBAdmin.UI.Open('Horse Manager', items, {
        subtitle = 'Spawn and customize',
        showBack = true,
        onBack   = function() OpenDevToolsMenu() end,
    })
end

function OpenAdminHorseMenu()
    local items = {}
    for i, h in ipairs(Config.AdminHorse or {}) do
        items[#items + 1] = {
            actionId = 'h_' .. i,
            title    = h.horsename,
            icon     = '🐴',
            fn       = function() SpawnTrackedHorse(h.horsehash, h.horsename) end,
        }
    end

    DBAdmin.UI.Open('Spawn Admin Horse', items, {
        subtitle   = 'Searchable list',
        showBack   = true,
        searchable = true,
        onBack     = function() OpenHorseManagerMenu() end,
    })
end

-- ============================================================================
-- SPAWN HORSE
-- ============================================================================
function SpawnTrackedHorse(modelName, name)
    local hash = GetHashKey(modelName)

    if not IsModelValid(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid horse model: ' .. modelName, type = 'error' })
    end

    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(50); timeout = timeout + 1
    end
    if not HasModelLoaded(hash) then
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to load model!', type = 'error' })
    end

    -- Spawn 50m away in the direction the player is facing
    local myCoords = GetEntityCoords(cache.ped)
    local heading  = GetEntityHeading(cache.ped)
    local rad      = math.rad(heading)
    local spawnX   = myCoords.x + (-math.sin(rad) * Config.HorseSpawnDistance)
    local spawnY   = myCoords.y + (math.cos(rad) * Config.HorseSpawnDistance)
    local spawnZ   = myCoords.z

    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ + 100.0, false)
    if foundGround then spawnZ = groundZ end

    local headingToPlayer = GetHeadingFromVector_2d(myCoords.x - spawnX, myCoords.y - spawnY)

    -- Cleanup any existing horse
    if lastHorse and DoesEntityExist(lastHorse.entity) then
        DeleteEntity(lastHorse.entity)
        lastHorse = nil
        Wait(300)
    end
    ResetEquipment()

    local horse = CreatePed(hash, spawnX, spawnY, spawnZ + 1.0, headingToPlayer, true, true, false, false)

    local spawnTimeout = 0
    while not DoesEntityExist(horse) and spawnTimeout < 50 do
        Wait(100); spawnTimeout = spawnTimeout + 1
    end

    if not DoesEntityExist(horse) then
        SetModelAsNoLongerNeeded(hash)
        return DBAdmin.Notify({ title = 'DB-Admin', description = 'Failed to create horse!', type = 'error' })
    end

    Wait(1000)

    SetEntityAsMissionEntity(horse, true, true)

    -- Critical calm sequence
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, horse, 0xE1DE6018, 1)
    Wait(500)

    Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
    Wait(500)

    Citizen.InvokeNative(0x59BD177A1A48600A, horse, Config.DefaultHorseSaddle, true)
    Wait(200)

    Citizen.InvokeNative(0xAAB86462966888AE, horse, true)
    Wait(300)
    Citizen.InvokeNative(0x9587913B9E772D29, horse, 0)
    Wait(500)

    PlaceEntityOnGroundProperly(horse)
    FreezeEntityPosition(horse, false)

    SetBlockingOfNonTemporaryEvents(horse, true)
    SetPedCanBeTargetted(horse, false)
    SetEntityInvincible(horse, true)

    Citizen.InvokeNative(0x9FF1E042FA597187, horse, 1)
    Citizen.InvokeNative(0xD2CB0FB0FDCB473D, horse, true)

    currentEquipment.saddle = Config.DefaultHorseSaddle

    SetModelAsNoLongerNeeded(hash)

    lastHorse = {
        entity = horse, hash = hash, label = name,
    }

    DBAdmin.Notify({ title = 'DB-Admin', description = 'Your horse is on its way!', type = 'inform' })
    TriggerServerEvent('dbadmin:server:log', 'spawn_horse', nil, nil, name)

    -- Make horse gallop to player
    local pCoords = GetEntityCoords(cache.ped)
    TaskGoToCoordAnyMeans(horse, pCoords.x, pCoords.y, pCoords.z, 7.0, 0, false, 786603, 0xbf800000)

    -- Watch for arrival
    CreateThread(function()
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < 30000 do
            Wait(500)
            if not DoesEntityExist(horse) then return end

            local hCoords = GetEntityCoords(horse)
            local pNow    = GetEntityCoords(cache.ped)
            local dist    = #(hCoords - pNow)

            if dist <= 5.0 then
                ClearPedTasksImmediately(horse)
                TaskStandStill(horse, -1)
                local newHeading = GetHeadingFromVector_2d(pNow.x - hCoords.x, pNow.y - hCoords.y)
                SetEntityHeading(horse, newHeading)

                SetBlockingOfNonTemporaryEvents(horse, true)

                DBAdmin.Notify({ title = 'DB-Admin', description = name .. ' has arrived!', type = 'success' })
                Wait(800)
                OpenHorseEquipmentMenu()
                return
            end
        end

        if DoesEntityExist(horse) then
            ClearPedTasksImmediately(horse)
            SetBlockingOfNonTemporaryEvents(horse, true)
            DBAdmin.Notify({ title = 'DB-Admin', description = 'Horse arrived (slow path).', type = 'inform' })
            OpenHorseEquipmentMenu()
        end
    end)
end

-- ============================================================================
-- HORSE EQUIPMENT MENU
-- ============================================================================
function OpenHorseEquipmentMenu()
    if not lastHorse or not DoesEntityExist(lastHorse.entity) then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No horse to edit!', type = 'error' })
        OpenHorseManagerMenu()
        return
    end

    local items = {
        {
            actionId = 'htp', title = 'Teleport to Horse', icon = '📍',
            fn = function()
                local c = GetEntityCoords(lastHorse.entity)
                SetEntityCoords(cache.ped, c.x + 1.5, c.y, c.z, false, false, false, false)
                OpenHorseEquipmentMenu()
            end,
        },
        {
            actionId = 'hmount', title = 'Mount Horse', icon = '🤠',
            fn = function()
                Citizen.InvokeNative(0x028F76B6E78246EB, lastHorse.entity, 0, true)
                TaskMountAnimal(cache.ped, lastHorse.entity, -1, 1)
                OpenHorseEquipmentMenu()
            end,
        },
        { actionId = 'eqsaddle',    title = 'Saddle',     icon = '🪑', fn = function() OpenEquipSubMenu('saddle',    Config.Saddles)    end },
        { actionId = 'eqblanket',   title = 'Blanket',    icon = '🟫', fn = function() OpenEquipSubMenu('blanket',   Config.Blankets)   end },
        { actionId = 'eqsaddlebag', title = 'Saddlebag',  icon = '💼', fn = function() OpenEquipSubMenu('saddlebag', Config.Saddlebags) end },
        { actionId = 'eqstirrups',  title = 'Stirrups',   icon = '⚙️', fn = function() OpenEquipSubMenu('stirrups',  Config.Stirrups)   end },
        { actionId = 'eqbedroll',   title = 'Bedroll',    icon = '🛏️', fn = function() OpenEquipSubMenu('bedroll',   Config.Bedrolls)   end },
        { actionId = 'eqmane',      title = 'Mane',       icon = '💇', fn = function() OpenEquipSubMenu('mane',      Config.Manes)      end },
        { actionId = 'eqtail',      title = 'Tail',       icon = '🎀', fn = function() OpenEquipSubMenu('tail',      Config.Tails)      end },
        { actionId = 'eqhorn',      title = 'Horn',       icon = '🎺', fn = function() OpenEquipSubMenu('horn',      Config.Horns)      end },
        { actionId = 'eqmask',      title = 'Mask',       icon = '🎭', fn = function() OpenEquipSubMenu('mask',      Config.Masks)      end },
        { actionId = 'eqmustache',  title = 'Mustache',   icon = '👨', fn = function() OpenEquipSubMenu('mustache',  Config.Mustaches)  end },
        {
            actionId = 'hclearall', title = 'Remove All Equipment',
            icon = '🧹', style = 'danger',
            fn = function()
                for eqType, hash in pairs(currentEquipment) do
                    if hash ~= 0 then
                        RemoveHorseComponent(lastHorse.entity, hash)
                        currentEquipment[eqType] = 0
                    end
                end
                DBAdmin.Notify({ title = 'DB-Admin', description = 'All equipment removed.', type = 'success' })
                OpenHorseEquipmentMenu()
            end,
        },
    }

    DBAdmin.UI.Open('Horse Equipment', items, {
        subtitle = lastHorse.label or 'Editing',
        showBack = true,
        onBack   = function() OpenHorseManagerMenu() end,
    })
end

-- ============================================================================
-- EQUIPMENT SUB MENU
-- ============================================================================
function OpenEquipSubMenu(eqType, eqList)
    if not eqList then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'No options for ' .. eqType, type = 'error' })
        return OpenHorseEquipmentMenu()
    end

    local items = {}
    local currentHash = currentEquipment[eqType]

    for i, item in ipairs(eqList) do
        local isSelected = (item.hash == currentHash)
        items[#items + 1] = {
            actionId    = 'opt_' .. i,
            title       = isSelected and ('✅ ' .. item.label) or item.label,
            description = isSelected and 'Currently equipped' or 'Click to equip',
            icon        = '🐴',
            fn          = function()
                if not lastHorse or not DoesEntityExist(lastHorse.entity) then
                    DBAdmin.Notify({ title = 'DB-Admin', description = 'No horse!', type = 'error' })
                    return
                end

                if currentEquipment[eqType] ~= 0 then
                    RemoveHorseComponent(lastHorse.entity, currentEquipment[eqType])
                end

                currentEquipment[eqType] = item.hash
                if item.hash ~= 0 then
                    ApplyHorseComponent(lastHorse.entity, item.hash)
                end

                DBAdmin.Notify({ title = 'DB-Admin', description = 'Applied: ' .. item.label, type = 'success' })
                OpenHorseEquipmentMenu()
            end,
        }
    end

    DBAdmin.UI.Open('Set: ' .. eqType:gsub('^%l', string.upper), items, {
        subtitle   = 'Choose an option',
        showBack   = true,
        searchable = true,
        onBack     = function() OpenHorseEquipmentMenu() end,
    })
end

-- ============================================================================
-- CLEANUP
-- ============================================================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and lastHorse then
        if lastHorse.entity and DoesEntityExist(lastHorse.entity) then
            DeleteEntity(lastHorse.entity)
        end
    end
end)