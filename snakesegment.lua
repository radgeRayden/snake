segment = {}
function segment.new(previous, position, direction)
  local self = {}
  if not previous then
    self.position = position
    self.direction = direction
    self.rotation = direction
  else
    previous.next = self
    self.position = previous.position - previous.direction
    self.direction = previous.direction
    self.previous = previous
  end

  function self:changeDirection(direction)
    --alignment correction (irregular dts might cause the segments to be unaligned)
    self.position = getQuadrant(self.position)

    if self.next then
      self.next:changeDirection(self.direction)
    end

    --we don't want the head colliding with itself :p


    --avoid turning back on itself
    if self.direction * -1 ~= direction then
      self.direction = direction
    end
  end

  function self:addSegment()
    if self.next then self.next:addSegment(); return end
    self.next = segment.new(self)
  end

  function self:update(ds)
    if self.next then
      self.next:update(ds)
    end

    self.position = self.position + self.direction * ds

    if not self.previous then
      local quadrant = getQuadrant(self.position)
      collisionResult = collisionMatrix.getCollisionPoint(quadrant.x, quadrant.y)
      return collisionResult
    else
      local quadrant = getQuadrant(self.position)
      collisionMatrix.setCollisionPoint(quadrant.x, quadrant.y, nil)
    end

    if not self.next then
      local lastQuadrant = getQuadrant(self.position) -- self.direction)
      collisionMatrix.setCollisionPoint(lastQuadrant.x, lastQuadrant.y, 0)
    end
  end

  return self
end

return segment
