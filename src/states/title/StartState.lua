-- Title screen state
Start = {}

function Start:init()
    -- Load title screen map created in Tiled
    titleMap = sti("levels/titleScreen.lua")
    -- Scrolling speed
    scrollSpeed = 20
    -- Start by scrolling the tilemap to the right
    scrollDirection = 'right'
    -- Original background position
    titleScreenBackgroundX = 0
    titleScreenBackgroundMove = true
end

function Start:enter()
    titleScreenMusic:setLooping(true)
    titleScreenMusic:play()
end

function Start:resume()
    titleScreenMusic:setLooping(true)
    titleScreenMusic:play()
end

function Start:update(dt)
    -- Scroll the background in the current direction until it reaches the end, then switch
    if titleScreenBackgroundMove then
        titleScreenBackgroundX = scrollDirection == 'right' and titleScreenBackgroundX - scrollSpeed * dt or titleScreenBackgroundX + scrollSpeed * dt
    end
    -- Scroll the tilemap in the current direction until it reaches the end, then switch
    for k, layer in pairs(titleMap.layers) do
        if scrollDirection == 'right' then
            if layer.x < -gameWidth + 1 then
                titleScreenBackgroundMove = false
                Timer.after(1, function() scrollDirection = 'left' end)
            else
                titleScreenBackgroundMove = true
                layer.x = layer.x - scrollSpeed * dt
            end
        elseif scrollDirection == 'left' then
            if layer.x > 0 then
                titleScreenBackgroundMove = false
                Timer.after(1, function() scrollDirection = 'right' end)
            else
                titleScreenBackgroundMove = true
                layer.x = layer.x + scrollSpeed * dt
            end
        end
    end
end

function Start:draw()
    -- Draw background
    love.graphics.draw(titleScreenBackground, titleScreenBackgroundX, 0)
    -- Draw tilemap
    titleMap:draw()
    -- Draw title logo
    love.graphics.draw(titleLogo, gameWidth / 2, gameHeight / 2, 0, 1, 1, titleLogo:getWidth() / 2, titleLogo:getHeight() / 2)
end