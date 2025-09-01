local love = require "love"

function Enemy()
    local dice= math.random(1,4)
    local _x,_y
    local _radius = 20

    if dice == 1 then
        _x = math.random(_radius,love.graphics.getWidth())
        _y = _radius * 4
    elseif dice == 2 then
        _x = _radius * 4
        _y = math.random(_radius,love.graphics.getHeight())
    elseif dice == 3 then
        _x = math.random(_radius,love.graphics.getWidth())
        _y = love.graphics.getHeight()+(_radius*4)
    else 
        _x = love.graphics.getWidth()+(_radius*4)
        _y = math.random(_radius,love.graphics.getHeight())
    end


    return {
        radius = _radius,
        level = 1,
        x = _x,
        y = _y,

        move = function(self,playerX,playerY)
            if playerX -self.x > 0 then
                self.x = self.x+self.level
            elseif playerX-self.x < 0 then
                self.x = self.x-self.level
            end
              if playerY -self.y > 0 then
                self.y = self.y+self.level
            elseif playerY-self.y < 0 then
                self.y = self.y-self.level
            end
            --self.x = playerX-45
            --self.y = playerY-45
        end,

        draw = function(self)
            love.graphics.setColor(1,.3,.5)
            love.graphics.circle("fill",self.x,self.y,self.radius)
            love.graphics.setColor(1,1,1)
        end,
    }
end

return Enemy