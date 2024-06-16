local menu = {}

menu.buttons = {}
menu.playClicked = false
menu.newGameClicked = false
menu.loadGameClicked = false
menu.saveClicked = false
menu.quitClicked = false

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

-- Add buttons to the main menu
function menu.load()
    menu.buttons = {} -- Clear existing buttons
    table.insert(menu.buttons, newButton("Play", function()
        print("Play button function called")
        menu.playClicked = true
    end))

    table.insert(menu.buttons, newButton("Load Game", function()
        print("Load Game button function called")
        menu.loadGameClicked = true
    end))

    table.insert(menu.buttons, newButton("Exit", function()
        print("Exit button function called")
        love.event.quit(0)
    end))
end

function menu.update(dt)
    -- Update buttons
    local mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        for _, button in ipairs(menu.buttons) do
            local bx, by, bw, bh = button.x, button.y, button.width, button.height
            if mouseX > bx and mouseX < bx + bw and mouseY > by and mouseY < by + bh then
                print("Button clicked: " .. button.text)
                button.fn()
            end
        end
    end
end

function menu.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local buttonWidth = 200
    local buttonHeight = 50
    local margin = 20
    local totalHeight = (buttonHeight + margin) * #menu.buttons

    local cursorY = 0

    for i, button in ipairs(menu.buttons) do
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

-- Add buttons to the choose screen
function menu.loadChooseScreen()
    menu.buttons = {} -- Clear existing buttons
    table.insert(menu.buttons, newButton("New Game", function()
        print("New Game button function called")
        menu.newGameClicked = true
    end))

    table.insert(menu.buttons, newButton("Load Game", function()
        print("Load Game button function called")
        menu.loadGameClicked = true
    end))
end

function menu.updateChooseScreen(dt)
    menu.update(dt)
end

function menu.drawChooseScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local buttonWidth = 200
    local buttonHeight = 50
    local margin = 20
    local totalHeight = (buttonHeight + margin) * #menu.buttons

    local cursorY = 0

    for i, button in ipairs(menu.buttons) do
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

-- Add buttons to the pause menu
function menu.loadPauseMenu()
    menu.buttons = {} -- Clear existing buttons
    table.insert(menu.buttons, newButton("Save", function()
        print("Save button function called")
        menu.saveClicked = true
    end))

    table.insert(menu.buttons, newButton("Quit", function()
        print("Quit button function called")
        menu.quitClicked = true
    end))
end

function menu.updatePauseMenu(dt)
    menu.update(dt)
end

function menu.drawPauseMenu()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    local buttonWidth = 200
    local buttonHeight = 50
    local margin = 20
    local totalHeight = (buttonHeight + margin) * #menu.buttons

    local cursorY = 0

    for i, button in ipairs(menu.buttons) do
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

return menu
