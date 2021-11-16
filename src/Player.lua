Player = Class{}

function Player:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.width = ENTITY_DEFS['player'].width
    self.height = ENTITY_DEFS['player'].height

    self.sheet = gImages[ENTITY_DEFS['player'].sheet]
    self.animations = ENTITY_DEFS['player'].animations
    self.state = 'idle'
    self.direction = 'right'

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.spawnX, self.spawnY, self.width, self.height)
    self.body:setCollisionClass('Player')
    self.body:setMass(ENTITY_DEFS['player'].mass)
    self.mass = self.body:getMass()
    self.linearImpulse = ENTITY_DEFS['player'].linearImpulse
    self.force = ENTITY_DEFS['player'].force
    self.linearVelocity = {}
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    self.linearVelocity.max = ENTITY_DEFS['player'].maxLinearVelocity
end

function Player:update(dt)
    self.body:setAngle(0)
    self.x, self.y = self.body:getPosition()
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()

    -- reset linear velocity
    if self.linearVelocity.x > -1 and self.linearVelocity.x < 1 then
        self.body:setLinearVelocity(0, self.linearVelocity.y)
    end

    if self.linearVelocity.y > -3 and self.linearVelocity.y < 3 then
        self.body:setLinearVelocity(self.linearVelocity.x, 0)
    end
end

function Player:draw()
    if self.animations[self.state .. '-' .. self.direction].interval then
        love.graphics.draw(self.sheet, self.animations[self.state .. '-' .. self.direction].frames[(math.floor(animationTimer) % #self.animations[self.state .. '-' .. self.direction].frames) + 1], self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
    else
        love.graphics.draw(self.sheet, self.animations[self.state .. '-' .. self.direction].frames[1], self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
    end
end