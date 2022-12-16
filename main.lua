local gameover = false
local cols = 600
local rows = 750
local snake_size = 15
local snake = {
    head = {
        x = cols / 2,
        y = rows / 2
    },
    body = {
        {
            x = cols / 2 + snake_size,
            y = rows / 2 + 0
        },
    },
}

local drawBoard = function()
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle('fill', 10, 10, cols, rows)
end

local drawSnake = function()
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', snake.head.x, snake.head.y, snake_size, snake_size)
    for _, coors in pairs(snake.body) do
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', coors.x, coors.y, snake_size, snake_size)
    end
end

local snakeMove = function(dir)
    local oldHead = {
        x = snake.head.x,
        y = snake.head.y
    }

    if dir == 'left' then
        if snake.head.x > snake_size then
            snake.head.x = snake.head.x - snake_size
        else
            snake.head.x = cols - snake_size
        end
    elseif dir == 'right' then
        if snake.head.x < cols - snake_size then
            snake.head.x = snake.head.x + snake_size
        else
            snake.head.x = snake_size
        end
    elseif dir == 'down' then
        if snake.head.y < rows - snake_size then
            snake.head.y = snake.head.y + snake_size
        else
            snake.head.y = snake_size
        end
    elseif dir == 'up' then
        if snake.head.y > snake_size then
            snake.head.y = snake.head.y - snake_size
        else
            snake.head.y = rows - snake_size
        end
    end

    if dir ~= '' then
        local oldBody
        for i = 1, #snake.body do
            oldBody = {
                x = snake.body[i].x,
                y = snake.body[i].y
            }

            snake.body[i].x = oldHead.x
            snake.body[i].y = oldHead.y

            oldHead = oldBody
        end
    end
end

local snakeIsEaten = function()
    for i = 4, #snake.body do
        if snake.head.x == snake.body[i].x and snake.head.y == snake.body[i].y then
            return true
        end
    end
    return false
end

local lengthen = function(x, y)
    table.insert(snake.body, { x = x * snake_size, y = y * snake_size })
end

local drawApple = function(x, y)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', x * snake_size, y * snake_size, snake_size, snake_size)
end

local appleIsEaten = function(appleX, appleY)
    if snake.head.x == appleX * snake_size and snake.head.y == appleY * snake_size then
        return true
    end
    return false
end

local drawScoreBoard = function()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('S c o r e:  ' .. #snake.body - 1, 10, rows + 10)
end

function love.load()
    love.window.setMode(cols + 20, rows + 50)
    love.graphics.setFont(love.graphics.setNewFont('orange_kid.ttf', 32))
end

local dir = ''
function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    elseif not gameover then
        if key == 'h' then
            if dir ~= 'right' then
                dir = 'left'
            end
        elseif key == 'l' then
            if dir ~= 'left' then
                dir = 'right'
            end
        elseif key == 'j' then
            if dir ~= 'up' then
                dir = 'down'
            end
        elseif key == 'k' then
            if dir ~= 'down' then
                dir = 'up'
            end
        end
    end
end

local dtotal = 0
local speed = 0.12
function love.update(dt)
    dtotal = dtotal + dt
    if dtotal >= speed then
        snakeMove(dir)
        if snakeIsEaten() then
            gameover = true
        end
        dtotal = 0
    end

    if gameover then
        dir = ''
    end
end

local x = math.random(1, cols / snake_size - 1)
local y = math.random(1, rows / snake_size - 1)

function love.draw()
    drawBoard()
    drawSnake()
    drawApple(x, y)

    if gameover then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print('GAMEOVER', cols / 2 - 48, rows / 2 - 12)
    else
        if appleIsEaten(x, y) then
            lengthen(x, y)
            x = math.random(1, cols / snake_size - 1)
            y = math.random(1, rows / snake_size - 1)
        end
    end

    drawScoreBoard()
end
