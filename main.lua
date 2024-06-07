-- main.lua

-- Set up player and boxes
local player = {
    x = 50,
    y = 300,
    width = 50,
    height = 50,
    speed = 200,
    yVelocity = 0,
    xVelocity = 0,
    onGround = false,
}

local boxes = {
    {x = 200, y = 350, width = 100, height = 50},
    {x = 400, y = 300, width = 150, height = 50},
    {x = 600, y = 250, width = 200, height = 50},
    {x = 0, y = 150, width = 250, height = 40},
    {x = 100, y = 450, width = 375, height = 30},
}

local groundHeight = 50
local cameraOffset = {x = 0, y = 0}

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.5, 0.5)
end

function love.update(dt) -- this is the loop of gameplay

    -- Move player
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

    -- Update player position
    player.y = player.y + player.yVelocity * dt

    -- Collision detection with ground and boxes
    -- Check for collisions and update player position
    local function checkAndMove(axis, move)
        if axis == 'x' then
            player.x = player.x + move
        elseif axis == 'y' then
            player.y = player.y + move
        end

        for _, box in ipairs(boxes) do
            if checkCollision(player, box) then
                if axis == 'x' then
                    if move > 0 then
                        player.x = box.x - player.width
                    elseif move < 0 then
                        player.x = box.x + box.width
                    end
                elseif axis == 'y' then
                    if move > 0 then
                        player.y = box.y - player.height
                    elseif move < 0 then
                        player.y = box.y + box.height
                    end
                end
            end
        end
    end

    checkAndMove('x', moveX)
    checkAndMove('y', moveY)

    -- Update camera offset
    cameraOffset.x = player.x - love.graphics.getWidth() / 2 + player.width / 2
    cameraOffset.y = player.y - love.graphics.getHeight() / 2 + player.height / 2
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y)

    -- Draw ground
    love.graphics.setColor(0.3, 0.3, 0.3)
    local groundWidth = love.graphics.getWidth()
    local startX = player.x - groundWidth
    local endX = player.x + groundWidth
    for x = startX, endX, groundWidth do
        love.graphics.rectangle('fill', x, love.graphics.getHeight() - groundHeight, groundWidth, groundHeight)
    end

    -- Draw player
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)

    -- Draw boxes
    love.graphics.setColor(1, 0, 0)
    for _, box in ipairs(boxes) do
        love.graphics.rectangle('fill', box.x, box.y, box.width, box.height)
    end

    love.graphics.pop()
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

--[[
    TODO:
        1. Make it so the player has a map to follow, very basic
        2. Make the screen larger
        3. Make it so the borders to the wall are an actual programmed border and you can not proceed
        4. Make small red dots as enemies that do not hurt you
        5. Have the player be able to attack when hitting space killing nearby enemies
]]