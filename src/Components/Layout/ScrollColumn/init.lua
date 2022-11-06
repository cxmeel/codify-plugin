local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local ListLayout = require(script.Parent.ListLayout)
local ScrollButton = require(script.ScrollButton)

local e = Roact.createElement

export type ScrollColumnProps = {
	position: UDim2?,
	size: UDim2?,
	disabled: boolean?,
	paddingTop: number?,
	paddingBottom: number?,
	scrollbarWidth: number?,
	visible: boolean?,
}

local function ScrollColumn(props: ScrollColumnProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local scrollFrameRef = hooks.useValue(Roact.createRef())
	local scrollPosition, setScrollPosition = hooks.useState(Vector2.new())
	local contentSize, setContentSize = hooks.useState(Vector2.new())
	local frameSize, setFrameSize = hooks.useState(Vector2.new())

	local newCanvasSize = hooks.useMemo(function()
		return contentSize + Vector2.new(0, props.paddingTop + props.paddingBottom)
	end, { contentSize, props.paddingTop, props.paddingBottom })

	local scrollbarVisible = hooks.useMemo(function()
		return newCanvasSize.Y > frameSize.Y
	end, { newCanvasSize, frameSize })

	local handlePosition = hooks.useMemo(function()
		local maxScroll = newCanvasSize - frameSize
		return scrollPosition / maxScroll
	end, { scrollPosition, newCanvasSize, frameSize, props.scrollbarWidth })

	local handleSize = hooks.useMemo(function()
		return frameSize / newCanvasSize
	end, { props.scrollbarWidth, frameSize, newCanvasSize })

	local incrementScroll = hooks.useCallback(function(amount: Vector2)
		local scrollFrame: ScrollingFrame? = scrollFrameRef.value:getValue()

		if scrollFrame then
			scrollFrame.CanvasPosition += amount
		end
	end, { setScrollPosition, scrollPosition, scrollFrameRef.value })

	return e("Frame", {
		BackgroundTransparency = 1,
		Position = props.position,
		Size = props.size,
		ClipsDescendants = true,
		Visible = props.visible,
	}, {
		scrollbar = if scrollbarVisible
			then Roact.createFragment({
				upButton = e(ScrollButton, {
					anchor = Vector2.new(1, 0),
					position = UDim2.fromScale(1, 0),
					size = UDim2.fromOffset(props.scrollbarWidth, props.scrollbarWidth),
					zindex = 20,
					icon = {
						icon = "Caret",
						rotation = 180,
					},
					onActivated = function()
						incrementScroll(Vector2.new(0, -styles.fontSize))
					end,
				}),

				downButton = e(ScrollButton, {
					anchor = Vector2.new(1, 1),
					position = UDim2.fromScale(1, 1),
					size = UDim2.fromOffset(props.scrollbarWidth, props.scrollbarWidth),
					zindex = 20,
					icon = "Caret",
					onActivated = function()
						incrementScroll(Vector2.new(0, styles.fontSize))
					end,
				}),

				scrollBacking = e("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ScrollBarBackground),
					BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
					Position = UDim2.new(1, 0, 0, props.scrollbarWidth),
					Size = UDim2.new(0, props.scrollbarWidth, 1, -props.scrollbarWidth * 2),
					ZIndex = 10,
				}, {
					scrollHandle = e(ScrollButton, {
						anchor = Vector2.new(1, handlePosition.Y),
						position = UDim2.fromScale(1, handlePosition.Y),
						size = UDim2.fromScale(1, handleSize.Y),
					}),
				}),
			})
			else nil,

		column = e("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = props.position,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.fromOffset(newCanvasSize.X, newCanvasSize.Y),
			CanvasPosition = scrollPosition,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			BottomImage = "",
			MidImage = "",
			TopImage = "",
			ScrollBarImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ScrollBar),
			ScrollBarThickness = props.scrollbarWidth,
			ScrollingEnabled = not props.disabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			ClipsDescendants = false,

			[Roact.Ref] = scrollFrameRef.value,
			[Roact.Change.AbsoluteSize] = function(rbx: ScrollingFrame)
				setFrameSize(rbx.AbsoluteSize)
			end,

			[Roact.Change.CanvasPosition] = function(rbx: ScrollingFrame)
				setScrollPosition(rbx.CanvasPosition)
			end,
		}, {
			layout = e(ListLayout, {
				direction = Enum.FillDirection.Vertical,
				onSizeChanged = function(rbx: UIListLayout)
					setContentSize(rbx.AbsoluteContentSize)
				end,
			}),

			Roact.createFragment(props[Roact.Children]),
		}),
	})
end

return Hooks.new(Roact)(ScrollColumn, {
	defaultProps = {
		size = UDim2.fromScale(1, 1),
		paddingTop = 0,
		paddingBottom = 0,
		scrollbarWidth = 18,
	},
})
