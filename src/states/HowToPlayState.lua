HowToPlay = {}

function HowToPlay:enter(def)
    self.image = gImages['how-to-play']

    self.sounds = {}
    self.sounds.select = gSounds['menu-select']

    self.canPressKey = true
end

function HowToPlay:keypressed(key)
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            self.sounds.select:play()
            Gamestate.pop() 
        end
    end
end

function HowToPlay:draw()
    -- Obscure the screen
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    -- Draw image
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, 0, 0)
end