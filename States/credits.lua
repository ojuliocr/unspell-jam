local credits = {}

local Timer = require "Libraries/timer"
local creditsImg = love.graphics.newImage("Assets/credits.png")
local font = love.graphics.newFont("Fonts/Irish Grover.ttf", 50)
local paused = false

local transition = {alpha = 1}


function credits.enter()
    paused = true
    Timer.tween(0.5, transition, {alpha = 0}, "linear", function() paused = false end)
end

function credits.update(dt)
    Timer.update(dt)
end

function credits.draw()
    love.graphics.draw(creditsImg, 0, 0)
    love.graphics.setFont(font)
    love.graphics.print("Press ENTER to return", 700, 1000)
    love.graphics.setColor(0,0,0,transition.alpha)
    love.graphics.rectangle('fill',0,0,1920,1080)
end

function credits.keypressed(key)
    if paused then return end

    if key == "return" then
        paused = true
        Timer.tween(0.5, transition, {alpha = 1}, "linear", function() changeState("menu") end)
    end
end

function credits.exit()

end

return credits