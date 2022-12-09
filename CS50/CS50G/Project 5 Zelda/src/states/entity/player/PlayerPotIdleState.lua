PlayerPotIdleState = Class{__includes = PlayerIdleState}

function PlayerPotIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity.pot.preThrow = true
        self.entity:changeState('idle')
    end
end