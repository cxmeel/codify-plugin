local Packages = script.Parent.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local Sift = require(Packages.Sift)

local Icon = require(script.Parent.Parent.Parent.Icon)

local e = Roact.createElement

export type ScrollButtonProps = {
	anchor: Vector2?,
	position: UDim2?,
	size: UDim2?,
	icon: (string | Icon.IconProps)?,
	disabled: boolean?,
	zindex: number?,
	onActivated: ((ImageButton) -> ())?,
}

local function ScrollButton(props: ScrollButtonProps, hooks)
	local theme = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)

	local colors = hooks.useMemo(function()
		local colors = {
			background = Enum.StudioStyleGuideColor.ScrollBar,
			foreground = Enum.StudioStyleGuideColor.TitlebarText,
			border = Enum.StudioStyleGuideColor.Border,
		}

		if props.disabled then
			colors.background = theme:GetColor(colors.background :: any, Enum.StudioStyleGuideModifier.Disabled)
			colors.foreground = theme:GetColor(colors.foreground :: any, Enum.StudioStyleGuideModifier.Disabled)
			colors.border = theme:GetColor(colors.border :: any, Enum.StudioStyleGuideModifier.Disabled)
		elseif press then
			colors.background = theme:GetColor(colors.background :: any, Enum.StudioStyleGuideModifier.Pressed)
			colors.foreground = theme:GetColor(colors.foreground :: any, Enum.StudioStyleGuideModifier.Pressed)
			colors.border = theme:GetColor(colors.border :: any, Enum.StudioStyleGuideModifier.Pressed)
		elseif hover then
			colors.background = theme:GetColor(colors.background :: any, Enum.StudioStyleGuideModifier.Hover)
			colors.foreground = theme:GetColor(colors.foreground :: any, Enum.StudioStyleGuideModifier.Hover)
			colors.border = theme:GetColor(colors.border :: any, Enum.StudioStyleGuideModifier.Hover)
		else
			colors.background = theme:GetColor(colors.background :: any, Enum.StudioStyleGuideModifier.Default)
			colors.foreground = theme:GetColor(colors.foreground :: any, Enum.StudioStyleGuideModifier.Default)
			colors.border = theme:GetColor(colors.border :: any, Enum.StudioStyleGuideModifier.Default)
		end

		return colors
	end, { props.disabled, press, hover, theme })

	local onInputBegan = hooks.useCallback(function(_, input: InputObject)
		if props.disabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(true)
		elseif input.UserInputType.Name:match("MouseButton%d+") then
			setPress(true)
		end
	end, { props.disabled })

	local function onInputEnded(_, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(false)
			setPress(false)
		elseif input.UserInputType.Name:match("MouseButton%d+") then
			setPress(false)
		end
	end

	local iconProps = hooks.useMemo(function()
		return Sift.Dictionary.merge(
			{
				anchor = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				color = colors.foreground,
			},
			if type(props.icon) == "table"
				then props.icon
				else {
					icon = props.icon,
				}
		)
	end, { props.icon, colors.foreground })

	return e(if props.onActivated then "ImageButton" else "Frame", {
		AutoButtonColor = if props.onActivated then false else nil,
		AnchorPoint = props.anchor,
		BackgroundColor3 = colors.background,
		BorderColor3 = colors.border,
		Position = props.position,
		Size = props.size,
		ZIndex = props.zindex,

		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
		[Roact.Event.Activated] = props.onActivated,
	}, {
		Icon = props.icon and e(Icon, iconProps),
	})
end

return Hooks.new(Roact)(ScrollButton, {
	defaultProps = {
		zindex = 30,
	},
})
