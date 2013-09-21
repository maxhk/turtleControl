-- used under windows for debugging purposes
-- this line must be commented in ComputerCraft
local turtle = require "turtle" ; require "json"  
-----------------------------------------------------

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
		print("turn around!")
end


controller = {}

controller.start = function()
	myTurtle.turnAround()
	myTurtle["turnAround"]()
	myTurtle.forward()
	myTurtle.forwards()
end


controller.start()
