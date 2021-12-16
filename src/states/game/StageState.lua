Stage = {}

function Stage:enter(def)
    -- Player variables
    self.lvl = def.lvl
    self.score = def.score
    self.lives = def.lives

    -- Looping background
    self.background = {}
    self.background.image = self.lvl > 3 and gImages['stage-background-ice'] or gImages['stage-background']
    self.background.x = 0
    self.background.y = 0
    self.background.dx = 150
    self.background.dy = 0
    
    self.captions = {}
    -- 'Level' caption
    self.captions[1] = {}
    self.captions[1].image = gImages['level-caption']
    self.captions[1].x = gameWidth / 2
    self.captions[1].y = gameHeight / 3
    self.captions[1].width = self.captions[1].image:getWidth()
    self.captions[1].height = self.captions[1].image:getHeight()
    -- Level number caption
    self.captions[2] = {}
    self.captions[2].image = gFrames['level-numbers'][self.lvl]
    self.captions[2].sheet = gImages['level-numbers']
    self.captions[2].x = gameWidth / 2
    self.captions[2].y = gameHeight + 15
    self.captions[2].width = gFrames['level-numbers'][#gFrames['level-numbers'] - 1]
    self.captions[2].height = gFrames['level-numbers'][#gFrames['level-numbers']]
    -- Level objective caption
    self.captions[3] = {}
    self.captions[3].text = love.graphics.newText(gFonts['messages'], LEVEL_OBJECTIVES[self.lvl])
    self.captions[3].x = gameWidth / 2
    self.captions[3].y = gameHeight / 2
    self.captions[3].width = self.captions[3].text:getWidth()
    self.captions[3].height = self.captions[3].text:getHeight()

    -- Press Enter to continue prompt
    self.prompt = {}
    self.prompt.image = gImages['key-prompt']
    self.prompt.color = {1, 1, 1, 1}

    -- Flag for recognizing key input
    self.canPressKey = true

    -- Ambient sound
    self.sounds = {}
    self.sounds.wind = gSounds['wind']
    self.sounds.prompt = gSounds['menu-select']

    -- Stage Objectives Music
    self.music = gMusic['stage']

    -- Snow Particles
    self.snow = love.graphics.newParticleSystem(gImages['snow'], 800)
    self.snow:setQuads(gFrames['snow'][1], gFrames['snow'][2], gFrames['snow'][3], gFrames['snow'][4])
    self.snow:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    self.snow:setParticleLifetime(7, 10)
    self.snow:setEmissionRate(100)
    self.snow:setSizes(1)
    self.snow:setLinearAcceleration(-10, 20, 10, 20)
    self.snow:setEmissionArea('normal', gameWidth, gameHeight, 0, false)

    love.audio.stop()
    self.music:setLooping(true)
    self.music:play()
    self.sounds.wind:play()
    Timer.tween(0.5, self.captions[2], { y = gameHeight / 3 })
end

function Stage:update(dt)
    -- Scroll background horizontally
    self.background.x = (self.background.x + self.background.dx * dt) % gameWidth

    -- Tween key prompt's alpha channel
    if self.prompt.color[4] == 0 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 1})
    elseif self.prompt.color[4] == 1 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 0})
    end
    -- Update snow
    if self.lvl > 3 then
        self.snow:update(dt)
    end
end

function Stage:keypressed(key)
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            self.prompt.color[4] = 1
            self.sounds.prompt:play()
            -- Change to the Play state
            local def = {
                lvl = self.lvl,
                score = self.score,
                lives = self.lives
            }
            Timer.after(0.5, function() Gamestate.switch(Play, def) end)
        end
    end
end

function Stage:draw()
    -- Draw background
    love.graphics.draw(self.background.image, -self.background.x, self.background.y)
    -- Draw snow
    if self.lvl > 3 then
        love.graphics.draw(self.snow, gameWidth / 2, -10)
    end
    -- Draw captions
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw 'Level' caption
    love.graphics.draw(self.captions[1].image, self.captions[1].x, self.captions[1].y, 0, 4, 4, self.captions[1].width / 2 + 2, self.captions[1].height / 2)
    -- Draw level number
    love.graphics.draw(self.captions[2].sheet, self.captions[2].image, self.captions[2].x, self.captions[2].y, 0, 4, 4, self.captions[2].width / 2 - 17, self.captions[2].height / 2)
    -- Draw level objective
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(self.captions[3].text, self.captions[3].x, self.captions[3].y, 0, 1, 1, self.captions[3].width / 2 - 1, self.captions[3].height / 2 - 1)
    love.graphics.setColor(255/255, 170/255, 60/255, 1)
    love.graphics.draw(self.captions[3].text, self.captions[3].x, self.captions[3].y, 0, 1, 1, self.captions[3].width / 2, self.captions[3].height / 2)
    -- Draw key prompt
    love.graphics.setColor(self.prompt.color)
    love.graphics.draw(self.prompt.image, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.prompt.image:getWidth() / 2, self.prompt.image:getHeight() / 2 - 20)
end