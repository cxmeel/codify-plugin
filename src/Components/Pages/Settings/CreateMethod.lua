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
	Enums.Framework.Jsx,
}

local DEFAULT_METHODS = {
	[Enums.Framework.Roact] = "React.createElement",
	[Enums.Framework.Fusion] = "New",
}

local function CreateMethod(props: CreateMethodProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local framework = userSettings.framework
	local value = userSettings["createMethod" .. framework]

	if table.find(DISABLED_FRAMEWORKS, framework) then
		return nil
	end

	return e(Layout.Forms.Section, {
		heading = "Create Method",
		hint = "Override the create method's name if, for example, you have assigned a variable or are using Roact.",
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
