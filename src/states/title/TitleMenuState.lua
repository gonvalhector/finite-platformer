-- Title screen menu state
TitleMenu = {}

function TitleMenu:enter(def) 
    self.map = def.map
    self.scroll = def.scroll
    self.background = def.background

    self.music = def.music
    self.sounds = {}
    self.sounds.select = gSounds['menu-select']
    self.sounds.cursor = gSounds['menu-cursor']

    self.logo = {}
    self.logo.image = def.logo
    self.logo.position = {}
    self.logo.position.x = gameWidth / 2
    self.logo.position.y = gameHeight / 2

    self.options = {}
    self.options.selected = 1
    self.options.image = gImages['title-menu']
    self.options.images = {
        optionA = {
            inactive = gFrames['title-menu'][1],
            active = gFrames['title-menu'][2]
        },
        optionB = {
            inactive = gFrames['title-menu'][3],
            active = gFrames['title-menu'][4]
        },
        optionC = {
            inactive = gFrames['title-menu'][5],
            active = gFrames['title-menu'][6]
        },
        width = gFrames['title-menu'][7],
        height = gFrames['title-menu'][8]
    }

    -- Play starts with Stage 1
    self.lvl = 1

    -- Raise the logo
    Timer.tween(0.5, self.logo.position, {x = gameWidth / 2, y = gameHeight / 4})
end

function TitleMenu:resume()
    self.music:setLooping(true)
    self.music:play()
end

function TitleMenu:update(dt)
    -- Automatically scroll the title screen's background and map, right and left.
    autoScroll(dt, self.map, self.background, self.scroll)

    -- Reset option highlighted's value to avoid going over or under
    if self.options.selected > 3 then
        self.options.selected = 1
    end
    if self.options.selected < 1 then
        self.options.selected = 3
    end
end

function TitleMenu:keypressed(key)
    -- Change option highlighted
    if key == 'up' or key == 'w' then
        self.options.selected = self.options.selected - 1
        self.sounds.cursor:play()
    elseif key == 'down' or key == 's' then
        self.options.selected = self.options.selected + 1
        self.sounds.cursor:play()
    end

    -- Select an option
    if key == 'enter' or key == 'return' then
        self.sounds.select:play()
        if self.options.selected == 1 then
            def = {
                lvl = self.lvl
            }
            Timer.after(0.5, function() Gamestate.switch(Play, def) end)
        elseif self.options.selected == 3 then
            Timer.after(0.5, function() Gamestate.push(ExitConfirm) end)
        end
    end
end

function TitleMenu:draw() 
    -- Draw background
    love.graphics.draw(self.background.image, self.background.x, 0)

    -- Draw tilemap
    self.map:draw()

    -- Draw title logo
    love.graphics.draw(self.logo.image, self.logo.position.x, self.logo.position.y, 0, 4, 4, self.logo.image:getWidth() / 2, self.logo.image:getHeight() / 2)

    -- Draw menu option A
    if self.options.selected == 1 then
        love.graphics.draw(self.options.image, self.options.images.optionA.active, gameWidth / 2, gameHeight / 2 + 80, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionA.inactive, gameWidth / 2, gameHeight / 2 + 80, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
    -- Draw menu option B
    if self.options.selected == 2 then
        love.graphics.draw(self.options.image, self.options.images.optionB.active, gameWidth / 2, gameHeight / 2 + 100, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionB.inactive, gameWidth / 2, gameHeight / 2 + 100, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
    -- Draw menu option C
    if self.options.selected == 3 then
        love.graphics.draw(self.options.image, self.options.images.optionC.active, gameWidth / 2, gameHeight / 2 + 120, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    else
        love.graphics.draw(self.options.image, self.options.images.optionC.inactive, gameWidth / 2, gameHeight / 2 + 120, 0, 2, 2, self.options.images.width / 2, self.options.images.height / 2)
    end
end