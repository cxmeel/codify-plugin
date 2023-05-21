local Plugin = script.Parent.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Sift = require(Plugin.Packages.Sift)

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
			hint: string?,
		},
	},
}

return function(options: CreateInputOptions)
	local DROPDOWN_OPTIONS = Sift.Dictionary.values(Sift.Dictionary.map(options.enumMap, function(details, enumItem)
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

		local value = userSettings[options.settingsKey]
		local details = options.enumMap[value] or {}

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

	return Hooks.new(Roact)(SettingsInput)
end
