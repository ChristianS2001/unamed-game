local player = require("player")
local map = require("map")
local boundaries = require("boundaries")
local enemies = require("enemy")

local isPaused = false
local startMenu = true
local gameStarted = false
local cameraOffset = {x = 0, y = 0}

local buttons = {}
local playClicked = false

-- Function to create a button
local function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        x = 0,
        y = 0,
        width = 200,
        height = 50
    }
end

-- Add buttons to the menu
local function loadMenu()
    table.insert(buttons, newButton("Play", function()
        print("Play button function called")
        playClicked = true
    end))

    table.insert(buttons, newButton("Exit", function()
        print("Exit button function called")
        love.event.quit(0)
    end))
end

local function updateMenu(dt)
    -- Update buttons
    local mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        for _, button in ipairs(buttons) do
            local bx, by, bw, bh = button.x, button.y, button.width, button.height
            if mouseX > bx and mouseX < bx + bw and mouseY > by and mouseY < by + bh then
                print("Button clicked: " .. button.text)
                button.fn()
            end
        end
    end
end

local function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local buttonWidth = 200
    local buttonHeight = 50
    local margin = 20
    local totalHeight = (buttonHeight + margin) * #buttons

    local cursorY = 0

    for i, button in ipairs(buttons) do
        button.x = (love.graphics.getWidth() * 0.5) - (buttonWidth * 0.5)
        button.y = (love.graphics.getHeight() * 0.5) - (totalHeight * 0.5) + cursorY
        button.width = buttonWidth
        button.height = buttonHeight

        local color = {0.4, 0.4, 0.5, 1.0}

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.text, button.x, button.y + (button.height / 4), button.width, "center")

        cursorY = cursorY + (buttonHeight + margin)
    end
end

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.5, 0.5)
    loadMenu()
    print("Game loaded, showing menu")
end

function love.startGame()
    print("Starting game")
    player.load(boundaries)
    enemies.create(300, 300)  -- Create an enemy at position (300, 300)
    startMenu = false
    gameStarted = true
    print("Game started")
end

function love.update(dt)
    if startMenu then
        updateMenu(dt)
        if playClicked then
            print("Play button clicked")
            playClicked = false
            love.startGame()
        end
        return
    end

    if isPaused then
        return
    end

    player.update(dt, map, boundaries)
    enemies.updateAll(dt, boundaries, player)
    cameraOffset.x = player.x - love.graphics.getWidth() / 2 + player.width / 2
    cameraOffset.y = player.y - love.graphics.getHeight() / 2 + player.height / 2
end

function love.draw()
    if startMenu then
        drawMenu()
        return
    end

    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y)
    
    map.draw()
    player.draw()
    enemies.drawAll()
    boundaries.draw()
    
    love.graphics.pop()
    
    if isPaused then
        drawPauseMenu()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        if startMenu then
            love.event.quit()
        else
            isPaused = not isPaused
        end
    elseif key == 'space' and not startMenu then
        player.attack(enemies)
    end
end

function drawPauseMenu()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', windowWidth / 2 - 200, windowHeight / 2 - 100, 400, 200)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Pause Menu", windowWidth / 2 - 200, windowHeight / 2 - 80, 400, "center")
    love.graphics.printf("Press Escape to Resume", windowWidth / 2 - 200, windowHeight / 2, 400, "center")
end
