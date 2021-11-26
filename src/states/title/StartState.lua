-- Title screen state
Start = {}

function Start:enter()
    -- Load title screen map created in Tiled
    self.map = STI("levels/titleScreen.lua")
    -- Scrolling speed
    self.scroll = {}
    self.scroll.speed = 20
    -- Start by scrolling the tilemap to the right
    self.scroll.direction = 'right'
    -- Original background position and
    self.background = {}
    self.background.image = gImages['title-background']
    self.background.x = 0
    self.background.canMove = true
    -- Key prompt's initial alpha channel
    self.prompt = {}
    self.prompt.image = gImages['key-prompt']
    self.prompt.color = {1, 1, 1, 1}
    -- Key prompt's sound
    self.prompt.sound = gSounds['menu-select']
    -- Background music
    self.music = gMusic['title-music']
    self.music:setLooping(true)
    -- Title logo
    self.logo = gImages['title-logo']

    -- Flag for recognizing key input
    self.canPressKey = true

    love.audio.stop()
    self.music:play()
end

function Start:resume()
    self.music:play()
end

function Start:update(dt)
    -- Automatically scroll the title screen's background and map, right and left.
    autoScroll(dt, self.map, self.background, self.scroll)
    -- Tween key prompt's alpha channel
    if self.prompt.color[4] == 0 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 1})
    elseif self.prompt.color[4] == 1 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 0})
    end
end

function Start:keypressed(key)
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            self.prompt.color[4] = 1
            self.prompt.sound:play()
            -- Change to the title menu state
            local def = {
                map = self.map,
                scroll = self.scroll,
                background = self.background,
                logo = self.logo,
                music = self.music
            }
            Timer.after(0.5, function() Gamestate.switch(TitleMenu, def) end)
        end
    end
end

function Start:draw()
    -- Draw background
    love.graphics.draw(self.background.image, self.background.x, 0)
    -- Draw tilemap
    self.map:draw()
    -- Draw title logo
    love.graphics.draw(self.logo, gameWidth / 2, gameHeight / 2, 0, 4, 4, self.logo:getWidth() / 2, self.logo:getHeight() / 2)
    -- Draw key prompt
    love.graphics.setColor(self.prompt.color)
    love.graphics.draw(self.prompt.image, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.prompt.image:getWidth() / 2, self.prompt.image:getHeight() / 2 - 20)
end