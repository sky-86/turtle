os.loadAPI('move.lua')
os.loadAPI('inv.lua')
os.loadAPI('net.lua')


function mine_layer()
    move.dig()
    move.fw()

    move.digUp()
    move.digDown()
    move.down()

end

function main()


    while true do
        mine_layer()
    end
    
end

main()
