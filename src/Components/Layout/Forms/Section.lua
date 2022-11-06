local Plugin = script.Parent.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local StudioTheme = require(Plugin.Packages.StudioTheme)

local ListLayout = require(Plugin.Components.Layout.ListLayout)
local Divider = require(Plugin.Components.Layout.Divider)
local Frame = require(Plugin.Components.Layout.Frame)
local Text = require(Plugin.Components.Text)
local Icon = require(Plugin.Components.Icon)

local e = Roact.createElement

export type FormSectionProps = {
	order: number?,
	divider: boolean?,
	heading: string?,
	hint: string?,
	formItem: boolean?,
	collapsed: boolean?,
	collapsible: boolean?,
	icon: string?,
}

local function FormSection(props: FormSectionProps, hooks)
	local collapsed, setCollapsed = hooks.useState(props.collapsed)
	local theme, styles = StudioTheme.useTheme(hooks)

	local function onActivated()
		setCollapsed(not collapsed)
	end

	return e(Frame, {
		order = props.order,
	}, {
		layout = e(ListLayout, {
			direction = Enum.FillDirection.Vertical,
			gap = props.formItem and styles.spacing * 0.5,
		}),

		divider = props.divider and e(Divider, {
			order = 0,
		}),

		heading = props.heading and e("ImageButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 10,
			Size = UDim2.fromScale(1, 0),

			[Roact.Event.Activated] = props.collapsible and onActivated,
		}, {
			layout = e(ListLayout, {
				direction = Enum.FillDirection.Horizontal,
			}),

			collapseIcon = props.collapsible and e("Frame", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 10,
				Size = UDim2.new(),
			}, {
				image = e(Icon, {
					icon = "Caret",
					color = theme:GetColor(Enum.StudioStyleGuideColor.BrightText),
					rotation = collapsed and -90 or 0,
					order = 10,
				}),
			}),

			icon = props.icon and e(Icon, {
				icon = props.icon,
				order = 15,
			}),

			label = e(Text, {
				text = props.heading,
				textColor = theme:GetColor(Enum.StudioStyleGuideColor.BrightText),
				size = props.collapsible and UDim2.new(1, -16, 0, 0),
				font = not props.formItem and styles.font.semibold,
				order = 20,
			}),
		}),

		collapsible = not collapsed and Roact.createFragment({
			hint = props.hint and e(Text, {
				text = props.hint,
				textColor = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
				order = 20,
			}),

			content = props[Roact.Children] and e(Frame, {
				order = 30,
			}, {
				layout = e(ListLayout, {
					direction = Enum.FillDirection.Vertical,
				}),

				Roact.createFragment(props[Roact.Children]),
			}),
		}),
	})
end

return Hooks.new(Roact)(FormSection)
