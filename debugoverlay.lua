overlay = {}

local fps = 0

function overlay.draw()
  love.graphics.print('FPS: ' .. fps, 25, 25)
end

function overlay.update(dt)
  fps = 1 / dt - (1 / dt % 1)
end

return overlay
