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
	iconColor: Color3?,
	disabled: boolean?,
	selected: boolean?,
	onActivated: ((rbx: ImageButton) -> ())?,
}

local function OptionButton(props: OptionButtonProps, hooks)
	local theme = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)

	local colors = hooks.useMemo(function()
		local colors = {
			background = { Enum.StudioStyleGuideColor.TableItem, nil, 1 },
			foreground = { Enum.StudioStyleGuideColor.MainText, nil },
			hint = { Enum.StudioStyleGuideColor.DimmedText, nil },
		}

		if props.disabled then
			colors.foreground[2] = Enum.StudioStyleGuideModifier.Disabled
			colors.hint[2] = Enum.StudioStyleGuideModifier.Disabled
		elseif props.selected then
			colors.background[3] = 0
			colors.background[2] = Enum.StudioStyleGuideModifier.Selected
			colors.foreground[2] = Enum.StudioStyleGuideModifier.Selected
			colors.hint[2] = Enum.StudioStyleGuideModifier.Selected
		elseif hover then
			colors.background[3] = 0
			colors.background[2] = Enum.StudioStyleGuideModifier.Hover
			colors.foreground[2] = Enum.StudioStyleGuideModifier.Hover
			colors.hint[2] = Enum.StudioStyleGuideModifier.Hover
		end

		colors.backgroundTransparency = colors.background[3]
		colors.background = theme:GetColor(colors.background[1], colors.background[2])
		colors.foreground = theme:GetColor(colors.foreground[1], colors.foreground[2])
		colors.hint = theme:GetColor(colors.hint[1], colors.hint[2])

		return colors
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
		BackgroundColor3 = colors.background,
		BackgroundTransparency = colors.backgroundTransparency,
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

		icon = props.icon and e(Icon, {
			icon = props.icon,
			order = if props.iconPosition == "end" then 40 else 10,
			color = if props.iconColor then props.iconColor else colors.foreground,
			size = 16,
		}),

		label = e(Text, {
			text = props.label,
			textColor = colors.foreground,
			wrapped = false,
			order = 20,
		}),

		hint = if props.hint
			then e(Text, {
				text = props.hint,
				textColor = colors.hint,
				wrapped = false,
				order = 30,
			})
			else nil,
	})
end

return Hooks.new(Roact)(OptionButton)
