local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local Layout = require(script.Parent.Parent.Layout)
local Text = require(script.Parent.Parent.Text)
local Icon = require(script.Parent.Parent.Icon)

local e = Roact.createElement

export type DropdownButtonProps = {
	label: string?,
	hint: string?,
	disabled: boolean?,
	active: boolean?,
	order: number?,
	icon: string?,
	iconPosition: string?,
	iconColour: Color3?,
	onActivated: ((rbx: ImageButton) -> ())?,
	onPositionChanged: ((rbx: ImageButton) -> ())?,
	onSizeChanged: ((rbx: ImageButton) -> ())?,
}

local function DropdownButton(props: DropdownButtonProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)

	local colours = hooks.useMemo(function()
		local colours = {
			border = { Enum.StudioStyleGuideColor.InputFieldBorder, nil },
			background = { Enum.StudioStyleGuideColor.InputFieldBackground, nil },
			foreground = { Enum.StudioStyleGuideColor.MainText, nil },
			hint = { Enum.StudioStyleGuideColor.DimmedText, nil },
		}

		if props.disabled then
			colours.border[2] = Enum.StudioStyleGuideModifier.Disabled
			colours.background[2] = Enum.StudioStyleGuideModifier.Disabled
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Disabled
			colours.hint[2] = Enum.StudioStyleGuideModifier.Disabled
		elseif press or props.active then
			colours.border[2] = Enum.StudioStyleGuideModifier.Pressed
			colours.background[2] = Enum.StudioStyleGuideModifier.Pressed
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Pressed
			colours.hint[2] = Enum.StudioStyleGuideModifier.Pressed
		elseif hover then
			colours.border[2] = Enum.StudioStyleGuideModifier.Hover
			colours.background[2] = Enum.StudioStyleGuideModifier.Hover
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Hover
			colours.hint[2] = Enum.StudioStyleGuideModifier.Hover
		end

		colours.border = theme:GetColor(colours.border[1], colours.border[2])
		colours.background = theme:GetColor(colours.background[1], colours.background[2])
		colours.foreground = theme:GetColor(colours.foreground[1], colours.foreground[2])
		colours.hint = theme:GetColor(colours.hint[1], colours.hint[2])

		return colours
	end, { theme, hover, press, props.disabled, props.active })

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

	return e("ImageButton", {
		Active = not props.disabled,
		AutoButtonColor = false,
		BackgroundColor3 = colours.border,
		LayoutOrder = props.order,
		Selectable = not props.disabled,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,

		[Roact.Event.Activated] = props.onActivated,
		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,

		[Roact.Change.AbsoluteSize] = props.onSizeChanged,
		[Roact.Change.AbsolutePosition] = props.onPositionChanged,
	}, {
		padding = e(Layout.Padding, { 1 }),
		corners = e(Layout.Corner),

		content = e("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = colours.background,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
		}, {
			padding = e(Layout.Padding),

			corners = e(Layout.Corner, {
				radius = styles.borderRadius - 1,
			}),

			layout = e(Layout.ListLayout, {
				alignY = Enum.VerticalAlignment.Center,
				alignX = Enum.HorizontalAlignment.Right,
			}),

			icon = e(Icon, {
				icon = "Caret",
				colour = colours.foreground,
				order = 20,
				size = 16,
			}),

			text = e("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				LayoutOrder = 10,
				Size = UDim2.new(1, -24, 0, 0),
			}, {
				layout = e(Layout.ListLayout, {
					alignY = Enum.VerticalAlignment.Center,
				}),

				icon = props.icon and e(Icon, {
					icon = props.icon,
					order = if props.iconPosition == "end" then 40 else 10,
					colour = if props.iconColour then props.iconColour else colours.foreground,
					size = 16,
				}),

				label = e(Text, {
					text = props.label,
					textColour = colours.foreground,
					order = 20,
				}),

				hint = if props.hint
					then e(Text, {
						text = props.hint,
						textColour = colours.hint,
						order = 30,
					})
					else nil,
			}),
		}),
	})
end

return Hooks.new(Roact)(DropdownButton, {
	componentType = "PureComponent",
})
