--[[
    Utilities & helper functions
]]

--[[
    Auto scrolls the title screen's background and map, right and left.
]]
function autoScroll(dt, map, background, scroll)
    -- Scroll the background in the current direction until it reaches the end, then switch
    if background.canMove then
        background.x = scroll.direction == 'right' and background.x - scroll.speed * dt or background.x + scroll.speed * dt
    end
    -- Scroll the tilemap in the current direction until it reaches the end, then switch
    for k, layer in pairs(map.layers) do
        if scroll.direction == 'right' then
            if layer.x < -gameWidth + 1 then
                background.canMove = false
                Timer.after(1, function() scroll.direction = 'left' end)
            else
                background.canMove = true
                layer.x = layer.x - scroll.speed * dt
            end
        elseif scroll.direction == 'left' then
            if layer.x > 0 then
                background.canMove = false
                Timer.after(1, function() scroll.direction = 'right' end)
            else
                background.canMove = true
                layer.x = layer.x + scroll.speed * dt
            end
        end
    end
end