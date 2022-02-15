local Selection = game:GetService("Selection")

local Highlighter = require(script.Packages.Highlighter)
local Roact = require(script.Packages.Roact)

local AppComponent = require(script.Components.App)

local RoduxHooks = require(script.Packages.RoduxHooks)
local Rodux = require(script.Packages.Rodux)

local UserSettingsManager = require(script.Lib.UserSettingsManager)
local Reducer = require(script.Reducer)
local Actions = require(script.Actions)
local Thunks = require(script.Thunks)

local store = Rodux.Store.new(Reducer, nil, {
	Rodux.thunkMiddleware,
})

UserSettingsManager.new(plugin, store)

do -- Enable debug mode --
	local PluginDebugService = game:GetService("PluginDebugService")

	if plugin.Parent == PluginDebugService then
		Roact.setGlobalConfig({
			elementTracing = true,
		})
	end
end

do -- Watch syntax colors --
	local Studio = settings():GetService("Studio") :: Studio
	local studioTheme = Studio.Theme :: StudioTheme

	local function UpdateHighlighterScheme()
		Highlighter.UpdateColors({
			background = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptBackground),
			iden = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptText),
			keyword = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptKeyword),
			builtin = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptBuiltInFunction),
			string = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptString),
			number = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptNumber),
			comment = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptComment),
			operator = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptOperator),
		})
	end

	Studio.ThemeChanged:Connect(function()
		studioTheme = Studio.Theme :: StudioTheme
		UpdateHighlighterScheme()
	end)

	UpdateHighlighterScheme()
end

do -- Watch selection --
	local ValidSelectionClasses = { "GuiBase2d", "UIBase", "ValueBase", "Folder", "Configuration" }

	local function GetCurrentSelection(): Instance?
		local ok, selection = pcall(function()
			local selection = Selection:Get()[1]

			if not selection then
				return
			end

			for _, class in ipairs(ValidSelectionClasses) do
				if selection:IsA(class) then
					return selection
				end
			end
		end)

		return ok and selection
	end

	do -- Check current selection --
		local selection = GetCurrentSelection()
		store:dispatch(Actions.SetTargetInstance(selection))
	end

	Selection.SelectionChanged:Connect(function()
		local selection = GetCurrentSelection()
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
