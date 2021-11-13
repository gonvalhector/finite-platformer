-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.lastX = 0

    self.camera = Camera()
    self.looksAtX = self.camera.x
    self.looksAtY = self.camera.y

    self.jumpCount = 0

    love.audio.stop()
end

function Play:update(dt)
    self.level:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        if self.level.player.linearVelocity.x > -self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(-self.level.player.force, 0)
        end
        -- update camera to the left
        if self.level.player.x >= gameWidth / 2 and self.level.player.x <= (self.level.map.width * 16) - (gameWidth / 2) then
            self.looksAtX = self.looksAtX + (self.level.player.x - self.lastX)
        end
    end

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        if self.level.player.linearVelocity.x < self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(self.level.player.force, 0)
        end
        -- update camera to the right
        if self.level.player.x >= gameWidth / 2 and self.level.player.x <= (self.level.map.width * 16) - (gameWidth / 2) then
            self.looksAtX = self.looksAtX + (self.level.player.x - self.lastX)
        end
    end
    self.camera:lookAt(self.looksAtX, self.looksAtY)
    self.lastX = self.level.player.x
end

function Play:keypressed(key)
    if key == "space" or key == "up" then
        if self.jumpCount < 2 then
            self.jumpCount = self.jumpCount + 1
            self.level.player.body:applyLinearImpulse(0, -self.level.player.linearImpulse)
        end
    end
end

function Play:draw()
    self.camera:attach()
        self.level:draw()
    self.camera:detach()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Player X: " .. tostring(self.level.player.x), 0, 0)
    love.graphics.print("Player Last X: " .. tostring(self.lastX), 0, 20)
end