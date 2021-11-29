Heart = Class{}

function Heart:init(def)
    self.destroyed = false

    self.x = def.x
    self.y = def.y
    self.width = ENTITY_DEFS['hearts'].width
    self.height = ENTITY_DEFS['hearts'].height

    self.status = 'not-picked-up'
    self.animations = createAnimations(ENTITY_DEFS['coins'].animations)
    self.currentAnimation = self.animations[self.status]

    self.world = def.world
    self.body = self.world:newCircleCollider(self.x + self.width / 2, self.y + self.height / 2, self.width / 2)
    self.body:setType('static')
    self.body:setCollisionClass('Hearts')
    self.body:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
    end)
    self.body:setObject(self)
end

function Heart:update(dt)
    if self.destroyed == false then
        self.currentAnimation = self.animations[self.status]
        self.currentAnimation:update(dt)
    end
end

function Heart:draw(dt)
    if self.destroyed == false then
        local anim = self.currentAnimation
        love.graphics.draw(gImages[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.x), math.floor(self.y))
    end
end