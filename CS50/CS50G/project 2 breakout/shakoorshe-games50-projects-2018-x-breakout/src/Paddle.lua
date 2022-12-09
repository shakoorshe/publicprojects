--[[
    GD50
    Breakout Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
]]

Paddle = Class{}

local PADDLE_WIDTHS = {32, 64, 96, 128}

--[[
    Our Paddle will initialize at the same spot every time, in the middle
    of the world horizontally, toward the bottom.
]]
function Paddle:init(skin)
    -- the variant is which of the four paddle sizes we currently are; 2
    -- is the starting size, as the smallest is too tough to start with
    self.size = 2

    -- the skin only has the effect of changing our color, used to offset us
    -- into the gPaddleSkins table later
    self.skin = skin

    -- starting dimensions - height is always the same
    self.height = 16
    self.width = PADDLE_WIDTHS[self.size]

    -- x is placed in the middle
    -- y is placed a little above the bottom edge of the screen
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT - self.height * 2

    -- start us off with no velocity
    self.dx = 0

    -- reset x based on size
    self:reset(self.size)
end

--[[
    Reset the paddle (e.g. after a game) to a new size, recentered on screen
]]
function Paddle:reset(size)
    -- we'll handle out of bound sizes here
    if size < 1 then
        size = 1
    elseif size > 4 then
        size = 4
    end

    -- remember what we were, to adjust x position later
    old_size = self.size
    old_width = self.width

    -- set new size and paddle width
    self.size = size
    self.width = PADDLE_WIDTHS[self.size]

    -- want to keep the current centre the new centre even as width changes
    self.x = self.x + (old_width / 2 - self.width / 2)
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

--[[
    Render the paddle by drawing the main texture, passing in the quad
    that corresponds to the proper skin and size.
]]
function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end