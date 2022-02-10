local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Llama = require(Packages.Llama)
local Hooks = require(Packages.Hooks)

local e = Roact.createElement
local max = math.max

export type JustifyFrameProps = {
	autoSize: (boolean | Enum.AutomaticSize)?,
	size: UDim2?,
	position: UDim2?,
	order: number?,
	gap: number?,
	direction: Enum.FillDirection?,
	zindex: number?,
	alignY: Enum.VerticalAlignment?,
	alignX: Enum.HorizontalAlignment?,
}

local function JustifyFrame(props: JustifyFrameProps, hooks)
	local childCount = hooks.useMemo(function()
		if not props[Roact.Children] then
			return 1
		end

		return max(Llama.Dictionary.count(props[Roact.Children]), 1)
	end, { props[Roact.Children] })

	local childSize = hooks.useMemo(function()
		local secondaryAxis = if props.autoSize == nil then 1 else 0

		return if props.direction == Enum.FillDirection.Vertical
			then UDim2.fromScale(secondaryAxis, 1 / childCount)
			else UDim2.fromScale(1 / childCount, secondaryAxis)
	end, { childCount, props.direction })

	local children = hooks.useMemo(function()
		if not props[Roact.Children] then
			return {}
		end

		return Llama.Dictionary.map(props[Roact.Children], function(el)
			local prop = el.props["$justify"]

			if type(prop) ~= "string" then
				prop = type(el.component) == "string" and "Size" or "size"
			end

			return e(
				el.component,
				Llama.Dictionary.merge(el.props, {
					[prop] = childSize,
				})
			)
		end)
	end, { props[Roact.Children], childSize })

	return e("Frame", {
		AutomaticSize = if props.autoSize == true then Enum.AutomaticSize.XY else props.autoSize,
		BackgroundTransparency = 1,
		Size = props.size,
		Position = props.position,
		LayoutOrder = props.order,
		ZIndex = props.zindex,
	}, {
		content = Roact.createFragment(children),

		layout = e("UIListLayout", {
			Padding = UDim.new(0, props.gap),
			FillDirection = props.direction,
			HorizontalAlignment = props.alignX,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = props.alignY,
		}),
	})
end

return Hooks.new(Roact)(JustifyFrame, {
	componentType = "PureComponent",
	defaultProps = {
		gap = 0,
		alignX = Enum.HorizontalAlignment.Left,
		alignY = Enum.VerticalAlignment.Top,
	},
})
