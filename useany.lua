-- useany.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 2022/5/13 17:50:46
--
---@type ns
local ns = select(2, ...)

local RW = ns.ActionBook:compatible('Rewire', 1, 21)

local core, cenv = CreateFrame('Frame', nil, nil, 'SecureHandlerBaseTemplate')

core:SetAttribute('RunSlashCmd', [[
    local slash, clause, target = ...
    if slash == '/useany' and clause ~= '' then
        st, ni = newtable(), 1
        for e in clause:gmatch("[^,]+") do
            st[ni], ni = '/use ' .. e:match("^%s*(.-)%s*$") .. '\n', ni + 1
        end
        local m = table.concat(st)
        return m
    end
]])

RW:RegisterCommand("/useany", true, true, core)
