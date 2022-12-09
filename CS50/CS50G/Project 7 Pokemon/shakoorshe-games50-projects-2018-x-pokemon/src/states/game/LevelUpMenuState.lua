
LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(stats, onClose)
    
    self.levelUpMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 200/2,
        y = (VIRTUAL_HEIGHT - 64)/2 - 128/2,
        width = 200,
        height = 128,
        items = {
            {
                text = '<<< STATS >>>',
            },
            {
                text = 'HP: ' .. tostring(stats.HP.before) .. ' + ' 
                .. tostring(stats.HP.increase) .. ' = ' .. tostring(stats.HP.after)
            },
            {
                text = 'ATTACK: ' .. tostring(stats.Attack.before) .. ' + ' 
                .. tostring(stats.Attack.increase) .. ' = ' .. tostring(stats.Attack.after)
            },
            {
                text = 'DEFENSE: ' .. tostring(stats.Defense.before) .. ' + ' 
                .. tostring(stats.Defense.increase) .. ' = ' .. tostring(stats.Defense.after)
            },
            {
                text = 'SPEED: ' .. tostring(stats.Speed.before) .. ' + ' 
                .. tostring(stats.Speed.increase) .. ' = ' .. tostring(stats.Speed.after)
            },            
            -- {
            --     text = '                ',
            -- }
        },
        cursor = false
    }

    self.onClose = onClose or function() end
end

function LevelUpMenuState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		self.onClose()
    end

end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end