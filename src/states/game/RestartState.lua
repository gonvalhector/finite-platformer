-- Restart level state
Restart = {}

function Restart:enter(def)
self.lvl = def.lvl
self.score = def.score
self.lives = def.lives

self.captions = {}
self.captions[1] = {}
self.captions[1].image = gImages['restart-caption']
self.captions[1].x = gameWidth / 2
self.captions[1].y = gameHeight / 2 - 20
self.captions[2] = {}
self.captions[2].image = love.graphics.newText(gFonts['messages'], "Yes")
self.captions[2].x = 179
self.captions[2].y = 209
self.captions[3] = {}
self.captions[3].image = love.graphics.newText(gFonts['messages'], "No")
self.captions[3].x = 445
self.captions[3].y = 209

self.sounds = {}
self.sounds.restart = gSounds['restart']
self.sounds.select = gSounds['menu-select']
self.sounds.cursor = gSounds['menu-cursor']

self.optionSelected = 1

love.audio.stop()
self.sounds.restart:play()
Timer.tween(0.5, self.captions[1], { y = gameHeight / 2 - 60 })
end

function Restart:keypressed(key)
    if key == 'a' or key == 'left' or key == 'right' or key == 'd' then
        self.sounds.cursor:play()
        self.optionSelected = self.optionSelected == 1 and 2 or 1
    end
    if key == 'enter' or key == 'return' then
        self.sounds.select:play()
        -- If 'Yes' is selected
        if self.optionSelected == 1 then
            -- Restart level
            local def = {
                lvl = self.lvl,
                score = self.score,
                lives = self.lives
            }
            Gamestate.pop()
            Gamestate.switch(Play, def)
        -- If 'No' is selected
        else
            -- Return to title
            Gamestate.pop()
            Gamestate.switch(Start)
        end
    end
end

function Restart:draw()
    -- Obscure the screen
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    -- Draw captions
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw 'Restart Level?' caption
    love.graphics.draw(self.captions[1].image, self.captions[1].x, self.captions[1].y, 0, 2, 2, self.captions[1].image:getWidth() / 2, self.captions[1].image:getHeight() / 2)
    -- Draw 'Yes' caption
    if self.optionSelected == 1 then
        love.graphics.setColor(247/255, 56/255, 91/255, 1)
        love.graphics.draw(self.captions[2].image, self.captions[2].x, self.captions[2].y)
        --
        love.graphics.setColor(255/255, 232/255, 148/255, 1)
        love.graphics.draw(self.captions[2].image, self.captions[2].x - 1, self.captions[2].y - 1)
    else
        love.graphics.setColor(175/255, 16/255, 29/255, 1)
        love.graphics.draw(self.captions[2].image, self.captions[2].x, self.captions[2].y)
        --
        love.graphics.setColor(255/255, 155/255, 61/255, 1)
        love.graphics.draw(self.captions[2].image, self.captions[2].x - 1, self.captions[2].y - 1)
    end
    -- Draw 'No' caption
    if self.optionSelected == 2 then
        love.graphics.setColor(247/255, 56/255, 91/255, 1)
        love.graphics.draw(self.captions[3].image, self.captions[3].x, self.captions[3].y)
        --
        love.graphics.setColor(255/255, 232/255, 148/255, 1)
        love.graphics.draw(self.captions[3].image, self.captions[3].x - 1, self.captions[3].y - 1)
    else
        love.graphics.setColor(175/255, 16/255, 29/255, 1)
        love.graphics.draw(self.captions[3].image, self.captions[3].x, self.captions[3].y)
        --
        love.graphics.setColor(255/255, 155/255, 61/255, 1)
        love.graphics.draw(self.captions[3].image, self.captions[3].x - 1, self.captions[3].y - 1)
    end
end