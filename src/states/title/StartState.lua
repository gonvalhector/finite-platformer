-- title screen state
Start = {}

function Start:init()
    titleMap = sti("levels/titleScreen.lua")
    camera = Camera()
end

function Start:update(dt)
    titleMap:update(dt)
end

function Start:draw()
    camera:attach()
        titleMap:drawLayer(titleMap.layers["Farground"])
        titleMap:drawLayer(titleMap.layers["Background"])
        titleMap:drawLayer(titleMap.layers["Midground"])
        titleMap:drawLayer(titleMap.layers["Foreground"])
        love.graphics.draw(titleLogo, gameWidth / 2, gameHeight / 2, 0, 1, 1, titleLogo:getWidth() / 2, titleLogo:getHeight() / 2)
    camera:detach()
end