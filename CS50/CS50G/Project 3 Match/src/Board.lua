--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

local COLOR_SCHEMES = {
    { 1,  2,  5,  6,  9, 10, 11, 12 },
    { 9, 10, 11, 12, 15, 16,  2,  3 },
    { 1,  4,  5,  8,  9, 12, 13, 16 },
    { 2,  3,  6,  7, 10, 11, 14, 15 },
    { 6, 12, 16,  9, 11, 17, 10,  2 }
}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}

    -- pick a color scheme
    self.scheme = math.random(1, table.getn(COLOR_SCHEMES))

    -- level determines color and varierty of tiles to be generated
    self.level = level
    self.maxVariety = math.min(level, 6)
    self.maxColor = math.min(3 + self.level, 8)

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do            
            -- create a new tile at X,Y with a random color and variety
            local color = COLOR_SCHEMES[self.scheme][math.random(self.maxColor)]
            table.insert(self.tiles[tileY], Tile(tileX, tileY, color, math.random(self.maxVariety)))
        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}
                    local rowHasShiny = false

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        rowHasShiny = rowHasShiny or self.tiles[y][x2].shiny
                    end

                    -- if a tile was shiny, add the rest of the row
                    if rowHasShiny then
                        -- add the "head" of the row
                        for i = x - matchNum - 1, 1, -1 do
                            table.insert(match, self.tiles[y][i])
                        end

                        -- add the "tail" of the row
                        for i = x, 8 do
                            table.insert(match, self.tiles[y][i])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            local rowHasShiny = false
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                rowHasShiny = rowHasShiny or self.tiles[y][x].shiny
            end

            -- keep going backwards if that last match included a shiny tile
            if rowHasShiny then
                for x = 8 - matchNum, 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end


    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}
                    local colHasShiny = false

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        colHasShiny = colHasShiny or self.tiles[y2][x].shiny
                    end

                    if colHasShiny then
                        -- add the "head" of the column
                        for i = y - matchNum - 1, 1, -1 do
                            table.insert(match, self.tiles[i][x])
                        end

                        -- add the "tail" of the column
                        for i = y, 8 do
                            table.insert(match, self.tiles[i][x])
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            local colHasShiny = false
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                colHasShiny = colHasShiny or self.tiles[y][x].shiny
            end

            -- if column had a shiny, keep moving back
            if colHasShiny then
                for y = 8 - matchNum, 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Clear the board of all tiles, for example if the board has no
    legal moves and needs to be reset.
]]
function Board:clear()
    for y = 1, 8 do
        for x = 1, 8 do
            self.tiles[y][x] = nil
        end
    end
    -- new color scheme, why not?
    self.scheme = math.random(1, table.getn(COLOR_SCHEMES))
end


--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local color = COLOR_SCHEMES[self.scheme][math.random(self.maxColor)]
                local tile = Tile(x, y, color, math.random(self.maxVariety))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

--[[ 
    Swaps tile y1,x1 with tile y2,x2. Does NOT change the tile's internal
    state, so their gridX and gridY and graphics x,y positions are not changed.
]]
function Board:swapTiles(y1, x1, y2, x2)
    local tempTile = self.tiles[y1][x1]
    self.tiles[y1][x1] = self.tiles[y2][x2]
    self.tiles[y2][x2] = tempTile
end


--[[
    Returns `true` if the current board has at least one legal move, which is a move
    that will result in a match.
]]
function Board:hasLegalMoves()
    -- if there are matches right now, board is still legal
    local matches = self:calculateMatches()
    if matches then
        return true
    end

    -- assume no matches are possible
    matchPossible = false

    -- We'll take each tile and try and swap it to the right, and then down.
    -- We don't need to swap "left" or "up" because that will be the same as 
    -- swapping with right/down, just starting with the other tile.

    for y = 1, 7 do
        for x = 1, 7 do
            -- can we swap this tile right?
            self:swapTiles(y, x, y, x + 1)
            matches = self:calculateMatches()
            if matches then
                matchPossible = true
            end

            -- swap back
            self:swapTiles(y, x + 1, y, x)

            -- can we swap this tile down?
            self:swapTiles(y, x, y + 1, x)
            matches = self:calculateMatches()
            if matches then
                matchPossible = true
            end

            -- swap back. If either of those worked, fall out of the loop
            self:swapTiles(y + 1, x, y, x)
            if matchPossible then
                break
            end
        end

        if matchPossible then
            break
        end
    end
    return matchPossible
end

function Board:update(dt)
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:update(dt)
        end
    end

end

function Board:render()
    -- first, render all tiles
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end

    -- last, render any particle effects
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            if self.tiles[y][x].shiny then
                self.tiles[y][x]:renderParticles(self.x, self.y)
            end
        end
    end
end