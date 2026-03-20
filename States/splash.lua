local splash = {}

local Timer = require "Libraries/timer"
local logoImg = love.graphics.newImage("Assets/splashLogo.png")
local logo = {alpha = 0}


function splash.enter()
    Timer.script(function(wait)
    Timer.tween(0.5, logo, {alpha = 1}, 'linear')
    wait(3)
    Timer.tween(0.5, logo, {alpha = 0}, 'linear')
    wait(1)
    changeState("menu") end)
end

function splash.update(dt)
     Timer.update(dt)
end

function splash.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 0, 0, 1920, 1080)
    love.graphics.setColor(1, 1, 1, logo.alpha)
    love.graphics.draw(logoImg, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
end

function splash.keypressed(key)

end

function splash.exit()

end

return splash