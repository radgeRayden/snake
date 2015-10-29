<<<<<<< HEAD
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
=======
local tmp = false
local tmp2 = false

function love.load()
	COLOR_RED = {255,0,0}
	initial_time = os.time()
	math.randomseed(os.time())
	sW, sH = love.window.getDimensions()
	local grid_size = 48
	local o = sW / grid_size
	
	require 'snake_class'
	require 'object_class'
	
	grid = {size = grid_size}
	for i = 0, grid_size, 1 do
		grid[i] = {}
	end
	
	function grid:drawlines()
		for i = 1, grid_size do
			love.graphics.line(0, i * o, sW, i * o)
		end
		for j = 1, grid_size do
			love.graphics.line(j * o, 0, j * o, sH)
		end
	end
	
	function grid:draw()
		for i = 1, #self do
			for j = 1, #self do
				if grid[i][j] then
					love.graphics.rectangle('fill', j*o, i*o, o, o)
				end
			end
		end
	end
	
	local mr = math.random
	snake = snake_class:new(_G, mr(10, 30), mr(10, 30), mr(4), o, o)
	
	food = generateObject()
	
	traps = {}
	for i = 1, 10 do
		local x, y = mr(grid_size-1), mr(grid_size-1)
		traps[i] = object_class:new(x, y, o, 'trap', COLOR_RED)
		grid[y][x] = traps[i]
	end
	
	function traps:draw()
		for i = 1, #self do
			self[i]:draw()
		end
	end
	
	gameOver = false
	started = false
end

function love.update(dt)
	if paused or gameOver or not started then
		return
	end

	-- status
	tmp = snake:update(dt)
	
	if tmp == 'food' then
		food = generateObject()
	elseif tmp == false then
		setGameOver()
	end
end

function love.draw()
	if gameOver then
		tmp = "Max. length: "..snake_length
		tmp2 =  "Total time: "..
				math.ceil(final_time - initial_time)..' segundos'
	
		love.graphics.print(tmp, sW/2 - string.len(tmp)/2, sH/2 - 10)
		love.graphics.print(tmp2, sW/2 - string.len(tmp2)/2, sH/2 + 10)
		love.graphics.print('Press ESC to exit.', 0, sH-20)
		return
	end

	traps:draw()
	snake:draw()
	food:draw()
	
	if paused then
		love.graphics.printf("PAUSE", grid.size/2, grid.size/2, 10, 'center')
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	
	if gameOver then
		return
	end
	
	started = true
	if key == ' ' then
		togglePause()
		return
	end
	
	if not paused then
		snake:handleKey(key)
	end
end

function setGameOver()
	snake_length = snake.nodes.length
	final_time = os.time()
	
	snake = nil
	traps = nil
	food = nil
	grid = nil
	
	gameOver = true
end

function togglePause()
	paused = not paused
end

function generateObject()
	-- x, y
	tmp, tmp2 = math.random(grid.size-1), math.random(grid.size-1)
	
	while grid[tmp2][tmp] do
		tmp, tmp2 = math.random(grid.size-1), math.random(grid.size-1)
	end
	
	return object_class:new(tmp, tmp2, sW / grid.size)
end

>>>>>>> origin/master
