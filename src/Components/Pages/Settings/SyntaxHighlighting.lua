local Plugin = script.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Actions = require(Plugin.Actions)

local Checkbox = require(Plugin.Components.Checkbox)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type SyntaxHighlightingProps = {
	order: number?,
}

local function SyntaxHighlighting(props: SyntaxHighlightingProps, hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local value = hooks.useMemo(function()
		return userSettings.syntaxHighlighting
	end, { userSettings })

	return e(Layout.Forms.Section, {
		heading = "Syntax Highlighting",
		hint = "Enable syntax highlighting in code snippets. Turn this off to increase performance.",
		formItem = true,
		order = props.order,
	}, {
		value = e(Checkbox, {
			label = "Highlight Code Snippets",
			order = 10,
			value = value,

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "syntaxHighlighting",
					value = value,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(SyntaxHighlighting, {
	componentType = "PureComponent",
})
