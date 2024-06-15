local player = require("player")
local map = require("map")
local boundaries = require("boundaries")
local enemies = require("enemy")

local isPaused = false
local showMenu = false
local cameraOffset = {x = 0, y = 0}

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.5, 0.5)
    player.load(boundaries)
    enemies.create(300, 300)  -- Create an enemy at position (300, 300)
    print("Window size: ", love.graphics.getWidth(), love.graphics.getHeight())
end

function love.update(dt)
    if isPaused then
        return
    end

    player.update(dt, map, boundaries)
    enemies.updateAll(dt, boundaries, player)
    cameraOffset.x = player.x - love.graphics.getWidth() / 2 + player.width / 2
    cameraOffset.y = player.y - love.graphics.getHeight() / 2 + player.height / 2
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y)
    
    map.draw()
    player.draw()
    enemies.drawAll()
    boundaries.draw()
    
    love.graphics.pop()
    
    if showMenu then
        drawMenu()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        showMenu = not showMenu
        isPaused = showMenu
    elseif key == 'return' and showMenu then
        love.event.quit()
    elseif key == 'space' then
        player.attack(enemies)
    end
end

function drawMenu()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', windowWidth / 2 - 200, windowHeight / 2 - 100, 400, 200)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Pause Menu", windowWidth / 2 - 200, windowHeight / 2 - 80, 400, "center")
    love.graphics.printf("Press Enter to Quit", windowWidth / 2 - 200, windowHeight / 2, 400, "center")
end
