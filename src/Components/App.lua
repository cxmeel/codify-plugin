local Plugin = script.Parent.Parent

local StudioPlugin = require(Plugin.Packages.StudioPlugin)
local StudioTheme = require(Plugin.Packages.StudioTheme)
local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Config = require(Plugin.Data.Config)

local Routing = require(Plugin.Components.Routing)

local e = Roact.createElement

type AppProps = {
	plugin: Plugin,
}

local function App(props: AppProps, hooks)
	local widgetVisible, setWidgetVisible = hooks.useState(true)

	local pluginMeta = RoduxHooks.useSelector(hooks, function(state)
		return state.pluginMeta
	end)

	local pluginIcon = hooks.useMemo(function()
		local build = pluginMeta.build:lower()

		if Config.icons[build] then
			return Config.icons[build]
		end

		return Config.icons.dev
	end, { pluginMeta })

	local buttonSuffix = hooks.useMemo(function()
		if pluginMeta.build ~= "STABLE" then
			return " [" .. pluginMeta.build .. "]"
		end

		return ""
	end, { pluginMeta })

	return e(StudioPlugin.Plugin, {
		plugin = props.plugin,
	}, {
		toolbar = e(StudioPlugin.Toolbar, {
			name = "Codify",
		}, {
			widgetToggle = e(StudioPlugin.ToolbarButton, {
				id = "widgetToggle",
				tooltip = "Show or hide the Codify widget",
				icon = pluginIcon,
				label = "Codify" .. buttonSuffix,
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
			title = "Codify" .. buttonSuffix,

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

return Hooks.new(Roact)(App)
