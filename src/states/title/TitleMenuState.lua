-- Title screen menu state
TitleMenu = {}

function TitleMenu:enter(def) 
    self.map = def.map
    self.scroll = def.scroll
    self.background = def.background
    self.sounds = {}
    self.sounds.select = def.selectSound
    self.sounds.cursor = menuCursorSound
    self.logo = {}
    self.logo.image = def.logo
    self.logo.position = {}
    self.logo.position.x = gameWidth / 2
    self.logo.position.y = gameHeight / 2
    
    Timer.tween(0.5, self.logo.position, {x = gameWidth / 2, y = gameHeight / 4})
end

function TitleMenu:update(dt)
    -- Automatically scroll the title screen's background and map, right and left.
    autoScroll(dt, self.map, self.background, self.scroll)
end

function TitleMenu:draw() 
    -- Draw background
    love.graphics.draw(self.background.image, self.background.x, 0)
    -- Draw tilemap
    self.map:draw()
    -- Draw title logo
    love.graphics.draw(self.logo.image, self.logo.position.x, self.logo.position.y, 0, 4, 4, self.logo.image:getWidth() / 2, self.logo.image:getHeight() / 2)
end