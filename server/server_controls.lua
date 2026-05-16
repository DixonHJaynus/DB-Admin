--[[
    DB-Admin | Server Controls (server-side)
    Routes weather/time changes through weathersync exports
]]

-- ============================================================================
-- SET WEATHER (broadcast to all clients)
-- ============================================================================
RegisterNetEvent('dbadmin:server:setWeather', function(data)
    local src = source
    if not HasPermission(src, 'admin') then return end

    local weather    = data.weather
    local label      = data.label
    local snow       = data.snow or false
    local transition = data.transition or 15.0

    -- broadcast to weathersync (preferred path for global sync)
    TriggerEvent('weathersync:setWeather', weather, transition, false, snow)

    -- fallback: trigger all clients to apply via export
    TriggerClientEvent('dbadmin:client:applyWeather', -1, weather, transition, snow)

    TriggerClientEvent('ox_lib:notify', src, {
        title       = 'DB-Admin',
        description = 'Weather: ' .. label,
        type        = 'success',
    })

    DBAdmin.Log(src, 'set_weather', nil, nil, weather)
    print('[DB-Admin] ' .. GetPlayerName(src) .. ' changed weather to ' .. weather)
end)

-- ============================================================================
-- SET TIME (broadcast to all clients)
-- ============================================================================
RegisterNetEvent('dbadmin:server:setTime', function(data)
    local src = source
    if not HasPermission(src, 'admin') then return end

    local hour   = data.hour
    local minute = data.minute
    local label  = data.label

    -- broadcast to weathersync (preferred path for global sync)
    TriggerEvent('weathersync:setTime', 0, hour, minute, 0, 30000, false)

    -- fallback: trigger all clients to apply via export
    TriggerClientEvent('dbadmin:client:applyTime', -1, hour, minute)

    TriggerClientEvent('ox_lib:notify', src, {
        title       = 'DB-Admin',
        description = 'Time: ' .. label,
        type        = 'success',
    })

    DBAdmin.Log(src, 'set_time', nil, nil, label)
    print('[DB-Admin] ' .. GetPlayerName(src) .. ' changed time to ' .. label)
end)