-- Exit confirmation state for when tne player hits the escape key
ExitConfirm = {}

function ExitConfirm:init()
    self.messages = {}
    -- Confirmation message
    self.messages[1] = love.graphics.newText(gFonts['messages'], "Are you sure you want to quit?")
    -- Options to display
    self.messages[2] = love.graphics.newText(gFonts['messages'], "No")
    self.messages[3] = love.graphics.newText(gFonts['messages'], "Yes")
    -- Option currently selected
    self.optionSelected = 1
    -- State sounds
    self.sounds = {}
    self.sounds.enter = gSounds['exit-confirm-in']
    self.sounds.leave = gSounds['exit-confirm-out']
    self.sounds.cursor = gSounds['menu-cursor']
end

function ExitConfirm:enter()
    -- Stop music and/or sounds from previous state
    love.audio.pause()
    self.sounds.enter:play()
    -- 'No' is selected as the default option
    self.optionSelected = 1
end

function ExitConfirm:leave()
    self.sounds.leave:play()
end

function ExitConfirm:keypressed(key)
    if key == 'a' or key == 'left' or key == 'right' or key == 'd' then
        self.sounds.cursor:play()
        self.optionSelected = self.optionSelected == 1 and 2 or 1
    end
    if key == 'enter' or key == 'return' then
        -- If 'No' is selected
        if self.optionSelected == 1 then
            -- Return to previous state
            Gamestate.pop()
        -- If 'Yes' is selected
        else
            -- Quit game
            self.sounds.leave:play()
            Timer.after(0.5, function() love.event.quit() end)
        end
    end
end

function ExitConfirm:draw()
    -- Obscure the screen
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    -- Draw messages
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.messages[1], gameWidth / 2, gameHeight / 2, 0, 1, 1, self.messages[1]:getWidth() / 2, self.messages[1]:getHeight() / 2)
    if self.optionSelected == 2 then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    end
    love.graphics.draw(self.messages[2], gameWidth / 2, gameHeight / 2 + 20, 0, 1, 1, self.messages[2]:getWidth() + 20, self.messages[2]:getHeight() / 2)
    if self.optionSelected == 1 then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(self.messages[3], gameWidth / 2, gameHeight / 2 + 20, 0, 1, 1, self.messages[3]:getWidth() - 30, self.messages[3]:getHeight() / 2)
end