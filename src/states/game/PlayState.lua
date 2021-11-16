-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)

    self.camera = Camera()
    self.cameraOrigin = {}
    self.cameraOrigin.x = self.camera.x
    self.cameraOrigin.y = self.camera.y

    self.jumpCount = 0

    love.audio.stop()
end

function Play:update(dt)
    self.level:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.level.player.direction = 'left'
        self.level.player.state = 'walking'
        if self.level.player.linearVelocity.x > -self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(-self.level.player.force, 0)
        end
    end

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.level.player.direction = 'right'
        self.level.player.state = 'walking'
        if self.level.player.linearVelocity.x < self.level.player.linearVelocity.max then
            self.level.player.body:applyForce(self.level.player.force, 0)
        end
    end

    -- Update camera
    self.camera.x = math.floor(math.max(self.cameraOrigin.x, self.cameraOrigin.x + math.min(16 * self.level.map.width - gameWidth, self.level.player.body:getX() - gameWidth / 2)))
    self.camera.y = math.floor(math.max(self.cameraOrigin.y, self.cameraOrigin.y + math.min(16 * self.level.map.height - gameHeight, self.level.player.body:getY() - gameHeight / 2)))

    -- Reset jumps available when the player hits the floor
    if self.level.player.body:enter('Boundaries') then
        self.jumpCount = 0
    end
end

function Play:keypressed(key)
    if key then
        if key == "space" or key == "up" then
            if self.jumpCount < 2 then
                self.level.player.state = 'jumping'
                self.jumpCount = self.jumpCount + 1
                self.level.player.body:applyLinearImpulse(0, -self.level.player.linearImpulse)
            end
        end
    else
        self.level.player.state = 'idle'
    end
end

function Play:draw()
    self.camera:attach()
        self.level:draw()
    self.camera:detach()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Player Y: " .. tostring(self.level.player.Y), 0, 0)
    love.graphics.print("Linear Velocity Y: " .. tostring(self.level.player.linearVelocity.y), 0, 20)
    love.graphics.setLineWidth(1)
    love.graphics.line(gameWidth / 2, 0, gameWidth / 2, gameHeight)
    love.graphics.line(0, gameHeight / 2, gameWidth, gameHeight / 2)
end