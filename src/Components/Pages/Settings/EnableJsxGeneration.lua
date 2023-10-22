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

	local value = userSettings.enableJsxGeneration

	return e(Layout.Forms.Section, {
		heading = "TypeScript JSX",
		hint = "Enable generating TypeScript JSX snippets.",
		formItem = true,
		order = props.order,
	}, {
		value = e(Checkbox, {
			label = "TypeScript JSX",
			order = 10,
			value = value,

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "enableJsxGeneration",
					value = value,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(SyntaxHighlighting)
