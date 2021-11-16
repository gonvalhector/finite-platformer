Player = Class{}

function Player:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.sprite = {}
    self.sprite.sheet = gImages['player']
    self.sprite.frames = gFrames['player']

    self.width = self.sprite.frames[#self.sprite.frames - 1]
    self.height = self.sprite.frames[#self.sprite.frames]

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.spawnX, self.spawnY, self.width, self.height)
    self.body:setCollisionClass('Player')
    self.body:setMass(30)
    self.mass = self.body:getMass()
    self.inertia = self.body:getInertia()
    self.linearImpulse = 5000
    self.force = 12000
    self.linearVelocity = {}
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    self.linearVelocity.max = 300
end

function Player:update(dt)
    self.body:setAngle(0)
    self.x, self.y = self.body:getPosition()
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    if self.linearVelocity.x > -1 and self.linearVelocity.x < 1 then
        self.body:setLinearVelocity(0, self.linearVelocity.y)
    end
end

function Player:draw()
    love.graphics.draw(self.sprite.sheet, self.sprite.frames[1], self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
end