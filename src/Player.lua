Player = Class{}

function Player:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.x = self.spawnX
    self.y = self.spawnY

    self.sprite = {}
    self.sprite.sheet = gImages['player']
    self.sprite.frames = gFrames['player']

    self.width = self.sprite.frames[#self.sprite.frames - 1]
    self.height = self.sprite.frames[#self.sprite.frames]

    self.world = def.world
    self.body = love.physics.newBody(self.world, self.spawnX + (self.width / 2), self.spawnY - (self.height / 2), 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setMass(30)
    self.mass = self.body:getMass()
    self.linearVelocity = {}
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    self.linearVelocity.max = 200
    self.force = 10000
    self.linearImpulse = 5000
end

function Player:update(dt)
    self.x, self.y = self.body:getPosition()
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
end

function Player:draw()
    love.graphics.draw(self.sprite.sheet, self.sprite.frames[1], self.x, self.y, self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
    --love.graphics.setColor(0, 1, 0, 0.5)
    --love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end