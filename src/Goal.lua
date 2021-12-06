Goal = Class{}

function Goal:init(def)
    self.destroyed = false
    self.visible = true

    self.lvl = def.lvl
    self.size = self.lvl == 5 and 'big' or 'small'

    self.x = def.x
    self.y = def.y
    self.width = 10
    self.height = self.lvl == 5 and 26 or 13

    self.flavor = GOAL_FLAVORS[self.lvl]

    self.world = def.world
    self.body = self.world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.body:setType('static')
    self.body:setCollisionClass('Goal')
    self.body:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
    end)
    self.body:setObject(self)
end

function Goal:update(dt)
    if self.destroyed == false then
        self.x, self.y = self.body:getPosition()
    end
end

function Goal:draw()
    if self.destroyed == false and self.visible == true then
        love.graphics.draw(gImages['ice-cream'], gFrames[self.size .. '-cones'][self.flavor], math.floor(self.x), math.floor(self.y), 0, 1, 1, self.width / 2, self.height / 2)
    end
end