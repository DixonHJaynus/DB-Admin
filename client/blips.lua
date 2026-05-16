--[[
    DB-Admin | Client Player Blips
    Toggle blips for all players (admin-only, real-time)
    Matches rsg-adminmenu blip pattern with cleanup improvements
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

local playerBlipsEnabled = false
local playerBlips        = {}
local blipUpdateThread   = nil

-- ============================================================================
-- TOGGLE PLAYER BLIPS
-- ============================================================================
RegisterNetEvent('dbadmin:client:togglePlayerBlips', function()
    playerBlipsEnabled = not playerBlipsEnabled

    if playerBlipsEnabled then
        lib.notify({ title = 'DB-Admin', description = 'Player blips enabled.', type = 'inform' })
        TriggerServerEvent('dbadmin:server:log', 'blips_enabled')

        if not blipUpdateThread then
            blipUpdateThread = CreateThread(function()
                while playerBlipsEnabled do
                    Wait(Config.BlipUpdateInterval)

                    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
                        if not players then return end

                        -- track active ids this cycle
                        local activeIds = {}
                        for _, player in pairs(players) do
                            if player.id ~= DBAdmin.serverId and player.coords then
                                activeIds[player.id] = true

                                if not playerBlips[player.id] then
                                    -- create blip
                                    local blip = BlipAddForCoords(1664425300, player.coords.x, player.coords.y, player.coords.z)
                                    SetBlipSprite(blip, GetHashKey('blip_ambient_companion'))
                                    SetBlipScale(blip, Config.BlipScale)
                                    local steamName = GetPlayerName(GetPlayerFromServerId(player.id)) or player.name
                                    SetBlipName(blip, 'ID: ' .. player.id .. ' ' .. steamName)
                                    playerBlips[player.id] = blip
                                else
                                    -- update position
                                    SetBlipCoords(playerBlips[player.id], player.coords.x, player.coords.y, player.coords.z)
                                end
                            end
                        end

                        -- remove stale blips
                        for blipId, blip in pairs(playerBlips) do
                            if not activeIds[blipId] then
                                RemoveBlip(blip)
                                playerBlips[blipId] = nil
                            end
                        end
                    end)
                end
                blipUpdateThread = nil
            end)
        end
    else
        lib.notify({ title = 'DB-Admin', description = 'Player blips disabled.', type = 'inform' })
        TriggerServerEvent('dbadmin:server:log', 'blips_disabled')

        -- cleanup all blips
        for _, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)

-- ============================================================================
-- CLEANUP ON RESOURCE STOP
-- ============================================================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        playerBlipsEnabled = false
        for _, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)