local mt = {}
local stripz = {}
setmetatable(stripz, mt)
mt.__index = mt

local dt = love.timer.getDelta()
lg = love.graphics

--[[
    ANIMATION LIB:
    send in only the atlas location, image width and height and it automatically chops it up into quads 
    ]]

---@param framerate number Animation Speed
---@param specificGroup "string" Quad group to play (ex. 2-8), defaults to 1 - #quad if n greater/lesser than #quad
function mt:play(framerate, specificGroup)

    if specificGroup then
        local from, to = specificGroup:match("(.+)-(.+)")
        assert(from < to, "minimum CANNOT be greater than maximum!")
        self.frame = math.max(math.max(1, from), (self.frame + (framerate / dt)) % math.min(to, #self.quad))
    else
        self.frame = math.max(1, (self.frame + (framerate / dt)) % #self.quad)
    end

    -- FOR THE LOVE OF GOD PLEASE DO NOT EDIT THE WIDTH AND HEIGHT RETROPECTIVLEY IT WONT DO ANYTHING
    local centX, centY = (math.floor(self.quadWidth / 2)), (math.floor(self.quadHeight / 2))

    lg.push()
    lg.origin()
    lg.translate(self.x + centX, self.y + centY)
    lg.rotate(self.r)
    lg.scale(self.sX, self.sY)
    lg.translate(-self.x - centX, -self.y - centY)
    lg.draw(self.atlas, self.quad[math.floor(self.frame) % #self.quad], self.x, self.y)
    lg.pop()
end

--- new animation strip/spritemap
---@class StripOptions
---@field atlas? "Image"|"string" Image (or location of) to break into quads
---@field x? number X position of object
---@field y? number Y position of object
---@field quadWidth? number  Quad width
---@field quadHeight? number Quad height
---@field sX? number Scale X amount 
---@field sY? number Scale Y amount
---@field readorder? "down"|"loopover" 'down' goes top to bottom, 'loopover' goes left to right top to bottom
---@field reverse boolean Flip list and add it back, acting as a revesal on play
---@field r? number Rotation of object

---@param stripData? StripOptions
function mt:newStrip(stripData)
    local atl, x, y, r, qW, qH, q, rorder, rev, sX, sY

    -- Throw error if not table
    assert(((stripData ~= nil and type(stripData) ~= "table") or stripData ~= nil), "table required! ex. {atlas = sheet1.png}")
    
    -- Account for passing direct images or image location (userdata/string)
    atl = type(stripData.atlas) == "userdata" and stripData.atlas or lg.newImage(stripData.atlas)
    
    -- Get readorder (rightloop, down)
    rorder = stripData.readorder or "down"
    rev = stripData.reverse

    -- Quad width & height (full quadWidth or qW)
    qW = stripData.quadWidth or 32
    qH = stripData.quadHeight or 32
    q = {}

    -- Set to X,Y
    x = stripData.x or 0
    y = stripData.y or 0

    -- Set to sX, sY
    r = stripData.r or 0
    sX = stripData.sX or 2
    sY = stripData.sY or 2
    
    -- Smash into Quads, Adding to list via read order
    if rorder == "down" then
        --Straight down 
        for i = 0, math.floor((atl:getHeight() / qH)) do
            q[i + 1] = lg.newQuad(0, (i) * qH, qW, qH, atl)
        end
    elseif rorder == "loopover" then
        -- Top to bottom, left to right
        local row = (atl:getWidth() / qW)
        for i = 0, math.floor((atl:getHeight() * atl:getWidth()) / (qW * qH)) do
            q[i + 1] = lg.newQuad((i % row) * qW, math.floor(i / row) * qH, qW, qH, atl)
        end
    end

    -- Flip the list and add (ex. {1,2,3} -> {1,2,3,2,1})
    if rev then
        for i = #q - 1, 0, -1 do
            table.insert(q, q[i])
        end
    end

    return setmetatable({
        atlas = atl,
        quad = q,
        x = x,
        y = y,
        r = r,
        sX = sX,
        sY = sY,
        quadHeight = qH,
        quadWidth = qW,
        frame = 1
    }, mt)
end

return stripz