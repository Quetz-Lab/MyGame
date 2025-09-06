local love = require "love"
local enemy = require "Enemy"
local button = require "Button"

math.randomseed(os.time())

local game = {
    level = 1,
    state = {
        menu = true,
        pause = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {
        5,10,15,20
    }
}

local Player={
    radius = 20,
    x = 20,
    y = 20
}

local buttons = {
    menuState={}
}
local enemies = {}

local function StartGame()
    game.state["menu"] = false
    game.state["running"]=true
    enemies = {
        Enemy(1)
    }
end

function love.mousepressed(x,y,button,istouch,presses)
    if not game.state["running"]then
        if button == 1 then
            if game.state["menu"]then
                for index in pairs(buttons.menuState) do
                    buttons.menuState[index]:checkPress(x,y,Player.radius)
                end
            end
        end
    end
end

-- Añade esta función para detectar colisiones circulares
local function checkCollision(x1, y1, r1, x2, y2, r2)
    local dx = x1 - x2
    local dy = y1 - y2
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (r1 + r2)
end

function love.load()
    love.mouse.setVisible(false)
    love.window.setTitle("myGame")
    table.insert(enemies,1,Enemy())
    buttons.menuState.playeGame = Button("Play", StartGame,nil,120,40)
    buttons.menuState.quitGame = Button("Quit",love.event.quit,nil,120,40)
end

function love.update(dt)
    if game.state["running"] then
        

        for i = 1, #enemies do
            enemies[i]:move(Player.x, Player.y)

            -- Colisión con el jugador
            if checkCollision(Player.x, Player.y, Player.radius, enemies[i].x, enemies[i].y, enemies[i].radius) then
                game.state["running"] = false
                game.state["ended"] = true
            end
        end

        -- Aumentar dificultad según puntos
        for i = 1, #game.levels do
            if math.floor(game.points) == game.levels[i] then
                table.insert(enemies, 1, Enemy(game.level * (i + 1)))
                game.points = game.points + 1 -- evitar duplicación
            end
        end

        -- Puntaje por tiempo sobrevivido
        game.points = game.points + dt

    end
            Player.x, Player.y = love.mouse.getPosition()

end


function love.draw()
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.printf("Points: " .. math.floor(game.points), 10, love.graphics.getHeight() - 60, love.graphics.getWidth())
    love.graphics.printf("FPS: " .. love.timer.getFPS(), 10, love.graphics.getHeight() - 30, love.graphics.getWidth())

    if game.state["running"] then
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", Player.x, Player.y, Player.radius)
        love.graphics.setColor(1, 1, 1)

    elseif game.state["menu"] then
        buttons.menuState.playeGame:draw(10, 20, 17, 10)
        buttons.menuState.quitGame:draw(80, 80, 51, 10)

    elseif game.state["ended"] then
        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Puntaje final: " .. math.floor(game.points), 0, love.graphics.getHeight() / 2 + 10, love.graphics.getWidth(), "center")
    end

    if not game.state["running"] then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.circle("fill", Player.x, Player.y, Player.radius / 2)
        love.graphics.setColor(1, 1, 1)
    end
end
