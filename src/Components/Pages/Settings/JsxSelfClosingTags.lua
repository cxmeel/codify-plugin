local Plugin = script.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Enums = require(Plugin.Data.Enums)
local Actions = require(Plugin.Actions)

local Checkbox = require(Plugin.Components.Checkbox)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

local ENABLED_FRAMEWORKS = {
	Enums.Framework.Jsx,
}

export type JsxSelfClosingTagsProps = {
	order: number?,
}

local function JsxSelfClosingTags(props: JsxSelfClosingTagsProps, hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local value = userSettings.jsxSelfClosingTags
	local framework = userSettings.framework

	if not table.find(ENABLED_FRAMEWORKS, framework) then
		return nil
	end

	return e(Layout.Forms.Section, {
		heading = "JSX Self-closing Tags",
		hint = "Determines if Instances without children should be self-closing tags.",
		formItem = true,
		order = props.order,
	}, {
		value = e(Checkbox, {
			label = "Enable Self-closing Tags",
			order = 10,
			value = value,

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "jsxSelfClosingTags",
					value = value,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(JsxSelfClosingTags)
