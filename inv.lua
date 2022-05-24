trash = {
    'minecraft:cobblestone',
    'minecraft:dirt',
    'forbidden_arcanus:darkstone',
    'byg:rocky_stone',
    'byg:scoria_cobblestone',
    'byg:soapstone',
	'create:limestone',
    'minecraft:diorite',
    'minecraft:granite',
    'quark:smooth_basalt',
    'quark:cobbled_deepslate'
}


function isInventoryFull()
    for i=1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

function stackItems()
    items = {}

    for i = 1, 16 do
        local detail = turtle.getItemDetail(i)

        if detail ~= nil then
            -- not empty

            local saved = items[detail.name]

            if saved ~= nil then
                -- seen

                local amount = detail.count
                turtle.select(i)
                turtle.transferTo(saved.slot)

                if amount > saved.space then
                    -- slot is full

                    saved.slot = i
                    saved.count = amount - saved.space

                    -- update
                    items[detail.name] = saved

                elseif amount == saved.space then
                    items[this.name] = nil
                end
            else
                -- not seen
                detail.slot = i
                detail.space = turtle.getItemSpace(i)
            end
        end
    end
    return true
end

function dropTrash()
    for i = 1, 16 do
        local details = turtle.getItemDetail(i)
        if details then
            for j = 1, #trash do
                if details.name == trash[j] then
                    turtle.select(i)
                    turtle.drop()
                end
            end
        end
    end
    return true
end
