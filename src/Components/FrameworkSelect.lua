local Plugin = script.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Sift = require(Plugin.Packages.Sift)

local Enums = require(Plugin.Data.Enums)
local Actions = require(Plugin.Actions)

local Dropdown = require(Plugin.Components.Dropdown)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type FrameworkSelectProps = {
	order: number?,
}

local FRAMEWORK_ENUM_MAP = {
	[Enums.Framework.Regular] = {
		icon = "FrameworkRegular",
		label = "Regular",
		hint = 'Instance.new("Frame")',
	},

	[Enums.Framework.Fusion] = {
		icon = "FrameworkFusion",
		label = "Fusion",
		hint = 'New "Frame" {...}',
	},

	[Enums.Framework.Roact] = {
		icon = "FrameworkRoact",
		label = "React",
		hint = 'React.createElement("Frame", {...}, {...})',
	},

	[Enums.Framework.Jsx] = {
		icon = "FrameworkJSX",
		label = "TypeScript JSX",
		hint = "<frame {...}>...</frame>",
	},
}

local DROPDOWN_OPTIONS = Sift.Dictionary.values(Sift.Dictionary.map(FRAMEWORK_ENUM_MAP, function(details, enumItem)
	return {
		icon = details.icon,
		label = details.label,
		hint = details.hint,
		value = enumItem,
	}
end))

local function FrameworkSelect(props: FrameworkSelectProps, hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local framework = userSettings.framework
	local details = FRAMEWORK_ENUM_MAP[framework] or {}

	local enableJsxGeneration = userSettings.enableJsxGeneration

	local dropdownOptions = hooks.useMemo(function()
		local options = table.clone(DROPDOWN_OPTIONS)

		if not enableJsxGeneration then
			for index, value in options do
				if value.value == Enums.Framework.Jsx then
					table.remove(options, index)
					break
				end
			end
		end

		return options
	end, { enableJsxGeneration })

	return e(Layout.Forms.Section, {
		heading = "Framework",
		hint = "Select the framework to be used by the plugin when generating code snippets.",
		order = props.order,
	}, {
		value = e(Dropdown, {
			icon = details.icon,
			label = details.label,
			hint = details.hint,
			value = framework,
			options = dropdownOptions,

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "framework",
					value = value,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(FrameworkSelect)
