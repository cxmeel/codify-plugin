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
			hint = "Configure options relating to code snippets.",
			divider = true,
			order = 20,
		}, {
			syntaxHighlighting = e(SyntaxHighlighting, {
				order = 10,
			}),

			indentFormat = e(IndentFormat, {
				order = 20,
			}),
		}),

		frameworks = e(Layout.Forms.Section, {
			heading = "Generation",
			hint = "Configure various options relating to the generation of code snippets.",
			divider = true,
			order = 40,
		}, {
			createMethod = e(CreateMethod, {
				order = 10,
			}),

			childrenKey = e(ChildrenKey, {
				order = 20,
			}),

			namingScheme = e(Inputs.NamingScheme, {
				order = 30,
			}),
		}),

		datatypes = e(Layout.Forms.Section, {
			heading = "Data Types",
			hint = "Configure how Roblox data types are formatted in your code snippets. You will need to regenerate your snippets to reflect changes.",
			divider = true,
			order = 50,
		}, {
			color3Format = e(Inputs.Color3Format, {
				order = 20,
			}),

			enumFormat = e(Inputs.EnumFormat, {
				order = 30,
			}),

			numberRangeFormat = e(Inputs.NumberRangeFormat, {
				order = 40,
			}),

			udim2Format = e(Inputs.UDim2Format, {
				order = 50,
			}),

			brickColorFormat = e(Inputs.BrickColorFormat, {
				order = 60,
			}),

			physicalPropertiesFormat = e(Inputs.PhysicalPropertiesFormat, {
				order = 70,
			}),
		}),

		about = e(About, {
			order = 60,
		}),
	})
end

return Hooks.new(Roact)(Page)
