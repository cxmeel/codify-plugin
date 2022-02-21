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

export type ChildrenKeyProps = {
	order: number?,
}

local DISABLED_FRAMEWORKS = {
	Enums.Framework.Roact,
	Enums.Framework.Regular,
}

local DEFAULT_METHODS = {
	[Enums.Framework.Fusion] = "Children",
}

local function ChildrenKey(props: ChildrenKeyProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local framework = userSettings.framework
	local value = userSettings["childrenKey" .. framework]

	if table.find(DISABLED_FRAMEWORKS, framework) then
		return nil
	end

	return e(Layout.Forms.Section, {
		heading = "Children Key",
		hint = "If you've assigned the Children key to a variable, you can specify this here.",
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
					key = "childrenKey" .. framework,
					value = rbx.Text,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(ChildrenKey)
