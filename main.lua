require 'src/dependencies'

function love.load()
	love.window.setTitle('Finite Platformer')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    gameWidth, gameHeight = 640, 360
    windowWidth, windowHeight = love.window.getDesktopDimensions()

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
        fullscreen = true,
        resizable = false,
        vsync = true
    })

    gamestate.switch(start)
end

function love.update(dt)
	currentState = gamestate.current()
end

function love.keypressed(key)
    currentState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    currentState:draw()
    push:finish()
end