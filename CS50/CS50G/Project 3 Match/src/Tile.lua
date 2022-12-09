--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function rgb(r, g, b)
    r = math.min(255, r * 1.5)
    g = math.min(255, g * 1.5)
    b = math.min(255, b * 1.5)
    return { ['r'] = r / 255, ['g'] = g / 255, ['b'] = b / 255 }
end

local PARTICLE_COLORS = {
    [1] = rgb(217,160,102),
    [3] = rgb(138,111,48),
    [5] = rgb(53,73,33),
    [7] = rgb(71,98,43),
    [9] = rgb(49,133,99),
    [11] = rgb(85,104,211),
    [13] = rgb(45,90,122),
    [15] = rgb(63,63,116),
    [17] = rgb(118,66,138),
    [2] = rgb(217,87,99),
    [4] = rgb(217,87,99),
    [6] = rgb(172,50,50),
    [8] = rgb(102,57,49),
    [10] = rgb(144,86,59),
    [12] = rgb(223,113,38),
    [14] = rgb(132,126,135),
    [16] = rgb(105,106,106),
    [18] = rgb(90,86,82),
    [99] = rgb(251, 242, 54)
}

-- Shiny tiles have a 1 in SHINY_CHANCE probability
local SHINY_CHANCE = 8 * 8

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny = math.random(SHINY_CHANCE) == 1 and true or false

    -- particle system for "shiny" tiles
    self.particles = nil
    self.lastEmit = 0
    if self.shiny then
        self:initParticles()
    end
end

function Tile:initParticles()
    self.particles = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.particles:setEmitterLifetime(-1)
    self.particles:setParticleLifetime(0.2, 1)
    self.particles:setLinearAcceleration(-32, -32, 32, 32)
    self.particles:setRotation( math.pi / 2, math.pi * 2 )
    self.particles:setSpin( math.pi / 2, math.pi * 2 )
    self.particles:setEmissionArea('uniform', 8, 8)
    self.particles:setEmissionRate(16)
    self.particles:setSizeVariation(1)
    self.particles:setSizes(0.5, 0.75, 0.9, 1.0, 1.05, 1.15)

    local c1 = PARTICLE_COLORS[self.color]
    local c2 = PARTICLE_COLORS[99]
    self.particles:setColors(c2['r'], c2['g'], c2['b'], 0.8, c1['r'], c1['g'], c1['b'], 0.1)
end

function Tile:update(dt)
    if self.particles then
        self.particles:update(dt)
    end
end

function Tile:render(x, y)    
    -- draw shadow
    love.graphics.setColor(34 / 255, 32 / 255, 52 / 255, 255 / 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Tile:renderParticles(x, y)
    -- draw shiny effect
    if self.particles then
        love.graphics.draw(self.particles, x + self.x + 16, y + self.y + 16)
    end
end