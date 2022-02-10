local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local Layout = require(script.Parent.Layout)
local Text = require(script.Parent.Text)
local Icon = require(script.Parent.Icon)

local e = Roact.createElement

export type ButtonProps = {
	autoSize: Enum.AutomaticSize?,
	primary: boolean?,
	disabled: boolean?,
	label: string?,
	hint: string?,
	icon: string?,
	iconPosition: string?,
	size: UDim2?,
	alignX: Enum.HorizontalAlignment?,
	position: UDim2?,
	zindex: number?,
	order: number?,
	onActivated: ((ImageButton) -> ())?,
}

local function Button(props: ButtonProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)

	local colours = hooks.useMemo(function()
		local colours = {
			background = if props.primary
				then Enum.StudioStyleGuideColor.DialogMainButton
				else Enum.StudioStyleGuideColor.Button,
			foreground = if props.primary
				then Enum.StudioStyleGuideColor.DialogMainButtonText
				else Enum.StudioStyleGuideColor.ButtonText,
			border = if props.primary
				then Enum.StudioStyleGuideColor.DialogButtonBorder
				else Enum.StudioStyleGuideColor.ButtonBorder,
			modifier = Enum.StudioStyleGuideModifier.Default,
		}

		if props.disabled then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Disabled)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Disabled)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Disabled)
			colours.modifier = Enum.StudioStyleGuideModifier.Disabled
		elseif press then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Pressed)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Pressed)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Pressed)
			colours.modifier = Enum.StudioStyleGuideModifier.Pressed
		elseif hover then
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Hover)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Hover)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Hover)
			colours.modifier = Enum.StudioStyleGuideModifier.Hover
		else
			colours.background = theme:GetColor(colours.background :: any, Enum.StudioStyleGuideModifier.Default)
			colours.foreground = theme:GetColor(colours.foreground :: any, Enum.StudioStyleGuideModifier.Default)
			colours.border = theme:GetColor(colours.border :: any, Enum.StudioStyleGuideModifier.Default)
		end

		return colours
	end, { hover, press, props.primary, props.disabled, theme })

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

	local autoSizeProps = hooks.useMemo(function()
		local full = props.autoSize == Enum.AutomaticSize.XY

		return {
			autoSize = if full then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y,
			size = if full then UDim2.new() else UDim2.fromScale(1, 1),
		}
	end, { props.autoSize })

	return e("ImageButton", {
		AutoButtonColor = false,
		AutomaticSize = props.autoSize,
		BackgroundColor3 = colours.border,
		Position = props.position,
		LayoutOrder = props.order,
		Size = props.size,
		ZIndex = props.zindex,
		Image = "",

		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
		[Roact.Event.Activated] = props.onActivated,
	}, {
		corners = e(Layout.Corner),
		padding = e(Layout.Padding, { 1 }),

		content = e("Frame", {
			AutomaticSize = autoSizeProps.autoSize,
			BackgroundColor3 = colours.background,
			Size = autoSizeProps.size,
			ClipsDescendants = true,
		}, {
			padding = e(Layout.Padding),

			corners = e(Layout.Corner, {
				radius = styles.borderRadius - 1,
			}),

			layout = e(Layout.ListLayout, {
				alignY = Enum.VerticalAlignment.Center,
				alignX = props.alignX,
			}),

			icon = if props.icon
				then e(Icon, {
					icon = props.icon,
					order = if props.iconPosition == "end" then 40 else 10,
					colour = colours.foreground,
					size = 16,
				})
				else nil,

			label = e(Text, {
				autoSize = Enum.AutomaticSize.XY,
				text = props.label,
				textColour = colours.foreground,
				alignX = Enum.TextXAlignment.Center,
				alignY = Enum.TextYAlignment.Center,
				size = UDim2.new(),
				order = 20,
			}),

			hint = if props.hint
				then e(Text, {
					autoSize = Enum.AutomaticSize.XY,
					text = props.hint,
					textColour = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText, colours.modifier),
					alignX = Enum.TextXAlignment.Center,
					alignY = Enum.TextYAlignment.Center,
					size = UDim2.new(),
					visible = false,
					order = 30,
				})
				else nil,
		}),
	})
end

return Hooks.new(Roact)(Button, {
	componentType = "PureComponent",
	defaultProps = {
		autoSize = Enum.AutomaticSize.XY,
		alignX = Enum.HorizontalAlignment.Center,
	},
})
