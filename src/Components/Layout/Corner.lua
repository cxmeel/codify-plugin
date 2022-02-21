local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local StudioTheme = require(Packages.StudioTheme)
local Hooks = require(Packages.Hooks)

local e = Roact.createElement

export type CornerProps = ({ number? } | { radius: number? })

local function Corner(props: CornerProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)

	local radius = props.radius or props[1] or styles.borderRadius

	return e("UICorner", {
		CornerRadius = UDim.new(0, radius),
	})
end

return Hooks.new(Roact)(Corner)
