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
    local unit = 'player'
    local sb = {}
    for i = 1, GetNumTalentTabs(unit) do
        for j = 1, GetNumTalents(i, unit) do
            local name, _, _, _, n = GetTalentInfo(i, j, unit)
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
