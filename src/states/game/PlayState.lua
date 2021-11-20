-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.music = gMusic['level-' .. tostring(self.levelNumber)]
    self.sounds = {}
    self.sounds.jump = 'sounds/sfx_sound_neutral1.wav'
    self.sounds.landing = 'sounds/sfx_movement_jump9_landing.wav'
    self.sounds.coinPickup = 'sounds/sfx_coin_double3.wav'
    self.sounds.impact = 'sounds/sfx_sounds_impact7.wav'
    self.sounds.playerHurt = 'sounds/sfx_sounds_damage1.wav'
    self.sounds.enemyHurt = 'sounds/sfx_sounds_button11.wav'

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
    -- Health
    self.UIelements.health = {}
    self.UIelements.health.max = 3
    self.UIelements.health.total = self.UIelements.health.max
    self.UIelements.health.captions = {}
    self.UIelements.health.captions[1] = love.graphics.newText(gFonts['interface'], "Health:")
    -- Coins
    self.UIelements.coins = {}
    self.UIelements.coins.total = 0
    self.UIelements.coins.captions = {}
    self.UIelements.coins.captions[1] = love.graphics.newText(gFonts['interface'], "Coins:")
    self.UIelements.coins.captions[2] = love.graphics.newText(gFonts['interface'], tostring(self.UIelements.coins.total))

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
        if self.level.player.state ~= 'hurt' then
            self.level.player.state = self.jumpCount == 0 and 'idle' or 'jump'
        end
    end

    -- Update camera
    self.camera.x = math.floor(math.max(self.cameraOrigin.x, self.cameraOrigin.x + math.min(16 * self.level.map.width - gameWidth, self.level.player.body:getX() - gameWidth / 2)))
    self.camera.y = math.floor(math.max(self.cameraOrigin.y, self.cameraOrigin.y + math.min(16 * self.level.map.height - gameHeight, self.level.player.body:getY() - gameHeight / 2)))

    -- Update level's background
    self.level.background.x = ((self.camera.x - self.cameraOrigin.x) / 3) % 256
    self.level.background.y = ((self.camera.y - self.cameraOrigin.y) / 6) % 256

    -- Reset jumps available when the player hits the floor
    if self.jumpCount > 0 then
        if self.level.player.body:enter('Ground') or self.level.player.body:enter('Obstacle') then
            local landingSound = love.audio.newSource(self.sounds.landing, 'static')
            landingSound:play()
            self.jumpCount = 0
        end
    end

    -- If player collides with a coin
    if self.level.player.body:enter('Coins') then
        local coinPickupSound = love.audio.newSource(self.sounds.coinPickup, 'static')
        coinPickupSound:play()
        self.UIelements.coins.total = self.UIelements.coins.total + 1
        self.UIelements.score.total = self.UIelements.score.total + 100
        local collision_data = self.level.player.body:getEnterCollisionData('Coins')
        -- gets the reference to the coin object
        local coin = collision_data.collider:getObject()
        coin.status = 'picked-up'
        coin.body:destroy()
        Timer.after(0.40, function() coin.destroyed = true end)
    end

    -- If player collides with an enemy
    if self.level.player.body:enter('Enemy') then
        -- Play impact sound
        local impactSound = love.audio.newSource(self.sounds.impact, 'static')
        impactSound:play()
        local collision_data = self.level.player.body:getEnterCollisionData('Enemy')
        local enemy = collision_data.collider:getObject()
        -- when player jumps on top of enemy
        if self.jumpCount > 0 then
            -- Play sound
            local enemyHurtSound = love.audio.newSource(self.sounds.enemyHurt, 'static')
            enemyHurtSound:play()
            -- Add to score
            self.UIelements.score.total = self.UIelements.score.total + 200
            -- Change enemy's state to hurt
            enemy.state = 'hurt'
            -- Destroy enemy's body
            enemy.canHurt = false
            Timer.after(0.40, function() 
                enemy.destroyed = true 
                enemy.body:destroy()
            end)
        -- When player touches enemy
        else
            if enemy.canHurt then
                -- Play sound
                local playerHurtSound = love.audio.newSource(self.sounds.playerHurt, 'static')
                playerHurtSound:play()
                -- Take one heart from Player
                self.UIelements.health.total = self.UIelements.health.total - 1
                -- Change enemy's direction
                enemy:changeDirection()
                -- Knock the player back
                local knockback = self.level.player.direction == 'right' and -self.level.player.linearImpulse or self.level.player.linearImpulse
                self.level.player.body:applyLinearImpulse(knockback, 0)
                -- Change player's state to hurt
                self.level.player.state = 'hurt'
                -- Change player's state to idle after 1 seconds
                Timer.every(0.1, function() self.level.player.alpha = self.level.player.alpha == 1 and 0 or 1 end, 6)
                Timer.after(1, function() self.level.player.state = 'idle' end)
            end
        end
    end

    -- Update UI totals in captions
    self.UIelements.lives.captions[2]:set(tostring(self.UIelements.lives.total))
    self.UIelements.score.captions[2]:set(tostring(self.UIelements.score.total))
    self.UIelements.coins.captions[2]:set(tostring(self.UIelements.coins.total))
