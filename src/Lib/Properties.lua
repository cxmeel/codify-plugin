local plugin = script:FindFirstAncestorOfClass("Plugin")
local PluginRoot = script.Parent.Parent
local RobloxVersion = version()

local HttpPromise = require(PluginRoot.Lib.HttpPromise)
local Promise = require(PluginRoot.Packages.Promise)
local Sift = require(PluginRoot.Packages.Sift)

local PLUGIN_CACHE_KEY = "API_DUMP_CACHE"
local PLUGIN_CACHED_DATA = nil

local Properties = {}

local IGNORED_PROPERTIES = {
	Classes = {
		GuiObject = {
			"Font",
		},
	},
	Global = {
		"Parent",
	},
}

function Properties.FetchDumpFromPluginCache()
	local storedValue = PLUGIN_CACHED_DATA or plugin:GetSetting(PLUGIN_CACHE_KEY)

	if not storedValue or storedValue.Version ~= RobloxVersion then
		return Promise.resolve()
	end

	PLUGIN_CACHED_DATA = storedValue

	return Promise.resolve(storedValue)
end

function Properties.FetchLatestVersionHash()
	return HttpPromise.RequestAsync("https://s3.amazonaws.com/setup.roblox.com/versionQTStudio", {
		cache = -1,
	}):andThen(function(version)
		local hash = version:match("version%-(%x+)")
		return hash
	end)
end

function Properties.FetchVersionHash(version: string?)
	local newVersion = version or RobloxVersion
	local deployVersion = newVersion:gsub("%.", ", ")

	return HttpPromise.RequestAsync("https://s3.amazonaws.com/setup.roblox.com/DeployHistory.txt", {
		cache = -1,
		timeout = 30,
	}):andThen(function(history: string)
		local deployments = history:split("\n")

		for lineNumber = #deployments, 1, -1 do
			local line = deployments[lineNumber]

			if line:find(deployVersion) then
				return assert(line:match("version%-(%x+)"), "Unable to find version hash in line: " .. line)
			end

			if lineNumber >= 128 then
				break
			end
		end

		return Promise.reject("Unable to find version hash for " .. deployVersion)
	end)
end

function Properties.FetchVersionWithFallback(version: string?)
	return Properties.FetchDumpFromPluginCache():andThen(function(cachedDump)
		if cachedDump and cachedDump.Version == RobloxVersion then
			return Promise.resolve(cachedDump.VersionHash)
		end

		return Properties.FetchVersionHash(version):catch(function()
			return Properties.FetchLatestVersionHash()
		end)
	end)
end

function Properties.FetchAPIDump(hash: string)
	return Properties.FetchDumpFromPluginCache():andThen(function(cachedDump)
		if cachedDump and cachedDump.VersionHash == hash then
			return cachedDump.Data
		end

		return HttpPromise.RequestJsonAsync(
			"https://s3.amazonaws.com/setup.roblox.com/version-" .. hash .. "-API-Dump.json",
			{
				cache = -1,
				timeout = 60,
			}
		)
			:andThen(function(apiDump)
				local dumpCache = {
					Version = RobloxVersion,
					VersionHash = hash,
					Data = apiDump,
				}

				plugin:SetSetting(PLUGIN_CACHE_KEY, dumpCache)
				PLUGIN_CACHED_DATA = dumpCache

				return apiDump
			end)
	end)
end

local function FindClassEntry(dump, class: string)
	local entryIndex = Sift.Array.findWhere(dump.Classes, function(classEntry)
		return classEntry.Name == class
	end)

	return dump.Classes[entryIndex]
end

function Properties.GetClassAncestry(class: string)
	return Properties.FetchVersionWithFallback()
		:andThen(function(version)
			return Properties.FetchAPIDump(version)
		end)
		:andThen(function(dump)
			local ancestorClasses = { FindClassEntry(dump, class) }

			while ancestorClasses[#ancestorClasses].Superclass ~= "<<<ROOT>>>" do
				table.insert(ancestorClasses, FindClassEntry(dump, ancestorClasses[#ancestorClasses].Superclass))
			end

			return ancestorClasses
		end)
end

function Properties.GetIgnoredPropertyNames(class: string)
	return Properties.GetClassAncestry(class):andThen(function(ancestry)
		local ignoredProperties = {}

		for _, ancestor in ipairs(ancestry) do
			local ignoreList = IGNORED_PROPERTIES.Classes[ancestor.Name]

			if ignoreList then
				table.insert(ignoredProperties, ignoreList)
			end
		end

		for _, globalProperty in ipairs(IGNORED_PROPERTIES.Global) do
			table.insert(ignoredProperties, globalProperty)
		end

		return Sift.Array.flatten(ignoredProperties, 1)
	end)
end

function Properties.GetPropertyList(class: string)
	return Properties.GetClassAncestry(class):andThen(function(ancestry)
		local success, ignoredProperties = Properties.GetIgnoredPropertyNames(class):await()
		local properties = {}

		for _, ancestor in ipairs(ancestry) do
			local propertyMembers = Sift.Array.filter(ancestor.Members, function(member)
				if member.MemberType ~= "Property" then
					return false
				end

				if member.Security.Read ~= "None" or member.Security.Write ~= "None" then
					return false
				end

				if member.Tags then
					local tagList = { "ReadOnly", "Deprecated", "Hidden", "NotScriptable" }

					for _, tag in ipairs(member.Tags) do
						if table.find(tagList, tag) then
							return false
						end
					end
				end

				return true
			end)

			for _, property in ipairs(propertyMembers) do
				if success and ignoredProperties and table.find(ignoredProperties, property.Name) then
					continue
				end

				table.insert(properties, property.Name)
			end
		end

		return properties
	end)
end

local INSTANCE_DEFAULTS = {}

function Properties.GetClassDefaultProperties(className: string, properties: { string })
	local classEntry = INSTANCE_DEFAULTS[className]

	if not classEntry then
		INSTANCE_DEFAULTS[className] = {}
		return Properties.GetClassDefaultProperties(className, properties)
	end

	local defaultValues = {}
	local missingValues = {}

	for _, property in properties do
		if classEntry[property] ~= nil then
			defaultValues[property] = classEntry[property]
		else
			table.insert(missingValues, property)
		end
	end

	if #missingValues == 0 then
		return Promise.resolve(defaultValues)
	end

	task.synchronize()
	local newInstance = Instance.new(className)

	for _, property in ipairs(missingValues) do
		defaultValues[property] = newInstance[property]
	end

	newInstance:Destroy()
	task.desynchronize()

	return Promise.resolve(defaultValues)
end

function Properties.GetChangedProperties(instance: Instance)
	return Properties.GetPropertyList(instance.ClassName):andThen(function(properties)
		return Properties.GetClassDefaultProperties(instance.ClassName, properties):andThen(function(defaultProps)
			local changedProps = {}

			for _, property in ipairs(properties) do
				if defaultProps[property] ~= (instance :: never)[property] then
					table.insert(changedProps, property)
				end
			end

			return changedProps
		end)
	end)
end

return Properties
