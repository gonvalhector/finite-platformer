--[[
    Libraries
]]

-- Resolution-handling
push = require 'lib/push'

-- Helper Utilities for a Multitude of Problems
Class = require 'lib/hump/class'
Timer = require 'lib/hump/timer'
Gamestate = require 'lib/hump/gamestate'
Camera = require 'lib/hump/camera'

-- Simple-Tiled-Implementation
STI = require 'lib/sti'

-- Windfield
WF = require 'lib/windfield'

-- Animation Class
require 'lib/Animation'

--[[
    Dependencies
]]

-- Gamestates
require 'src/states/title/StartState'
require 'src/states/title/TitleMenuState'
require 'src/states/game/PlayState'
require 'src/states/game/PauseState'
require 'src/states/game/RestartState'
require 'src/states/game/GameoverState'
require 'src/states/ExitConfirmState'

-- Helper functions and utilities
require 'src/util'

-- Classes
require 'src/Level'
require 'src/Player'
require 'src/Enemy'
require 'src/Coin'
require 'src/Heart'
require 'src/Crate'

-- Data
require 'src/constants'
require 'src/entity_defs'

-- Images
gImages = {
    ['title-logo'] = love.graphics.newImage('graphics/title.png'),
    ['title-background'] = love.graphics.newImage('graphics/titleScreenBackground.png'),
    ['title-menu'] = love.graphics.newImage('graphics/titleMenu.png'),
    ['key-prompt'] = love.graphics.newImage('graphics/keyPrompt.png'),
    ['player'] = love.graphics.newImage('graphics/player.png'),
    ['level-1-background'] = love.graphics.newImage('graphics/level1Background.png'),
    ['gameover-background'] = love.graphics.newImage('graphics/gameoverBackground.png'),
    ['coins'] = love.graphics.newImage('graphics/coins.png'),
    ['crates'] = love.graphics.newImage('graphics/crates.png'),
    ['ui-elements'] = love.graphics.newImage('graphics/ui_elements.png'),
    ['enemies-a'] = love.graphics.newImage('graphics/enemies_a.png'),
    ['captions'] = love.graphics.newImage('graphics/captions.png')
}
for k, image in pairs(gImages) do
    gImages[k]:setFilter('nearest', 'nearest', 16)
end

-- Frames
gFrames = {
    ['title-menu'] = GenerateQuads(gImages['title-menu'], 59, 7),
    ['player'] = GenerateQuads(gImages['player'], 20, 18),
    ['coins'] = GenerateQuads(gImages['coins'], 16, 16),
    ['crates'] = GenerateQuads(gImages['crates'], 16, 16),
    ['ui-elements'] = GenerateQuads(gImages['ui-elements'], 8, 8),
    ['enemies-a'] = GenerateQuads(gImages['enemies-a'], 16, 16),
    ['captions'] = GenerateQuads(gImages['captions'], 242, 28)
}

-- Fonts
gFonts = {
    ['messages'] = love.graphics.newFont('fonts/kenpixel_mini.ttf', 16),
    ['interface'] = love.graphics.newFont('fonts/Sharp Retro.ttf', 16)
}

-- Music
gMusic = {
    ['title-music'] = love.audio.newSource('music/titleScreenMusic.ogg', 'static'),
    ['level-1'] = love.audio.newSource('music/level1.ogg', 'static'),
    ['gameover'] = love.audio.newSource('music/gameover.ogg', 'static')
}
gMusic['title-music']:setVolume(0.25)
gMusic['level-1']:setVolume(0.25)
gMusic['gameover']:setVolume(0.5)

-- Sounds
gSounds = {
    ['exit-confirm-in'] = love.audio.newSource('sounds/sfx_sounds_pause5_in.wav', 'static'),
    ['exit-confirm-out'] = love.audio.newSource('sounds/sfx_sounds_pause5_out.wav', 'static'),
    ['menu-cursor'] = love.audio.newSource('sounds/sfx_menu_move1.wav', 'static'),
    ['menu-select'] = love.audio.newSource('sounds/sfx_sounds_pause1_in.wav', 'static'),
    ['restart'] = love.audio.newSource('sounds/game_over_bad_chest.wav', 'static'),
    ['pause-in'] = love.audio.newSource('sounds/sfx_sounds_pause4_in.wav', 'static'),
    ['pause-out'] = love.audio.newSource('sounds/sfx_sounds_pause4_out.wav', 'static')
}