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
require 'src/states/ExitConfirmState'

--[[
    Dependencies
]]

-- Images
titleLogo = love.graphics.newImage('graphics/title.png')
titleScreenBackground = love.graphics.newImage('graphics/titleScreenBackground.png')

-- Fonts
messageFont = love.graphics.newFont('fonts/kenpixel_mini.ttf', 11)

-- Music
titleScreenMusic = love.audio.newSource('music/titleScreenMusic.ogg', 'static')
titleScreenMusic:setVolume(0.25)

-- Sounds
exitConfirmInSound = love.audio.newSource('sounds/sfx_sounds_pause5_in.wav', 'static')
exitConfirmOutSound = love.audio.newSource('sounds/sfx_sounds_pause5_out.wav', 'static')