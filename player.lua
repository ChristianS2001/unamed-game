local player = {
    x = 50,
    y = 300,
    width = 50,
    height = 50,
    speed = 200,
    yVelocity = 0,
    xVelocity = 0,
    onGround = false,
    isDead = false,
    attacking = false,
    attackTime = 0,
    attackDuration = 3,  -- seconds
    attackRadius = 150,
}

function player.load(boundaries) --initialization of player traits
    player.x = (boundaries.right - boundaries.left) / 2 - player.width / 2
    player.y = (boundaries.bottom - boundaries.top) / 2 - player.height / 2
end

function player.update(dt, map, boundaries)
    if player.isDead then
        return
    end

    if player.attacking then
        player.attackTime = player.attackTime + dt
        if player.attackTime >= player.attackDuration then
            player.attacking = false
            player.attackTime = 0
        end
    end

    local moveX, moveY = 0, 0
    if love.keyboard.isDown('right') then
        moveX = player.speed * dt
    elseif love.keyboard.isDown('left') then
        moveX = -player.speed * dt
    end

    if love.keyboard.isDown('up') then
        moveY = -player.speed * dt
    elseif love.keyboard.isDown('down') then
        moveY = player.speed * dt
    end

    player.y = player.y + player.yVelocity * dt

    local function checkAndMove(axis, move)
        if axis == 'x' then
            player.x = player.x + move
            boundaries.checkX(player)
        elseif axis == 'y' then
            player.y = player.y + move
            boundaries.checkY(player)
        end

        for _, object in ipairs(map.objects) do -- collisions are handled here
            if checkCollision(player, object) then
                if axis == 'x' then
                    if move > 0 then
                        player.x = object.x - player.width
                    elseif move < 0 then
                        player.x = object.x + object.width
                    end
                elseif axis == 'y' then
                    if move > 0 then
                        player.y = object.y - player.height
                    elseif move < 0 then
                        player.y = object.y + object.height
                    end
                end
            end
        end
    end

    checkAndMove('x', moveX)
    checkAndMove('y', moveY)
end

function player.attack(enemies)
    if player.attacking then
        return
    end

    player.attacking = true

    -- Check for enemies within the attack radius
    for _, enemy in ipairs(enemies) do
        local distance = math.sqrt((player.x + player.width / 2 - enemy.x - enemy.width / 2) ^ 2 + (player.y + player.height / 2 - enemy.y - enemy.height / 2) ^ 2)
        print("Distance to enemy: " .. distance)  -- Debugging statement
        if not enemy.isDead and distance <= player.attackRadius then
            print("Enemy within attack radius")  -- Debugging statement
            enemy:die()
        end
    end
end

function player.draw()
    if player.isDead then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 1, 0)
    end
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)

    if player.attacking then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.circle('fill', player.x + player.width / 2, player.y + player.height / 2, player.attackRadius)
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

return player
