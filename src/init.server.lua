local PluginDebugService = game:GetService("PluginDebugService")

local Roact = require(script.Packages.Roact)
local RoduxHooks = require(script.Packages.RoduxHooks)
local Rodux = require(script.Packages.Rodux)

local UserSettingsManager = require(script.Lib.UserSettingsManager)
local HighlighterManager = require(script.Lib.HighlighterManager)
local SelectionManager = require(script.Lib.SelectionManager)
local Properties = require(script.Lib.Properties)

local AppComponent = require(script.Components.App)

local Reducer = require(script.Reducer)
local Actions = require(script.Actions)
local Thunks = require(script.Thunks)

local store = Rodux.Store.new(Reducer, nil, {
	Rodux.thunkMiddleware,
})

if plugin.Parent == PluginDebugService then
	Roact.setGlobalConfig({
		elementTracing = true,
	})
end

UserSettingsManager.new(plugin, store)
HighlighterManager.new(plugin)

-- Fetch the version early so we don't have to synchronize while converting
-- the instances to code in parallel.
Properties.FetchVersionWithFallback()

do -- Handle Selection --
	local selection = SelectionManager.new(plugin, {
		classFilter = {
			function(selection: Instance)
				return selection.Parent ~= game
			end,

			function(selection: Instance)
				local ok = pcall(function()
					local new = Instance.new(selection.ClassName)
					new:Destroy()
				end)

				return ok
			end,
		},
	})

	store:dispatch(Actions.SetTargetInstance(selection:GetCurrentSelection()))

	selection.Changed:Connect(function(selection)
		store:dispatch(Actions.SetTargetInstance(selection))
	end)
end

do -- Create PluginAction --
	local action = plugin:CreatePluginAction(
		"codifyGenerateSnippet",
		"Codify (Generate)",
		"Generate a snippet in Codify for the current selection",
		"rbxassetid://8730522354",
		true
	)

	action.Triggered:Connect(function()
		store:dispatch(Thunks.GenerateSnippet())
	end)
end

do -- Mount app --
	store:dispatch(Thunks.DeterminePluginMetadata(plugin))

	local rootComponent = Roact.createElement(RoduxHooks.Provider, {
		store = store,
	}, {
		app = Roact.createElement(AppComponent, {
			plugin = plugin,
		}),
	})

	local handle = Roact.mount(rootComponent, nil, "Codify")

	plugin.Unloading:Connect(function()
		Roact.unmount(handle)
	end)
end
