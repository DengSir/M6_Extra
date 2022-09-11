-- Conditions.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 11/5/2021, 12:51:05 AM
--
---@type ns
local ns = select(2, ...)

local KR = assert(ns.ActionBook:compatible('Kindred', 1, 12), 'A compatible version of Kindred is required')
local EV = ns.Evie

local function onTalentUpdate()
    local inspect = false
    local pet = false
    local group = GetActiveTalentGroup()
    local sb = {}
    for i = 1, GetNumTalentTabs(inspect) do
        for j = 1, GetNumTalents(i, inspect) do
            local name, _, _, _, n = GetTalentInfo(i, j, inspect, pet, group)
            if n > 0 then
                tinsert(sb, name)
                for k = 1, n do
                    tinsert(sb, name .. '.' .. k)
                end
            end
        end
    end
    local t = #sb > 0 and table.concat(sb, '/')
    KR:SetStateConditionalValue('talent', t or false)
end

onTalentUpdate()
EV.PLAYER_TALENT_UPDATE = onTalentUpdate
EV.PLAYER_ENTERING_WORLD = onTalentUpdate
EV.CHARACTER_POINTS_CHANGED = onTalentUpdate
EV.ACTIVE_TALENT_GROUP_CHANGED = onTalentUpdate

local function onTrinketUpdate()
    local sb = {}
    for slot = 13, 14 do
        local itemId = GetInventoryItemID('player', slot)
        local name = itemId and GetItemInfo(itemId)
        if name then
            tinsert(sb, name)
        end
    end

    local t = #sb > 0 and table.concat(sb, '/')
    KR:SetStateConditionalValue('trinket', t or false)
end

local function onEquipmentChanged(_, slot)
    if not (slot == 13 or slot == 14) then
        return
    end
    onTrinketUpdate()
end

onTrinketUpdate()
EV.PLAYER_ENTERING_WORLD = onTrinketUpdate
EV.PLAYER_EQUIPMENT_CHANGED = onEquipmentChanged


local stringArgCache = {} do
	local empty = {}
	setmetatable(stringArgCache, {__index=function(t,k)
		if k then
			local at
			for s in k:gmatch("[^/]+") do
				s = s:match("^%s*(.-)%s*$")
				if #s > 0 then
					at = at or {}
					at[#at + 1] = s
				end
			end
			at = at or empty
			t[k] = at
			return at
		end
		return empty
	end})
end

KR:SetNonSecureConditional('enough', function(_, args)
    if not args or args == '' then
        return false
    end

    local usable, noMana = IsUsableSpell(args)
    return usable and not noMana
end)

KR:SetNonSecureConditional('name', function(_, args, unit)
    if not args or args == '' then
        return false
    end

    unit = unit or 'target'

    return UnitExists(unit) and UnitName(unit) == args
end)

local function HaveCompanion(t, n)
    local id = tonumber(n)
    for i = 1, GetNumCompanions(t) do
        local cId, name, spellId, icon, summoned, mountType = GetCompanionInfo(t, i)
        if name == n then
            return true
        end
        if id and id == spellId then
            return true
        end
    end
    return false
end

KR:SetNonSecureConditional('have', function(_, args)
    if not args or args == "" then
        return false
    end

    local at = stringArgCache[args]
    for i=1,#at do
        if (GetItemCount(at[i]) or 0) > 0 then
            return true
        end
        if HaveCompanion('MOUNT', at[i]) or HaveCompanion('CRITTER', at[i]) then
            return true
        end
    end
    return false
end)

if true then
    return
end

local core = KR:seclib()

local runner = CreateFrame('Frame', nil, nil, 'SecureHandlerBaseTemplate')
runner:SetFrameRef('tempRef', core)
runner:Execute([===[
    core = self:GetFrameRef('tempRef')
    sandbox = core:GetFrameRef('sandbox')
    sandbox:SetFrameRef('core', core)

    sandbox:Run([[
        core = self:GetFrameRef('core')
        print(core)
    ]])

    ReplaceCondition = [[
        print(...)
        local name, pattern, code = ...
        cndState[name] = cndState[name]:gsub(pattern, code)
    ]]
]===])

local function UpdateCompaion(t, out)
    for i = 1, GetNumCompanions(t) do
        local cId, name, spellId, icon, summoned, mountType = GetCompanionInfo(t, i)
        if cId then
            tinsert(out, spellId)
        end
    end
end

local function onCompaionUpdate(...)
    print(...)
    local ids = {}
    UpdateCompaion('MOUNT', ids)
    UpdateCompaion('CRITTER', ids)

    local t = #ids > 0 and table.concat(ids, '/')
    print(t)
    KR:SetStateConditionalValue('_known', t or false)
end

onCompaionUpdate()
EV.COMPANION_UPDATE = onCompaionUpdate

local function ConditionReplace(name, pattern, code)
    runner:SetAttribute('name', name)
    runner:SetAttribute('pattern', pattern)
    runner:SetAttribute('code', code)
    runner:Execute([[core:Run(ReplaceCondition, self:GetAttribute('name'), self:GetAttribute('pattern'), self:GetAttribute('code'))]])
end

ConditionReplace('known', 'return true', [[
    return true end

    print(...)

    if cndState._known[id] then
        print(#cndState._known)
        return true
]])

core:Execute([[
    print(cndState.known)
]])
