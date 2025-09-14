anim = require "stripz"
love.graphics.setDefaultFilter('nearest', 'nearest')

local a = anim:newStrip({atlas = "laz-mur-spin.png", quadWidth = 46, quadHeight = 38, reverse = false, x = 360, y = 120, readorder = "down", sX = 4})
local b = anim:newStrip({atlas = "laz-mur-spin.png", quadWidth = 46, quadHeight = 38, reverse = false, x = 360, y = 420, readorder = "down", sX = 4})
local ns = anim:newStrip({atlas = "mursheet1.png", readorder = "loopover", x = 220, y = 240})
local bs = anim:newStrip({atlas = "mursheet1.png", readorder = "loopover", x = 520, y = 240})
local ls = anim:newStrip({atlas = "lazsheet1.png", readorder = "loopover", x = 520, y = 240})

local va = 1

function love.load()
    love.window.setTitle("this is a desparate cry for help")
    
end

function love.update(dt)
    va = va + dt
end

function love.draw()
    love.graphics.draw(ls.atlas, ls.quad[math.max(1, math.floor(va) % 4)], -120,520,0,40, -50)
    love.graphics.setColor(1,1,1,0.6)
    love.graphics.draw(ns.atlas, ns.quad[math.max(1, math.floor(va) % 4)], -256,0,0,40, 30)
    love.graphics.setColor(1,1,1)

    -- FOR THE LOVE OF GOD PLEASE DO NOT EDIT THE WIDTH AND HEIGHT RETROPECTIVLEY IT WONT DO ANYTHING
    ns:play(0.1, "1-22")
    ns.sX = math.abs(math.cos(va / 4)) * 8
    ns.sY = math.abs(math.cos(va / 4)) * 8
    ns.r = math.rad(va * 56)
    
    bs:play(0.1, "-100-122")
    bs.sX = math.abs(math.cos(va / 4)) * 8
    bs.sY = math.abs(math.cos(va / 4)) * 8
    bs.r = -math.rad(va * 56)
    
    a:play(0.1)
    b:play(0.1)

end