hg = hg or {}
hg.settings = hg.settings or {}
hg.settings.tbl = hg.settings.tbl or {}

CreateClientConVar("hg_binds_enable", "1", true, false, "Toggle weapon keybinds display on pickup/equip")
CreateClientConVar("hg_binds_display_time", "5", true, false, "Time in seconds to display keybinds panel")
CreateClientConVar("hg_binds_min_width", "300", true, false, "Minimum width of keybinds UI")

hg.settings:AddOpt("Controls", "hg_binds_enable", "Enable Keybinds UI")
hg.settings:AddOpt("Controls", "hg_binds_display_time", "Keybinds Display Duration", true, nil, "int")
hg.settings:AddOpt("Controls", "hg_binds_min_width", "Keybinds Panel Width", true, nil, "int")

hg.WeaponKeybinds = hg.WeaponKeybinds or {}
local WK = hg.WeaponKeybinds

local panelYMul = 0.68
local panelPadding = 14
local rowGap = 8
local titleGap = 10
local keyBoxPaddingX = 12
local keyBoxPaddingY = 6
local keyActionGap = 12
local outlineThickness = 1
local screenRightPadding = 14
local fadeSpeed = 12

local panelBg = Color(0, 0, 0, 220)
local panelOutline = Color(255, 255, 255, 255)
local textColor = Color(255, 255, 255, 255)
local faintTextColor = Color(255, 255, 255, 220)

local function GetUIFont()
    local cvar = GetConVar("hg_font")
    if cvar and cvar:GetString() ~= "" then
        return cvar:GetString()
    end
    return "Bahnschrift"
end

surface.CreateFont("HGWeaponKeybindsTitle", {
    font = GetUIFont(),
    size = ScreenScale(9),
    weight = 700,
    antialias = true
})

surface.CreateFont("HGWeaponKeybindsText", {
    font = GetUIFont(),
    size = ScreenScale(7),
    weight = 500,
    antialias = true
})

surface.CreateFont("HGWeaponKeybindsKey", {
    font = GetUIFont(),
    size = ScreenScale(7),
    weight = 700,
    antialias = true
})

local tokenBindingMap = {
    ["R"] = "+reload", ["RELOAD"] = "+reload",
    ["LMB"] = "+attack", ["RMB"] = "+attack2", ["MMB"] = "mouse3",
    ["E"] = "+use", ["USE"] = "+use",
    ["SHIFT"] = "+speed", ["SPEED"] = "+speed",
    ["ALT"] = "+walk", ["WALK"] = "+walk",
    ["SPACE"] = "+jump", ["JUMP"] = "+jump"
}

local prettyBindingMap = {
    ["MOUSE1"] = "LMB", ["MOUSE2"] = "RMB", ["MOUSE3"] = "MMB",
    ["ENTER"] = "LMB", ["MWHEELUP"] = "MWHEELUP", ["MWHEELDOWN"] = "MWHEELDOWN"
}

local derivedActionsByClass = {
    ["weapon_ducttape"] = { {"LMB", "Tape objects"} },
    ["weapon_matches"] = { {"LMB", "Ignite match"} },
    ["weapon_walkie_talkie"] = { {"LMB", "Radio menu"}, {"R", "Toggle radio"} },
    ["weapon_bloodbag"] = { {"LMB", "Use on self"}, {"RMB", "Use on target"}, {"R", "Change mode"} }
}

local derivedActionsByBase = {
    ["weapon_bandage_sh"] = { {"LMB", "Use on self"}, {"RMB", "Use on target"}, {"R", "Change mode"} },
    ["weapon_hg_medicine_base"] = { {"LMB", "Use on self"} },
    ["weapon_bigconsumable"] = { {"LMB", "Consume"} }
}

local function formatBindingToken(token)
    token = string.Trim(string.upper(token or ""))
    if token == "" then return "" end
    token = string.Replace(token, "+", "")
    token = string.Replace(token, "\"", "")
    token = string.Replace(token, "'", "")
    token = string.Replace(token, "_", " ")
    return prettyBindingMap[token] or token
end

local function resolveBindingToken(token)
    token = formatBindingToken(token)
    local bindKey = tokenBindingMap[token]
    if bindKey then
        local bound = input.LookupBinding(bindKey)
        if bound and bound ~= "" then
            return formatBindingToken(bound)
        end
    end
    return token
end