end

function Play:keypressed(key)
    if key == "space" or key == "up" then
        if self.jumpCount < 2 then
            local jumpSound = love.audio.newSource(self.sounds.jump, 'static')
            jumpSound:setVolume(0.5)
            jumpSound:play()
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
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][1], 10, self.UIelements.lives.captions[1]:getHeight(), 0, 2, 2, 0, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][3], 10, self.UIelements.lives.captions[1]:getHeight(), 0, 2, 2, -8, 0)
    love.graphics.draw(self.UIelements.lives.captions[2], 10, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, -22, 2)
    -- Health
    love.graphics.draw(self.UIelements.health.captions[1], 20 + self.UIelements.lives.captions[1]:getWidth(), 0)
    -- Full hearts
    local heartIndex = 1
    for i = 1, self.UIelements.health.total do
        heartIndex = heartIndex + 1
        love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][4], 20 + self.UIelements.lives.captions[1]:getWidth(), self.UIelements.health.captions[1]:getHeight(), 0, 2, 2, -((8 * i) - 8), 0)
    end
    -- Empty hearts
    for i = heartIndex, self.UIelements.health.max do
        love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][5], 20 + self.UIelements.lives.captions[1]:getWidth(), self.UIelements.health.captions[1]:getHeight(), 0, 2, 2, -((8 * i) - 8), 0)
    end
    -- Coins
    love.graphics.draw(self.UIelements.coins.captions[1], 500, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][2], 500, self.UIelements.coins.captions[1]:getHeight(), 0, 2, 2)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][3], 516, self.UIelements.coins.captions[1]:getHeight(), 0, 2, 2)
    love.graphics.draw(self.UIelements.coins.captions[2], 532, self.UIelements.coins.captions[1]:getHeight(), 0, 1.4, 1.4, 0, 2)
    -- Score
    love.graphics.draw(self.UIelements.score.captions[1], gameWidth - self.UIelements.score.captions[1]:getWidth(), 0, 0, 1, 1, 10, 0)
    love.graphics.draw(self.UIelements.score.captions[2], gameWidth - 55, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, 0, 2)

    --love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.print("Enemy mass: " .. tostring(self.level.enemies[1].mass), 0, gameHeight - 20)
    --love.graphics.print("Linear Velocity Y: " .. tostring(self.level.player.linearVelocity.y), 0, 20)
    --love.graphics.setLineWidth(1)
    --love.graphics.line(gameWidth / 2, 0, gameWidth / 2, gameHeight)
    --love.graphics.line(0, gameHeight / 2, gameWidth, gameHeight / 2)
end