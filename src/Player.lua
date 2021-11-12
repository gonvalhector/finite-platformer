Player = Class{}

function Player:init(def)
    self.x = def.x
    self.y = def.y

    self.sprite = {}
    self.sprite.sheet = gImages['player']
    self.sprite.frames = gFrames['player']

    self.width = self.sprite.frames[#self.sprite.frames - 1]
    self.height = self.sprite.frames[#self.sprite.frames]

    self.world = def.world
    self.body = love.physics.newBody(self.world, self.x + (self.width / 2), self.y - (self.height / 2), 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Player:update(dt, world) 
    self.world = world
end

function Player:draw()
    love.graphics.draw(self.sprite.sheet, self.sprite.frames[1], self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2, self.height / 2)
    --love.graphics.setColor(0, 1, 0, 1)
    --love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end