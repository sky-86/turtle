os.loadAPI('inventory')
os.loadAPI('move')

-- bugs: 
-- 1. when on top mining level, it fails to find the chest 1 block below it
-- 2. io for size is broken


local x = 0
local y = 0
local z = 0
local max = 16
local deep = 64
local facingfw = true
 
local ERROR = 0
local GO_ON  = 1
local DONE  = 2
local OUTOFFUEL = 3
local FULLINV = 4
local BLOCKEDMOVE = 5

-- function get_input()
--     io.write("Enter mining area size: ")
--     local max = io.read('*n')
--     if max > 64 or max < 4 then
--         print("Invalid area size, defaulting to 16x16")
--         max = 16
--     end
-- end


function broadcast(curr)
    -- return postion and current process

    msg = curr .. " @ [" .. x .. ", " .. y .. ", " .. z .. "]"
    print(msg)
    rednet.broadcast(msg, "quarry")
end

function dropInChest()
    turtle.turnLeft()
    local success, data = turtle.inspect()
    local hasCoal = false
    if success then
        if string.find(data.name, 'chest') then
            print("Dropping items in chest")

            for i = 1, 16 do
                turtle.select(i)
                data = turtle.getItemDetail()
                if data ~= nil then
                    -- if data.name ~= "minecraft:coal" then
                    if not string.find(data.name, 'coal') then
                        turtle.drop()
                    elseif string.find(data.name, 'coal') and hasCoal == false then
                        hasCoal = true
                    elseif string.find(data.name, 'coal') and hasCoal == true then
                        turtle.drop()
                    end
                end
            end
        end
    end
    turtle.turnRight()
    return true
end

function goDown()
    while true do
        if turtle.getFuelLevel() <= fuelNeeded() then
            if not refuel() then
                return OUTOFFUEL
            end
        end

        if not turtle.down() then
            -- going up one
            turtle.up()
            z = z + 1
            return
        end
        -- going down
        z = z - 1
    end
end

function fuelNeeded()
    return -z + x + y + 2
end

function refuel()
    for i = 1, 16 do
        turtle.select(i)
        item = turtle.getItemDetail()
        
        if item and string.find(item.name, 'coal') then
            turtle.refuel()
            return true
        end
    end
    return false
end

function moveH()


    if inventory.isInventoryFull() then
        print("Dropping Trash")
        inventory.dropTrash()

        if inventory.isInventoryFull() then
            print("Stacking items")
            inventory.stackItems()
        end

        if inventory.isInventoryFull() then
            print("Full Inventory")
            broadcast("FULL INVENTORY")
            return FULLINV
        end
    end

    if turtle.getFuelLevel() <= fuelNeeded() then
        if not refuel() then
            print("Out of fuel")
            broadcast("OUT OF FUEL")
            return OUTOFFUEL
        end
    end

    if facingfw and y < max - 1 then
        -- going forward
        move.dig()
        move.digUp()
        move.digDown()

        if move.fw() == false then
            return BLOCKEDMOVE
        end

        y = y + 1

    elseif not facingfw and y > 0 then
        -- going backwards
        move.dig()
        move.digUp()
        move.digDown()

        if move.fw() == false then
            return BLOCKEDMOVE
        end

        y = y - 1

    else

        if x + 1 >= max then
            move.digUp()
            move.digDown()
            return DONE -- done with this Y level
        end

        -- not done with Y
        if facingfw then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end

        move.dig()
        move.digUp()
        move.digDown()

        if move.fw() == false then
            return BLOCKEDMOVE
        end

        x = x + 1

        if facingfw then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end

        facingfw = not facingfw
    end
    broadcast("MINING")
    return GO_ON
end

function doSquare()
    local report = GO_ON

    while report == GO_ON do
        report = moveH()
    end

    if report == DONE then
        return GO_ON
    end
    return report
end

function goToOrigin()
    if facingfw then
        turtle.turnLeft()
        move.fw(x)
        turtle.turnLeft()
        move.fw(y)
        move.turnAround()
    else
        turtle.turnRight()
        move.fw(x)
        turtle.turnLeft()
        move.fw(y)
        move.turnAround()
    end

    x = 0
    y = 0
    facingfw = true
end

function goUp()
    while z < 0 do
        move.up()
        z = z + 1
    end
    goToOrigin()
end

function main()
    while true do
        local report = doSquare()

        if report ~= GO_ON then
            goUp()
            return report
        end

        goToOrigin()


        for i = 1, 3 do
            move.digDown()
            success = move.down()

            if not success then
                goUp()
                return BLOCKEDMOVE
            end

            z = z - 1
            print("Z: " .. z)
        end
    end
end

rednet.open("right")
rednet.host("quarry", "turtle")
print("\n\n\n-- WELCOME TO THE MINING TURTLE --\n\n")

while true do
  goDown()
  local report = main()
  dropInChest()
  
  if report ~= FULLINV then
    break
  end
end
rednet.close("right")

