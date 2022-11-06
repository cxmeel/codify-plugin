local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local e = Roact.createElement

export type TextProps = {
	autoSize: Enum.AutomaticSize?,
	position: UDim2?,
	size: UDim2?,
	font: Enum.Font?,
	richText: boolean?,
	text: string?,
	textColor: Color3?,
	textSize: number?,
	textTransparency: number?,
	textScaled: boolean?,
	wrapped: boolean?,
	alignX: Enum.TextXAlignment?,
	alignY: Enum.TextYAlignment?,
	truncate: Enum.TextTruncate?,
	zindex: number?,
	order: number?,
	clipsDescendants: boolean?,

	onAbsoluteSizeChanged: ((TextLabel) -> ())?,
}

local function Text(props: TextProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	return e("TextLabel", {
		AutomaticSize = props.autoSize or Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = props.order,
		Position = props.position,
		Size = props.size,
		ZIndex = props.zindex,
		ClipsDescendants = props.clipsDescendants,
		Font = props.font or styles.font.default,
		RichText = props.richText,
		Text = props.text,
		TextColor3 = props.textColor or theme:GetColor(Enum.StudioStyleGuideColor.MainText),
		TextSize = props.textSize or styles.fontSize,
		TextWrapped = if props.wrapped ~= nil then props.wrapped else true,
		TextXAlignment = props.alignX or Enum.TextXAlignment.Left,
		TextYAlignment = props.alignY or Enum.TextYAlignment.Top,
		TextTruncate = props.truncate,
		TextScaled = props.textScaled,
		TextTransparency = props.textTransparency,

		[Roact.Change.AbsoluteSize] = props.onAbsoluteSizeChanged,
	}, props[Roact.Children])
end

return Hooks.new(Roact)(Text)
