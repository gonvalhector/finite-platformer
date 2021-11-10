-- Title screen state
Start = {}

function Start:init()
    -- Load title screen map created in Tiled
    self.map = sti("levels/titleScreen.lua")
    -- Scrolling speed
    self.scroll = {}
    self.scroll.speed = 20
    -- Start by scrolling the tilemap to the right
    self.scroll.direction = 'right'
    -- Original background position and
    self.background = {}
    self.background.image = titleScreenBackground
    self.background.x = 0
    self.background.canMove = true
    -- Key prompt's initial alpha channel
    self.prompt = {}
    self.prompt.image = keyPrompt
    self.prompt.color = {1, 1, 1, 1}
    -- Key prompt's sound
    self.prompt.sound = menuSelectSound
    -- Background music
    self.music = titleScreenMusic
    -- Title logo
    self.logo = titleLogo
end

function Start:enter()
    self.music:setLooping(true)
    self.music:play()
end

function Start:resume()
    self.music:setLooping(true)
    self.music:play()
end

function Start:update(dt)
    -- Scroll the background in the current direction until it reaches the end, then switch
    if self.background.canMove then
        self.background.x = self.scroll.direction == 'right' and self.background.x - self.scroll.speed * dt or self.background.x + self.scroll.speed * dt
    end
    -- Scroll the tilemap in the current direction until it reaches the end, then switch
    for k, layer in pairs(self.map.layers) do
        if self.scroll.direction == 'right' then
            if layer.x < -gameWidth + 1 then
                self.background.canMove = false
                Timer.after(1, function() self.scroll.direction = 'left' end)
            else
                self.background.canMove = true
                layer.x = layer.x - self.scroll.speed * dt
            end
        elseif self.scroll.direction == 'left' then
            if layer.x > 0 then
                self.background.canMove = false
                Timer.after(1, function() self.scroll.direction = 'right' end)
            else
                self.background.canMove = true
                layer.x = layer.x + self.scroll.speed * dt
            end
        end
    end
    -- Tween key prompt's alpha channel
    if self.prompt.color[4] == 0 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 1})
    elseif self.prompt.color[4] == 1 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 0})
    end
end

function Start:keypressed(key)
    if key == 'enter' or key == 'return' then
        self.prompt.color[4] = 1
        self.prompt.sound:play()
        -- Change to the title menu state
        Timer.after(1, function() Gamestate.switch(TitleMenu) end)
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