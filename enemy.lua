local enemies = {}

local enemyPrototype = {
    x = 300,
    y = 300,
    width = 50,
    height = 50,
    speed = 100,
    directionX = 1,  -- 1 for right, -1 for left
    directionY = 1,  -- 1 for down, -1 for up
    isDead = false,
}

function enemyPrototype.load(self)
    -- Initialize random seed
    math.randomseed(os.time())

    -- Set random initial directions
    self.directionX = math.random(2) == 1 and 1 or -1
    self.directionY = math.random(2) == 1 and 1 or -1

    -- Set random speed
    self.speed = math.random(50, 150)
end

function enemyPrototype.update(self, dt, boundaries, player)
    if self.isDead then
        return
    end

    -- Move the enemy randomly
    self.x = self.x + self.speed * dt * self.directionX
    self.y = self.y + self.speed * dt * self.directionY

    -- Reverse direction if hitting the boundaries
    if self.x <= boundaries.left then
        self.directionX = 1
    elseif self.x + self.width >= boundaries.right then
        self.directionX = -1
    end

    if self.y <= boundaries.top then
        self.directionY = 1
    elseif self.y + self.height >= boundaries.bottom then
        self.directionY = -1
    end

    -- Check collision with the player
    if checkCollision(self, player) then
        player.isDead = true
    end
end

function enemyPrototype.die(self)
    print("Enemy died")  -- Debugging statement
    self.isDead = true
end

function enemyPrototype.draw(self)
    if self.isDead then
        return
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Function to create new enemies
function enemies.create(x, y)
    local newEnemy = setmetatable({ x = x, y = y }, { __index = enemyPrototype })
    table.insert(enemies, newEnemy)
    newEnemy:load()
end

function enemies.updateAll(dt, boundaries, player)
    for _, enemy in ipairs(enemies) do
        enemy:update(dt, boundaries, player)
    end
end

function enemies.drawAll()
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end

function enemies.clear()
    for i = #enemies, 1, -1 do
        table.remove(enemies, i)
    end
end

-- Make the enemy prototype accessible
enemies.prototype = enemyPrototype

return enemies
