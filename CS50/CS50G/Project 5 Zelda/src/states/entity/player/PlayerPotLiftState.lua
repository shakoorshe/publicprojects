PlayerPotLiftState = Class{__includes = PlayerIdleState}

function PlayerPotLiftState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
end

function PlayerPotLiftState:update(dt)
    Timer.after(0.20, function() self.entity:changeState('pot-idle') end)
end