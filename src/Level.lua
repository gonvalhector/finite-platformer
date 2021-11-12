-- Handles the data of every stage
Level = Class{}

function Level:init(levelNumber)
    self.map = STI('levels/level' .. tostring(levelNumber) .. '.lua')
end

function Level:update(dt)
    self.map:update(dt)
end

function Level:draw()
    self.map:draw()
end