local PluginDebugService = game:GetService("PluginDebugService")
local Plugin = script.Parent.Parent

local Config = require(Plugin.Data.Config)
local Actions = require(Plugin.Actions)

local function DeterminePluginMetadata(plugin: Plugin)
	local pluginId = plugin.Name:match("%d+$")
	pluginId = tonumber(pluginId)

	return function(store)
		if pluginId == nil or plugin.Parent == PluginDebugService then
			if plugin.Name:match("codify_dev_%x+") then
				return store:dispatch(Actions.SetPluginMetadata({
					build = "DEV",
					isDevMode = true,
				}))
			else
				-- Likely a local install (itch.io)...
				return store:dispatch(Actions.SetPluginMetadata({
					build = "STABLE",
				}))
			end
		end

		if pluginId == Config.pluginId.canary then
			return store:dispatch(Actions.SetPluginMetadata({
				build = "CANARY",
			}))
		end

		if pluginId == Config.pluginId.preview then
			return store:dispatch(Actions.SetPluginMetadata({
				build = "PREVIEW",
			}))
		end

		if pluginId == Config.pluginId.stable then
			return store:dispatch(Actions.SetPluginMetadata({
				build = "STABLE",
			}))
		end

		store:dispatch(Actions.SetPluginMetadata({
			build = "FORK",
		}))
	end
end

return DeterminePluginMetadata
