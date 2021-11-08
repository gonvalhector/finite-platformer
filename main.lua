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
    currentStack = gamestate.getStack()
end

function love.keypressed(key)
    currentState:keypressed(key)
    if key == 'escape' then
        gamestate.push(exitConfirm)
    end
end

function love.draw()
    push:start()
    for i = 1, #currentStack do
        currentStack[i]:draw()
    end
    push:finish()
end