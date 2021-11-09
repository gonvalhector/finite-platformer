-- Exit confirmation state for when tne player hits the escape key
ExitConfirm = {}

function ExitConfirm:init()
    exitMessage1 = love.graphics.newText(messageFont, "Are you sure you want to exit?")
    exitMessage2 = love.graphics.newText(messageFont, "Y = Yes | N = No")
end

function ExitConfirm:enter()
    love.audio.pause()
end

function ExitConfirm:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(exitMessage1, gameWidth / 2, gameHeight / 2 + 20, 0, 1, 1, exitMessage1:getWidth() / 2, exitMessage1:getHeight() / 2)
    love.graphics.draw(exitMessage2, gameWidth / 2, gameHeight / 2 + 40, 0, 1, 1, exitMessage2:getWidth() / 2, exitMessage2:getHeight() / 2)
end

function ExitConfirm:keypressed(key)
    if key == 'y' then
        love.event.quit()
    elseif key == 'n' then
        Gamestate.pop()
    end
end