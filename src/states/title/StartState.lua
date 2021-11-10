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
    -- Key prompt's initial alpha channel
    keyPromptColor = {1, 1, 1, 1}
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
    -- Tween key prompt's alpha channel
    if keyPromptColor[4] == 0 then
        Timer.tween(1, keyPromptColor, {1, 1, 1, 1})
    elseif keyPromptColor[4] == 1 then
        Timer.tween(1, keyPromptColor, {1, 1, 1, 0})
    end
end

function Start:keypressed(key)
    if key == 'enter' or key == 'return' then
        keyPromptColor[4] = 1
        menuSelectSound:play()
        Timer.after(1, function() Gamestate.switch(TitleMenu) end)
    end
end

function Start:draw()
    -- Draw background
    love.graphics.draw(titleScreenBackground, titleScreenBackgroundX, 0)
    -- Draw tilemap
    titleMap:draw()
    -- Draw title logo
    love.graphics.draw(titleLogo, gameWidth / 2, gameHeight / 2, 0, 4, 4, titleLogo:getWidth() / 2, titleLogo:getHeight() / 2)
    -- Draw key prompt
    love.graphics.setColor(keyPromptColor)
    love.graphics.draw(keyPrompt, gameWidth / 2, gameHeight / 2, 0, 2, 2, keyPrompt:getWidth() / 2, keyPrompt:getHeight() / 2 - 20)
end