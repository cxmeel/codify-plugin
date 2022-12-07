--!strict
local React = require(script.Parent.Parent.Packages.React)

local Studio = settings():GetService("Studio")
local useEffect, useState = React.useEffect, React.useState

local function useStudioTheme()
	local studioTheme: StudioTheme, setStudioTheme = useState(Studio.Theme)

	useEffect(function()
		local connection = Studio.ThemeChanged:Connect(function()
			setStudioTheme(Studio.Theme)
		end)

		return function()
			connection:Disconnect()
		end
	end, {})

	return studioTheme
end

return useStudioTheme
