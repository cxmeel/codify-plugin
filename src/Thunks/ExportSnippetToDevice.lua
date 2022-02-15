local ServerStorage = game:GetService("ServerStorage")
local Selection = game:GetService("Selection")

local Plugin = script.Parent.Parent

local Promise = require(Plugin.Packages.Promise)

local function PromptAndInsertModuleScript(props)
	return Promise.try(function()
		local module = Instance.new("ModuleScript")

		if props then
			for key, value in pairs(props) do
				module[key] = value
			end
		end

		return module
	end)
end

local function ExportSnippetToDevice(plugin: Plugin)
	return function(store)
		local state = store:getState()

		PromptAndInsertModuleScript({
			Name = state.snippet.name,
			Source = state.snippet.content,
			Archivable = false,
			Parent = ServerStorage,
		})
			:andThen(function(module: ModuleScript)
				local activeSelection = Selection:Get()

				Selection:Set({ module })
				plugin:PromptSaveSelection(state.snippet.name)

				Selection:Set(activeSelection)
				module:Destroy()
			end)
			:catch(function() -- fail silently
				return false
			end)
	end
end

return ExportSnippetToDevice
