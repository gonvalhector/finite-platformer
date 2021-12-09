-- Game state
Play = {}

function Play:enter(def)
    self.lvl = def.lvl
    self.level = Level(self.lvl)

    self.music = gMusic['level-' .. tostring(self.lvl)]
    self.sounds = {}
    self.sounds.jump = 'sounds/sfx_sound_neutral1.wav'
    self.sounds.landing = 'sounds/sfx_movement_jump9_landing.wav'
    self.sounds.coinPickup = 'sounds/sfx_coin_double3.wav'
    self.sounds.heartPickup = 'sounds/sfx_coin_cluster3.wav'
    self.sounds.goalPickup = 'sounds/sfx_coin_cluster5.wav'
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
    self.score = def.score
    self.UIelements.score = {}
    self.UIelements.score.captions = {}
    self.UIelements.score.captions[1] = love.graphics.newText(gFonts['interface'], "Score:")
    self.UIelements.score.captions[2] = love.graphics.newText(gFonts['interface'], tostring(self.score))
    self.UIelements.score.max = 99999
    -- Lives
    self.lives = def.lives
    self.UIelements.lives = {}
    self.UIelements.lives.captions = {}
    self.UIelements.lives.captions[1] = love.graphics.newText(gFonts['interface'], "Lives:")
    self.UIelements.lives.captions[2] = love.graphics.newText(gFonts['interface'], tostring(self.lives))
    self.UIelements.lives.max = 99
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
    self.UIelements.coins.max = 999
     -- Goal
     self.UIelements.goal = {}
     self.UIelements.goal.captions = {}
     self.UIelements.goal.captions[1] = love.graphics.newText(gFonts['interface'], "Get the ice cream!")
     self.UIelements.goal.alpha = 1

    self.jumpCount = 0

    love.audio.stop()
    self.music:setLooping(true)
    self.music:play()

    -- Toggle the alpha channel of the goal caption
    Timer.every(0.75, function() self.UIelements.goal.alpha = self.UIelements.goal.alpha == 1 and 0 or 1 end)
end

function Play:resume()
    self.music:setLooping(true)
    self.music:play()
end

