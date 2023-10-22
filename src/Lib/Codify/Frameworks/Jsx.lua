local Properties = require(script.Parent.Parent.Parent.Properties)
local Serialise = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local SafeNamer = require(script.Parent.Parent.SafeNamer)

local concat = table.concat

local function generate(instance: Instance, options)
	local snippet = Script.new()

	local success, changedProps = Properties.GetChangedProperties(instance):await()
	local children = instance:GetChildren()

	if not success then
		error("Failed to get changed properties: " .. tostring(changedProps), 2)
	end

	task.desynchronize()

	local function tab()
		return string.rep(options.TabCharacter, options.Indent)
	end

	local isNameChanged = table.find(changedProps, "Name")
	local isSelfClosing = options.JsxSelfClosingTags == true

	local classTag = instance.ClassName:lower()
	local closingTag = if #children > 0 then ">" else isSelfClosing and "/>" or `></{classTag}>`

	local startLine = snippet:CreateLine()
	startLine:Push((#children > 0 or options.isChild) and tab() or "", "<", classTag)

	if #changedProps > 0 then
		options.Indent += 1

		if options.NamingScheme == "All" and not isNameChanged then
			table.insert(changedProps, 1, "Name")
		end

		for _, prop in ipairs(changedProps) do
			if
				prop == "Name"
				and (options.NamingScheme == "None" or (options.NamingScheme == "Changed" and not isNameChanged))
			then
				continue
			end

			local value = Serialise.SerialiseProperty(instance, prop, options, true)

			if value == nil then
				continue
			end

			options.PropIndent = #prop + 3
			snippet:CreateLine():Push(`{tab()}{prop == "Name" and "Key" or prop}=\{{value}}`)
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), closingTag)
	else
		if options.NamingScheme == "All" and not isNameChanged then
			local name = Serialise.SerialiseProperty(instance, "Name", options, true)
			startLine:Push(` Key=\{{name}}`)
		end

		if isSelfClosing then
			startLine:Push(" ")
		end

		startLine:Push(`{closingTag}`)
	end

	if #children > 0 then
		options.Indent += 1

		for index, child in ipairs(children) do
			if index > 1 then
				snippet:CreateLine()
			end

			options.isChild = true
			snippet:CreateLine():Push(generate(child, options))
			options.isChild = false
		end

		options.Indent -= 1
		snippet:CreateLine():Push(`{tab()}</{classTag}>`)
	end

	return snippet:Concat()
end

return {
	Generator = function(instance: Instance, options)
		local hasChildren = #instance:GetChildren() > 0
		local snippet = Script.new()

		if hasChildren then
			options.Indent = 1
			snippet:CreateLine():Push("(")
		end

		snippet:CreateLine():Push(generate(instance, options))

		if hasChildren then
			snippet:CreateLine():Push(")")
		end

		return snippet:Concat()
	end,

	Sample = concat({
		"return <lorem",
		'    ipsum="dolor"',
		'    sit="amet"',
		'    consectetur="adipiscing"',
		'    elit="sed"',
		'    do="eiusmod"',
		'    tempor="incididunt"',
		"/>",
	}, "\n"),
}
