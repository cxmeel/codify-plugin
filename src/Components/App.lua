local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local StudioPlugin = require(Packages.StudioPlugin)
local StudioTheme = require(Packages.StudioTheme)
local Hooks = require(Packages.Hooks)

local Routing = require(script.Parent.Routing)

local e = Roact.createElement

type AppProps = {
	plugin: Plugin,
}

local function App(props: AppProps, hooks)
	local widgetVisible, setWidgetVisible = hooks.useState(true)

	return e(StudioPlugin.Plugin, {
		plugin = props.plugin,
	}, {
		toolbar = e(StudioPlugin.Toolbar, {
			name = "Codify",
		}, {
			widgetToggle = e(StudioPlugin.ToolbarButton, {
				id = "widgetToggle",
				tooltip = "Show or hide the Codify widget",
				icon = "rbxassetid://8730522354",
				label = "Codify",
				active = widgetVisible,
				onActivated = function()
					setWidgetVisible(not widgetVisible)
				end,
			}),
		}),

		widget = e(StudioPlugin.Widget, {
			id = "CodifyWidget",
			initState = Enum.InitialDockState.Left,
			enabled = widgetVisible,
			title = "Codify",

			onInit = setWidgetVisible,
			onToggle = setWidgetVisible,
		}, {
			themeProvider = e(StudioTheme.Provider, {
				styles = {
					font = {
						default = Enum.Font.Gotham,
						semibold = Enum.Font.GothamSemibold,
						bold = Enum.Font.GothamBold,
						black = Enum.Font.GothamBlack,
						mono = Enum.Font.Code,
					},
				},
			}, {
				routing = widgetVisible and e(Routing),
			}),
		}),
	})
end

return Hooks.new(Roact)(App, {
	componentType = "PureComponent",
})
