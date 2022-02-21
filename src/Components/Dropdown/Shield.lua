local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioPlugin = require(Packages.StudioPlugin)

local e = Roact.createElement

export type DropdownPopoverShieldProps = {
	onActivated: ((rbx: ImageButton) -> ())?,
}

local function DropdownPopoverShield(props: DropdownPopoverShieldProps, hooks)
	local widget = StudioPlugin.useWidget(hooks)

	return e(Roact.Portal, {
		target = widget,
	}, {
		scrollShield = e("ScrollingFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 300,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(1, 1),
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			clickShield = e("ImageButton", {
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),

				[Roact.Event.Activated] = props.onActivated,
			}, props[Roact.Children]),
		}),
	})
end

return Hooks.new(Roact)(DropdownPopoverShield)
