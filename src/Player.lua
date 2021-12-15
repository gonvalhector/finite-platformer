Player = Class{}

function Player:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.width = ENTITY_DEFS['player'].width
    self.height = ENTITY_DEFS['player'].height

    self.animations = def.animations
    self.state = 'idle'
    self.direction = 'right'
    self.currentAnimation = self.animations[self.state .. '-' .. self.direction]

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.spawnX, self.spawnY, self.width - 1, self.height - 1)
    self.body:setObject(self)
    self.body:setCollisionClass('Player')
    self.body:setMass(ENTITY_DEFS['player'].mass)
    self.mass = self.body:getMass()
    self.linearImpulse = ENTITY_DEFS['player'].linearImpulse
    self.force = ENTITY_DEFS['player'].force
    self.linearVelocity = {}
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    self.linearVelocity.max = ENTITY_DEFS['player'].maxLinearVelocity
    self.restitution = self.body:getRestitution()

    self.alpha = 1
    self.invincible = false

    self.checkpoint = {}
    self.checkpoint.x = self.spawnX
    self.checkpoint.y = self.spawnY
end

function Player:changeAnimation(name)
    self.currentAnimation = self.animations[name]
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

    self:changeAnimation(self.state .. '-' .. self.direction)
    self.currentAnimation:update(dt)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    local anim = self.currentAnimation
    love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, 1, 1, self.width / 2, self.height / 2)
    love.graphics.setColor(1, 1, 1, 1)
end