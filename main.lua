local player = require("player")
local map = require("map")
local boundaries = require("boundaries")
local menu = require("menu")
local enemies = require("enemy")

local isPaused = false
local startMenu = true
local gameStarted = false
local chooseScreen = false
local cameraOffset = {x = 0, y = 0}

-- Helper function to get save files
local function getSaveFiles()
    local files = love.filesystem.getDirectoryItems("")
    local saveFiles = {}

    for _, file in ipairs(files) do
        if file:match("^savegame_%d+%.lua$") then
            local info = love.filesystem.getInfo(file)
            if info then
                table.insert(saveFiles, {name = file, time = info.modtime})
            end
        end
    end

    table.sort(saveFiles, function(a, b) return a.time > b.time end)
    return saveFiles
end

-- Save game state
local function saveGame()
    local state = {
        player = {
            x = player.x,
            y = player.y
        },
        enemies = {}
    }

    for i, enemy in ipairs(enemies) do
        table.insert(state.enemies, {
            x = enemy.x,
            y = enemy.y
            -- Add other enemy state info as needed
        })
    end

    local serializedState = "return " .. table.tostring(state)
    print("Serialized State: " .. serializedState) -- Debugging statement
    local timestamp = os.time()
    local filename = string.format("savegame_%d.lua", timestamp)

    local success, message = love.filesystem.write(filename, serializedState)
    if success then
        print("Game saved successfully")

        local saveFiles = getSaveFiles()
        if #saveFiles > 3 then
            for i = 4, #saveFiles do
                love.filesystem.remove(saveFiles[i].name)
            end
        end

        print("Save directory: " .. love.filesystem.getSaveDirectory()) -- Print save directory
    else
        print("Failed to save game: " .. message)
    end
end

-- Load game state
local function loadGame()
    local saveFiles = getSaveFiles()
    if #saveFiles > 0 then
        local state = love.filesystem.load(saveFiles[1].name)()
        player.x = state.player.x
        player.y = state.player.y

        -- Clear existing enemies and load saved enemies
        enemies = require("enemy")
        enemies.clear()
        for i, enemyState in ipairs(state.enemies) do
            enemies.create(enemyState.x, enemyState.y)
        end

        -- Load other game state info as needed
        print("Game loaded: Player position (" .. player.x .. ", " .. player.y .. ")")
    else
        print("No save game found")
    end
end

-- Helper function to convert table to string for saving
function table.tostring(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        if type(v) == "table" then
            v = table.tostring(v)
        elseif type(v) == "string" then
            v = string.format("%q", v)
        end
        result = result .. "[" .. k .. "]=" .. v .. ","
    end
    return result .. "}"
end

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.5, 0.5)
    menu.load()
    print("Game loaded, showing menu")
end

function love.startGame(newGame)
    if newGame then
        print("Starting new game")
        player.load(boundaries)
        enemies.create(300, 300)  -- Create an enemy at position (300, 300)
    else
        print("Loading game")
        loadGame()
    end
    startMenu = false
    chooseScreen = false
    gameStarted = true
    print("Game started")
end

function love.update(dt)
    if startMenu then
        menu.update(dt)
        if menu.playClicked then
            print("Play button clicked")
            startMenu = false
            chooseScreen = true
            menu.playClicked = false
            menu.loadChooseScreen() -- Load the choose screen buttons
        elseif menu.loadGameClicked then
            print("Load Game button clicked")
            menu.loadGameClicked = false
            love.startGame(false) -- Load the most recent game
        end
        return
    end

    if chooseScreen then
        menu.updateChooseScreen(dt)
        if menu.newGameClicked then
            menu.newGameClicked = false
            love.startGame(true)
        elseif menu.loadGameClicked then
            menu.loadGameClicked = false
            love.startGame(false)
        end
        return
    end

    if isPaused then
        menu.updatePauseMenu(dt)
        if menu.saveClicked then
            saveGame()
            menu.saveClicked = false
        elseif menu.quitClicked then
            love.event.quit()
        end
        return
    end

    player.update(dt, map, boundaries)
    enemies.updateAll(dt, boundaries, player)
    cameraOffset.x = player.x - love.graphics.getWidth() / 2 + player.width / 2
    cameraOffset.y = player.y - love.graphics.getHeight() / 2 + player.height / 2
end

function love.draw()
    if startMenu then
        menu.draw()
        return
    end

    if chooseScreen then
        menu.drawChooseScreen()
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
        menu.drawPauseMenu()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        if startMenu or chooseScreen then
            love.event.quit()
        else
            isPaused = not isPaused
            if isPaused then
                menu.loadPauseMenu() -- Load the pause menu buttons
            end
        end
    elseif key == 'space' and not startMenu and not chooseScreen then
        player.attack(enemies)
    end
end
