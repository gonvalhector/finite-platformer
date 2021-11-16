require 'src/dependencies'

function love.load()
	love.window.setTitle('Finite Platformer')
    love.graphics.setDefaultFilter('nearest', 'nearest', 16)
    math.randomseed(os.time())

    gameWidth, gameHeight = 640, 360
    windowWidth, windowHeight = love.window.getDesktopDimensions()

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
        fullscreen = true,
        resizable = false,
        vsync = true
    })

    animationTimer = 0

    Gamestate.registerEvents{'update', 'keypressed'}
    Gamestate.switch(Start)
end

function love.update(dt)
	currentState = Gamestate.current()
    currentStack = Gamestate.getStack()
    Timer.update(dt)
    animationTimer = animationTimer + dt * 10
end

function love.keypressed(key)
    if key == 'escape' and currentState ~= ExitConfirm then
        Gamestate.push(ExitConfirm)
    end
end

function love.draw()
    push:start()
    for i = 1, #currentStack do
        currentStack[i]:draw()
    end
    push:finish()
end