function Play:update(dt)
    self.level:update(dt)
    if self.level.player.state == 'death' then return end
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
    self.level.background.x = ((self.camera.x - self.cameraOrigin.x) / 3) % gameWidth
    self.level.background.y = ((self.camera.y - self.cameraOrigin.y) / 6) % gameHeight

    -- Reset jumps available when the player hits the floor
    if self.jumpCount > 0 then
        if self.level.player.body:enter('Ground') or self.level.player.body:enter('Crates') then
            local landingSound = love.audio.newSource(self.sounds.landing, 'static')
            landingSound:play()
            self.jumpCount = 0
        end
    end

    -- If player collides with a checkpoint
    if self.level.player.body:enter('Checkpoint') then
        -- Get checkpoint data
        local collision_data = self.level.player.body:getEnterCollisionData('Checkpoint')
        local checkpoint = collision_data.collider:getObject()
        -- Update player's checkpoint position
        self.level.player.checkpoint.x = checkpoint.x + (self.level.player.width / 2)
        self.level.player.checkpoint.y = (checkpoint.y + checkpoint.height) - self.level.player.height
    end

    -- If player collides with a resetpoint
    if self.level.player.body:enter('Resetpoint') then
        -- Play sound
        local playerHurtSound = love.audio.newSource(self.sounds.playerHurt, 'static')
        playerHurtSound:play()
        -- Take one heart from Player
        self.UIelements.health.total = self.UIelements.health.total - 1
        -- Change player's state to hurt
        self.level.player.state = 'hurt'
        -- Change player's state to idle after 1 seconds
        Timer.every(0.1, function() self.level.player.alpha = self.level.player.alpha == 1 and 0 or 1 end, 6)
        Timer.after(1, function() self.level.player.state = 'idle' end)
        -- Reset player's position to checkpoint
        self.level.player.body:setLinearVelocity(0, 0)
        self.level.player.body:setPosition(self.level.player.checkpoint.x, self.level.player.checkpoint.y)
    end

    -- If player collides with a coin
    if self.level.player.body:enter('Coins') then
        local coinPickupSound = love.audio.newSource(self.sounds.coinPickup, 'static')
        coinPickupSound:play()
        self.UIelements.coins.total = math.min(self.UIelements.coins.max, self.UIelements.coins.total + 1)
        self.score = math.min(self.UIelements.score.max, self.score + 100)
        local collision_data = self.level.player.body:getEnterCollisionData('Coins')
        -- gets the reference to the coin object
        local coin = collision_data.collider:getObject()
        coin.status = 'picked-up'
        -- destroy coin
        coin.body:destroy()
        Timer.after(0.40, function() coin.destroyed = true end)
    end

    -- If player collides with a heart
    if self.level.player.body:enter('Hearts') then
        local heartPickupSound = love.audio.newSource(self.sounds.heartPickup, 'static')
        heartPickupSound:play()
        self.UIelements.health.total = math.min(self.UIelements.health.max, self.UIelements.health.total + 1)
        local collision_data = self.level.player.body:getEnterCollisionData('Hearts')
        -- gets the reference to the heart object
        local heart = collision_data.collider:getObject()
        -- destroy heart
        heart.body:destroy()
        heart.destroyed = true
    end

    -- if player collides with the goal
    if self.level.player.body:enter('Goal') then
        local collision_data = self.level.player.body:getEnterCollisionData('Goal')
        local goal = collision_data.collider:getObject()
        if goal.visible == true and goal.destroyed == false then
            local goalPickupSound = love.audio.newSource(self.sounds.goalPickup, 'static')
            goalPickupSound:play()
            -- destroy goal
            goal.body:destroy()
            goal.destroyed = true
            -- Change to next level
            self.lvl = self.lvl + 1
            local def = {
                lvl = self.lvl,
                score = self.score,
                lives = self.lives
            }
            Timer.after(0.5, function() Gamestate.push(Victory, def) end)
        end
    end

    -- If player collides with an enemy
    if self.level.player.body:enter('Enemy') and self.level.player.state ~= 'hurt' then
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
            self.score = math.min(self.UIelements.score.max, self.score + 200)
            -- Change enemy's state to hurt
            enemy.state = 'hurt'
            -- Spawn a heart
            if math.random(2) == 1 then
                local def = {
                    x = enemy.body:getX(),
                    y = enemy.body:getY(),
                    world = self.level.world
                }
                local heart = Heart(def)
                table.insert(self.level.hearts, heart)
            end
            -- Destroy enemy's body
            enemy.body:setCollisionClass('Ghost')
            enemy.body:setAngularVelocity(12.5)
            Timer.after(5, function() 
                enemy.destroyed = true
                enemy.body:destroy()
            end)
        -- When player touches enemy
        else
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

    -- Update UI totals in captions
    self.UIelements.lives.captions[2]:set(tostring(self.lives))
    self.UIelements.score.captions[2]:set(tostring(self.score))
    self.UIelements.coins.captions[2]:set(tostring(self.UIelements.coins.total))

    -- Restart level if player loses all health
    if self.UIelements.health.total <= 0 and self.level.player.state ~= 'death' then
        -- Update player's state
        self.level.player.state = 'death'
        -- If there are no lives left
        if self.lives - 1 < 0 then
            -- Switch to game over state
            Timer.after(0.5, function()
                Gamestate.switch(Gameover)
            end)
        -- If there are still lives left
        else
            -- Update lives
            self.lives = math.max(0, self.lives - 1)
            -- Restart level
            Timer.after(0.5, function()
                local def = {
                    lvl = self.lvl,
                    score = self.score,
                    lives = self.lives
                }
                Gamestate.push(Restart, def)
            end)
        end
    end

    -- Level Objectives
    if self.lvl == 1 then
        self.level.goal.visible = true
    elseif self.lvl == 2 then
        if self.UIelements.coins.total >= 150 then
            self.level.goal.visible = true
        end
    end

    -- Remove destroyed entitites
    self:clean(self.level.coins, self.level.hearts, self.level.crates, self.level.enemies)
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

    if key == "p" then
        Gamestate.push(Pause)
    end
end

