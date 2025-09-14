## Quick START!

This is an animation strip in an .png format, it is 46 x 228 and is split into 6 frames
<img width="46" height="228" alt="laz-mur-spin" src="https://github.com/user-attachments/assets/2f1cfb85-1772-46f8-b8d3-3930f0c1ea68" />

As it is to be animated from top to bottom, heres how that would look like
```lua
local stripz = require 'stripz'
local anim = stripz:newStrip({atlas = "laz-mur-spin.png", quadWidth = 46, quadHeight = 38, reverse = false, x = 360, y = 120, readorder = "down", sX = 4})
```

and heres how to play, with a built-in function from stripz
```lua
function love.draw()
  anim:play(0.1)
end
```
