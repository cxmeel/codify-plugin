local HttpService = game:GetService("HttpService")
local PluginDebugService = game:GetService("PluginDebugService")

local repo = "csqrl/roactify-plugin"
local publishedId = "4749111907"

local plugin = script:FindFirstAncestorOfClass("Plugin")
local pluginId = plugin.Name:match("%d+$")

local Config = {
	Version = "1.0.0",
	VersionTag = "Public",
	Author = string.match(repo, "^[^/]+"),
	Contributors = {},
}

local contribSuccess, contribResponse = pcall(HttpService.RequestAsync, HttpService, {
	Url = "https://api.github.com/repos/"..repo.."/contributors?anon=1",
	Method = "GET",
})
if contribSuccess and contribResponse.Success then
	local jsonSuccess, data = pcall(HttpService.JSONDecode, HttpService, contribResponse.Body)
	if jsonSuccess and data then
		for i, contributor in ipairs(data) do
			local name = contributor.login or contributor.name
			if name == Config.Author then continue end

			Config.Contributors[i] = name
		end
	end
end

if plugin.Parent == PluginDebugService then
	Config.VersionTag = "Dev"
elseif pluginId ~= publishedId then
	Config.VersionTag = "Canary"
end

return Config
