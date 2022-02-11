local PluginDebugService = game:GetService("PluginDebugService")
local Players = game:GetService("Players")

local Promise = require(script.Parent.Packages.Promise)
local HttpPromise = require(script.Parent.Lib.HttpPromise)

local Plugin = script:FindFirstAncestorOfClass("Plugin")
local httpCache = {}

local CurrentPluginId = Plugin.Name:match("%d+$")
CurrentPluginId = CurrentPluginId and tonumber(CurrentPluginId)

local Config = require(script.Config)

function Config.FetchContributors()
	if httpCache.Contributors then
		return Promise.resolve(httpCache.Contributors)
	elseif httpCache.__contributorsPromise then
		return httpCache.__contributorsPromise
	end

	local repoAuthor = string.match(Config.Author.Repo, "^[^/]+")

	local contributorsPromise = HttpPromise.RequestJsonPromise({
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

	httpCache.__contributorsPromise = contributorsPromise

	return contributorsPromise
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
