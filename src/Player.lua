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
    self.linearImpulse = 200
    self.speed = 200
    self.dx = 0
end

function Player:update(dt)
    self.x, self.y = self.body:getPosition()
end

function Player:draw()
    love.graphics.draw(self.sprite.sheet, self.sprite.frames[1], self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
end