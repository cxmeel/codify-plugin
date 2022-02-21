local Plugin = script.Parent.Parent.Parent.Parent

local StudioTheme = require(Plugin.Packages.StudioTheme)
local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Enums = require(Plugin.Data.Enums)
local Actions = require(Plugin.Actions)

local TextInput = require(Plugin.Components.TextInput)
local Checkbox = require(Plugin.Components.Checkbox)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type IndentFormatProps = {
	order: number?,
}

local DISABLED_FRAMEWORKS = {
	Enums.Framework.Regular,
}

local function IndentFormat(props: IndentFormatProps, hooks)
	local styles = select(2, StudioTheme.useTheme(hooks))
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local values = hooks.useMemo(function()
		return {
			useTabs = userSettings.indentationUsesTabs,
			tabWidth = userSettings.indentationLength,
		}
	end, { userSettings })

	if table.find(DISABLED_FRAMEWORKS, userSettings.framework) then
		return nil
	end

	return e(Layout.Forms.Section, {
		heading = "Indentation",
		hint = "Select the indentation format for your code snippets.",
		formItem = true,
		order = props.order,
	}, {
		value = e(Checkbox, {
			label = "Indent using tabs",
			order = 10,
			value = values.useTabs,

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "indentationUsesTabs",
					value = value,
				}))
			end,
		}),

		tabWidth = not values.useTabs and e(Layout.Forms.Section, {
			heading = "Tab Width",
			hint = "The number of spaces to use for each tab.",
			formItem = true,
			order = 20,
		}, {
			value = e(TextInput, {
				placeholder = "2",
				text = values.tabWidth,
				font = styles.font.mono,
				textSize = styles.fontSize + 2,

				onChanged = function(rbx: TextBox)
					dispatch(Actions.SetSetting({
						key = "indentationLength",
						value = tonumber(rbx.Text),
					}))
				end,
			}),
		}),
	})
end

return Hooks.new(Roact)(IndentFormat)
