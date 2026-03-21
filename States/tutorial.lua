local tutorial = {}

local Timer = require "Libraries/timer"
local tutorialImg = love.graphics.newImage("Assets/tutorial.png")
local tutorialBg = love.graphics.newImage("Assets/background.png")
local transition = {alpha = 1}


function tutorial.enter()
    Timer.tween(0.3, transition, {alpha = 0}, "linear")
end

function tutorial.update(dt)
    Timer.update(dt)
end

function tutorial.draw()
    love.graphics.draw(tutorialBg, 0, 0)
    love.graphics.draw(tutorialImg, 0, 0)
    love.graphics.setColor(0,0,0,transition.alpha)
    love.graphics.rectangle('fill',0,0,1920,1080)
end

function tutorial.keypressed(key)
    if key == "return" then changeState("game") end
end

function tutorial.exit()

end

return tutorial