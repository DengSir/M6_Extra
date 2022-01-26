-- Rewire.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 11/12/2021, 12:21:39 AM
--
---@type ns
local ns = select(2, ...)

local RW = ns.ActionBook:compatible('Rewire', 1, 21)

RW:SetMetaHintFilter('countall', 'replaceCount', true, function(_meta, value, _target)
    if value == 'none' then
        return false, 0
    end

    local items = ns.splititems(value)
    if #items == 0 then
        return false, 0
    end

    local count = 0
    for _, item in ipairs(items) do
        count = count + GetItemCount(item)
    end
    return true, count
end)

-- local function GetCooldown(item)
--     if GetItemCount(item) > 0 then
--         return GetItemCooldown(item)
--     else
--         return GetSpellCooldown(item)
--     end
-- end

-- local function GetIcon(item)
--     if GetItemCount(item) > 0 then
--         return GetItemIcon(item)
--     else
--         return (select(3, GetSpellInfo(item)))
--     end
-- end

-- RW:SetMetaHintFilter('iconready', 'replaceIcon', true, function(_meta, value, _target, ...)
--     if value == 'none' then
--         return false, 0
--     end

--     local items = ns.splititems(value)
--     if #items == 0 then
--         return false, 0
--     end

--     local now = GetTime()
--     local bestLeft
--     local bestItem
--     local start, duration, left, enable

--     for _, item in ipairs(items) do
--         start, duration, enable = GetCooldown(item)

--         if enable then
--             if start == 0 then
--                 return true, GetIcon(item)
--             else
--                 left = start + duration - now
--                 if not bestLeft or left < bestLeft then
--                     bestLeft = left
--                     bestItem = item
--                 end
--             end
--         end
--     end

--     if bestLeft then
--         return true, GetIcon(bestItem)
--     end
--     return false, 0, 0
-- end)

-- RW:SetMetaHintFilter('cooldownready', 'replaceCooldown', true, function(_meta, value,_target)
--     if value == 'none' then
--         return false, 0
--     end

--     local items = ns.splititems(value)
--     if #items == 0 then
--         return false, 0
--     end

--     local now = GetTime()
--     local bestLeft
--     local bestDuration
--     local start, duration, left, enable

--     for _, item in ipairs(items) do
--         start, duration, enable = GetCooldown(item)

--         if enable then
--             if start == 0 then
--                 return true, 0, 0
--             else
--                 left = start + duration - now
--                 if not bestLeft or left < bestLeft then
--                     bestLeft = left
--                     bestDuration = duration
--                 end
--             end
--         end
--     end

--     if bestLeft then
--         return true, bestLeft, bestDuration
--     end
--     return false, 0, 0
-- end)
