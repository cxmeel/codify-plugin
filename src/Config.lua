local PluginDebugService = game:GetService("PluginDebugService")

local plugin = script:FindFirstAncestorOfClass("Plugin")
local pluginId = plugin.Name:match("%d+$")

local Config = {
	Version = "1.0.0",
	VersionTag = "Public",
}

if plugin.Parent == PluginDebugService then
	Config.VersionTag = "Dev"
elseif pluginId ~= "4749111907" then
	Config.VersionTag = "Canary"
end

return Config
