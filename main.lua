--dependencies
local vector2 = require "vector2"
local dbgoverlay = require "debugoverlay"
local segment = require "snakesegment"
collisionMatrix = require "collisionmatrix"

--game variables
local score = 0
local quadrantSize = 32
local speed = 10
local currentDirection = vector2.new(1, 0)
local goal = vector2.new(0,0)
local gridSize = vector2.new(0,0)
local isDead = false
local debug = false

math.randomseed(os.time())

function reset()
  head = segment.new(nil, vector2.new(5, 5), vector2.new(1, 0))
  head:addSegment()
  head:addSegment()
  score = 0
  local screenW
  local screenH
  screenW, screenH = love.window.getMode()
  gridSize.x = math.floor(screenW / quadrantSize)
  gridSize.y = math.floor(screenH / quadrantSize)
  collisionMatrix.init(gridSize.x, gridSize.y)
  currentDirection = vector2.new(1, 0)
  isDead = false
  head:update(0)
  setGoal()
end

function whenScored()
  score = score + 1
  head:addSegment()
  setGoal()
end

function setGoal()
  collisionMatrix.setCollisionPoint(goal.x, goal.y, 0)
  local goalCandidate = vector2.new(math.random(0, gridSize.x - 1), math.random(0, gridSize.y - 1))
  if collisionMatrix.getCollisionPoint(goalCandidate.x, goalCandidate.y) ~= 0 then
    setGoal()
    return
  end
  goal = goalCandidate
  collisionMatrix.setCollisionPoint(goal.x, goal.y, 1)
end

function getQuadrant(position)
  local center = position + vector2.one() * 0.5
  return vector2.new(math.floor(center.x), math.floor(center.y))
end

function love.load()
end

reset()

function love.draw()
  --draw head
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle('fill', head.position.x * quadrantSize, head.position.y * quadrantSize, quadrantSize, quadrantSize)
  love.graphics.setColor(255, 255, 255)
  --draw segments
  local currentSegment = head.next
  while currentSegment.next do
    love.graphics.circle('fill', currentSegment.position.x * quadrantSize + (quadrantSize / 2), currentSegment.position.y * quadrantSize + (quadrantSize / 2), quadrantSize / 2, 100)
    currentSegment = currentSegment.next
  end

  --draw goal
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle('fill', goal.x * quadrantSize, goal.y * quadrantSize, quadrantSize, quadrantSize)
  love.graphics.setColor(255, 255, 255)

  --draw score
  local x, y = love.window.getMode()
  love.graphics.print("Score: " .. score, x - 100, 25)

  if debug then
    --draw debug overlay
    dbgoverlay.draw()

    --draw collision info
    love.graphics.setColor(255, 50, 255)
    for x = 0, gridSize.x do
      for y = 0, gridSize.y do
        love.graphics.print(tostring(collisionMatrix.getCollisionPoint(x, y)), x * quadrantSize, y * quadrantSize)
      end
    end
    love.graphics.setColor(255, 255, 255)

    --draw position info
    love.graphics.print(getQuadrant(head.position).x .. " " .. getQuadrant(head.position).y, 25, 50)
  end

  if isDead then
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("HAHA YOU DIED \n (press enter to start again)", 100, 300, 0, 5, 5)
    love.graphics.setColor(255, 255, 255)
  end
end

function love.keypressed(key)
    if key == 'left' then
      currentDirection = vector2.left()
    end
    if key == 'right' then
      currentDirection = vector2.right()
    end
    if key == 'up' then
      currentDirection = vector2.up()
    end
    if key == 'down' then
      currentDirection = vector2.down()
    end
    if key == 'return' then
      reset()
    end
    if key == ' ' then
      isPaused = not isPaused
    end
    if key == 'f1' then
      debug = not debug
    end
end


local timer = 1 / speed

function love.update(dt)
  if not isDead and not isPaused then
    timer = timer - dt
    if timer <= 0 then
      dbgoverlay.update(dt)
      timer = timer + 1 / speed
      head:changeDirection(currentDirection)
    end
    collisionResult = head:update(dt * speed)
    isDead = collisionResult == nil
    if collisionResult == 1 then
      whenScored()
    end
  end
end