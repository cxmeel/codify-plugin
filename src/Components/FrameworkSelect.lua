local Plugin = script.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Llama = require(Plugin.Packages.Llama)

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
		hint = 'New "Frame" { ... }',
	},
	[Enums.Framework.Roact] = {
		icon = "FrameworkRoact",
		label = "Roact",
		hint = 'Roact.createElement("Frame", { ... }, { ... })',
	},
}

local DROPDOWN_OPTIONS = Llama.Dictionary.values(Llama.Dictionary.map(FRAMEWORK_ENUM_MAP, function(details, enumItem)
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
			options = DROPDOWN_OPTIONS,

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
