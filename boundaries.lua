local boundaries = {
    left = 0,
    right = 1950,
    top = 0,
    bottom = 1100,
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

function boundaries.checkY(enemy)
    if enemy.y < boundaries.top then
        enemy.y = boundaries.top
    elseif enemy.y + enemy.height > boundaries.bottom then
        enemy.y = boundaries.bottom - enemy.height
    end
end

function boundaries.draw()
    love.graphics.setColor(0, 0, 0) -- Set color to black
    love.graphics.line(boundaries.left, boundaries.top, boundaries.right, boundaries.top) -- Top boundary
    love.graphics.line(boundaries.left, boundaries.bottom, boundaries.right, boundaries.bottom) -- Bottom boundary
    love.graphics.line(boundaries.left, boundaries.top, boundaries.left, boundaries.bottom) -- Left boundary
    love.graphics.line(boundaries.right, boundaries.top, boundaries.right, boundaries.bottom) -- Right boundary
end

return boundaries
