local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local StudioPlugin = require(Packages.StudioPlugin)

local Layout = require(script.Parent.Parent.Layout)

local e = Roact.createElement

export type OptionsContainerProps = {
	buttonPosition: Vector2?,
	buttonSize: Vector2?,
}

local function OptionsContainer(props: OptionsContainerProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)
	local widget = StudioPlugin.useWidget(hooks)

	local optionsSize, setOptionsSize = hooks.useState(Vector2.new())
	local scrollable, setScrollable = hooks.useState(false)

	local logicalContainerSize = hooks.useMemo(function()
		return Vector2.new(props.buttonSize.X, math.min(optionsSize.Y, widget.AbsoluteSize.Y))
	end, { optionsSize })

	local containerDisplay = hooks.useMemo(function()
		local targetPosition = props.buttonPosition + Vector2.new(0, props.buttonSize.Y + styles.spacing)
		local targetSize = UDim2.fromOffset(logicalContainerSize.X, logicalContainerSize.Y + 2 + styles.spacing)
		local targetAnchor = Vector2.new()

		if (targetPosition + logicalContainerSize).Y >= widget.AbsoluteSize.Y then
			targetPosition = props.buttonPosition - Vector2.new(0, styles.spacing)
			targetAnchor = Vector2.new(0, 1)

			if targetPosition.Y - targetSize.Y.Offset < 0 then
				targetSize = UDim2.new(1, -styles.spacing * 2, 1, -styles.spacing * 3)
				targetPosition = Vector2.new(styles.spacing, styles.spacing * 2)
				targetAnchor = Vector2.new()
			end
		end

		return {
			position = UDim2.fromOffset(targetPosition.X, targetPosition.Y),
			anchor = targetAnchor,
			size = targetSize,
		}
	end, { props.buttonPosition, props.buttonSize, styles, logicalContainerSize })

	local function onScrollFrameAdjusted(rbx: ScrollingFrame)
		setScrollable(rbx.AbsoluteCanvasSize.Y > rbx.AbsoluteWindowSize.Y)
	end

	return e("ImageButton", {
		AnchorPoint = containerDisplay.anchor,
		AutoButtonColor = false,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
		Position = containerDisplay.position,
		Size = containerDisplay.size,
		ClipsDescendants = true,
	}, {
		corners = e(Layout.Corner),
		padding = e(Layout.Padding, { 1 }),

		options = e("Frame", {
			BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
		}, {
			padding = e(Layout.Padding, { styles.spacing * 0.5 }),

			corners = e(Layout.Corner, {
				radius = styles.borderRadius - 1,
			}),

			options = e("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BottomImage = "rbxasset://textures/StudioSharedUI/ScrollBarBottom.png",
				CanvasSize = UDim2.new(),
				ElasticBehavior = Enum.ElasticBehavior.Never,
				MidImage = "rbxasset://textures/StudioSharedUI/ScrollBarMiddle.png",
				ScrollBarImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
				ScrollBarThickness = 8,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				TopImage = "rbxasset://textures/StudioSharedUI/ScrollBarTop.png",
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				Active = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),

				[Roact.Change.AbsoluteCanvasSize] = onScrollFrameAdjusted,
				[Roact.Change.AbsoluteWindowSize] = onScrollFrameAdjusted,
			}, {
				padding = e(Layout.Padding, { 0, if scrollable then styles.spacing else 0, 0, 0 }),

				layout = e(Layout.ListLayout, {
					direction = Enum.FillDirection.Vertical,
					gap = 0,

					onSizeChanged = function(rbx: UIListLayout)
						setOptionsSize(rbx.AbsoluteContentSize)
					end,
				}),

				options = Roact.createFragment(props[Roact.Children]),
			}),
		}),
	})
end

return Hooks.new(Roact)(OptionsContainer, {
	componentType = "PureComponent",
})
