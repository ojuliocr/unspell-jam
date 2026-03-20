local menu = {}

local Timer = require "Libraries/timer"

local background = love.graphics.newImage("Assets/menuBackground.png")
local mooriHead = love.graphics.newImage("Assets/mooriHead.png")
local logo = love.graphics.newImage("Assets/logo.png")
local font = love.graphics.newFont("Fonts/Irish Grover.ttf", 80)
local transition = {alpha = 1}

function menu.enter()
    love.graphics.setFont(font)

    Timer.tween(0.5, transition, {alpha = 0}, "linear")
end

function menu.update(dt)
    Timer.update(dt)
end

function menu.draw()
    love.graphics.draw(background)
    love.graphics.draw(mooriHead,610,0)
    love.graphics.draw(logo, 50, 70)
    love.graphics.print("START", 350, 800)
    love.graphics.print("CREDITS", 350, 900)
    love.graphics.setColor(1, 1, 1, transition.alpha)
    love.graphics.rectangle('fill', 0, 0, 1920, 1080)
    love.graphics.setColor(1, 1, 1, 1)
end

function menu.keypressed(key)
    if key == "return" then
        changeState("game")
    end
end

function menu.exit()

end

return menu