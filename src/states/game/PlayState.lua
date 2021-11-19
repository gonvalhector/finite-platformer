-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.music = gMusic['level-' .. tostring(self.levelNumber)]
    self.sounds = {}
    self.sounds.jump = gSounds['jump']
    self.sounds.landing = gSounds['landing']
    self.sounds.coinPickup = gSounds['coin-pickup']

    self.camera = Camera()
    self.cameraOrigin = {}
    self.cameraOrigin.x = self.camera.x
    self.cameraOrigin.y = self.camera.y

    -- Score, Lives, Health & Coins
    self.UIelements = {}
    -- Score
    self.UIelements.score = {}
    self.UIelements.score.total = def.score
    self.UIelements.score.captions = {}
    self.UIelements.score.captions[1] = love.graphics.newText(gFonts['interface'], "Score:")
    self.UIelements.score.captions[2] = love.graphics.newText(gFonts['interface'], tostring(self.UIelements.score.total))
    -- Lives
    self.UIelements.lives = {}
    self.UIelements.lives.total = def.lives
    self.UIelements.lives.captions = {}
    self.UIelements.lives.captions[1] = love.graphics.newText(gFonts['interface'], "Lives:")
    self.UIelements.lives.captions[2] = love.graphics.newText(gFonts['interface'], tostring(self.UIelements.lives.total))

    self.jumpCount = 0

    love.audio.stop()
    self.music:setLooping(true)
    self.music:play()
end

function Play:resume()
    self.music:setLooping(true)
    self.music:play()
end

function Play:update(dt)
    self.level:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.level.player.direction = 'left'
        self.level.player.state = self.jumpCount == 0 and 'walk' or 'jump'
        if self.level.player.linearVelocity.x > -self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(-self.level.player.force, 0)
        end
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.level.player.direction = 'right'
        self.level.player.state = self.jumpCount == 0 and 'walk' or 'jump'
        if self.level.player.linearVelocity.x < self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(self.level.player.force, 0)
        end
    else
        self.level.player.state = self.jumpCount == 0 and 'idle' or 'jump'
    end

    -- Update camera
    self.camera.x = math.floor(math.max(self.cameraOrigin.x, self.cameraOrigin.x + math.min(16 * self.level.map.width - gameWidth, self.level.player.body:getX() - gameWidth / 2)))
    self.camera.y = math.floor(math.max(self.cameraOrigin.y, self.cameraOrigin.y + math.min(16 * self.level.map.height - gameHeight, self.level.player.body:getY() - gameHeight / 2)))

    -- Update level's background
    self.level.background.x = ((self.camera.x - self.cameraOrigin.x) / 3) % 256
    self.level.background.y = ((self.camera.y - self.cameraOrigin.y) / 6) % 256

    -- Reset jumps available when the player hits the floor
    if self.level.player.body:enter('Boundaries') and self.jumpCount > 0 then
        self.sounds.landing:play()
        self.jumpCount = 0
    end

    -- If player collides with a coin
    if self.level.player.body:enter('Coins') then
        self.sounds.coinPickup:play()
        self.UIelements.score.total = self.UIelements.score.total + 100
        local collision_data = self.level.player.body:getEnterCollisionData('Coins')
        -- gets the reference to the coin object
        local coin = collision_data.collider:getObject()
        coin.status = 'picked-up'
        coin.body:destroy()
        Timer.after(0.40, function() coin.destroyed = true end)
    end

    -- Update score total in caption
    self.UIelements.score.captions[2]:set(tostring(self.UIelements.score.total))
end

function Play:keypressed(key)
    if key == "space" or key == "up" then
        if self.jumpCount < 2 then
            self.sounds.jump:play()
            self.jumpCount = self.jumpCount + 1
            self.level.player.body:applyLinearImpulse(0, -self.level.player.linearImpulse)
        end
    end
end

function Play:draw()
    self.camera:attach()
        self.level:draw()
    self.camera:detach()
    -- UI Elements
    love.graphics.setColor(20/255, 20/255, 20/255, 1)
    love.graphics.rectangle("fill", 0, 0, gameWidth, 32)
    love.graphics.setColor(1, 1, 1, 1)
    -- Lives
    love.graphics.draw(self.UIelements.lives.captions[1], 10, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][1], 10, self.UIelements.score.captions[1]:getHeight(), 0, 2, 2, 0, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][3], 10, self.UIelements.score.captions[1]:getHeight(), 0, 2, 2, -8, 0)
    love.graphics.draw(self.UIelements.lives.captions[2], 10, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, -22, 2)
    -- Score
    love.graphics.draw(self.UIelements.score.captions[1], gameWidth - self.UIelements.score.captions[1]:getWidth(), 0, 0, 1, 1, 10, 0)
    love.graphics.draw(self.UIelements.score.captions[2], gameWidth - 55, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, 0, 2)
    --love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.print("Player Y: " .. tostring(self.level.player.Y), 0, 0)
    --love.graphics.print("Linear Velocity Y: " .. tostring(self.level.player.linearVelocity.y), 0, 20)
    --love.graphics.setLineWidth(1)
    --love.graphics.line(gameWidth / 2, 0, gameWidth / 2, gameHeight)
    --love.graphics.line(0, gameHeight / 2, gameWidth, gameHeight / 2)
end