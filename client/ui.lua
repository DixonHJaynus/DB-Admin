--[[
    DB-Admin | NUI Adapter (with searchable menus + custom forms)
]]

DBAdmin = DBAdmin or {}
DBAdmin.UI = DBAdmin.UI or {}
DBAdmin.UI._visible    = false
DBAdmin.UI.actions     = {}
DBAdmin.UI._onBack     = nil
DBAdmin.UI._formCb     = nil
DBAdmin.UI._formCancel = nil

-- ============================================================================
-- OPEN MENU
-- ============================================================================
function DBAdmin.UI.Open(title, items, opts)
    opts = opts or {}

    DBAdmin.UI.actions = {}
    DBAdmin.UI._onBack = opts.onBack
    DBAdmin.UI._formCb = nil
    DBAdmin.UI._formCancel = nil

    local nuiItems = {}
    for _, it in ipairs(items or {}) do
        if it.actionId and it.fn then
            DBAdmin.UI.actions[it.actionId] = {
                fn       = it.fn,
                stayOpen = it.stayOpen == true,
            }
        end
        nuiItems[#nuiItems + 1] = {
            id          = it.actionId,
            title       = it.title,
            description = it.description,
            icon        = it.icon,
            style       = it.style,
        }
    end

    SendNUIMessage({
        action     = 'openMenu',
        title      = title or 'DB-ADMIN',
        subtitle   = opts.subtitle or 'Administrator Console',
        showBack   = opts.showBack == true,
        hint       = opts.hint or 'ESC to close',
        searchable = opts.searchable == true,
        items      = nuiItems,
    })

    DBAdmin.UI._visible = true
    SetNuiFocus(true, true)
end

-- ============================================================================
-- OPEN FORM
-- form = {
--   id, submitLabel,
--   fields = {
--     { key='foo', type='input/number/select/textarea', label='', default=, options={{value=,label=}}, placeholder=, min=, max= },
--   }
-- }
-- ============================================================================
function DBAdmin.UI.OpenForm(title, form, opts)
    opts = opts or {}

    DBAdmin.UI.actions = {}
    DBAdmin.UI._onBack = opts.onBack
    DBAdmin.UI._formCb = opts.onSubmit
    DBAdmin.UI._formCancel = opts.onCancel

    SendNUIMessage({
        action   = 'openForm',
        title    = title or 'DB-ADMIN',
        subtitle = opts.subtitle or '',
        showBack = opts.showBack == true,
        hint     = opts.hint or 'ESC to cancel',
        form     = form,
    })

    DBAdmin.UI._visible = true
    SetNuiFocus(true, true)
end

-- ============================================================================
-- CLOSE
-- ============================================================================
function DBAdmin.UI.Close()
    DBAdmin.UI._visible = false
    SendNUIMessage({ action = 'closeMenu' })
    SetNuiFocus(false, false)
end

-- ============================================================================
-- NUI CALLBACKS
-- ============================================================================
RegisterNUICallback('selectItem', function(data, cb)
    cb({ ok = true })
    local actionId = data and data.id
    if not actionId then return end
    local action = DBAdmin.UI.actions[actionId]
    if not action then return end

    if not action.stayOpen then
        DBAdmin.UI.Close()
    end

    SetTimeout(0, function()
        if action.fn then
            local ok, err = pcall(action.fn)
            if not ok then print('[DB-Admin] action error: ' .. tostring(err)) end
        end
    end)
end)

RegisterNUICallback('back', function(_, cb)
    cb({ ok = true })
    local back = DBAdmin.UI._onBack
    DBAdmin.UI.Close()
    if back then
        SetTimeout(0, function()
            local ok, err = pcall(back)
            if not ok then print('[DB-Admin] back error: ' .. tostring(err)) end
        end)
    end
end)

RegisterNUICallback('close', function(_, cb)
    cb({ ok = true })
    DBAdmin.UI.Close()
end)

RegisterNUICallback('formSubmit', function(data, cb)
    cb({ ok = true })
    local fn = DBAdmin.UI._formCb
    DBAdmin.UI.Close()
    if fn then
        SetTimeout(0, function()
            local ok, err = pcall(fn, data and data.values or {})
            if not ok then print('[DB-Admin] form submit error: ' .. tostring(err)) end
        end)
    end
end)

RegisterNUICallback('formCancel', function(_, cb)
    cb({ ok = true })
    local fn = DBAdmin.UI._formCancel
    DBAdmin.UI.Close()
    if fn then
        SetTimeout(0, function()
            local ok, err = pcall(fn)
            if not ok then print('[DB-Admin] form cancel error: ' .. tostring(err)) end
        end)
    end
end)

-- ============================================================================
-- ox_lib helpers (for things still using ox_lib)
-- ============================================================================
function DBAdmin.Input(title, fields)
    if DBAdmin.UI._visible then SetNuiFocus(false, false) end
    local result = lib.inputDialog(title, fields)
    if DBAdmin.UI._visible then SetNuiFocus(true, true) end
    return result
end

function DBAdmin.Alert(opts)
    if DBAdmin.UI._visible then SetNuiFocus(false, false) end
    local result = lib.alertDialog(opts)
    if DBAdmin.UI._visible then SetNuiFocus(true, true) end
    return result
end

function DBAdmin.Notify(opts)
    lib.notify(opts)
end