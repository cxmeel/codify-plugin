local Plugin = script.Parent.Parent

local HttpPromise = require(Plugin.Lib.HttpPromise2)
local Llama = require(Plugin.Packages.Llama)
local Actions = require(Plugin.Actions)

local function FetchContributors(repo: string, authors: { string }?)
	local repoOwner = repo:match("^[^/]+")

	repoOwner = repoOwner and repoOwner:lower()
	authors = Llama.List.map(authors or {}, function(author)
		return author:lower()
	end)

	return function(store)
		HttpPromise.RequestJsonAsync("https://api.github.com/repos/" .. repo .. "/contributors?anon=1")
			:andThen(function(data)
				table.sort(data, function(a, b)
					return a.contributions > b.contributions
				end)

				return Llama.List.reduce(data, function(reduction, user)
					local username = user.login or user.name

					if username and not (username == repoOwner or table.find(authors, username)) then
						table.insert(reduction, username)
					end

					return reduction
				end, {})
			end)
			:andThen(function(contributors)
				store:dispatch(Actions.SetContributors(contributors))
			end)
			:catch(function() -- fail silently
				return false
			end)
	end
end

return FetchContributors
