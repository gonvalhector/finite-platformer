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
sti = require 'lib/sti'

-- Gamestates
require 'src/states/title/StartState'
require 'src/states/title/TitleMenuState'
require 'src/states/ExitConfirmState'

--[[
    Dependencies
]]
-- Helper functions and utilities
require 'src/util'

-- Images
titleLogo = love.graphics.newImage('graphics/title.png')
titleLogo:setFilter('nearest', 'nearest', 16)
titleScreenBackground = love.graphics.newImage('graphics/titleScreenBackground.png')
keyPrompt = love.graphics.newImage('graphics/keyPrompt.png')
keyPrompt:setFilter('nearest', 'nearest', 16)

-- Fonts
messageFont = love.graphics.newFont('fonts/kenpixel_mini.ttf', 16)

-- Music
titleScreenMusic = love.audio.newSource('music/titleScreenMusic.ogg', 'static')
titleScreenMusic:setVolume(0.25)

-- Sounds
exitConfirmInSound = love.audio.newSource('sounds/sfx_sounds_pause5_in.wav', 'static')
exitConfirmOutSound = love.audio.newSource('sounds/sfx_sounds_pause5_out.wav', 'static')
menuCursorSound = love.audio.newSource('sounds/sfx_menu_move1.wav', 'static')
menuSelectSound = love.audio.newSource('sounds/sfx_sounds_pause1_in.wav', 'static')