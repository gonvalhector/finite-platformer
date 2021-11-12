-- Game state
Play = {}

function Play:enter(def)
    self.levelNumber = def.lvl
    self.level = Level(self.levelNumber)
    love.audio.stop()
end

function Play:update(dt)
    self.level:update(dt)
end

function Play:draw()
    self.level:draw()
end