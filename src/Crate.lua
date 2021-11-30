Crate = Class{}

function Crate:init(def)
    self.color = CRATE_COLORS[math.random(4)]
    self.destroyed = false

    self.spawnX = def.x
    self.spawnY = def.y
    self.x = self.spawmX
    self.y = self.spawnY
    self.width = ENTITY_DEFS[tostring(self.color) .. '-crates'].width
    self.height = ENTITY_DEFS[tostring(self.color) .. '-crates'].height

    self.status = 'unbroken'
    self.animations = createAnimations(ENTITY_DEFS[tostring(self.color) .. '-crates'].animations)
    self.currentAnimation = self.animations[self.status]

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.spawnX, self.spawnY, self.width - 1, self.height - 1)
    self.body:setType('dynamic')
    self.body:setCollisionClass('Crates')
    self.body:setObject(self)
    self.body:setMass(ENTITY_DEFS[tostring(self.color) .. '-crates'].mass)
    self.mass = self.body:getMass()
    self.angle = self.body:getAngle()
end

function Crate:update(dt)
    if self.destroyed == false then
        self.x, self.y = self.body:getPosition()
        self.angle = self.body:getAngle()
        self.currentAnimation = self.animations[self.status]
        self.currentAnimation:update(dt)
    end
end

function Crate:draw(dt)
    if self.destroyed == false then
        local anim = self.currentAnimation
        love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.x), math.floor(self.y), self.angle, 1, 1, self.width / 2, self.height / 2)
    end
end