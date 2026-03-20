local game = {}

---------------------------------------------------------------------------------
local words = {
    "people", "time", "day", "year", "way", "thing", "man",
    "world", "life", "hand", "part", "child", "eye", "place",
    "work", "week", "case", "point", "government", "company",
    "development", "environment", "knowledge", "responsibility", 
    "opportunity", "relationship", "performance", "communication", 
    "improvement", "management", "achievement", "requirement", "significance",
    "confidence", "independence", "perspective", "consequence", 
    "interpretation", "distribution", "maintenance"
}

-- LOAD LIBRARIES --

local screen = require "Libraries/shack"
local Timer = require "Libraries/timer"
local push = require "Libraries/push"

-- LOAD ASSETS --

local background = {
    n1 = love.graphics.newImage("Assets/Background/1.png"),
    n2 = love.graphics.newImage("Assets/Background/2.png"),
    n3 = love.graphics.newImage("Assets/Background/3.png"),
    n4 = love.graphics.newImage("Assets/Background/4.png"),
    n5 = love.graphics.newImage("Assets/Background/5.png"),
    clouds = love.graphics.newImage("Assets/Background/6.png"),
    n7 = love.graphics.newImage("Assets/Background/7.png"),
    n8 = love.graphics.newImage("Assets/Background/8.png"),
    n9 = love.graphics.newImage("Assets/Background/9.png")
}

local endCharacter =  {
    win = love.graphics.newImage("Assets/charWin.png"),
    lose = love.graphics.newImage("Assets/charLose.png"),
    lose2 = love.graphics.newImage("Assets/charLose2.png")
}
local mainCharacter = love.graphics.newImage("Assets/mainCharacter.png")
local babyDemon = love.graphics.newImage("Assets/babyDemon.png")
local ribbon = love.graphics.newImage("Assets/ribbon.png")
local font = love.graphics.newFont("Fonts/Irish Grover.ttf", 80)
local mooriChibi = love.graphics.newImage("Assets/mooriChibi.png")
local babyChibi = love.graphics.newImage("Assets/babyChibi.png")
local progressBar = love.graphics.newImage("Assets/progressBar.png")
local light = love.graphics.newImage("Assets/light.png")
local combo = {
    x1 = love.graphics.newImage("Assets/combo1.png"),
    x2 = love.graphics.newImage("Assets/combo2.png"),
    x3 = love.graphics.newImage("Assets/combo3.png")
}

-------------------------

-- LOAD SHADERS --

local dissolveShader = love.graphics.newShader("Shaders/dissolve.glsl")
local noiseMap = love.graphics.newImage("Shaders/noise.png")

-------------------------

---------------------------------------------
    local invertedWord = ""
    local typedWord = ""
    local acertou = false
    local paused = false
    local charIndex = 1
    local lvlIndex = 1
    local health = 50
    local countdownTime = 1
    local hitTimer = { player = 0, enemy = 0 }
    local hitDuration = 0.3
    local gameState = ""
    local endTriggered = false
    local isRetry = false
    local comboMeter = 0
----------------------------------------
-- TWEEN VARIABLES --

    local dissolve = {threshold = 1}
    local wordOpacity = {alpha = 1}
    local charPos = {x = -500}
    local charColor = {255, 255, 255}
    local typedLetters = {}
    local iniValues = {totalValue = 50, enemy = 1, playerSub = 2, PlayerAdd = 4}
    local barValues = {totalValue = 50, enemy = 1, playerSub = 2, PlayerAdd = 4}
    local statePos = {x = 140, y = 290}
    local retryOpacity = {alpha = 0}
    local cloudX = 0
    local lightOpacity = {alpha = 0}
--------------------------

function game.enter()
---------------------------------------------
    invertedWord = ""
    typedWord = ""
    acertou = false
    paused = false
    charIndex = 1
    lvlIndex = 1
    health = 50
    countdownTime = 1
    hitTimer.player = 0
    hitTimer.enemy = 0
    hitDuration = 0.3
    gameState = ""
    endTriggered = false
    isRetry = false
    comboMeter = 0
----------------------------------------
-- TWEEN VARIABLES --

    dissolve.threshold = 1
    wordOpacity.alpha = 1
    charPos.x = -500
    charColor = {255, 255, 255}
    typedLetters = {}
    barValues.totalValue = 50
    barValues.enemy = 1
    barValues.playerSub = 2
    barValues.PlayerAdd = 4
    statePos.x = 140
    statePos.y = 290
    retryOpacity.alpha = 0
    cloudX = 0
    lightOpacity.alpha = 0
