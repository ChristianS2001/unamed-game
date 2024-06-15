local map = {}
map.groundHeight = 50
map.gridSize = 50
map.objects = {
    {x = 100, y = 300, width = 50, height = 50, type = "rock"},
    {x = 400, y = 200, width = 120, height = 80, type = "wall"},
    {x = 600, y = 250, width = 70, height = 100, type = "tree"},
    {x = 200, y = 350, width = 100, height = 50},
    {x = 150, y = 150, width = map.gridSize, height = map.gridSize, type = "gridObject"}, -- Example grid-aligned object
}
map.boundaries = {
    left = 0,
    right = 1920,
    top = 0,
    bottom = 1080,
}

function map.drawGrid()
    love.graphics.setColor(0.7, 0.7, 0.7)
    local gridRange = 4000 -- Arbitrary large range to cover beyond the visible area

    for x = -gridRange, map.boundaries.right + gridRange, map.gridSize do
        love.graphics.line(x, map.boundaries.top - gridRange, x, map.boundaries.bottom + gridRange)
    end
    for y = -gridRange, map.boundaries.bottom + gridRange, map.gridSize do
        love.graphics.line(map.boundaries.left - gridRange, y, map.boundaries.right + gridRange, y)
    end
end

function map.draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    local groundWidth = love.graphics.getWidth()
    local groundHeight = love.graphics.getHeight()
    
    -- Draw ground
    for x = -groundWidth, groundWidth * 2, groundWidth do
        love.graphics.rectangle('fill', x, groundHeight - map.groundHeight, groundWidth, map.groundHeight)
    end
    
    -- Draw the grid
    map.drawGrid()
    
    -- Draw objects
    for _, object in ipairs(map.objects) do
        if object.type == "rock" then
            love.graphics.setColor(0.5, 0.5, 0.5) -- Gray for rocks
        elseif object.type == "wall" then
            love.graphics.setColor(0.4, 0.4, 0.2) -- Brown for walls
        elseif object.type == "tree" then
            love.graphics.setColor(0, 1, 0) -- Green for trees
        elseif object.type == "gridObject" then
            love.graphics.setColor(1, 0, 0) -- Red for grid-aligned objects
        else
            love.graphics.setColor(1, 1, 1) -- Default color for other objects
        end
        love.graphics.rectangle('fill', object.x, object.y, object.width, object.height)
    end
end

return map
