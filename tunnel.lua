os.loadAPI('move.lua')
os.loadAPI('inv.lua')
os.loadAPI('net.lua')

local x = 0
local y = 0
local z = 0
local MAX_DEPTH = 100

local ERROR = 0
local GO_ON = 1
local DONE = 2
local OUTOFFUEL = 3
local FULLINV = 4
local BLOCKEDMOVE = 5

function triple_mine()
    move.digDown()
    move.dig()
    move.digUp()
end

function mine_layer()
    local report = GO_ON
    return report
end

function go_home()
end

function main()
    net.connect("worker", "tunnel")

    while true do
        local report = mine_layer()

        if report ~= GO_ON then
            -- Go home
        end

        z = z + 1
        print("Z: " .. z)
    end
end

main()

