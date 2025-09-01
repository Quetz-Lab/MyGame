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


function love.load()
    love.mouse.setVisible(false)
    love.window.setTitle("myGame")
    table.insert(enemies,1,Enemy())
    buttons.menuState.playeGame = Button("Play", StartGame,nil,120,40)
    buttons.menuState.quitGame = Button("Quit",love.event.quit,nil,120,40)
end

function love.update(dt)
    if game.state["running"]then
        for i = 1, #enemies do
            enemies[i]:move(Player.x,Player.y)
            for i = 1, #game.levels do
                if math.floor(game.points) == game.levels[i] then
                    table.insert(enemies,1,Enemy(game.level*(i+1)))
                    game.points = game.points+1
                end
            end
        end
        game.points = game.points + dt
    end

    Player.x,Player.y = love.mouse.getPosition()
end

function love.draw()
    love.graphics.printf("Points: " ..game.points,love.graphics.newFont(16),10,love.graphics.getHeight()-60,love.graphics.getWidth())
    love.graphics.printf("FPS: " ..love.timer.getFPS(),love.graphics.newFont(16),10,love.graphics.getHeight()-30,love.graphics.getWidth())
    if game.state["running"]then
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        love.graphics.circle("fill",Player.x,Player.y,Player.radius)
    
elseif game.state["menu"]then
    buttons.menuState.playeGame:draw(10,20,17,10)
    buttons.menuState.quitGame:draw(80,80,51,10)
    end
    if not game.state["running"] then
        love.graphics.circle("fill",Player.x,Player.y,Player.radius/2)
    end
end