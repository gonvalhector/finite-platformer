require 'src/dependencies'

function love.load()
	love.window.setTitle('Finite Platformer')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    local gameWidth, gameHeight = 640, 360
    local windowWidth, windowHeight = love.window.getDesktopDimensions()

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})
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

    push:finish()
end