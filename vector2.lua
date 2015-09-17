--[[
Copyright (c) 2015, Westerbly (radgeRayden) Snaydley
This is licensed under the MIT license (http://opensource.org/licenses/MIT).
Time of creation: June 30th, 2015 12:32 GMT
Description:
Helper script for handling of Vector2 type objects.
--]]

local vector2 = {}

function vector2.new(x, y)
  local self = {}
  setmetatable(self, vector2.meta)
  self.x = x
  self.y = y
  function self:magnitude()
    local x = math.abs(self.x)
    local y = math.abs(self.y)
    return math.sqrt(x ^ 2 + y ^ 2)
  end

  function self:normalized()
    local magnitude = self:magnitude()
    if magnitude == 0 then return vector2.new(0,0) end
    return vector2.new(self.x / magnitude, self.y / magnitude)
  end

  return self
end

function vector2.add(v1, v2)
  return vector2.new(v1.x + v2.x, v1.y + v2.y)
end

function vector2.sub(v1, v2)
  return vector2.new(v1.x - v2.x, v1.y - v2.y)
end

function vector2.multbynumber(v, number)
  if type(number) ~= "number" then
    error("Tried to multiply a vector but the other operand wasn't a number.")
  end

  return vector2.new(v.x * number, v.y * number)
end

function vector2.divbynumber(v, number)
  if type(number) ~= "number" then
    error("Tried to divide a vector but the other operand wasn't a number.")
  end

  return vector2.new(v.x / number, v.y / number)
end

function vector2.compare(v1, v2)
  return v1.x == v2.x and v1.y == v2.y
end

function vector2.distance(v1, v2)
  return (v2 - v1):magnitude()
end

function vector2.tostring(v)
  return "vector2(" .. v.x .. ", " .. v.y ..")"
end

vector2.meta = {}
vector2.meta.__add = vector2.add
vector2.meta.__sub = vector2.sub
vector2.meta.__mul = vector2.multbynumber
vector2.meta.__div = vector2.divbynumber
vector2.meta.__eq = vector2.compare
vector2.meta.__tostring = vector2.tostring

--'static' references to fixed directions
local _zero = vector2.new(0, 0)
local _one = vector2.new(1, 1)
local _up = vector2.new(0, -1)
local _down = vector2.new(0, 1)
local _right = vector2.new(1, 0)
local _left = vector2.new(-1, 0)

function vector2.zero()
  return _zero
end

function vector2.one()
  return _one
end

function vector2.up()
  return _up
end

function vector2.down()
  return _down
end

function vector2.right()
  return _right
end

function vector2.left()
  return _left
end

return vector2
