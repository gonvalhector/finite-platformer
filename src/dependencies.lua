--[[
    Libraries and dependencies
]]

-- Resolution-handling
push = require 'lib/push'
-- Helper Utilities for a Multitude of Problems
class = require 'lib/hump/class'
timer = require 'lib/hump/timer'
gamestate = require 'lib/hump/gamestate'
camera = require 'lib/hump/camera'
-- Simple-Tiled-Implementation
sti = require 'lib/sti'

-- Gamestates
require 'src/states/title/StartState'
require 'src/states/ExitConfirmState'

-- Images
titleLogo = love.graphics.newImage('graphics/title.png')

-- Fonts
messageFont = love.graphics.newFont('fonts/kenpixel_mini.ttf', 11)