--[[
Copyright (c) 2015, Westerbly (radgeRayden) Snaydley
This is licensed under the MIT license (http://opensource.org/licenses/MIT).
Time of creation: September 9th, 2015 20:59 ACT
Description:
Simple overlay for displaying debug information (only fps as of this version).
Version: 1.00
--]]

overlay = {}

local fps = 0

function overlay.draw()
  love.graphics.print('FPS: ' .. fps, 25, 25)
end

function overlay.update(dt)
  fps = 1 / dt - (1 / dt % 1)
end

return overlay
