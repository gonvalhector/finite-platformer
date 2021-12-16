Credits = {}

function Credits:enter(def)
    self.map = STI('levels/credits.lua')

    self.world = WF.newWorld(0, 300, true)
    self.world:addCollisionClass('Ground')
    self.world:addCollisionClass('Player')

    self.boundaries = {}

    -- Iterate over map objects
    for k, object in pairs(self.map.objects) do
        -- Boundaries
        if object.type == "Boundaries" then
            local boundary = {
                type = object.name,
                x = object.x, 
                y = object.y, 
                width = object.width, 
                height = object.height,
                body = self.world:newRectangleCollider(object.x, object.y, object.width, object.height)
            }
            boundary.body:setType('static')
            local collisionClass =  boundary.type == "Ice" and "Ground" or boundary.type
            boundary.body:setCollisionClass(collisionClass)
            local friction = boundary.type == "Ice" and 0.1 or 1
            boundary.body:setFriction(friction)

            boundary.body:setObject(boundary)
            table.insert(self.boundaries, boundary)
        -- Get Player spawn position
        elseif object.type == "SpawnPoint" and object.name == "PlayerSpawn" then
            playerSpawnX, playerSpawnY = object.x, object.y
        end
    end

    -- Instantiate Player
    local def = {
        x = playerSpawnX,
        y = playerSpawnY,
        world = self.world,
        animations = createAnimations(ENTITY_DEFS['player'].animations)
    }
    self.player = Player(def)

    -- Screen alpha
    self.screen = {}
    self.screen.alpha = 0

    -- Credits
    self.credits = {}
    self.credits.image = gImages['credits']
    self.credits.width = self.credits.image:getWidth()
    self.credits.height = self.credits.image:getHeight()
    self.credits.x = gameWidth / 2
    self.credits.y = gameHeight

    -- 'Press Enter to continue' prompt
    self.prompt = {}
    self.prompt.sound = gSounds['menu-select']

    -- Flag for recognizing key input
    self.canPressKey = true

    -- Credits Music
    self.music = {}
    self.music.track = gMusic['credits']
    self.music.volume = 0.5

    love.audio.stop()
    self.music.track:setLooping(true)
    self.music.track:play()

    -- Animate the player
    self.player.direction = 'left'
    Timer.after(1, function() 
        Timer.during(3.23, function()
            self.player.state = 'walk'
            self.player.body:applyLinearImpulse(-100, 0)
         end, 
         function()
            self.player.body:setLinearVelocity(0, 0)
            self.player.state = 'idle'
            Timer.after(1, function()
                Timer.every(0.5, function()
                    self.player.state = self.player.state == 'idle' and 'jump' or 'idle'
                end)
                -- Obscure screen
                Timer.tween(3, self.screen, {alpha = 0.75})
                -- Scroll credits
                Timer.after(3, function()
                    Timer.tween(180, self.credits, {y = -self.credits.height})
                    Timer.after(182, function()
                        -- Music fade out
                        Timer.tween(3, self.music, {volume = 0})
                        -- Obscure screen
                        Timer.tween(3, self.screen, {alpha = 1})
                        -- Switch to start state
                        Timer.after(4, function() Gamestate.switch(Start) end)
                    end)
                end)
            end)
        end)
     end)
end

function Credits:update(dt)
    self.map:update(dt)
    self.world:update(dt)
    self.player:update(dt)
    self.music.track:setVolume(self.music.volume)
end

function Credits:keypressed(key)
    if self.canPressKey then
        if key == 'enter' or key == 'return' then
            self.canPressKey = false
            self.prompt.sound:play()
            Timer.after(0.5, function() Gamestate.switch(Start) end)
        end
    end
end

function Credits:draw()
    self.map:drawLayer(self.map.layers["Farground"])
    self.map:drawLayer(self.map.layers["Background"])
    self.map:drawLayer(self.map.layers["Midground"])
    -- Player character
    self.player:draw()
    self.map:drawLayer(self.map.layers["Foreground"])
    -- Obscure the screen
    love.graphics.setColor(0, 0, 0, self.screen.alpha)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    -- Draw credits
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.credits.image, self.credits.x, self.credits.y, 0, 1, 1, self.credits.width / 2, 0)
end