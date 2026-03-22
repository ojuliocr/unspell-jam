local menu = {}

local Timer = require "Libraries/timer"

local background = love.graphics.newImage("Assets/menuBackground.png")
local mooriHead = love.graphics.newImage("Assets/mooriHead.png")
local logo = love.graphics.newImage("Assets/logo.png")
local font = love.graphics.newFont("Fonts/Irish Grover.ttf", 80)
local star = love.graphics.newImage("Assets/star.png")
local bgMusic = love.audio.newSource("Assets/SFX/menu_music.mp3", "stream")
local selected = 1
local paused = false

local transition = {alpha = 1}

function menu.enter()
    selected = 1
    bgMusic:setLooping(true)
    bgMusic:play()
    love.graphics.setFont(font)

    Timer.tween(0.5, transition, {alpha = 0}, "linear", function() paused = false end)
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

    if selected == 1 then
        love.graphics.draw(star, 260, 810)
    else
        love.graphics.draw(star, 260, 910)
    end

    love.graphics.setColor(0, 0, 0, transition.alpha)
    love.graphics.rectangle('fill', 0, 0, 1920, 1080)
    love.graphics.setColor(1, 1, 1, 1)
end

function menu.keypressed(key)
    if paused then return end

    if key == "up" then selected = 1 end
    if key == "down" then selected = 2 end
    if key == "return" then
        paused = true
        Timer.tween(0.5, transition, {alpha = 1}, "linear", 
        function()
            if selected == 1 then changeState("tutorial") end
            if selected == 2 then changeState("credits") end end)
    end
end

function menu.exit()

end

return menu