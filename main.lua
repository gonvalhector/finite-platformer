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
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
	
end

function love.draw()
	push:start()
    love.graphics.clear(0, 0, 1, 1)
    love.graphics.print('Finite Platformer', gameWidth / 2, gameHeight / 2)
    push:finish()
end