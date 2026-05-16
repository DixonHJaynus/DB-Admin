--[[
    DB-Admin | Server Controls Menu (NUI version - uses weathersync exports)
]]

-- ============================================================================
-- SERVER CONTROLS MAIN MENU
-- ============================================================================
RegisterNetEvent('dbadmin:client:serverControlsMenu', function()
    local items = {
        {
            actionId    = 'weather',
            title       = 'Weather Control',
            description = 'Change server weather using presets',
            icon        = '🌦️',
            fn          = function() OpenWeatherMenu() end,
        },
        {
            actionId    = 'time',
            title       = 'Set Time',
            description = 'Change the server time',
            icon        = '🕐',
            fn          = function() OpenTimeMenu() end,
        },
    }

    DBAdmin.UI.Open('Server Controls', items, {
        subtitle = 'Server-Wide Settings',
        showBack = true,
        onBack   = function() DBAdmin.OpenMainMenu() end,
    })
end)

-- ============================================================================
-- WEATHER MENU
-- ============================================================================
function OpenWeatherMenu()
    local items = {}

    for _, preset in ipairs(Config.WeatherPresets) do
        items[#items + 1] = {
            actionId    = 'w_' .. preset.value,
            title       = preset.label,
            description = preset.snow and 'Snow coverage enabled' or '',
            icon        = preset.icon or '🌦️',
            fn          = function()
                TriggerServerEvent('dbadmin:server:setWeather', {
                    weather    = preset.value,
                    label      = preset.label,
                    snow       = preset.snow,
                    transition = Config.WeatherTransition,
                })
                Wait(200)
                OpenWeatherMenu()
            end,
            stayOpen = true,
        }
    end

    DBAdmin.UI.Open('Weather Presets', items, {
        subtitle   = 'Click to change weather',
        showBack   = true,
        searchable = true,
        onBack     = function() TriggerEvent('dbadmin:client:serverControlsMenu') end,
    })
end

-- ============================================================================
-- TIME MENU
-- ============================================================================
function OpenTimeMenu()
    local timePresets = {
        { label = 'Sunrise (06:00)',     hour = 6,  minute = 0,  icon = '🌅' },
        { label = 'Morning (09:00)',     hour = 9,  minute = 0,  icon = '☀️' },
        { label = 'Noon (12:00)',        hour = 12, minute = 0,  icon = '🌞' },
        { label = 'Afternoon (15:00)',   hour = 15, minute = 0,  icon = '☀️' },
        { label = 'Sunset (18:00)',      hour = 18, minute = 0,  icon = '🌇' },
        { label = 'Evening (20:00)',     hour = 20, minute = 0,  icon = '🌆' },
        { label = 'Night (22:00)',       hour = 22, minute = 0,  icon = '🌙' },
        { label = 'Midnight (00:00)',    hour = 0,  minute = 0,  icon = '🌌' },
        { label = 'Late Night (03:00)',  hour = 3,  minute = 0,  icon = '🌃' },
    }

    local items = {}

    for _, p in ipairs(timePresets) do
        items[#items + 1] = {
            actionId = 't_' .. p.hour,
            title    = p.label,
            icon     = p.icon,
            fn       = function()
                TriggerServerEvent('dbadmin:server:setTime', {
                    hour   = p.hour,
                    minute = p.minute,
                    label  = p.label,
                })
                Wait(200)
                OpenTimeMenu()
            end,
            stayOpen = true,
        }
    end

    items[#items + 1] = {
        actionId    = 't_custom',
        title       = 'Custom Time',
        description = 'Enter a specific hour and minute',
        icon        = '⌨️',
        fn          = function() OpenCustomTimeForm() end,
    }

    DBAdmin.UI.Open('Set Time', items, {
        subtitle = 'Choose a preset or custom',
        showBack = true,
        onBack   = function() TriggerEvent('dbadmin:client:serverControlsMenu') end,
    })
end

-- ============================================================================
-- CUSTOM TIME FORM
-- ============================================================================
function OpenCustomTimeForm()
    DBAdmin.UI.OpenForm('Set Custom Time', {
        id          = 'customtime',
        submitLabel = 'Apply Time',
        fields = {
            { key = 'hour',   type = 'number', label = 'Hour (0-23)',   default = 12, min = 0, max = 23 },
            { key = 'minute', type = 'number', label = 'Minute (0-59)', default = 0,  min = 0, max = 59 },
        },
    }, {
        subtitle = 'Custom Time',
        showBack = true,
        onBack   = function() OpenTimeMenu() end,
        onSubmit = function(values)
            local hour   = tonumber(values.hour)
            local minute = tonumber(values.minute)

            if not hour or not minute or hour < 0 or hour > 23 or minute < 0 or minute > 59 then
                DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid time!', type = 'error' })
                OpenCustomTimeForm()
                return
            end

            TriggerServerEvent('dbadmin:server:setTime', {
                hour   = hour,
                minute = minute,
                label  = string.format('%02d:%02d', hour, minute),
            })
            OpenTimeMenu()
        end,
        onCancel = function()
            OpenTimeMenu()
        end,
    })
end

-- ============================================================================
-- CLIENT HANDLERS - apply weather/time via weathersync exports
-- ============================================================================
RegisterNetEvent('dbadmin:client:applyWeather', function(weather, transition, snow)
    exports['weathersync']:setMyWeather(weather, transition, snow)
end)

RegisterNetEvent('dbadmin:client:applyTime', function(hour, minute)
    exports['weathersync']:setMyTime(hour, minute, 0, 30000)
end)