--------------------------

    love.graphics.setFont(font)
    shuffle(words)

    for i = #words, 1, -1 do
        invertedWord = invertedWord .. words[lvlIndex]:sub(i, i)
    end
    Timer.script(function(wait) wait(0.5) Timer.tween(0.5, charPos, {x = 140}, 'out-elastic') end)
end

function game.update(dt)
    screen:update(dt)
    Timer.update(dt)

    hitTimer.player = hitTimer.player - dt
    hitTimer.enemy = hitTimer.enemy - dt

    if barValues.totalValue <= 0 and endTriggered == false then 
        gameState = "lose"
        endTriggered = true
        screen:setShake(20)
        Timer.script(function(wait) wait(1) Timer.tween(1, statePos, {x = 720, y = 290}, 'out-quad', function() isRetry = true end) end)
         Timer.tween(0.3, lightOpacity, {alpha = 1}, 'in-bounce')
    end
    
    if isRetry and retryOpacity.alpha == 0 then
        Timer.tween(0.1, retryOpacity, {alpha = 1}, "linear")
    end

    if paused then return end 

    cloudX = cloudX - 50 * dt

    if cloudX < -background.clouds:getWidth() then
        cloudX = cloudX + background.clouds:getWidth()
    end

    countdownTime = countdownTime - dt
     if countdownTime <= 0 then
            -- DIMINUI A BARRA DO PLAYER POR SEGUNDO --
          Timer.tween(1, barValues, {totalValue = barValues.totalValue - barValues.enemy}, "linear")
          --
          countdownTime = countdownTime + 1
     end


     if comboMeter >= 1 then
        barValues.enemy = iniValues.enemy * comboMeter
        barValues.playerSub = iniValues.playerSub * comboMeter
        barValues.PlayerAdd = iniValues.PlayerAdd * comboMeter
     else
        barValues.enemy = iniValues.enemy
        barValues.playerSub = iniValues.playerSub
        barValues.PlayerAdd = iniValues.PlayerAdd
    end
end

