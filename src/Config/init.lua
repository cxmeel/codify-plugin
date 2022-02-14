local PluginDebugService = game:GetService("PluginDebugService")
local Players = game:GetService("Players")

local Plugin = script:FindFirstAncestorOfClass("Plugin")

local CurrentPluginId = Plugin.Name:match("%d+$")
CurrentPluginId = CurrentPluginId and tonumber(CurrentPluginId)

local Config = require(script.Config)

Config.Author.Username = Players:GetNameFromUserIdAsync(Config.Author.UserId)

if Plugin.Parent == PluginDebugService then
	Config.VersionTag = "Dev"
	Config.IsDev = true
elseif CurrentPluginId == Config.PluginId.Canary then
	Config.VersionTag = "Canary"
elseif CurrentPluginId ~= Config.PluginId.Stable then
	Config.VersionTag = "Fork"
end

local originalAuthorId = 3659905
if Config.Author.UserId ~= originalAuthorId then
	Config.OriginalAuthor = {
		UserId = originalAuthorId,
		Username = Players:GetNameFromUserIdAsync(originalAuthorId),
		Repo = "csqrl/roactify-plugin",
	}
end

return Config
