--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Match-3 has taken several forms over the years, with its roots in games
    like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
    version of this game, as well as Candy Crush from 2012, though all these
    games owe Shariki, a DOS game from 1994, for their inspiration.

    The goal of the game is to match any three tiles of the same variety by
    swapping any two adjacent tiles; when three or more tiles match in a line,
    those tiles add to the player's score and are removed from play, with new
    tiles coming from the ceiling to replace them.

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 40

-- debug mode on or off
DEBUG_MODE = false

function love.load()
    
    -- window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    if DEBUG_MODE then
        math.randomseed(1)
    else
        math.randomseed(os.time())
    end

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    if not DEBUG_MODE then
        gSounds['music']:play()
    end

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
    love.mouse.mouseClicked = nil
    love.mouse.mouseReleased = nil

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


--[[
    Called by Love2D when user clicks. Record the x,y and convert to `push`
    coordinates.
]]
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 or istouch then
        x, y = push:toGame(x, y)
        if x and y then
            love.mouse.mouseClicked = { ['x'] = x, ['y'] = y }
        end
    end
end

--[[
    Called by Love2D when user releases mouse (or lifts finger from touchpad).
    Converts the x,y coordimates to `push` coordinates.
]]
function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 or istouch then
        x, y = push:toGame(x, y)
        if x and y then
            love.mouse.mouseReleased = { ['x'] = x, ['y'] = y }
        end
    end
end


function love.update(dt)
    
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
    
    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    -- process some global keys
    if love.keyboard.wasPressed('m') then
        if gSounds['music']:isPlaying() then
            gSounds['music']:pause()
        else
            gSounds['music']:play()
        end
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- reset keyboard and mouse state
    love.keyboard.keysPressed = {}
    love.mouse.mouseClicked = nil
    love.mouse.mouseReleased = nil
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)
    
    gStateMachine:render()
    push:finish()
end