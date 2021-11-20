Enemy = Class{}

function Enemy:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.type = def.type
    self.width = ENTITY_DEFS[self.type].width
    self.height = ENTITY_DEFS[self.type].height

    self.animations = def.animations
    self.state = 'walk'
    self.direction = 'left'
    self.currentAnimation = self.animations[self.state .. '-' .. self.direction]

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.spawnX, self.spawnY, self.width, self.height)
    self.body:setObject(self)
    self.body:setCollisionClass('Enemy')
    self.body:setMass(ENTITY_DEFS[self.type].mass)
    self.mass = self.body:getMass()
    self.linearImpulse = -ENTITY_DEFS[self.type].linearImpulse
    self.force = ENTITY_DEFS[self.type].force
    self.linearVelocity = {}
    self.linearVelocity.x, self.linearVelocity.y = self.body:getLinearVelocity()
    self.linearVelocity.max = ENTITY_DEFS[self.type].maxLinearVelocity
end

function Enemy:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Enemy:changeDirection()
    self.direction = self.direction == 'left' and 'right' or 'left'
    self.linearImpulse = -self.linearImpulse
end

function Enemy:update(dt)
    self:changeAnimation(self.state .. '-' .. self.direction)
    self.currentAnimation:update(dt)

    -- Change direction on collision with obstacles
    if self.body:enter('Obstacle') then
        self:changeDirection()
    end

    -- Movement
    self.body:applyLinearImpulse(self.linearImpulse, 0)
end

function Enemy:draw()
    local anim = self.currentAnimation
    love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
end