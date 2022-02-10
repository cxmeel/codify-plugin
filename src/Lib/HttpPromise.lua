local HttpService = game:GetService("HttpService")

local Promise = require(script.Parent.Parent.Packages.Promise)

local HttpPromise = {}

function HttpPromise.RequestPromise(...)
	local requestOptions = { ... }

	return Promise.new(function(resolve, reject)
		local ok, response = pcall(HttpService.RequestAsync, HttpService, unpack(requestOptions))

		if not ok then
			reject(response)
		end

		if not response.Success then
			reject(response.Body)
		end

		resolve(response.Body)
	end)
end

function HttpPromise.RequestJsonPromise(...)
	return HttpPromise.RequestPromise(...):andThen(function(body)
		return Promise.new(function(resolve, reject)
			local ok, json = pcall(HttpService.JSONDecode, HttpService, body)

			if not ok then
				reject(json)
			end

			resolve(json)
		end)
	end)
end

return HttpPromise
