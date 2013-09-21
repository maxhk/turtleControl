local turtle = {}

setmetatable(turtle, {
	__index = function(t,k)
		return function()
			print("[TURTLE] was asked to: ", k)
		end
	end
})

return turtle