local Packages = script.Parent.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local Llama = require(Packages.Llama)

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

	local colours = hooks.useMemo(function()
		local colours = {
			background = Enum.StudioStyleGuideColor.ScrollBar,
			foreground = Enum.StudioStyleGuideColor.TitlebarText,
			border = Enum.StudioStyleGuideColor.Border,
		}

		if props.disabled then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Disabled)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Disabled)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Disabled)
		elseif press then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Pressed)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Pressed)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Pressed)
		elseif hover then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Hover)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Hover)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Hover)
		else
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Default)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Default)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Default)
		end

		return colours
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
		return Llama.Dictionary.merge(
			{
				anchor = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				colour = colours.foreground,
			},
			if type(props.icon) == "table"
				then props.icon
				else {
					icon = props.icon,
				}
		)
	end, { props.icon, colours.foreground })

	return e(if props.onActivated then "ImageButton" else "Frame", {
		AutoButtonColor = if props.onActivated then false else nil,
		AnchorPoint = props.anchor,
		BackgroundColor3 = colours.background,
		BorderColor3 = colours.border,
		Position = props.position,
		Size = props.size,
		ZIndex = props.zindex,

		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
		[Roact.Event.Activated] = props.onActivated,
	}, {
		Icon = if props.icon then e(Icon, iconProps) else nil,
	})
end

return Hooks.new(Roact)(ScrollButton, {
	componentType = "PureComponent",
	defaultProps = {
		zindex = 30,
	},
})
