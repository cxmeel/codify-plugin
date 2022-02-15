local function IsLargeInstance(instance: Instance?): boolean
	local ok, size = pcall(function()
		return #instance:GetDescendants()
	end)

	return ok and size >= 20
end

return function(state, action)
	state = state or {
		instance = nil,
		large = false,
	}

	if action.type == "SET_TARGET_INSTANCE" then
		local isLarge = IsLargeInstance(action.payload)

		return {
			instance = action.payload,
			large = isLarge,
		}
	end

	return state
end
