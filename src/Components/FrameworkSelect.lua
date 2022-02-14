local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Llama = require(Plugin.Packages.Llama)

local Store = require(Plugin.Store)

local Dropdown = require(Plugin.Components.Dropdown)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type FrameworkSelectProps = {
	order: number?,
}

local DROPDOWN_OPTIONS = Llama.Dictionary.values(Llama.Dictionary.map(Store.Enum.Framework, function(item, key)
	return {
		icon = key,
		label = item[1],
		hint = item[2],
		value = key,
	}
end))

local function FrameworkSelect(props: FrameworkSelectProps, hooks)
	local state = Store.useStore(hooks)

	return e(Layout.Forms.Section, {
		heading = "Framework",
		hint = "Select the framework to be used by the plugin when generating code snippets.",
		order = props.order,
	}, {
		value = e(Dropdown, {
			icon = state.Settings.Framework,
			label = Store.Enum.Framework[state.Settings.Framework][1],
			hint = Store.Enum.Framework[state.Settings.Framework][2],
			value = state.Settings.Framework,
			options = DROPDOWN_OPTIONS,

			onChanged = function(value)
				Store:SetState({ Settings = { Framework = value } })
			end,
		}),
	})
end

return Hooks.new(Roact)(FrameworkSelect, {
	componentType = "PureComponent",
})
