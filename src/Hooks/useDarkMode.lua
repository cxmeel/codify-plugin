--!strict
local React = require(script.Parent.Parent.Packages.React)

local Studio = settings():GetService("Studio")
local useEffect, useState = React.useEffect, React.useState

local function useDarkMode()
	local studioTheme, setStudioTheme = useState(Studio.Theme)

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

return useDarkMode
