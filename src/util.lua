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


--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    -- Custom feature
    -- Adds width and height of the quads at the end of the table
    table.insert(spritesheet, tilewidth)
    table.insert(spritesheet, tileheight)

    return spritesheet
end


--[[
    Defines the friction of a fixture given a type of surface.
]]
function newFriction(surfaceType)
    local surfaces = {
        ['Ground'] = 0.5,
        ['Obstacle'] = 0.5
    }
    return surfaces[surfaceType]
end