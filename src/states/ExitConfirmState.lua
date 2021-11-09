-- Exit confirmation state for when tne player hits the escape key
ExitConfirm = {}

function ExitConfirm:init()
    exitMessage1 = love.graphics.newText(messageFont, "Are you sure you want to exit?")
    exitMessage2 = love.graphics.newText(messageFont, "No")
    exitMessage3 = love.graphics.newText(messageFont, "Yes")
end

function ExitConfirm:enter()
    love.audio.pause()
    exitConfirmInSound:play()
    optionSelected = 1
end

function ExitConfirm:leave()
    exitConfirmOutSound:play()
end

function ExitConfirm:keypressed(key)
    if key == 'a' or key == 'left' or key == 'right' or key == 'd' then
        menuCursorSound:play()
        optionSelected = optionSelected == 1 and 2 or 1
    end
    if key == 'enter' or key == 'return' then
        if optionSelected == 1 then
            Gamestate.pop()
        else
            exitConfirmOutSound:play()
        Timer.after(0.5, function() love.event.quit() end)
        end
    end
end

function ExitConfirm:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(exitMessage1, gameWidth / 2, gameHeight / 2 + 20, 0, 1, 1, exitMessage1:getWidth() / 2, exitMessage1:getHeight() / 2)
    if optionSelected == 2 then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    end
    love.graphics.draw(exitMessage2, gameWidth / 2, gameHeight / 2 + 40, 0, 1, 1, exitMessage2:getWidth() + 20, exitMessage2:getHeight() / 2)
    if optionSelected == 1 then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(exitMessage3, gameWidth / 2, gameHeight / 2 + 40, 0, 1, 1, exitMessage3:getWidth() - 30, exitMessage3:getHeight() / 2)
end