local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local Layout = require(script.Parent.Parent.Layout)
local Text = require(script.Parent.Parent.Text)
local Icon = require(script.Parent.Parent.Icon)

local e = Roact.createElement

export type OptionButtonProps = {
	label: string?,
	hint: string?,
	order: number?,
	icon: string?,
	iconPosition: string?,
	iconColour: Color3?,
	disabled: boolean?,
	selected: boolean?,
	onActivated: ((rbx: ImageButton) -> ())?,
}

local function OptionButton(props: OptionButtonProps, hooks)
	local theme = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)

	local colours = hooks.useMemo(function()
		local colours = {
			background = { Enum.StudioStyleGuideColor.TableItem, nil, 1 },
			foreground = { Enum.StudioStyleGuideColor.MainText, nil },
			hint = { Enum.StudioStyleGuideColor.DimmedText, nil },
		}

		if props.disabled then
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Disabled
			colours.hint[2] = Enum.StudioStyleGuideModifier.Disabled
		elseif props.selected then
			colours.background[3] = 0
			colours.background[2] = Enum.StudioStyleGuideModifier.Selected
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Selected
			colours.hint[2] = Enum.StudioStyleGuideModifier.Selected
		elseif hover then
			colours.background[3] = 0
			colours.background[2] = Enum.StudioStyleGuideModifier.Hover
			colours.foreground[2] = Enum.StudioStyleGuideModifier.Hover
			colours.hint[2] = Enum.StudioStyleGuideModifier.Hover
		end

		colours.backgroundTransparency = colours.background[3]
		colours.background = theme:GetColor(colours.background[1], colours.background[2])
		colours.foreground = theme:GetColor(colours.foreground[1], colours.foreground[2])
		colours.hint = theme:GetColor(colours.hint[1], colours.hint[2])

		return colours
	end, { theme, hover, props.disabled, props.selected })

	local onInputBegan = hooks.useCallback(function(_, input: InputObject)
		if props.disabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(true)
		end
	end, { props.disabled })

	local function onInputEnded(_, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(false)
		end
	end

	return e("ImageButton", {
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = colours.background,
		BackgroundTransparency = colours.backgroundTransparency,
		Size = UDim2.fromScale(1, 0),

		[Roact.Event.Activated] = props.onActivated,
		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
	}, {
		padding = e(Layout.Padding),

		corners = e(Layout.Corner, {
			radius = 2,
		}),

		layout = e(Layout.ListLayout, {
			alignY = Enum.VerticalAlignment.Center,
		}),

		icon = if props.icon
			then e(Icon, {
				icon = props.icon,
				order = if props.iconPosition == "end" then 40 else 10,
				colour = if props.iconColour then props.iconColour else colours.foreground,
				size = 16,
			})
			else nil,

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
	})
end

return Hooks.new(Roact)(OptionButton, {
	componentType = "PureComponent",
})
