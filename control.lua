-- this line must be commented in ComputerCraft (windows debug)
-- local turtle = require "turtle"

-- myTurtle class inherits from turtle (both in game and in Windows)
local myTurtle = {}
myTurtle.mt = {
	-- called if field doesn't exist in myTurtle
	__index = function(t, key)
		-- get field from parent turtle if it exists
		local func = turtle[key]
		if func then return func end
		-- return warning function otherwise
		return function() 
			print("[WARN] Unknown turtle command:", key)
		end
	end
}
-- activate inheritance
setmetatable(myTurtle, myTurtle.mt)


-- myTurtle implementation
function myTurtle.turnAround()
	myTurtle.turnRight()
	myTurtle.turnRight()
end

function myTurtle.uTurnLeft()
	myTurtle.turnLeft()
	myTurtle.forward()
	myTurtle.turnLeft()
end

function myTurtle.uTurnRight()
	myTurtle.turnRight()
	myTurtle.forward()
	myTurtle.turnRight()
end


function myTurtle.select(slots)
	for id, slot in pairs(slots) do
		if myTurtle.getItemCount(slot) > 0 then
			turtle.select(slot)
			return true
		end
	end
	myTurtle.failure("No item left to select")
end

function myTurtle.place(slots)
	myTurtle.select(slots)
	return turtle.place(slot)
end

function myTurtle.placeDown(slots)
	myTurtle.select(slots)
	return turtle.placeDown(slot)
end


function myTurtle.failure(message)
	print("Turtle failure: " .. message)
	error()
end

function myTurtle.build(items)
	print("building with ", table.concat(items, ','))
end

-- Define main controller
controller = {}
controller.processMove = function(move) 
	-- figure how many times this move must be repeated
	local repeatCount = 1
	if move.rep	then 
		repeatCount = move.rep
	end
	
	for i = 1, repeatCount do
		if move.action == "composite" and move.submoves then
			for subid, submove in pairs(move.submoves) do
				controller.processMove(submove)
			end
		else
			myTurtle[move.action](move.args)
		end
		
	end
end

controller.start = function(path)
	local f = io.open(path, "r")
	
	-- Load whole file into string (workaround since *all doesn't work in ComputerCraft)
	local configAsJsonText = ""
	while true do
		local line =  f:read()
		if line == nil then break end
		configAsJsonText = configAsJsonText .. line
	end
	-- Decode to table
	local config = json.decode(configAsJsonText)
	
	-- Run
	for id, move in pairs(config.actionList) do
		controller.processMove(move)
	end
	
end

local tArgs = { ... }
if #tArgs ~= 1 then
	print( "Usage: control <json_file>" )
	return
end
controller.start(tArgs[1])

