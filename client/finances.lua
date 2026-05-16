--[[
    DB-Admin | Finances Menu (NUI version)
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================================
-- FINANCES MAIN (player list)
-- ============================================================================
RegisterNetEvent('dbadmin:client:financesMenu', function()
    RSGCore.Functions.TriggerCallback('dbadmin:server:getPlayers', function(players)
        if not players or #players == 0 then
            return DBAdmin.Notify({ title = 'DB-Admin', description = 'No players online!', type = 'error' })
        end

        local items = {}
        for _, v in pairs(players) do
            items[#items + 1] = {
                actionId    = 'f_' .. v.id,
                title       = '[' .. v.id .. '] ' .. v.name,
                description = 'Character: ' .. (v.charname or 'N/A'),
                icon        = '💰',
                fn          = function()
                    OpenFinanceActions(v.id, v.name)
                end,
            }
        end

        DBAdmin.UI.Open('Finances', items, {
            subtitle = 'Select a player',
            showBack = true,
            onBack   = function() DBAdmin.OpenMainMenu() end,
        })
    end)
end)

-- ============================================================================
-- PER-PLAYER FINANCE ACTIONS
-- ============================================================================
function OpenFinanceActions(targetId, targetName)
    local items = {
        {
            actionId = 'addcash', title = 'Add Cash', icon = '💵',
            description = 'Increase player cash on-hand', style = 'success',
            fn = function() OpenFinanceDialog(targetId, targetName, 'add', 'cash') end,
        },
        {
            actionId = 'remcash', title = 'Remove Cash', icon = '💵',
            description = 'Decrease player cash on-hand', style = 'danger',
            fn = function() OpenFinanceDialog(targetId, targetName, 'remove', 'cash') end,
        },
        {
            actionId = 'addbank', title = 'Add Bank', icon = '🏦',
            description = 'Increase player bank balance', style = 'success',
            fn = function() OpenFinanceDialog(targetId, targetName, 'add', 'bank') end,
        },
        {
            actionId = 'rembank', title = 'Remove Bank', icon = '🏦',
            description = 'Decrease player bank balance', style = 'danger',
            fn = function() OpenFinanceDialog(targetId, targetName, 'remove', 'bank') end,
        },
    }

    DBAdmin.UI.Open(targetName, items, {
        subtitle = 'Finance Actions',
        showBack = true,
        onBack   = function() TriggerEvent('dbadmin:client:financesMenu') end,
    })
end

-- ============================================================================
-- FINANCE DIALOG
-- ============================================================================
function OpenFinanceDialog(targetId, targetName, action, moneyType)
    local actionLabel = action == 'add' and 'Add' or 'Remove'
    local typeLabel   = moneyType == 'cash' and 'Cash' or 'Bank'

    local input = DBAdmin.Input(actionLabel .. ' ' .. typeLabel .. ' - ' .. targetName, {
        { type = 'number', label = 'Amount', required = true, min = 1 },
    })
    if not input then
        OpenFinanceActions(targetId, targetName)
        return
    end

    local amount = tonumber(input[1])
    if not amount or amount < 1 then
        DBAdmin.Notify({ title = 'DB-Admin', description = 'Invalid amount!', type = 'error' })
        OpenFinanceActions(targetId, targetName)
        return
    end

    TriggerServerEvent('dbadmin:server:manageMoney', targetId, action, moneyType, amount)
    OpenFinanceActions(targetId, targetName)
end