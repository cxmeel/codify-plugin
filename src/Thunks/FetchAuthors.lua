local Players = game:GetService("Players")
local Plugin = script.Parent.Parent

local Promise = require(Plugin.Packages.Promise)
local Sift = require(Plugin.Packages.Sift)

local Config = require(Plugin.Data.Config)
local Actions = require(Plugin.Actions)

local USER_ID_CACHE = {}

local function GetUsernameFromUserIdAsync(userId: number)
	if USER_ID_CACHE[userId] then
		return Promise.resolve(USER_ID_CACHE[userId])
	end

	return Promise.new(function(resolve, reject)
		task.spawn(function()
			local ok, username = pcall(Players.GetNameFromUserIdAsync, Players, userId)

			if not ok then
				reject(username)
				return
			end

			USER_ID_CACHE[userId] = username

			resolve(username)
		end)
	end)
end

local function FetchAuthors()
	return function(store)
		Promise.all(Sift.Array.map(Config.authors, function(author)
			return Promise.retryWithDelay(GetUsernameFromUserIdAsync, 3, 30, author.userId)
		end))
			:andThen(function(authors)
				store:dispatch(Actions.SetAuthors(authors))
			end)
			:catch(function() -- fail silently
				return false
			end)
	end
end

return FetchAuthors
