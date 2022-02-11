local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local Layout = require(script.Parent.Layout)
local Text = require(script.Parent.Text)

local BaseCheckbox = require(script.BaseCheckbox)

local e = Roact.createElement

export type CheckboxProps = {
	disabled: boolean?,
	emphasised: boolean?,
	order: number?,
	label: string?,
	hint: string?,
	value: boolean?,
	onChanged: ((value: boolean) -> ())?,
}

local function Checkbox(props: CheckboxProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)

	local modifier = hooks.useMemo(function()
		if props.disabled then
			return Enum.StudioStyleGuideModifier.Disabled
		elseif press then
			return Enum.StudioStyleGuideModifier.Pressed
		elseif hover then
			return Enum.StudioStyleGuideModifier.Hover
		end
	end, { props.disabled, hover, press })

	local onActivated = hooks.useCallback(function()
		if props.onChanged then
			props.onChanged(not props.value)
		end
	end, { props.onChanged, props.value })

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
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.order,
		Selectable = not props.disabled,
		Size = UDim2.fromScale(1, 0),

		[Roact.Event.Activated] = onActivated,
		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
	}, {
		checkbox = e(BaseCheckbox, {
			disabled = props.disabled,
			pressed = press,
			hovered = hover,
			checked = props.value == true,
		}),

		container = e("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -28 - styles.spacing, 0, 30),
			Position = UDim2.fromScale(1, 0),
		}, {
			layout = e(Layout.ListLayout, {
				direction = Enum.FillDirection.Vertical,
				alignY = Enum.VerticalAlignment.Center,
				gap = styles.spacing / 2,
			}),

			label = e(Text, {
				text = props.label,
				textColour = if props.emphasised
					then theme:GetColor(Enum.StudioStyleGuideColor.BrightText, modifier)
					else theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
				order = 10,
			}),

			hint = props.hint and e(Text, {
				text = props.hint,
				textColour = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText, modifier),
				order = 20,
			}),
		}),
	})
end

return Hooks.new(Roact)(Checkbox, {
	componentType = "PureComponent",
})
