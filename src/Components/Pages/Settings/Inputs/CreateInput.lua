local Plugin = script.Parent.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Llama = require(Plugin.Packages.Llama)

local Actions = require(Plugin.Actions)

local Dropdown = require(Plugin.Components.Dropdown)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type SettingsInputProps = {
	order: number?,
}

export type CreateInputOptions = {
	heading: string,
	hint: string?,

	settingsKey: string,

	enumMap: {
		[string]: {
			label: string,
			hint: string,
		},
	},
}

return function(options: CreateInputOptions)
	local DROPDOWN_OPTIONS = Llama.Dictionary.values(Llama.Dictionary.map(options.enumMap, function(details, enumItem)
		return {
			label = details.label,
			hint = details.hint,
			value = enumItem,
		}
	end))

	local function SettingsInput(props: SettingsInputProps, hooks)
		local dispatch = RoduxHooks.useDispatch(hooks)

		local userSettings = RoduxHooks.useSelector(hooks, function(state)
			return state.userSettings
		end)

		local value = hooks.useMemo(function()
			return userSettings[options.settingsKey]
		end, { userSettings })

		local details = hooks.useMemo(function()
			return options.enumMap[value] or {}
		end, { value })

		return e(Layout.Forms.Section, {
			heading = options.heading,
			hint = options.hint,
			formItem = true,
			order = props.order,
		}, {
			selection = e(Dropdown, {
				label = details.label,
				hint = details.hint,
				value = value,
				options = DROPDOWN_OPTIONS,

				onChanged = function(value)
					dispatch(Actions.SetSetting({
						key = options.settingsKey,
						value = value,
					}))
				end,
			}),
		})
	end

	return Hooks.new(Roact)(SettingsInput, {
		componentType = "PureComponent",
	})
end
