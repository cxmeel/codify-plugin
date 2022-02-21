local Packages = script.Parent.Parent.Packages

local IconMap = require(script.Parent.Parent.IconMap)

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local e = Roact.createElement

export type IconProps = {
	icon: string,
	anchor: Vector2?,
	size: (UDim2 | number)?,
	position: UDim2?,
	rotation: number?,
	colour: Color3?,
	zindex: number?,
	order: number?,
	resample: Enum.ResamplerMode?,
	scaleType: Enum.ScaleType?,
	imageOffset: Vector2?,
	imageSize: Vector2?,
	transparency: number?,
}

local function Icon(props: IconProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local icon = hooks.useMemo(function()
		local icon = IconMap[props.icon]

		if icon and icon[theme.Name] then
			return icon[theme.Name]
		end

		return icon
	end, { props.icon, theme })

	local size = hooks.useMemo(function()
		return if typeof(props.size) == "UDim2"
			then props.size
			elseif type(props.size) == "number" then UDim2.fromOffset(props.size, props.size)
			else UDim2.fromOffset(styles.fontSize, styles.fontSize)
	end, { props.size, icon, styles.fontSize })

	return e("ImageLabel", {
		AnchorPoint = props.anchor,
		BackgroundTransparency = 1,
		LayoutOrder = props.order,
		Position = props.position,
		Rotation = props.rotation,
		Size = size,
		ZIndex = props.zindex,
		Image = if icon then icon.assetId else props.icon,
		ImageColor3 = if icon and icon.colour
			then icon.colour
			elseif props.colour then props.colour
			else theme:GetColor(Enum.StudioStyleGuideColor.MainText),
		ImageRectOffset = if icon then Vector2.new(icon.x, icon.y) else props.imageOffset,
		ImageRectSize = if icon then Vector2.new(icon.w, icon.h) else props.imageSize,
		ImageTransparency = props.transparency,
		ResampleMode = props.resample,
		ScaleType = props.scaleType,
	})
end

return Hooks.new(Roact)(Icon)
