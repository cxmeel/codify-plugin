local PluginDebugService = game:GetService("PluginDebugService")
local Players = game:GetService("Players")

local Promise = require(script.Parent.Packages.Promise)
local HttpPromise = require(script.Parent.Lib.HttpPromise)

local Plugin = script:FindFirstAncestorOfClass("Plugin")
local CurrentPluginId = Plugin.Name:match("%d+$")
local httpCache = {}

local Config = require(script.Config)

function Config.FetchContributors()
	if httpCache.Contributors then
		return Promise.resolve(httpCache.Contributors)
	end

	local repoAuthor = string.match(Config.Author.Repo, "^[^/]+")

	return HttpPromise.RequestJsonPromise({
		Url = "https://api.github.com/repos/" .. Config.Author.Repo .. "/contributors?anon=1",
		Method = "GET",
	}):andThen(function(data)
		local contributors = {}

		for _, contributor in ipairs(data) do
			local contributorName = contributor.login or contributor.name

			if contributorName == repoAuthor then
				continue
			end

			table.insert(contributors, contributorName)
		end

		httpCache.Contributors = contributors

		return contributors
	end)
end

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