function Play:draw()
    self.camera:attach()
        self.level:draw()
    self.camera:detach()
    -- UI Elements
    love.graphics.setColor(20/255, 20/255, 20/255, 1)
    love.graphics.rectangle("fill", 0, 0, gameWidth, 32)
    love.graphics.setColor(240/255, 238/255, 236/255, 1)
    -- Lives
    love.graphics.draw(self.UIelements.lives.captions[1], 10, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][1], 10, self.UIelements.lives.captions[1]:getHeight(), 0, 2, 2, 0, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][3], 10, self.UIelements.lives.captions[1]:getHeight(), 0, 2, 2, -8, 0)
    if self.lives == self.UIelements.lives.max then love.graphics.setColor(241/255, 187/255, 59/255, 1) else love.graphics.setColor(240/255, 238/255, 236/255, 1) end
    love.graphics.draw(self.UIelements.lives.captions[2], 10, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, -22, 2)
    -- Health
    love.graphics.setColor(240/255, 238/255, 236/255, 1)
    love.graphics.draw(self.UIelements.health.captions[1], 22 + self.UIelements.lives.captions[1]:getWidth(), 0)
    -- Full hearts
    local heartIndex = 1
    for i = 1, self.UIelements.health.total do
        heartIndex = heartIndex + 1
        love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][4], 22 + self.UIelements.lives.captions[1]:getWidth(), self.UIelements.health.captions[1]:getHeight(), 0, 2, 2, -((8 * i) - 8), 0)
    end
    -- Empty hearts
    for i = heartIndex, self.UIelements.health.max do
        love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][5], 22 + self.UIelements.lives.captions[1]:getWidth(), self.UIelements.health.captions[1]:getHeight(), 0, 2, 2, -((8 * i) - 8), 0)
    end
    -- Goal
    love.graphics.setColor(240/255, 238/255, 236/255, self.UIelements.goal.alpha)
    if self.level.goal.destroyed == false and self.level.goal.visible == true then
        love.graphics.draw(self.UIelements.goal.captions[1], gameWidth / 2, 14, 0, 1, 1, math.floor(self.UIelements.goal.captions[1]:getWidth() / 2), math.floor(self.UIelements.goal.captions[1]:getHeight() / 2))
    end
    -- Coins
    love.graphics.setColor(240/255, 238/255, 236/255, 1)
    love.graphics.draw(self.UIelements.coins.captions[1], 500, 0)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][2], 500, self.UIelements.coins.captions[1]:getHeight(), 0, 2, 2)
    love.graphics.draw(gImages['ui-elements'], gFrames['ui-elements'][3], 516, self.UIelements.coins.captions[1]:getHeight(), 0, 2, 2)
    if self.UIelements.coins.total == self.UIelements.coins.max then love.graphics.setColor(241/255, 187/255, 59/255, 1) else love.graphics.setColor(240/255, 238/255, 236/255, 1) end
    love.graphics.draw(self.UIelements.coins.captions[2], 532, self.UIelements.coins.captions[1]:getHeight(), 0, 1.4, 1.4, 0, 2)
    -- Score
    love.graphics.setColor(240/255, 238/255, 236/255, 1)
    love.graphics.draw(self.UIelements.score.captions[1], gameWidth - self.UIelements.score.captions[1]:getWidth(), 0, 0, 1, 1, 10, 0)
    if self.score == self.UIelements.score.max then love.graphics.setColor(241/255, 187/255, 59/255, 1) else love.graphics.setColor(240/255, 238/255, 236/255, 1) end
    love.graphics.draw(self.UIelements.score.captions[2], gameWidth - 55, self.UIelements.score.captions[1]:getHeight(), 0, 1.4, 1.4, 0, 2)

    --love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.print("LVL: " .. tostring(self.level.goal.lvl), 0, gameHeight - 20)
    --love.graphics.print("Checkpoint Y: " .. tostring(self.level.player.checkpoint.y), 0, gameHeight - 10)
    --love.graphics.setLineWidth(1)
    --love.graphics.line(gameWidth / 2, 0, gameWidth / 2, gameHeight)
    --love.graphics.line(0, gameHeight / 2, gameWidth, gameHeight / 2)
end

-- Remove destroyed entitites
function Play:clean(coins, hearts, crates, enemies)
    local destroyIndex = 0
    -- Remove destroyed coins from level
    for i = 1, #coins do
        if coins[i].destroyed then
            destroyIndex = i
            break
        end
    end
    if destroyIndex ~= 0 then table.remove(coins, destroyIndex) end
    destroyIndex = 0
    -- Remove destroyed hearts from level
    for i = 1, #hearts do
        if hearts[i].destroyed then
            destroyIndex = i
            break
        end
    end
    if destroyIndex ~= 0 then table.remove(hearts, destroyIndex) end
    destroyIndex = 0
    -- Remove destroyed crates from level
    for i = 1, #crates do
        if crates[i].destroyed then
            destroyIndex = i
            break
        end
    end
    if destroyIndex ~= 0 then table.remove(crates, destroyIndex) end
    destroyIndex = 0
    -- Remove destroyed enemies from level
    for i = 1, #enemies do
        if enemies[i].destroyed then
            destroyIndex = i
            break
        end
    end
    if destroyIndex ~= 0 then table.remove(enemies, destroyIndex) end
    destroyIndex = 0
end