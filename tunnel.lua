os.loadAPI('move.lua')
os.loadAPI('inv.lua')
os.loadAPI('net.lua')

local x = 0
local y = 0
local z = 0
local MAX_DEPTH = 100
local toggle = true

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

    for i=0, 1, 1
    do
        triple_mine()
        move.fw()
    end

    if (toggle)
    then
        -- on right side
        turtle.turnLeft()
    else
        -- left side
        turtle.turnRight()
    end

    triple_mine()
    move.fw()

    if (toggle)
    then
        -- on right side
        turtle.turnLeft()
        toggle = false
    else
        -- left side
        turtle.turnRight()
        toggle = true
    end

    return report
end

function go_home()
end

function main()
    net.connect("worker", "tunnel")
    move.up()
    move.fw()
    turtle.turnRight()

    while true do

        if inv.isInventoryFull() then
            print("Dropping Trash")
            inv.dropTrash()

            if inv.isInventoryFull() then
                print("Stacking items")
                inv.stackItems()
            end

            if inv.isInventoryFull() then
                print("Full Inventory")
                broadcast("FULL INVENTORY")
                return FULLINV
            end
        end


        local report = mine_layer()

        if report ~= GO_ON then
            -- Go home
        end

        z = z + 1
        print("Z: " .. z)
    end
end

main()

