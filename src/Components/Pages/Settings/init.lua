local Plugin = script.Parent.Parent.Parent

local StudioTheme = require(Plugin.Packages.StudioTheme)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local RoduxHooks = require(Plugin.Packages.RoduxHooks)

local Enums = require(Plugin.Data.Enums)

local FrameworkSelect = require(Plugin.Components.FrameworkSelect)
local Layout = require(Plugin.Components.Layout)

local SyntaxHighlighting = require(script.SyntaxHighlighting)
local IndentFormat = require(script.IndentFormat)
local CreateMethod = require(script.CreateMethod)
local ChildrenKey = require(script.ChildrenKey)
local Inputs = require(script.Inputs)
local About = require(script.About)

local EnableJsxGeneration = require(script.EnableJsxGeneration)
local JsxSelfClosingTags = require(script.JsxSelfClosingTags)

local e = Roact.createElement

local function Page(_, hooks)
	local _, styles = StudioTheme.useTheme(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)
	local framework = userSettings.framework

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
			collapsible = true,
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
			collapsible = true,
			divider = true,
			order = 40,
		}, {
			createMethod = e(CreateMethod, { order = 10 }),
			childrenKey = e(ChildrenKey, { order = 20 }),
			namingScheme = e(Inputs.ChildIndexing, { order = 30 }),
			caseFormat = framework ~= Enums.Framework.Fusion and e(Inputs.CaseFormat, { order = 40 }),
		}),

		datatypes = e(Layout.Forms.Section, {
			heading = "Data Types",
			hint = "Configure how Roblox data types are formatted in your code snippets. You will need to regenerate your snippets to reflect changes.",
			collapsible = true,
			divider = true,
			order = 50,
		}, {
			color3Format = e(Inputs.Color3Format, {
				order = 20,
			}),

			enumFormat = e(Inputs.EnumFormat, {
				order = 30,
			}),

			fontFormat = e(Inputs.FontFormat, {
				order = 35,
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

			jsxSelfClosing = e(JsxSelfClosingTags, {
				order = 80,
			}),
		}),

		experimental = e(Layout.Forms.Section, {
			heading = "Experimental",
			hint = "These features may be highly unstable and may cause issues. Use at your own risk.",
			collapsible = true,
			--collapsed = true,
			divider = true,
			order = 60,
			icon = "Fire",
		}, {
			enableJsxGeneration = e(EnableJsxGeneration, {
				order = 10,
			}),
		}),

		about = e(About, {
			order = 70,
		}),
	})
end

return Hooks.new(Roact)(Page)
