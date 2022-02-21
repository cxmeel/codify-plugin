local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)

local e = Roact.createElement

export type FrameProps = {
	autoSize: Enum.AutomaticSize?,
	size: UDim2?,
	order: number?,
}

local function Frame(props: FrameProps)
	return e("Frame", {
		AutomaticSize = props.autoSize,
		BackgroundTransparency = 1,
		Size = props.size,
		LayoutOrder = props.order,
	}, props[Roact.Children])
end

return Hooks.new(Roact)(Frame, {
	defaultProps = {
		autoSize = Enum.AutomaticSize.Y,
		size = UDim2.fromScale(1, 0),
	},
})
