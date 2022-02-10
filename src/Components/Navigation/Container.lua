local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local JustifyFrame = require(script.Parent.Parent.JustifyFrame)

local e = Roact.createElement

local function NavigationContainer(props)
	return e("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = 0,
	}, {
		tabContainer = e(JustifyFrame, {
			size = UDim2.fromScale(1, 1),
			direction = Enum.FillDirection.Horizontal,
			alignX = Enum.HorizontalAlignment.Center,
			alignY = Enum.VerticalAlignment.Top,
		}, props[Roact.Children]),
	})
end

return NavigationContainer
