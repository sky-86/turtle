local global_net = "base"

function connect(name, net)
    peripheral.find("modem", rednet.open)
    global_net = net
    rednet.host(net, name)
end

function broadcast(state, x, y, z)
    msg = state .. " @ [" .. x .. ", " .. y .. ", " .. z .. "]"
    print(msg)
    rednet.broadcast(msg, global_net)
end
