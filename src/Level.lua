-- Handles the data of every stage
Level = Class{}

function Level:init(levelNumber)
    self.lvl = levelNumber
    self.map = STI('levels/level' .. tostring(self.lvl) .. '.lua')

    self.background = {}
    self.background.image = gImages['level-' .. tostring(self.lvl) .. '-background']
    self.background.x = 0
    self.background.y = 0

    self.world = WF.newWorld(0, 300, true)
    self.world:addCollisionClass('Ground')
    self.world:addCollisionClass('Wall')
    self.world:addCollisionClass('Obstacle')
    self.world:addCollisionClass('Checkpoint')
    self.world:addCollisionClass('Resetpoint')
    self.world:addCollisionClass('Coins')
    self.world:addCollisionClass('Hearts')
    self.world:addCollisionClass('Goal')
    self.world:addCollisionClass('Crates')
    self.world:addCollisionClass('Enemy', {ignores = {'Checkpoint'}})
    self.world:addCollisionClass('Player', {ignores = {'Obstacle', 'Checkpoint'}})
    self.world:addCollisionClass('Ghost', {ignores = {'Player', 'Ground', 'Obstacle', 'Resetpoint', 'Wall', 'Checkpoint', 'Coins', 'Hearts', 'Goal', 'Crates', 'Enemy'}})

    -- Level boundaries and floors
    self.boundaries = {}
    -- Player spawn position
    local playerSpawnX, playerSpawnY
    -- Coins
    self.coins = {}
    -- Hearts
    self.hearts = {}
    -- Crates
    self.crates = {}
    -- Enemies
    self.enemies = {}
    -- Goal
    self.goal = nil
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
            boundary.body:setCollisionClass(boundary.type)
            boundary.body:setFriction(1)

            boundary.body:setObject(boundary)
            table.insert(self.boundaries, boundary)
        -- Coins
        elseif object.type == "Coins" then
            local def = {
                x = object.x,
                y = object.y,
                width = object.width,
                height = object.height,
                world = self.world
            }
            local coin = Coin(def)
            table.insert(self.coins, coin)

        -- Crates
        elseif object.type == "Crates" then
            local def = {
                x = object.x,
                y = object.y,
                world = self.world
            }
            local crate = Crate(def)
            table.insert(self.crates, crate)
        
        -- Enemies
        elseif object.type == "Enemies" then
           local  def = {
                x = object.x,
                y = object.y,
                world = self.world,
                type = object.name,
                animations = createAnimations(ENTITY_DEFS[object.name].animations)
            }
            local enemy = Enemy(def)
            table.insert(self.enemies, enemy)

        -- Goal
        elseif object.type == "Goal" then
            local def = {
                x = object.x,
                y = object.y,
                world = self.world,
                lvl = self.lvl
            }
            self.goal = Goal(def)

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
end

function Level:update(dt)
    self.map:update(dt)
    self.world:update(dt)
    self.player:update(dt)

    -- Update coins
    for k, coin in pairs(self.coins) do
        coin:update(dt)
    end
    -- Update hearts
    for k, heart in pairs(self.hearts) do
        heart:update(dt)
    end
    -- Update crates
    for k, crate in pairs(self.crates) do
        crate:update(dt)
    end
    -- Update enemies
    for k, enemy in pairs(self.enemies) do
        enemy:update(dt)
    end
    -- Update goal
    self.goal:update(dt)
end

function Level:draw()
    love.graphics.draw(self.background.image, math.floor(-self.background.x), math.floor(-self.background.y))
    self.map:drawLayer(self.map.layers["Farground"])
    self.map:drawLayer(self.map.layers["Background"])
    self.map:drawLayer(self.map.layers["Midground"])
    -- Coins
    for k, coin in pairs(self.coins) do
        coin:draw()
    end
    -- Hearts
    for k, heart in pairs(self.hearts) do
        heart:draw()
    end
    -- Crates
    for k, crate in pairs(self.crates) do
        crate:draw()
    end
    -- Enemies
    for k, enemy in pairs(self.enemies) do
        enemy:draw()
    end
    -- Goal
    self.goal:draw()
    -- Player
    self.player:draw()
    self.map:drawLayer(self.map.layers["Foreground"])
    --self.world:draw()
end