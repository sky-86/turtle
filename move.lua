function turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
    return true
end

function dig()
    local tries = 0 

    while turtle.detect() do

        turtle.dig()
        sleep(0.4)
        tries = tries+1
        if tries > 100 then
            printError("Can't Dig Forward")
            return false
        end
    end
    return true
end

function digDown()
    local tries = 0 

    while turtle.detectDown() do

        turtle.digDown()
        sleep(0.4)
        tries = tries+1
        if tries > 100 then
            printError("Can't Dig Down")
            return false
        end
    end
    return true
end

function digUp()
    local tries = 0 

    while turtle.detectUp() do

        turtle.digUp()
        sleep(0.4)
        tries = tries+1
        if tries > 100 then
            printError("Can't Dig Up")
            return false
        end
    end
    return true
end

function fw(blocks)
    blocks = blocks or 1

    for i = 1, blocks do
        local tries = 0

        while turtle.forward() ~= true do
            turtle.dig()
            turtle.attack()
            sleep(0.2)

            tries = tries + 1
            if tries > 100 then
                printError("Can't Move Forward")
                return false
            end
        end
    end
    return true
end

function up(blocks)
    blocks = blocks or 1

    for i = 1, blocks do
        local tries = 0

        while turtle.up() ~= true do
            turtle.digUp()
            turtle.attackUp()
            sleep(0.2)

            tries = tries + 1
            if tries > 100 then
                printError("Can't Move Up")
                return false
            end
        end
    end
    return true
end

function down(blocks)
    blocks = blocks or 1

    for i = 1, blocks do
        local tries = 0

        while turtle.down() ~= true do
            turtle.digDown()
            turtle.attackDown()
            sleep(0.2)

            tries = tries + 1
            if tries > 100 then
                printError("Can't Move Down")
                return false
            end
        end
    end
    return true
end

function back(blocks)
    blocks = blocks or 1

    for i = 1, blocks do
        if turtle.back() ~= true then
            turnAround()
            fw()
            turnAround()
        end
    end
    return true
end
