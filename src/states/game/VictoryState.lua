Victory = {}

function Victory:enter(def)
    -- Level variables
    self.lvl = def.lvl
    self.score = def.score
    self.lives = def.lives

    -- 'Victory' caption
    self.captions = {}
    self.captions[1] = {}
    self.captions[1].image = gFrames['captions'][4]
    self.captions[1].sheet = gImages['captions']
    self.captions[1].x = gameWidth / 2
    self.captions[1].y = gameHeight / 2
    self.captions[1].width = gFrames['captions'][#gFrames['captions'] - 1]
    self.captions[1].height = gFrames['captions'][#gFrames['captions']]

    -- 'Press Enter to continue' prompt
    self.prompt = {}
    self.prompt.image = gImages['key-prompt']
    self.prompt.color = {1, 1, 1, 1}
    self.prompt.sound = gSounds['menu-select']

    -- Flag for recognizing key input
    self.canPressKey = true

    -- Game Over Music
    self.music = gMusic['victory']

    -- Confetti Particles
    self.confetti = love.graphics.newParticleSystem(gImages['confetti'], 1000)
    self.confetti:setQuads(gFrames['confetti'][1], gFrames['confetti'][2], gFrames['confetti'][3], gFrames['confetti'][4], gFrames['confetti'][5])
    self.confetti:setParticleLifetime(7, 10)
    self.confetti:setEmissionRate(100)
    self.confetti:setSizes(1)
    self.confetti:setLinearAcceleration(-10, 20, 10, 20)
    self.confetti:setEmissionArea('normal', gameWidth, gameHeight, 0, false)

    love.audio.stop()
    self.music:setLooping(true)
    self.music:play()
end

function Victory:update(dt)
    -- Tween key prompt's alpha channel
    if self.prompt.color[4] == 0 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 1})
    elseif self.prompt.color[4] == 1 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 0})
    end
    -- Update confetti
    self.confetti:update(dt)
end

function Victory:keypressed(key)
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            self.prompt.color[4] = 1
            self.prompt.sound:play()
            -- Change to the Start state
            Timer.after(0.5, function() Gamestate.switch(Start) end)
        end
    end
end

function Victory:draw()
    -- Draw confetti
    love.graphics.draw(self.confetti, gameWidth / 2, -10)
    -- Draw captions
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw 'Victory' caption
    love.graphics.draw(self.captions[1].sheet, self.captions[1].image, self.captions[1].x, self.captions[1].y, 0, 2, 2, self.captions[1].width / 2, self.captions[1].height / 2)
    -- Draw key prompt
    love.graphics.setColor(self.prompt.color)
    love.graphics.draw(self.prompt.image, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.prompt.image:getWidth() / 2, self.prompt.image:getHeight() / 2 - 20)
end