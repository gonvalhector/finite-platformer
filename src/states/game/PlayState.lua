-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.jumpCount = 0

    love.audio.stop()
end

function Play:update(dt)
    self.level:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        if self.level.player.linearVelocity.x > -self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(-self.level.player.force, 0)
        end
    end

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        if self.level.player.linearVelocity.x < self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(self.level.player.force, 0)
        end
    end
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
    self.level:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mass: " .. tostring(self.level.player.mass), 0, 0)
    love.graphics.print("Linear Velocity: " .. tostring(self.level.player.linearVelocity.x), 0, 20)
end