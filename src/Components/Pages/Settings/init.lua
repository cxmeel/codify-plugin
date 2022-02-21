local Plugin = script.Parent.Parent.Parent

local StudioTheme = require(Plugin.Packages.StudioTheme)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local FrameworkSelect = require(Plugin.Components.FrameworkSelect)
local Layout = require(Plugin.Components.Layout)

local SyntaxHighlighting = require(script.SyntaxHighlighting)
local IndentFormat = require(script.IndentFormat)
local CreateMethod = require(script.CreateMethod)
local ChildrenKey = require(script.ChildrenKey)
local Inputs = require(script.Inputs)
local About = require(script.About)

local e = Roact.createElement

local function Page(_, hooks)
	local _, styles = StudioTheme.useTheme(hooks)

	return e(Layout.ScrollColumn, {
		paddingTop = styles.spacing,
		paddingBottom = styles.spacing,
	}, {
		padding = e(Layout.Padding),

		framework = e(FrameworkSelect, {
			order = 10,
		}),

		snippets = e(Layout.Forms.Section, {
			heading = "Snippets",
			hint = "Configure options relating to the main Codify tab.",
			divider = true,
			order = 20,
		}, {
			syntaxHighlighting = e(SyntaxHighlighting, {
				order = 10,
			}),
		}),

		output = e(Layout.Forms.Section, {
			heading = "Output",
			hint = "Customise the formatting of your generated code snippets. You will need to regenerate your snippets to reflect changes.",
			divider = true,
			order = 30,
		}, {
			createMethod = e(CreateMethod, {
				order = 10,
			}),

			childrenKey = e(ChildrenKey, {
				order = 20,
			}),

			indentFormat = e(IndentFormat, {
				order = 30,
			}),

			namingScheme = e(Inputs.NamingScheme, {
				order = 40,
			}),

			color3Format = e(Inputs.Color3Format, {
				order = 50,
			}),

			enumFormat = e(Inputs.EnumFormat, {
				order = 60,
			}),

			numberRangeFormat = e(Inputs.NumberRangeFormat, {
				order = 70,
			}),

			udim2Format = e(Inputs.UDim2Format, {
				order = 80,
			}),

			brickColorFormat = e(Inputs.BrickColorFormat, {
				order = 90,
			}),

			physicalPropertiesFormat = e(Inputs.PhysicalPropertiesFormat, {
				order = 100,
			}),
		}),

		about = e(About, {
			order = 40,
		}),
	})
end

return Hooks.new(Roact)(Page, {
	componentType = "PureComponent",
})
