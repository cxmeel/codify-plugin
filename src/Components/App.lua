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
			name = "Roactify",
		}, {
			widgetToggle = e(StudioPlugin.ToolbarButton, {
				id = "widgetToggle",
				tooltip = "Show or hide the Roactify widget",
				icon = "rbxassetid://8730522354",
				label = "Roactify",
				active = widgetVisible,
				onActivated = function()
					setWidgetVisible(not widgetVisible)
				end,
			}),
		}),

		widget = e(StudioPlugin.Widget, {
			id = "roactifyWidget",
			initState = Enum.InitialDockState.Left,
			enabled = widgetVisible,
			title = "Roactify",

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
				routing = if widgetVisible then e(Routing) else nil,
			}),
		}),
	})
end

return Hooks.new(Roact)(App, {
	componentType = "PureComponent",
})
