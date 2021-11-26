Gameover = {}

function Gameover:enter()
    self.captions = {}
    self.captions[1] = {}
    self.captions[1].image = gImages['gameover-caption']
    self.captions[1].x = gameWidth / 2
    self.captions[1].y = gameHeight / 2

    -- Press Enter to continue prompt
    self.prompt = {}
    self.prompt.image = gImages['key-prompt']
    self.prompt.color = {1, 1, 1, 1}
    self.prompt.sound = gSounds['menu-select']

    -- Flag for recognizing key input
    self.canPressKey = true

    -- Game Over Music
    self.music = gMusic['gameover']

    
    self.world = WF.newWorld(0, 300, true)
    -- Boundaries
    self.boundaries = {}
    -- Left-side wall
    self.boundaries[1] = self.world:newLineCollider(0, 0, 0, gameHeight)
    self.boundaries[1]:setType('static')
    -- Right-side wall
    self.boundaries[2] = self.world:newLineCollider(gameWidth, 0, gameWidth, gameHeight)
    self.boundaries[2]:setType('static')
    -- Floor
    self.boundaries[3] = self.world:newLineCollider(0, gameHeight, gameWidth, gameHeight)
    self.boundaries[3]:setType('static')


    self.maxBodies = 500
    self.bodies = {}
    Timer.every(0.25, function()
        local body = {
            sheet = gImages['player'],
            sprite = gFrames['player'][math.random(13, 14)],
            width = 20,
            height = 18,
            spawnX = math.random(gameWidth - 20),
            spawnY = -18,
        }
        body.collider = self.world:newCircleCollider(body.spawnX + body.width / 2, body.spawnY + body.height / 2, body.height / 2 - 2)
        body.collider:setMass(30)
        body.x, body.y = body.collider:getPosition()
        table.insert(self.bodies, body)
    end, self.maxBodies)

    love.audio.stop()
    self.music:play()
end

function Gameover:update(dt)
    self.world:update(dt)

    -- Tween key prompt's alpha channel
    if self.prompt.color[4] == 0 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 1})
    elseif self.prompt.color[4] == 1 then
        Timer.tween(1, self.prompt.color, {1, 1, 1, 0})
    end

    -- Update bodies
    for k, body in pairs(self.bodies) do
        body.x, body.y = body.collider:getPosition()
    end
end

function Gameover:keypressed(key)
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

function Gameover:draw()
    -- Draw bodies
    for k, body in pairs(self.bodies) do
        love.graphics.draw(body.sheet, body.sprite, math.floor(body.x), math.floor(body.y), body.collider:getAngle(), 1, 1, body.width / 2, body.height / 2)
    end
    --self.world:draw()
    -- Draw captions
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw 'Game Over' caption
    love.graphics.draw(self.captions[1].image, self.captions[1].x, self.captions[1].y, 0, 2, 2, self.captions[1].image:getWidth() / 2, self.captions[1].image:getHeight() / 2)
    -- Draw key prompt
    love.graphics.setColor(self.prompt.color)
    love.graphics.draw(self.prompt.image, gameWidth / 2, gameHeight / 2, 0, 2, 2, self.prompt.image:getWidth() / 2, self.prompt.image:getHeight() / 2 - 20)
end