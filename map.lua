-- map.lua

local map = {}

map.groundHeight = 50
map.boxes = {
    {x = 200, y = 350, width = 100, height = 50},
}

map.boundaries = {
    left = 0,
    right = 1920,
    top = 0,
    bottom = 1080,
}

function map.draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    local groundWidth = love.graphics.getWidth()
    local groundHeight = love.graphics.getHeight()
    
    for x = -groundWidth, groundWidth * 2, groundWidth do
        love.graphics.rectangle('fill', x, groundHeight - map.groundHeight, groundWidth, map.groundHeight)
    end

    love.graphics.setColor(1, 0, 0)
    for _, box in ipairs(map.boxes) do
        love.graphics.rectangle('fill', box.x, box.y, box.width, box.height)
    end
end

return map
