-- API.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 11/12/2021, 12:24:49 AM
--
---@type ns
local ns = select(2, ...)

function ns.memorize(func)
    local cache = {}
    return function(k, ...)
        if not k then
            return
        end
        if cache[k] == nil then
            cache[k] = func(k, ...)
        end
        return cache[k]
    end
end

ns.splititems = ns.memorize(function(val)
    local items = {strsplit(',', val)}
    for i, v in ipairs(items) do
        items[i] = v:trim()
    end
    return items
end)
