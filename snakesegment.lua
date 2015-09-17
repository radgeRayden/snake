segment = {}
function segment.new(parent, position, direction)
  local self = {}
  if not parent then
    self.position = position
    self.direction = direction
  else
    parent.child = self
    self.position = parent.position - parent.direction
    self.direction = parent.direction
    self.parent = parent
  end

  function self:changeDirection(direction)
    --alignment correction (irregular dts might cause the segments to be unaligned)
    self.position = getQuadrant(self.position)

    if self.child then
      self.child:changeDirection(self.direction)
    end

    --we don't want the head colliding with itself :p
    if not self.child then
      local lastQuadrant = getQuadrant(self.position - self.direction)
      collisionMatrix.setCollisionPoint(lastQuadrant.x, lastQuadrant.y, 0)
    end

    --avoid turning back on itself
    if self.direction * -1 ~= direction then
      self.direction = direction
    end
  end

  function self:addSegment()
    if self.child then self.child:addSegment(); return end
    self.child = segment.new(self)
  end

  function self:update(ds)
    if self.child then
      self.child:update(ds)
    end

    self.position = self.position + self.direction * ds

    if not self.parent then
      local quadrant = getQuadrant(self.position)
      collisionResult = collisionMatrix.getCollisionPoint(quadrant.x, quadrant.y)
      return collisionResult
    else
      local quadrant = getQuadrant(self.position)
      collisionMatrix.setCollisionPoint(quadrant.x, quadrant.y, nil)
    end
  end

  return self
end

return segment
