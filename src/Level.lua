-- Handles the data of every stage
Level = Class{}

function Level:init(levelNumber)
    self.map = STI('levels/level' .. tostring(levelNumber) .. '.lua')

    self.background = {}
    self.background.image = gImages['level-1-background']
    self.background.x = 0
    self.background.y = 0

    self.world = WF.newWorld(0, 300, true)
    self.world:addCollisionClass('Player')
    self.world:addCollisionClass('Ground')
    self.world:addCollisionClass('Wall')
    self.world:addCollisionClass('Coins')

    -- Level boundaries and floors
    self.boundaries = {}
    -- Player spawn position
    local playerSpawnX, playerSpawnY
    -- Coins
    self.coins = {}
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
            local collisionClass = object.name == 'Ground' and 'Ground' or 'Wall'
            boundary.body:setCollisionClass(collisionClass)
            boundary.body:setFriction(1)

            boundary.body:setObject(boundary)
            table.insert(self.boundaries, boundary)
        -- Coins
        elseif object.type == "Coins" then
            local coin = {
                destroyed = false,
                x = object.x,
                y = object.y,
                width = object.width,
                height = object.height,
                status = 'not-picked-up',
                animations = createAnimations(ENTITY_DEFS['coins'].animations),
                currentAnimation = nil,
                body = self.world:newCircleCollider(object.x + object.width / 2, object.y + object.height / 2, object.width / 2)
            }
            coin.currentAnimation = coin.animations[coin.status]
            coin.body:setType('static')
            coin.body:setCollisionClass('Coins')
            coin.body:setPreSolve(function(collider_1, collider_2, contact)
                contact:setEnabled(false)
            end)

            coin.body:setObject(coin)
            table.insert(self.coins, coin)
        -- Get Player spawn position
        elseif object.type == "SpawnPoint" and object.name == "PlayerSpawn" then
            playerSpawnX, playerSpawnY = object.x, object.y
        end
    end

    -- Instantiate Player
    def = {
        x = playerSpawnX,
        y = playerSpawnY,
        world = self.world,
        animations = createAnimations(ENTITY_DEFS['player'].animations)
    }
    self.player = Player(def)
end

function Level:update(dt)
    self.map:update(dt)
    self.world:update(dt)
    self.player:update(dt)

    -- Uodate coins
    for k, coin in pairs(self.coins) do
        if coin.destroyed == false then
            coin.currentAnimation = coin.animations[coin.status]
            coin.currentAnimation:update(dt)
        end
    end
end

function Level:draw()
    love.graphics.draw(self.background.image, math.floor(-self.background.x), math.floor(-self.background.y))
    self.map:drawLayer(self.map.layers["Farground"])
    self.map:drawLayer(self.map.layers["Background"])
    self.map:drawLayer(self.map.layers["Midground"])
    -- Coins
    for k, coin in pairs(self.coins) do
        if coin.destroyed == false then
            local anim = coin.currentAnimation
            love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(coin.x), math.floor(coin.y))
        end
    end
    -- Player
    self.player:draw()
    self.map:drawLayer(self.map.layers["Foreground"])
    --self.world:draw()
end