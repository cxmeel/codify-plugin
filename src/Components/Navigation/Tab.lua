local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local RoactRouter = require(Packages.RoactRouter)

local Layout = require(script.Parent.Parent.Layout)
local Icon = require(script.Parent.Parent.Icon)
local Text = require(script.Parent.Parent.Text)

local e = Roact.createElement

export type NavigationTabProps = {
	label: string?,
	icon: string?,
	order: number?,
	size: UDim2?,
	location: string,
}

local function NavigationTab(props: NavigationTabProps, hooks)
	local theme = StudioTheme.useTheme(hooks)
	local history = RoactRouter.useHistory(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)

	local active = history.location.path == props.location

	local modifier = if press
		then Enum.StudioStyleGuideModifier.Pressed
		elseif hover then Enum.StudioStyleGuideModifier.Hover
		else nil

	local onActivated = hooks.useCallback(function()
		history:push(props.location)
	end, { history, props.location })

	return e("ImageButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab, modifier),
		BorderSizePixel = 0,
		LayoutOrder = props.order,
		Size = props.size,
		[Roact.Event.Activated] = onActivated,

		[Roact.Event.InputBegan] = function(_, input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				setHover(true)
			elseif input.UserInputType.Name:match("MouseButton%d+") then
				setPress(true)
			end
		end,

		[Roact.Event.InputEnded] = function(_, input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				setHover(false)
				setPress(false)
			elseif input.UserInputType.Name:match("MouseButton%d+") then
				setPress(false)
			end
		end,
	}, {
		topBorder = if active
			then e("Frame", {
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.LinkText, modifier),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 2),
			})
			else nil,

		leftBorder = if active
			then e("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border, modifier),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(0, 2, 1, -2),
			})
			else nil,

		rightBorder = if active
			then e("Frame", {
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border, modifier),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(1, 1),
				Size = UDim2.new(0, 2, 1, -2),
			})
			else nil,

		bottomBorder = if not active
			then e("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border, modifier),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 2),
			})
			else nil,

		content = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
		}, {
			padding = e(Layout.Padding),

			layout = e(Layout.ListLayout, {
				direction = Enum.FillDirection.Horizontal,
				alignX = Enum.HorizontalAlignment.Center,
				alignY = Enum.VerticalAlignment.Center,
			}),

			icon = if props.icon
				then e(Icon, {
					icon = props.icon,
					size = 16,
					color = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
					order = 10,
				})
				else nil,

			label = if props.label
				then e(Text, {
					text = props.label,
					textColor = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
					order = 20,
				})
				else nil,
		}),
	})
end

return Hooks.new(Roact)(NavigationTab)
