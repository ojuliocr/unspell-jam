local states = {}
local currentState = nil
local push = require "Libraries/push"

local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

function love.load()
    states.menu = require("States/menu")
    states.game = require("States/game")
    states.splash = require("States/splash")
    states.credits = require("States/credits")
    states.tutorial = require("States/tutorial")

    currentState = states.splash
    if currentState.enter then currentState.enter() end
end

function love.update(dt)
    if currentState and currentState.update then
        currentState.update(dt)
    end
end

function love.draw()
    if currentState and currentState.draw then
        currentState.draw()
    end
end

function love.keypressed(key)
    if currentState and currentState.keypressed then
        currentState.keypressed(key)
    end
end

function love.textinput(t)
    if currentState and currentState.textinput then
        currentState.textinput(t)
    end
end

function changeState(name, ...)
    if currentState and currentState.exit then
        currentState.exit()
    end
    currentState = states[name]
    if currentState and currentState.enter then
        currentState.enter(...)
    end
end

function love.draw()
    push:start()
    currentState.draw()
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end