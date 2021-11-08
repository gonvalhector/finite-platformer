-- title screen state
Start = {}

function Start:draw()
    love.graphics.draw(titleLogo, gameWidth / 2, gameHeight / 2, 0, 1, 1, titleLogo:getWidth() / 2, titleLogo:getHeight() / 2)
end