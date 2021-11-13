-- Handles the data of every stage
Level = Class{}

function Level:init(levelNumber)
    self.map = STI('levels/level' .. tostring(levelNumber) .. '.lua')
    self.world = love.physics.newWorld(0, 300)

    -- Level boundaries and floors
    self.boundaries = {}
    local playerSpawnX, playerSpawnY
    for k, object in pairs(self.map.objects) do
        if object.type == "Boundaries" then
            local boundary = {
                type = object.name,
                x = object.x, 
                y = object.y, 
                width = object.width, 
                height = object.height,
                body = nil,
                shape = nil,
                fixture = nil
            }
            table.insert(self.boundaries, boundary)
        elseif object.type == "SpawnPoint" and object.name == "PlayerSpawn" then
            playerSpawnX, playerSpawnY = object.x, object.y
        end
    end
    
    for k, boundary in pairs(self.boundaries) do
        boundary.body = love.physics.newBody(self.world, boundary.x + ( boundary.width / 2), boundary.y + (boundary.height / 2), 'static')
        boundary.shape = love.physics.newRectangleShape(boundary.width, boundary.height)
        boundary.fixture = love.physics.newFixture(boundary.body, boundary.shape)
        
        local friction = newFriction(boundary.type)

        boundary.fixture:setFriction(friction)
        boundary.fixture:setUserData(boundary.type)
    end

    -- Player
    def = {
        x = playerSpawnX,
        y = playerSpawnY,
        world = self.world
    }
    self.player = Player(def)
end

function Level:update(dt)
    self.map:update(dt)
    self.world:update(dt)
    self.player:update(dt)
end

function Level:draw()
    self.map:drawLayer(self.map.layers["Farground"])
    self.map:drawLayer(self.map.layers["Background"])
    self.map:drawLayer(self.map.layers["Midground"])
    self.player:draw()
    self.map:drawLayer(self.map.layers["Foreground"])
end