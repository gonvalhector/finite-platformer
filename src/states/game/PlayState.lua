-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.camera = Camera()

    self.jumpCount = 0

    love.audio.stop()
end

function Play:update(dt)
    self.level:update(dt)
    self.level.player.dx = 0
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.level.player.dx = math.floor(-self.level.player.speed * dt)
    end

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.level.player.dx = math.floor(self.level.player.speed * dt)
    end

    self.level.player.body:setX(self.level.player.body:getX() + self.level.player.dx)
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
    love.graphics.print("Camera X: " .. tostring(self.camera.x), 0, 20)
    love.graphics.print("Camera Scale: " .. tostring(self.camera.scale), 0, 40)
    love.graphics.setLineWidth(1)
    love.graphics.line(gameWidth / 2, 0, gameWidth / 2, gameHeight)
end