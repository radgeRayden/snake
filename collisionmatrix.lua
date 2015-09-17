self = {}
local matrix = {}
self.xSize = 0
self.ySize = 0
local origins = {}

function self.init(xSize, ySize)
  --it's zero-based because of the coordinate system.
  for i=0, xSize * ySize do
    matrix[i] = 0
  end
  self.xSize = xSize
  self.ySize = ySize
end

function self.setCollisionPoint(x, y, value, origin)
  --if self.getCollisionPoint(x, y) ~= 0 then return end
  matrix[y * self.xSize + x] = value
end

function self.getCollisionPoint(x, y)
  if x < 0 or x >= self.xSize or y < 0 or y > self.ySize then
    return nil
  end
  return matrix[y * self.xSize + x]
end

return self
