--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

-- How many seconds before a player will feel bored because nothing has happened?
-- (That means no bricks hit, no powerups seen - probably just one ball bouncing
-- around and missing the last block). If this happens we'll drop a powerup at
-- random.

local BORED_THRESHOLD = 10

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = params.balls
    self.level = params.level
    self.paused = false
    self.sleep_enabled = love.window.isDisplaySleepEnabled()

    self.recoverPoints = params.recoverPoints or 5000
    self.lastAction = love.timer.getTime()

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)

    -- no powerups in play yet
    self.powerup = Powerup(VIRTUAL_WIDTH / 2, 0)
    self.powerup.inPlay = false

    -- How many bricks are locked? By default, player can't unlock any until
    -- the "unlock" powerup is caught
    self.canBreakLocks = false
    self.numLockedBricks = 0
    for k, brick in pairs(self.bricks) do
        if brick.isLocked then
            self.numLockedBricks = self.numLockedBricks + 1
        end
    end
end

function PlayState:update(dt)

    -- For testing, hit a key to spawn a powerup
    if DEBUG_MODE and love.keyboard.wasPressed('x') then
        self.powerup:reset(self.paddle.x + self.paddle.width / 2,
            self.paddle.y - self.paddle.height * 3, 
            { 
                needKey = self.numLockedBricks > 0 and not self.canBreakLocks,
                health = self.health,
                paddleSize = self.paddle.size,
                numBalls = table.getn(self.balls),
                level = self.level
            })
    end

    -- Check for pause / unpause conditions
    if self.paused then
        if love.keyboard.wasPressed('space') then
            -- unpause resumes music only if it was playing when paused, and
            -- prevents display from sleeping if that was original setting
            self.paused = false
            self.lastAction = love.timer.getTime()
            gSounds['pause']:play()
            gSounds['music']:setVolume(1)
            love.window.setDisplaySleepEnabled(self.sleep_enabled)
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        -- pausing quietens music and allows display to sleep
        self.paused = true
        gSounds['pause']:play()
        gSounds['music']:setVolume(0.25)
        love.window.setDisplaySleepEnabled(true)
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end

    -- update powerup if in play
    self.powerup:update(dt)
    if self.powerup.inPlay and self.powerup:collides(self.paddle) then
        self.powerup:hit(self)
    end

    -- check if any balls have collided with paddle
    for k, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - ball.height
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(ball.width * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (ball.width * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end

    -- detect collision across all bricks with all balls
    for k, brick in pairs(self.bricks) do
        for l, ball in pairs(self.balls) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- add to score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                self.lastAction = love.timer.getTime()

                -- trigger the brick's hit function, which removes it from play
                wasLocked = brick.isLocked
                brick:hit(self.canBreakLocks)
                if wasLocked and not brick.isLocked then
                    -- locked brick was unlocked
                    self.numLockedBricks = self.numLockedBricks - 1
                    self.canBreakLocks = false -- used that power, will need another
                end

                -- sometimes, a brick will spawn a power up
                if math.random(3) == 2 and not self.powerup.inPlay then
                    self.powerup:reset(brick.x + brick.width / 2, brick.y,
                        { 
                            needKey = self.numLockedBricks > 0 and not self.canBreakLocks,
                            health = self.health,
                            paddleSize = self.paddle.size,
                            numBalls = table.getn(self.balls),
                            level = self.level
                        })
                end

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(1e6, self.recoverPoints * 2)

                    -- go down a paddle size
                    self.paddle:reset(self.paddle.size - 1)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    -- paddle gets smaller on victory -- after a point
                    if self.level >= 5 then
                        self.paddle:reset(1)
                    elseif self.level >= 2 then
                        self.paddle:reset(self.paddle.size - 1)
                    end

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        balls = self.balls,
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - ball.width
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y -  ball.height
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end -- for l, ball
    end -- for k, brick

    -- if ball goes below bounds, take it out of play
    local num_balls = 0
    for k, ball in pairs(self.balls) do
        if ball.y >= VIRTUAL_HEIGHT then
            gSounds['hurt']:play()
            ball.inPlay = false
        else
            num_balls = num_balls + 1
        end
    end

    -- remove any balls from self.balls that have gone out of play
    for k, ball in pairs(self.balls) do
        if not ball.inPlay then
            table.remove(self.balls, k)
        end
    end

    -- only lose health if all balls are now out of play
    if num_balls <= 0 then
        self.health = self.health - 1
        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            -- make the paddle bigger (but not biggest possible)
            self.paddle:reset(math.min(3, self.paddle.size + 1))
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end


    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    -- if nothing has happened for "a while" maybe a powerup will help?
    if love.timer.getTime() - self.lastAction > BORED_THRESHOLD then
        if math.random(2) == 2 then
            self.powerup:reset(math.random(32, VIRTUAL_WIDTH - 32), 0,
                { 
                    needKey = self.numLockedBricks > 0 and not self.canBreakLocks,
                    health = self.health,
                    paddleSize = self.paddle.size,
                    numBalls = table.getn(self.balls),
                    level = self.level
                })
        end
        self.lastAction = love.timer.getTime()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render powerup
    self.powerup:render()

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderLevel(self.level)
    renderScore(self.score)
    renderHealth(self.health)
    renderPowerups(self.canBreakLocks)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end

    -- debug text, if in DEBUG_MODE
    if DEBUG_MODE then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 0, 0, 0.8)
        love.graphics.print(string.format("Recover: %d; BT in %d", 
            self.recoverPoints, BORED_THRESHOLD - (love.timer.getTime() - self.lastAction)), 50, 5)
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end