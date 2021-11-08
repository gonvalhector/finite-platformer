-- title screen state
start = {}

function start:draw()
    love.graphics.draw(titleLogo, gameWidth / 2, gameHeight / 2, 0, 1, 1, titleLogo:getWidth() / 2, titleLogo:getHeight() / 2)
end

function start:keypressed(key)
    if key == 'p' then
        love.event.quit()
    end
end