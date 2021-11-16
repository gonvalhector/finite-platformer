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
require 'src/states/ExitConfirmState'

-- Helper functions and utilities
require 'src/util'

-- Classes
require 'src/Level'
require 'src/Player'

-- Data
require 'src/entity_defs'

-- Images
gImages = {
    ['title-logo'] = love.graphics.newImage('graphics/title.png'),
    ['title-background'] = love.graphics.newImage('graphics/titleScreenBackground.png'),
    ['title-menu'] = love.graphics.newImage('graphics/titleMenu.png'),
    ['key-prompt'] = love.graphics.newImage('graphics/keyPrompt.png'),
    ['player'] = love.graphics.newImage('graphics/player.png')
}
gImages['title-logo']:setFilter('nearest', 'nearest', 16)
gImages['key-prompt']:setFilter('nearest', 'nearest', 16)
gImages['title-menu']:setFilter('nearest', 'nearest', 16)
gImages['player']:setFilter('nearest', 'nearest', 16)

-- Frames
gFrames = {
    ['title-menu'] = GenerateQuads(gImages['title-menu'], 59, 7),
    ['player'] = GenerateQuads(gImages['player'], 20, 19)
}

-- Fonts
gFonts = {
    ['messages'] = love.graphics.newFont('fonts/kenpixel_mini.ttf', 16)
}

-- Music
gMusic = {
    ['title-music'] = love.audio.newSource('music/titleScreenMusic.ogg', 'static')
}
gMusic['title-music']:setVolume(0.25)

-- Sounds
gSounds = {
    ['exit-confirm-in'] = love.audio.newSource('sounds/sfx_sounds_pause5_in.wav', 'static'),
    ['exit-confirm-out'] = love.audio.newSource('sounds/sfx_sounds_pause5_out.wav', 'static'),
    ['menu-cursor'] = love.audio.newSource('sounds/sfx_menu_move1.wav', 'static'),
    ['menu-select'] = love.audio.newSource('sounds/sfx_sounds_pause1_in.wav', 'static')
}