Player = Class{}

function Player:init(def)
    self.spawnX = def.x
    self.spawnY = def.y

    self.width = ENTITY_DEFS['player'].width
    self.height = ENTITY_DEFS['player'].height

    self.animations = self:createAnimations(def.animations)
    self.state = 'idle'
    self.direction = 'right'
    self.currentAnimation = self.animations[self.state .. '-' .. self.direction]

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

function Player:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
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
    local anim = self.currentAnimation
    love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
end