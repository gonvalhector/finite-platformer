# Finite Platformer

## About

**Finite Platformer** is a 2D platformer game made by [Hector Gonzalez](https://www.gonvalhector.com/) with the **LÖVE** framework and written in ***Lua***.  
Intended as my submission for the final project of the **"CS50’s Introduction to Game Development"** online course.

## Installation

1. Install [LÖVE 11.3](https://love2d.org/).
2. Download the repository's [zip file](https://github.com/gonvalhector/finite-platformer/archive/refs/heads/main.zip).
3. Drag and drop the ***/finite-platformer-main*** folder into ***love.exe***.

## How To Play

| Action | Keys |
| ----------- | ----------- |
| Accept | Enter or Return |
| Jump | Space |
| Right | D or Right Arrow Key |
| Left | A or Left Arrow Key |
| Pause | Escape or P |

## Objective

Traverse through five levels and complete their specific objectives to make the **ice cream** item appear, which gives you access to the next level:
1. Get the ice cream at the end of the level.
2. Get all coins.
3. Destroy all enemies.
4. Get the ice cream at the top.
5. Get all coins and destroy all enemies.

## Technical Overview

### LÖVE Libraries

Found inside the **/lib** folder:

#### Push

Resolution-handling library that allows the user to focus on making their game with a fixed resolution.  
Used in **Finite Platformer** for creating a virtual in-game resolution of 640px by 360px that gets upscaled to whatever resolution the player's desktop uses.

#### HUMP

**Helper Utilities for Massive Progression** is a small collection of tools for developing games with **LÖVE**.  
Used in **Finite Platformer** for creating game objects with the help of classes, the switching and pushing/popping of states with gamestates, 
the camera that tracks the player's movement and the timing and tweening of certain actions with timers.

#### STI

**Simple Tiled Implementation** is a [Tiled](https://www.mapeditor.org/) map loader and renderer designed for **LÖVE**.  
Used in **Finite Platformer** for loading the maps/levels created with **Tiled** and exported as ***lua*** files, and for rendering each layer and object in the maps.

#### Windfield

A physics module for **LÖVE** that wraps its physics API so that using **box2d** becomes as simple as possible.  
Used in **Finite Platformer** for creating a simple collider per object, simplying collision detection and creating collision classes to easily establish what can collide with what.

#### Animations

A class that simplifies animating sprites.  
Used in **Finite Platformer** for animating all entities, such as the playable character, the enemies and coins.

### Helper functions and Utilities

Found in ***util.lua***:

#### autoScroll

Auto scrolls the title screen's background and map, right and left.

#### GenerateQuads

Given an "atlas" (a texture with multiple sprites), as well as a width and a height for the tiles therein,
split the texture into all the quads by simply dividing it evenly.

#### createAnimations

Given a table with data, returns a table with animations created based on the data.

### Source files

Found inside ***/src*** folder:

#### Coin.lua

Manages a class to create, update and render a coin object in-game.

#### constants.lua

States tables with data that is not going to change for use in other files.

#### Crate.lua

Manages a class to create, update and render a crate/box object in-game.

#### dependencies.lua

States all rquired libraries, files and resources that the game needs.

#### Enemy.lua

Manages a class to create, update, render and change directions when bumping into something for an enemy object in-game.

#### entity_defs.lua

Contains tables with data relevant for all entities such as the playable character, enemies, coins, goals and crates.

#### Goal.lua

Manages a class to create, update and render a goal/ice cream object in-game.

#### Heart.lua

Manages a class to create, update and render a heart object in-game.

#### Level.lua

Manages a class that creates a level based on a **Tiled** map using **STI**, creates a physics world for it with **Windfield**, states all its collision classes, and instantiates in-game objects for every object found in each **Tiled** map, like coins, enemies, goal and player.  
It also updates and renders each of these elements.

#### Player.lua

Manages a class to create, update and render a playable character in-game.

### Game States

Found inside ***/states*** folder:

#### StartState.lua

Prompts the player to press enter to continue while displaying the title of the game with an auto scrolling background (using the **autoScroll()** function).

#### TitleMenuState.lua

Displays a set of options (Play, How To Play and Quit).

#### StageState.lua

Display a scrolling background, the level number and objective, and prompts the user to press enter to continue.

#### PlayState.lua

Uses the level number given by the **StageState** to instantiate a corresponding Level object. It also instantiates a ***Camera*** object from **HUMP** to follow the player.  
It keeps track of the player's score, health, lives and coins obtained, while also performing each action corresponding to the key pressed by the player and handling what happens after a collision.  
Lastly, it ensures that conditions are met to allow the goal object to be spawned into the level, and switches to the **VictoryState** once the player reaches the goal object (***ice cream***).

#### PauseState.lua

Pauses the game and displays a set of options (Resume, How To Play and Quit).

#### RestartState.lua

Displays a 'yes' or 'no' options in order to restart the level if the player has lives left, but lost all health.
'Yes' restarts the level. 'No' returns to the title screen.

#### GameOverState.lua

Displayed when the player has lost all lives.  
Creates a physics world with **Windfield** in order to handle the collision of all the player sprites that rain down in the background and prompts the player to press enter to continue, returning to the title screen.

#### VictoryState.lua

Uses **LÖVE**'S particle system to spawn confetti that rains down in the background while prompting the player to press enter to continue, switching to the **StageState**.

#### CreditsState.lua

Displays a background with the player sprite being animated while scrolling the game credits.

#### HowToPlayState.lua

Displays all actions and their respective keys.

#### ExitConfirmState.lua

Displays a 'yes' or 'no' options in order to confirm that the player really wants to quit the game.
'Yes' quits the game. 'No' returns to the previous game state.

## Credits & Attributions

### Finite Platformer

Made by [Hector Gonzalez](https://www.gonvalhector.com/).

### LÖVE Libraries

- **Resolution-handling library**: [Push](https://github.com/Ulydev/push) by [Ulysse Ramage](https://github.com/Ulydev).
- **Class, GameState, Timer and Camera library**: [Helper Utilities for a Multitude of Problems(Hump)](https://github.com/vrld/hump) by [Matthias Richter](https://github.com/vrld).
- **Load maps created in Tiled**: [Simple-Tiled-Implementation(STI)](https://github.com/karai17/Simple-Tiled-Implementation) by [Landon Manning](https://github.com/karai17).
- **Simplify Love2D's Physics API**: [Windfield](https://github.com/a327ex/windfield) by [adn](https://github.com/a327ex).
- **Animation Class**: by [Colton Ogden](https://github.com/coltonoscopy).

### Helper functions and Utilities

- **GenerateQuads**: by [Colton Ogden](https://github.com/coltonoscopy).
- **createAnimations**: by [Colton Ogden](https://github.com/coltonoscopy).

### Fonts

- **Title font**: [Font.](https://opengameart.org/content/font-0) by [thekingphoenix](https://opengameart.org/users/thekingphoenix).
- **Message font**: [KenPixel Mini Square](https://opengameart.org/content/kenney-fonts) by [Kenney](https://opengameart.org/users/kenney).
- **UI font**: [Sharp Retro Font](https://opengameart.org/content/sharp-retro-font) by [JROB774](https://opengameart.org/users/jrob774).
- **Block Font**: [Pixel Block Font](https://opengameart.org/content/pixel-block-font) by [JROB774](https://opengameart.org/users/jrob774).

### Graphics

- **Platformer Assets**: [Arcade Platformer Assets](https://opengameart.org/content/arcade-platformer-assets) by [GrafxKid](https://opengameart.org/users/grafxkid).
- **Crates and Spikes**: [Items And Elements](https://opengameart.org/content/items-and-elements) by [GrafxKid](https://opengameart.org/users/grafxkid).
- **Ice Cream**: [City Mega Pack](https://opengameart.org/content/city-mega-pack) by [GrafxKid](https://opengameart.org/users/grafxkid).
- **Keys**: [Input Prompts Pixel 16×](https://opengameart.org/content/input-prompts-pixel-16%C3%97) by [Kenney](https://opengameart.org/users/kenney).

### Music

- **Title Screen Music**: [Birthday Cake](https://opengameart.org/content/birthday-cake) by [Viktor Kraus](https://opengameart.org/users/viktor-kraus).
- **Stage Objective**: [Stage Select](https://opengameart.org/content/4-chiptunes-adventure) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level 1**: [Stage 1](https://opengameart.org/content/4-chiptunes-adventure) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level 2**: [Stage 2](https://opengameart.org/content/4-chiptunes-adventure) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level 3**: [Boss Fight](https://opengameart.org/content/4-chiptunes-adventure) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level 4**: [Grasslands](https://opengameart.org/content/jrpg-pack-1-exploration) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level 5**: [Prairie Nights](https://opengameart.org/content/jrpg-pack-1-exploration) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Game Over**: [Witch's Lair](https://opengameart.org/content/jrpg-pack-3-evil) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Level Completed**: [Victory!](https://opengameart.org/content/victory-1) by [Viktor Kraus](https://opengameart.org/users/viktor-kraus).
- **Credits**: [Blueberries](https://opengameart.org/content/blueberries) by [Viktor Kraus](https://opengameart.org/users/viktor-kraus).

### Sounds

- **Exit Confirmation In**: [sfx_sounds_pause5_in.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Exit Confirmation Out**: [sfx_sounds_pause5_out.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Menu Cursor**: [sfx_menu_move1.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Menu Select**: [sfx_sounds_pause1_in.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Jump**: [sfx_sound_neutral1.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Landing**: [sfx_movement_jump9_landing.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Coin Pickup**: [sfx_coin_double3.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Heart Pickup**: [sfx_coin_cluster3.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Impact**: [sounds/sfx_sounds_impact7.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Player Being Hit**: [sounds/sfx_sounds_damage1.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Enemy Being Hit**: [sounds/sfx_sounds_button11.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Restart Level**: [game_over_bad_chest.wav](https://opengameart.org/content/game-over-bad-chest-sfx) by [Oiboo](https://opengameart.org/users/oiboo).
- **Pause In**: [sfx_sounds_pause4_in.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Pause Out**: [sfx_sounds_pause4_out.wav](https://opengameart.org/content/512-sound-effects-8-bit-style) by [SubspaceAudio](https://opengameart.org/users/subspaceaudio).
- **Wind**: [Wind.ogg](https://opengameart.org/content/wind) by [IgnasD](https://opengameart.org/users/ignasd).