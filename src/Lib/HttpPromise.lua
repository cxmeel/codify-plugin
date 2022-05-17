local HttpService = game:GetService("HttpService")
local Plugin = script.Parent.Parent

local Promise = require(Plugin.Packages.Promise)
local Sift = require(Plugin.Packages.Sift)
local String = require(script.Parent.String)

export type RequestAsyncOptions = {
	method: string?,
	headers: { [string]: string | number | boolean }?,
	body: string?,
	timeout: number?,
	retries: number?,
	retryDelay: number?,
	resolve2xxOnly: boolean?,
	cache: boolean | number?,
}

type URL = {
	protocol: string,
	domain: string,
	path: string?,
}

type CacheEntry = {
	content: any?,
	expires: number,
}

type ICacheDictionary = {
	[string]: {
		[string]: CacheEntry,
	},
}

local APPROVED_DOMAINS: { [string]: boolean } = {}
local CACHED_DATA: ICacheDictionary = {}

local SENSIBLE_DEFAULT_CACHE = 300

local DEFAULT_OPTIONS: RequestAsyncOptions = {
	method = "GET",
	headers = nil,
	body = nil,
	timeout = 60,
	retries = 0,
	retryDelay = 10,
	resolve2xxOnly = false,
	cache = true,
}

local function ParseURL(url: string): URL
	local domain, path = url:match("^%w+://([^/]+)([^#]*)")
	local protocol = url:match("^(%w+)://")

	return {
		protocol = protocol or "https",
		domain = domain:lower(),
		path = path,
	}
end

local function FetchCachedData(url: string): any?
	local URL = ParseURL(url)

	if CACHED_DATA[URL.domain] then
		local entry = CACHED_DATA[URL.domain][URL.path]

		if entry and entry.expires > os.time() then
			return entry.content
		end

		CACHED_DATA[URL.domain][URL.path] = nil
	end

	return nil
end

local function ParseResponseHeaderCSV(header: string)
	return Sift.Array.reduce(header:split(","), function(reduction, value)
		local kvPair = value:split("=")

		kvPair[1] = String.Trim(kvPair[1]):lower()

		if kvPair[2] ~= nil then
			local kvValue = String.Trim(kvPair[2])

			if tonumber(kvValue) then
				kvValue = tonumber(kvValue)
			end

			kvPair[2] = kvValue
		else
			kvPair[2] = true
		end

		reduction[kvPair[1]] = kvPair[2]

		return reduction
	end, {})
end

local function GetHeaderContent(headers, key: string): string?
	key = key:lower()

	for headerKey, headerValue in pairs(headers) do
		if key == headerKey:lower() then
			return headerValue
		end
	end

	return nil
end

local function PromptDomainApproval(url: string)
	local URL = ParseURL(url)
	local status = APPROVED_DOMAINS[URL.domain]

	if status == true then
		return Promise.resolve()
		-- elseif status == false then
		-- return Promise.reject("User declined permission for domain: " .. domain)
	end

	return Promise.new(function(resolve, reject)
		task.spawn(function()
			local ok, response = pcall(HttpService.RequestAsync, HttpService, {
				Method = "OPTIONS",
				Url = URL.protocol .. "://" .. URL.domain,
			})

			APPROVED_DOMAINS[URL.domain] = ok

			if not ok then
				reject(response)
				return
			end

			resolve()
		end)
	end)
end

local function RequestAsync(url: string, options: RequestAsyncOptions?)
	local cachedData = FetchCachedData(url)

	if cachedData then
		return Promise.resolve(cachedData)
	end

	local config = Sift.Dictionary.merge(DEFAULT_OPTIONS, options) :: RequestAsyncOptions
	local URL = ParseURL(url)

	return PromptDomainApproval(url):andThen(function()
		local httpPromise = Promise.new(function(resolve, reject)
			task.spawn(function()
				local ok, response = pcall(HttpService.RequestAsync, HttpService, {
					Url = url,
					Method = config.method,
					Headers = config.headers,
					Body = config.body,
				})

				if not ok then
					reject(response, response)
					return
				end

				if config.resolve2xxOnly and not response.Success then
					reject(response.StatusMessage, response)
					return
				end

				local cacheHeader = GetHeaderContent(response.Headers, "cache-control")

				if config.cache or (config.cache and cacheHeader ~= nil) then
					local cachePolicy = ParseResponseHeaderCSV(cacheHeader)
					local shouldCache = config.cache or not (cachePolicy["no-cache"] and cachePolicy["no-store"])

					if shouldCache then
						local maxAge = if type(config.cache) == "number"
							then if config.cache < 0 then math.huge else config.cache
							elseif cachePolicy["max-age"] then cachePolicy["max-age"]
							else SENSIBLE_DEFAULT_CACHE

						if maxAge then
							local expires = os.time() + maxAge

							CACHED_DATA[URL.domain] = CACHED_DATA[URL.domain] or {}
							CACHED_DATA[URL.domain][URL.path] = {
								content = response.Body,
								expires = expires,
							}
						end
					end
				end

				resolve(response.Body, response)
			end)
		end)

		if config.timeout then
			local timeout = if type(config.timeout) == "number"
				then if config.timeout < 0 then math.huge else config.timeout
				else DEFAULT_OPTIONS.timeout

			httpPromise = httpPromise:timeout(timeout, "Request timed out")
		end

		if config.retries then
			local retries = if type(config.retries) == "number" and config.retries < 0
				then config.retries
				else DEFAULT_OPTIONS.retries

			local retryDelay = if type(config.retryDelay) == "number" and config.retryDelay > 0
				then config.retryDelay
				else nil

			local retryablePromise = function()
				return httpPromise
			end

			if retryDelay then
				httpPromise = Promise.retryWithDelay(retryablePromise, retries, retryDelay)
			else
				httpPromise = Promise.retry(retryablePromise, retries)
			end
		end

		return httpPromise
	end)
end

local function RequestJsonAsync(url: string, options: RequestAsyncOptions?)
	return RequestAsync(url, options):andThen(function(body, response)
		local ok, data = pcall(HttpService.JSONDecode, HttpService, body)

		if not ok then
			return Promise.reject(data, response)
		end

		return data, response
	end)
end

return {
	RequestAsync = RequestAsync,
	RequestJsonAsync = RequestJsonAsync,
}
