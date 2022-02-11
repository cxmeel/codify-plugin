local Packages = script.Parent.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local ListLayout = require(script.Parent.Parent.ListLayout)
local Text = require(script.Parent.Parent.Parent.Text)
local Divider = require(script.Parent.Parent.Divider)
local Frame = require(script.Parent.Parent.Frame)

local e = Roact.createElement

export type FormSectionProps = {
	order: number?,
	divider: boolean?,
	heading: string?,
	hint: string?,
	formItem: boolean?,
}

local function FormSection(props: FormSectionProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	return e(Frame, {
		order = props.order,
	}, {
		layout = e(ListLayout, {
			direction = Enum.FillDirection.Vertical,
			gap = props.formItem and styles.spacing * 0.5,
		}),

		divider = if props.divider
			then e(Divider, {
				order = 0,
			})
			else nil,

		heading = if props.heading
			then e(Text, {
				text = props.heading,
				textColour = theme:GetColor(Enum.StudioStyleGuideColor.BrightText),
				font = not props.formItem and styles.font.semibold,
				order = 10,
			})
			else nil,

		hint = if props.hint
			then e(Text, {
				text = props.hint,
				textColour = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
				order = 20,
			})
			else nil,

		content = if props[Roact.Children]
			then e(Frame, {
				order = 30,
			}, {
				layout = e(ListLayout, {
					direction = Enum.FillDirection.Vertical,
				}),

				Roact.createFragment(props[Roact.Children]),
			})
			else nil,
	})
end

return Hooks.new(Roact)(FormSection, {
	componentType = "PureComponent",
})
