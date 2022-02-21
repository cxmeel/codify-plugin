local Plugin = script.Parent.Parent.Parent.Parent

local StudioTheme = require(Plugin.Packages.StudioTheme)
local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Enums = require(Plugin.Data.Enums)
local Actions = require(Plugin.Actions)

local TextInput = require(Plugin.Components.TextInput)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type CreateMethodProps = {
	order: number?,
}

local DISABLED_FRAMEWORKS = {
	Enums.Framework.Regular,
}

local DEFAULT_METHODS = {
	[Enums.Framework.Roact] = "Roact.createElement",
	[Enums.Framework.Fusion] = "New",
}

local function CreateMethod(props: CreateMethodProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local framework = hooks.useMemo(function()
		return userSettings.framework
	end, { userSettings })

	local value = hooks.useMemo(function()
		return userSettings["createMethod" .. framework]
	end, { userSettings, framework })

	if table.find(DISABLED_FRAMEWORKS, framework) then
		return nil
	end

	return e(Layout.Forms.Section, {
		heading = "Create Method",
		hint = "If you've assigned the creator method to a variable, you can specify this here.",
		formItem = true,
		order = props.order,
	}, {
		value = e(TextInput, {
			placeholder = DEFAULT_METHODS[framework],
			text = value,
			font = styles.font.mono,
			textSize = styles.fontSize + 2,

			onChanged = function(rbx: TextBox)
				dispatch(Actions.SetSetting({
					key = "createMethod" .. framework,
					value = rbx.Text,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(CreateMethod)
