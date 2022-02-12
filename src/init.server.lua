local ServerStorage = game:GetService("ServerStorage")
local Selection = game:GetService("Selection")

local Roact = require(script.Packages.Roact)
local Highlighter = require(script.Packages.Highlighter)
local Codify = require(script.Lib.Codify)

local Store = require(script.Store)
local AppComponent = require(script.Components.App)

do -- Enable debug mode --
	local PluginDebugService = game:GetService("PluginDebugService")

	if plugin.Parent == PluginDebugService then
		Roact.setGlobalConfig({
			elementTracing = true,
		})
	end
end

do -- Settings persistence --
	local SettingsKey = "bedc0f22-settings"
	local currentSettings = plugin:GetSetting(SettingsKey)

	if currentSettings then
		Store:SetState({
			Settings = currentSettings,
		})
	end

	Store:GetChangedSignal("Settings"):Connect(function()
		local settings = Store:Get("Settings")
		plugin:SetSetting(SettingsKey, settings)
	end)
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

	local function IsSelectionValid(selection: Instance?)
		if not selection then
			return false
		end

		for _, class in ipairs(ValidSelectionClasses) do
			if selection:IsA(class) then
				return true
			end
		end

		return false
	end

	local function IsLargeInstance(instance: Instance?)
		if not instance then
			return false
		end

		local size = #instance:GetDescendants()
		return size >= 20
	end

	do -- Check current selection --
		local currentSelection = Selection:Get()[1]

		local ok, valid = pcall(IsSelectionValid, currentSelection)

		if not ok then
			-- Probably selected something roblox locked
			valid = false
		end

		local isLarge = if valid then IsLargeInstance(currentSelection) else false

		Store:SetState({
			RootTarget = if valid then currentSelection else Store.None,
			LargeInstance = isLarge,
		})

		currentSelection = nil
	end

	Selection.SelectionChanged:Connect(function()
		local currentSelection = Selection:Get()[1]

		local ok, valid = pcall(IsSelectionValid, currentSelection)

		if not ok then
			-- Probably selected something roblox locked
			valid = false
		end

		local isLarge = if valid then IsLargeInstance(currentSelection) else false

		Store:SetState({
			RootTarget = if valid then currentSelection else Store.None,
			LargeInstance = isLarge,
		})
	end)
end

do -- Respond to actions --
	Store.Actions.GenerateSnippet.Event:Connect(function()
		local rootTarget: Instance? = Store:Get("RootTarget")

		if rootTarget == nil then
			return
		end

		local state = Store:GetState()
		Store:SetState({ SnippetProcessing = true })

		local createMethod = state.Settings.CreateMethod

		local ok, snippet = pcall(Codify, rootTarget, {
			Framework = state.Settings.Framework,
			CreateMethod = if not createMethod or #createMethod == 0 then nil else createMethod,
			Color3Format = state.Settings.Color3Format,
			UDim2Format = state.Settings.UDim2Format,
			NumberRangeFormat = state.Settings.NumberRangeFormat,
			EnumFormat = state.Settings.EnumFormat,
			NamingScheme = state.Settings.NamingScheme,
		})

		if ok then
			Store:Set("Snippet", {
				TargetName = rootTarget.Name,
				Snippet = snippet,
			})
		else
			error(snippet, 2)
		end

		Store:SetState({ SnippetProcessing = false })
	end)

	Store.Actions.SaveSnippet.Event:Connect(function()
		local snippet = Store:Get("Snippet")

		if snippet == nil then
			return
		end

		local sourceCode = Instance.new("ModuleScript")
		sourceCode.Name = snippet.TargetName
		sourceCode.Source = snippet.Snippet
		sourceCode.Archivable = false
		sourceCode.Parent = ServerStorage

		local currentSelection = Selection:Get()

		Selection:Set({ sourceCode })
		plugin:PromptSaveSelection(snippet.TargetName)

		Selection:Set(currentSelection)
		sourceCode:Destroy()
	end)
end

do -- Create PluginAction --
	local action = plugin:CreatePluginAction(
		"generateSnippet",
		"Generate Roact Snippet",
		"Generate a Roact snippet for the current selection",
		"rbxassetid://8730522354",
		true
	)

	action.Triggered:Connect(function()
		Store.Actions.GenerateSnippet:Fire()
	end)
end

do -- Mount app --
	local handle = Roact.mount(
		Roact.createElement(AppComponent, {
			plugin = plugin,
		}),
		nil,
		"Codify"
	)

	plugin.Unloading:Connect(function()
		Roact.unmount(handle)
	end)
end
