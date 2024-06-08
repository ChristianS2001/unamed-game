-- boundaries.lua

local boundaries = {
    left = 0,
    right = 1920,
    top = 0,
    bottom = 1080,
}

function boundaries.checkX(player)
    if player.x < boundaries.left then
        player.x = boundaries.left
    elseif player.x + player.width > boundaries.right then
        player.x = boundaries.right - player.width
    end
end

function boundaries.checkY(player)
    if player.y < boundaries.top then
        player.y = boundaries.top
    elseif player.y + player.height > boundaries.bottom then
        player.y = boundaries.bottom - player.height
    end
end

return boundaries
