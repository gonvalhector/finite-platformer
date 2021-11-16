-- Handles the data of every stage
Level = Class{}

function Level:init(levelNumber)
    self.map = STI('levels/level' .. tostring(levelNumber) .. '.lua')
    self.world = WF.newWorld(0, 300, true)
    self.world:addCollisionClass('Player')
    self.world:addCollisionClass('Boundaries')

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
                body = nil
            }
            table.insert(self.boundaries, boundary)
        elseif object.type == "SpawnPoint" and object.name == "PlayerSpawn" then
            playerSpawnX, playerSpawnY = object.x, object.y
        end
    end
    
    for k, boundary in pairs(self.boundaries) do
        boundary.body = self.world:newRectangleCollider(boundary.x, boundary.y, boundary.width, boundary.height)
        boundary.body:setType('static')
        boundary.body:setCollisionClass('Boundaries')
        
        local friction = newFriction(boundary.type)

        boundary.body:setFriction(friction)
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
    self.world:draw()
end