local function normalizeCombo(combo)
    local tokens = {}
    for token in string.gmatch(combo or "", "[^%+]+") do
        local resolved = resolveBindingToken(token)
        if resolved ~= "" then
            tokens[#tokens + 1] = resolved
        end
    end
    return table.concat(tokens, " + ")
end

local function upsertBind(rows, seen, combo, action)
    combo = normalizeCombo(combo)
    action = string.Trim(action or "")
    if combo == "" or action == "" then return end

    if seen[combo] then
        local row = rows[seen[combo]]
        if not string.find(row.action, action, 1, true) then
            row.action = row.action .. " / " .. action
        end
        return
    end

    rows[#rows + 1] = { combo = combo, action = action }
    seen[combo] = #rows
end

local function collectWeaponBinds(wep)
    local rows, seen = {}, {}

    if wep.ismelee or wep.ismelee2 or wep.Base == "weapon_melee" then
        upsertBind(rows, seen, "LMB", "Attack")
        upsertBind(rows, seen, "RMB", "Block")
    elseif wep.ishgweapon or wep.Base == "homigrad_base" then
        upsertBind(rows, seen, "LMB", "Fire")
        upsertBind(rows, seen, "RMB", "Aim")
        upsertBind(rows, seen, "R", "Reload")
        upsertBind(rows, seen, "ALT + R", "Check ammo")
        upsertBind(rows, seen, "E + LMB", "Buttstroke")
    end

    local classActions = derivedActionsByClass[wep:GetClass()]
    if classActions then
        for _, entry in ipairs(classActions) do upsertBind(rows, seen, entry[1], entry[2]) end
    end

    local baseActions = derivedActionsByBase[wep.Base]
    if baseActions then
        for _, entry in ipairs(baseActions) do upsertBind(rows, seen, entry[1], entry[2]) end
    end

    return rows
end

local function setDisplayWeapon(wep)
    local displayTime = GetConVar("hg_binds_display_time"):GetFloat()
    if IsValid(wep) then
        WK.rows = collectWeaponBinds(wep)
        WK.title = wep.GetPrintName and wep:GetPrintName() or wep:GetClass()
        WK.showUntil = CurTime() + displayTime
    else
        WK.rows = nil
        WK.title = nil
        WK.showUntil = 0
    end
end

local function drawPanel(alpha)
    local rows = WK.rows
    if not rows or #rows < 1 then return end

    local minWidth = GetConVar("hg_binds_min_width"):GetInt()
    local title = WK.title or "Weapon Keybinds"
    
    surface.SetFont("HGWeaponKeybindsTitle")
    local titleW, titleH = surface.GetTextSize(title)
    local width = math.max(minWidth, titleW + panelPadding * 2)
    local rowHeight = 0

    for index, row in ipairs(rows) do
        surface.SetFont("HGWeaponKeybindsKey")
        local comboW, comboH = surface.GetTextSize(row.combo)
        surface.SetFont("HGWeaponKeybindsText")
        local actionW, actionH = surface.GetTextSize(row.action)
        
        local boxH = comboH + keyBoxPaddingY * 2
        rowHeight = math.max(rowHeight, math.max(boxH, actionH))
        width = math.max(width, panelPadding * 2 + actionW + keyActionGap + comboW + keyBoxPaddingX * 2)
    end

    local height = panelPadding * 2 + titleH + titleGap + (#rows * rowHeight) + ((#rows - 1) * rowGap)
    local x = ScrW() - width - screenRightPadding
    local y = ScrH() * panelYMul - height * 0.5

    draw.SimpleText(title, "HGWeaponKeybindsTitle", x + width - panelPadding, y + panelPadding, Color(textColor.r, textColor.g, textColor.b, textColor.a * alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    local rowY = y + panelPadding + titleH + titleGap
    for _, row in ipairs(rows) do
        surface.SetFont("HGWeaponKeybindsKey")
        local comboW, comboH = surface.GetTextSize(row.combo)
        local boxW = comboW + keyBoxPaddingX * 2
        local boxH = comboH + keyBoxPaddingY * 2
        
        local boxX = x + width - panelPadding - boxW
        local boxY = rowY + (rowHeight - boxH) * 0.5

        draw.SimpleText(row.action, "HGWeaponKeybindsText", x + panelPadding, rowY + (rowHeight - comboH) * 0.5, Color(faintTextColor.r, faintTextColor.g, faintTextColor.b, faintTextColor.a * alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        surface.SetDrawColor(panelBg.r, panelBg.g, panelBg.b, panelBg.a * alpha)
        surface.DrawRect(boxX, boxY, boxW, boxH)
        surface.SetDrawColor(panelOutline.r, panelOutline.g, panelOutline.b, panelOutline.a * alpha)
        surface.DrawOutlinedRect(boxX, boxY, boxW, boxH, outlineThickness)
        
        draw.SimpleText(row.combo, "HGWeaponKeybindsKey", boxX + boxW * 0.5, boxY + boxH * 0.5, Color(textColor.r, textColor.g, textColor.b, textColor.a * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        rowY = rowY + rowHeight + rowGap
    end
end

hook.Add("HUDPaint", "HGWeaponKeybinds_Draw", function()
    if not GetConVar("hg_binds_enable"):GetBool() then return end

    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then
        WK.activeWeapon = nil
        WK.showUntil = 0
        WK.alpha = Lerp(FrameTime() * fadeSpeed, WK.alpha or 0, 0)
        return
    end

    local wep = ply:GetActiveWeapon()
    if wep ~= WK.activeWeapon then
        WK.activeWeapon = wep
        setDisplayWeapon(wep)
    end

    local shouldShow = WK.rows and #WK.rows > 0 and (WK.showUntil or 0) > CurTime()
    WK.alpha = Lerp(FrameTime() * fadeSpeed, WK.alpha or 0, shouldShow and 1 or 0)

    if (WK.alpha or 0) > 0.01 then
        drawPanel(WK.alpha)
    end
end)