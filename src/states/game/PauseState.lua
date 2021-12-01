Pause = {}

function Pause:enter()
    self.sounds = {}
    self.sounds.pauseIn = gSounds['pause-in']
    self.sounds.pauseOut = gSounds['pause-out']
    self.sounds.select = gSounds['menu-select']
    self.sounds.cursor = gSounds['menu-cursor']

    self.caption = {}
    self.caption.image = gFrames['captions'][1]
    self.caption.sheet = gImages['captions']
    self.caption.x = gameWidth / 2
    self.caption.y = gameHeight / 2
    self.caption.width = gFrames['captions'][#gFrames['captions'] - 1]
    self.caption.height = gFrames['captions'][#gFrames['captions']]

    self.options = {}
    self.options.selected = 1
    self.options.image = gImages['title-menu']
    self.options.images = {
        optionA = {
            inactive = gFrames['title-menu'][7],
            active = gFrames['title-menu'][8]
        },
        optionB = {
            inactive = gFrames['title-menu'][3],
            active = gFrames['title-menu'][4]
        },
        optionC = {
            inactive = gFrames['title-menu'][5],
            active = gFrames['title-menu'][6]
        },
        width = gFrames['title-menu'][#gFrames['title-menu'] - 1],
        height = gFrames['title-menu'][#gFrames['title-menu']]
    }
    self.options.alpha = 0

    -- Flag for recognizing key input
    self.canPressKey = true

    love.audio.stop()
    self.sounds.pauseIn:play()
    Timer.tween(0.25, self.caption, { y = gameHeight / 2 - 100 })
    Timer.tween(0.5, self.options, { alpha = 1 })
end

function Pause:resume()
    -- Flag for recognizing key input
    self.canPressKey = true
end

function Pause:update(dt)
    -- Reset option highlighted's value to avoid going over or under
    if self.options.selected > 3 then
        self.options.selected = 1
    end
    if self.options.selected < 1 then
        self.options.selected = 3
    end
end

function Pause:keypressed(key)
    -- Change option highlighted
    if key == 'up' or key == 'w' then
        self.options.selected = self.options.selected - 1
        self.sounds.cursor:play()
    elseif key == 'down' or key == 's' then
        self.options.selected = self.options.selected + 1
        self.sounds.cursor:play()
    end

    -- Select an option
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            -- 'Resume' option
            if self.options.selected == 1 then
                self.sounds.pauseOut:play()
                Gamestate.pop() 
            -- 'Quit' option
            elseif self.options.selected == 3 then
                self.sounds.select:play()
                Timer.after(0.5, function() Gamestate.push(ExitConfirm) end)
            end
        end
    end
end

function Pause:draw() 
    -- Obscure the screen
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)

    -- Draw 'Pause' caption
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.caption.sheet, self.caption.image, self.caption.x, self.caption.y, 0, 2, 2, self.caption.width / 2, self.caption.height / 2)

    -- Draw menu option A
    love.graphics.setColor(1, 1, 1, self.options.alpha)
    if self.options.selected == 1 then
        love.graphics.draw(self.options.image, self.options.images.optionA.active, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionA.inactive, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
    -- Draw menu option B
    if self.options.selected == 2 then
        love.graphics.draw(self.options.image, self.options.images.optionB.active, gameWidth / 2, gameHeight / 2 + 20, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionB.inactive, gameWidth / 2, gameHeight / 2 + 20, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
    -- Draw menu option C
    if self.options.selected == 3 then
        love.graphics.draw(self.options.image, self.options.images.optionC.active, gameWidth / 2, gameHeight / 2 + 40, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionC.inactive, gameWidth / 2, gameHeight / 2 + 40, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
end