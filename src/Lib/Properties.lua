local Promise = require(script.Parent.Parent.Packages.Promise)
local Llama = require(script.Parent.Parent.Packages.Llama)

local HttpPromise = require(script.Parent.HttpPromise)

local Properties = {
	Cache = {
		LatestVersionGUID = nil,
		APIDump = {},
	},
}

function Properties.FetchLatestVersion()
	if Properties.Cache.LatestVersionGUID then
		return Promise.resolve(Properties.Cache.LatestVersionGUID)
	end

	return HttpPromise.RequestPromise({
		Url = "https://s3.amazonaws.com/setup.roblox.com/versionQTStudio",
		Method = "GET",
	}):andThen(function(version)
		Properties.Cache.LatestVersionGUID = version
		return version
	end)
end

function Properties.FetchAPIDump(version: string)
	if Properties.Cache.APIDump[version] then
		return Promise.resolve(Properties.Cache.APIDump[version])
	end

	return HttpPromise.RequestJsonPromise({
		Url = "https://s3.amazonaws.com/setup.roblox.com/" .. version .. "-API-Dump.json",
		Method = "GET",
	}):andThen(function(data)
		Properties.Cache.APIDump[version] = data
		return data
	end)
end

local function FindClassEntry(dump, class: string)
	local entryIndex = Llama.List.findWhere(dump.Classes, function(classEntry)
		return classEntry.Name == class
	end)

	return dump.Classes[entryIndex]
end

function Properties.GetClassAncestry(class: string)
	return Properties.FetchLatestVersion()
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

function Properties.GetPropertyList(class: string)
	return Properties.GetClassAncestry(class):andThen(function(ancestry)
		local properties = {}

		for _, ancestor in ipairs(ancestry) do
			local propertyMembers = Llama.List.filter(ancestor.Members, function(member)
				if member.MemberType ~= "Property" then
					return false
				end

				if member.Security.Read ~= "None" or member.Security.Write ~= "None" then
					return false
				end

				if member.Tags then
					local tagList = { "ReadOnly", "Deprecated", "Hidden" }

					for _, tag in ipairs(member.Tags) do
						if table.find(tagList, tag) then
							return false
						end
					end
				end

				return true
			end)

			for _, property in ipairs(propertyMembers) do
				table.insert(properties, property.Name)
			end
		end

		return properties
	end)
end

function Properties.GetChangedProperties(instance: Instance)
	return Properties.GetPropertyList(instance.ClassName):andThen(function(properties)
		local newInstance = Instance.new(instance.ClassName)
		local changedProps = {}

		for _, property in ipairs(properties) do
			if property == "Parent" then
				continue
			end

			if newInstance[property] ~= instance[property] then
				table.insert(changedProps, property)
			end
		end

		newInstance:Destroy()

		return changedProps
	end)
end

return Properties
