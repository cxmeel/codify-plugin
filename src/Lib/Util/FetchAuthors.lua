local Players = game:GetService("Players")
local Plugin = script.Parent.Parent.Parent

local Promise = require(Plugin.Packages.Promise)
local Llama = require(Plugin.Packages.Llama)

local Config = require(Plugin.Data.Config)

local AUTHORS = nil

local function GetUsernameFromUserIdAsync(userId: number)
	return Promise.new(function(resolve, reject)
		local ok, username = pcall(Players.GetNameFromUserIdAsync, Players, userId)

		if not ok then
			reject(username)
			return
		end

		resolve(username)
	end)
end

local function FetchAuthors()
	if AUTHORS then
		return AUTHORS
	end

	AUTHORS = Promise.all(Llama.List.map(Config.authors, function(author)
		return Promise.retryWithDelay(GetUsernameFromUserIdAsync, 3, 15, author.userId)
	end))

	return AUTHORS
end

return FetchAuthors
