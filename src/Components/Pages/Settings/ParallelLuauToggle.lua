local Plugin = script.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Actions = require(Plugin.Actions)

local Checkbox = require(Plugin.Components.Checkbox)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type ParallelLuauToggleProps = {
	order: number?,
}

local function ParallelLuauToggle(props: ParallelLuauToggleProps, hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local userSettings = RoduxHooks.useSelector(hooks, function(state)
		return state.userSettings
	end)

	local value = userSettings.parallelLuauGeneration

	return e(Layout.Forms.Section, {
		heading = "Parallel Luau",
		hint = "Use parallel Luau to generate code snippets. This should prevent Studio from becoming unresponsive while generating code, but still may take a while and cause lag.",
		formItem = true,
		order = props.order,
	}, {
		value = e(Checkbox, {
			label = "Parallel Luau",
			order = 10,
			value = value,
			disabled = not task or not (task.synchronize and task.desynchronize),

			onChanged = function(value)
				dispatch(Actions.SetSetting({
					key = "parallelLuauGeneration",
					value = value,
				}))
			end,
		}),
	})
end

return Hooks.new(Roact)(ParallelLuauToggle)
