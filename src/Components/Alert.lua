local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local Llama = require(Packages.Llama)

local Icon = require(script.Parent.Icon)
local Text = require(script.Parent.Text)
local JustifyFrame = require(script.Parent.JustifyFrame)

local e = Roact.createElement

export type AlertProps = {
	order: number?,
	zindex: number?,
	variant: Enum.MessageType?,
	label: string,
	icon: string?,
}

local variantMap = {
	[Enum.MessageType.MessageInfo] = {
		background = Enum.StudioStyleGuideColor.DialogMainButton,
		text = Enum.StudioStyleGuideColor.DialogMainButtonText,
	},
	[Enum.MessageType.MessageWarning] = {
		background = Enum.StudioStyleGuideColor.WarningText,
		text = Enum.StudioStyleGuideColor.DialogMainButtonText,
	},
	[Enum.MessageType.MessageError] = {
		background = Enum.StudioStyleGuideColor.ErrorText,
		text = Enum.StudioStyleGuideColor.DialogMainButtonText,
	},
	[Enum.MessageType.MessageOutput] = {
		background = Enum.StudioStyleGuideColor.SensitiveText,
		text = Enum.StudioStyleGuideColor.DialogMainButtonText,
	},
}

local function Alert(props: AlertProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)
	local variant = variantMap[props.variant]

	local hasChildren = hooks.useMemo(function()
		if not props[Roact.Children] then
			return false
		end

		return Llama.Dictionary.count(props[Roact.Children]) > 0
	end, { props[Roact.Children] })

	return e("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.order,
		Size = UDim2.fromScale(1, 0),
		ZIndex = props.zindex,
	}, {
		layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),

		content = e("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme:GetColor(variant.background),
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 100,
		}, {
			corners = e("UICorner", {
				CornerRadius = UDim.new(0, styles.borderRadius),
			}),

			content = e("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
			}, {
				padding = e("UIPadding", {
					PaddingBottom = UDim.new(0, styles.spacing),
					PaddingLeft = UDim.new(0, styles.spacing),
					PaddingRight = UDim.new(0, styles.spacing),
					PaddingTop = UDim.new(0, styles.spacing),
				}),

				content = e("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					LayoutOrder = 100,
				}, {
					layout = e("UIListLayout", {
						Padding = UDim.new(0, styles.spacing),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					padding = e("UIPadding", {
						PaddingRight = UDim.new(0, 20),
					}),

					icon = if props.icon
						then e(Icon, {
							id = props.icon,
							colour = theme:GetColor(variant.text),
							size = 20,
						})
						else nil,

					label = e(Text, {
						text = props.label,
						textColour = theme:GetColor(variant.text),
						autoSize = Enum.AutomaticSize.Y,
						size = UDim2.fromScale(1, 0),
					}),
				}),
			}),
		}),

		actions = if hasChildren
			then e(JustifyFrame, {
				autoSize = Enum.AutomaticSize.Y,
				size = UDim2.fromScale(1, 0),
				order = 200,
				gap = 2,
				direction = Enum.FillDirection.Horizontal,
				alignY = Enum.VerticalAlignment.Top,
				alignX = Enum.HorizontalAlignment.Center,
			}, props[Roact.Children])
			else nil,
	})
end

return Hooks.new(Roact)(Alert, {
	componentType = "PureComponent",
	defaultProps = {
		variant = Enum.MessageType.MessageInfo,
	},
})
