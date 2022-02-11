local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local Llama = require(Packages.Llama)

local DropdownButton = require(script.Button)
local PopoverShield = require(script.Shield)
local OptionsContainer = require(script.OptionsContainer)
local OptionButton = require(script.OptionButton)

local e = Roact.createElement

type DropdownOption = {
	label: string?,
	hint: string?,
	disabled: boolean?,
	value: any,
	icon: string?,
	iconPosition: string?,
	iconColour: Color3?,
}

export type DropdownProps = {
	disabled: boolean?,
	label: string?,
	hint: string?,
	value: any?,
	options: { DropdownOption }?,
	onChanged: ((value: any) -> ())?,
	icon: string?,
	iconPosition: string?,
	iconColour: Color3?,
}

local function Dropdown(props: DropdownProps, hooks)
	local buttonPosition, setButtonPosition = hooks.useState(Vector2.new())
	local buttonSize, setButtonSize = hooks.useState(Vector2.new())

	local showDropdown, setShowDropdown = hooks.useState(false)

	local optionButtons = hooks.useMemo(function()
		return Llama.List.map(props.options, function(option: DropdownOption, index: number)
			return e(OptionButton, {
				icon = option.icon,
				iconColour = option.iconColour,
				iconPosition = option.iconPosition,
				label = option.label or tostring(option.value),
				hint = option.hint,
				disabled = option.disabled,
				selected = props.value == option.value,
				order = index,

				onActivated = function()
					setShowDropdown(false)
					props.onChanged(option.value)
				end,
			})
		end)
	end, { props.options, props.onChanged, props.value })

	return Roact.createFragment({
		button = e(DropdownButton, {
			disabled = props.disabled,
			icon = props.icon,
			iconPosition = props.iconPosition,
			iconColour = props.iconColour,
			label = props.label,
			hint = props.hint,
			active = showDropdown,

			onActivated = function()
				setShowDropdown(true)
			end,

			onPositionChanged = function(rbx: ImageButton)
				setButtonPosition(rbx.AbsolutePosition)
			end,

			onSizeChanged = function(rbx: ImageButton)
				setButtonSize(rbx.AbsoluteSize)
			end,
		}),

		popover = if showDropdown
			then e(PopoverShield, {
				onActivated = function()
					setShowDropdown(false)
				end,
			}, {
				options = e(OptionsContainer, {
					buttonSize = buttonSize,
					buttonPosition = buttonPosition,
				}, optionButtons),
			})
			else nil,
	})
end

return Hooks.new(Roact)(Dropdown, {
	componentType = "PureComponent",
	defaultProps = {
		options = {},
	},
})