function game.textinput(t)
    if acertou or paused then return end  

    local nextChar = string.sub(string.upper(words[lvlIndex]), charIndex, charIndex)

    if string.upper(t) == nextChar then
        table.insert(typedLetters, {char = t,scale = {sx = 0, sy = 0}}) Timer.tween(0.15, typedLetters[#typedLetters].scale, {sx = 1, sy = 1}, "out-back")
        typedWord = typedWord .. t
        charIndex = charIndex + 1
    else
        playerHit()
        comboMeter = 0
        -- DIMINUI A BARRA DO PLAYER QUANDO ERRA --
        Timer.tween(0.1, barValues, {totalValue = barValues.totalValue - barValues.playerSub}, "linear")
    end

    if typedWord == words[lvlIndex] then
        acertou = true
        if comboMeter <= 2 then
            comboMeter = comboMeter + 1
        end
        enemyHit()
        -- AUMENTA O VALOR DA BARRA DO PLAYER --
        Timer.tween(0.1, barValues, {totalValue = barValues.totalValue + barValues.PlayerAdd}, "linear")
        --
        dissolve.threshold = 1
        Timer.tween(1.0, dissolve, {threshold = 0}, "linear", function() dissolve.threshold = 1 wordOpacity.alpha = 0 end)
        Timer.after(1.5, function() nxtLevel() end)
    end

end

function game.keypressed(key)
    if acertou then return end

    if key == "return" and isRetry then
        changeState("game")
    end
end

function game.draw()
    screen:apply()

    local shakeX, shakeY = 0, 0

    love.graphics.setColor(1, 1, 1, 1)
    
    drawBackground()

    love.graphics.draw(ribbon, 400, 10, 0)
    love.graphics.setColor(charColor)

    drawPlayer()

    drawEnemy()

    love.graphics.setColor(0, 0, 0, wordOpacity.alpha)
    love.graphics.setShader(dissolveShader)
    dissolveShader:send("dissolve_texture", noiseMap)
    dissolveShader:send("dissolve_value", dissolve.threshold)
    dissolveShader:send("burn_size", 0.08)
    dissolveShader:send("burn_color", {1.0, 0.4, 0.8, 1.0})

    font:setLineHeight(100)
    love.graphics.printf(string.upper(invertedWord), 0, 50, push:getWidth(), "center")

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)

    local startX = (push:getWidth() - font:getWidth(string.upper(typedWord))) / 2
    local x = startX

    for _, letra in ipairs(typedLetters) do
        local char = string.upper(letra.char)
        local lw = font:getWidth(char)
        local lh = font:getHeight()
        love.graphics.print(char,x + lw/2,980 + lh/2,0,letra.scale.sx,letra.scale.sy,lw/2,lh/2)
        x = x + lw
    end

    if comboMeter == 3 then
        love.graphics.draw(combo.x3, 370, 250)
        love.graphics.print(barValues.enemy .."  ".. barValues.playerSub .."  ".. barValues.PlayerAdd, 500, 500)
    elseif comboMeter == 2 then
        love.graphics.draw(combo.x2, 370, 250)
        love.graphics.print(barValues.enemy .."  ".. barValues.playerSub .."  ".. barValues.PlayerAdd, 500, 500)
    elseif comboMeter == 1 then
        love.graphics.draw(combo.x1, 370, 250)
        love.graphics.print(barValues.enemy .."  ".. barValues.playerSub .."  ".. barValues.PlayerAdd, 500, 500)
    else
        love.graphics.print(barValues.enemy .."  ".. barValues.playerSub .."  ".. barValues.PlayerAdd, 500, 500)
    end

    local barW = 525
    local barH = 40
    local barX = 690
    local barY = 808
    local playerW = (barValues.totalValue / 100) * barW
    local enemyW = barW - playerW

    love.graphics.setColor(0.37, 0.78, 0.97)
    love.graphics.rectangle("fill", barX, barY, playerW, barH)

    love.graphics.setColor(1, 0.27, 0.40)
    love.graphics.rectangle("fill", barX + playerW, barY, enemyW, barH)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(progressBar, 620, 790)

    love.graphics.draw(mooriChibi, barX + playerW - 100 * 2, 690)

    love.graphics.draw(babyChibi, barX + playerW + 100/2, 690)

    if gameState == "lose" then
        drawEnd(lose)
    end

    if isRetry == true then
        drawRetry()
    end

end

function drawBackground()
    love.graphics.draw(background.n9)
    love.graphics.draw(background.n8)
    love.graphics.draw(background.n7)
    love.graphics.draw(background.clouds, cloudX, 0)
    love.graphics.draw(background.clouds, cloudX + background.clouds:getWidth(), 0)
    love.graphics.draw(background.n4)
    love.graphics.draw(background.n5)
    love.graphics.draw(background.n2)
    love.graphics.draw(background.n3)
    love.graphics.draw(background.n1)

end

function drawPlayer()
    local shakeX, shakeY = 0, 0

    if hitTimer.player > 0 then
        love.graphics.setBlendMode("add")
        shakeX = math.random(-8, 8)
        shakeY = math.random(-8, 8)
    end
    
    love.graphics.draw(mainCharacter, charPos.x + shakeX, 290 + shakeY)

    love.graphics.setBlendMode("alpha")
end

function drawEnemy()
      local shakeX, shakeY = 0, 0

    if hitTimer.enemy > 0 then
        love.graphics.setBlendMode("add")
        shakeX = math.random(-8, 8)
        shakeY = math.random(-8, 8)
    end

    love.graphics.draw(babyDemon, 920 + shakeX, 250 + shakeY)

    love.graphics.setBlendMode("alpha")
end

function drawEnd(state)
    
    if state == lose then
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", 0, 0, 1920, 1080)
        love.graphics.setColor(1,1,1,1)

        if statePos.x <= 140 then
            love.graphics.draw(endCharacter.lose2, statePos.x, statePos.y)
        else
            love.graphics.draw(endCharacter.lose, statePos.x, statePos.y)
        end

    end
end

function drawRetry()
    love.graphics.setColor(1, 1, 1, retryOpacity.alpha)
    love.graphics.printf(string.upper("Retry?"), 0, 920, push:getWidth(), "center")
    love.graphics.setColor(1, 1, 1, lightOpacity.alpha)
    love.graphics.draw(light, 720, 0)

end

function shuffle(t)
    local n = #t
    while n > 1 do
        local k = love.math.random(n)
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
    return t
end

function nxtLevel()
    charIndex = 1
    typedLetters = {}
    typedWord = ""
    invertedWord = ""
    lvlIndex = lvlIndex + 1
    for i = #words, 1, -1 do
        invertedWord = invertedWord .. words[lvlIndex]:sub(i, i)
    end
    Timer.tween(0.5, wordOpacity, {alpha = 1}, "linear", function() acertou = false end)
end

function playerHit()
    hitTimer.player = hitDuration
end

function enemyHit()
    hitTimer.enemy = hitDuration
end

return game