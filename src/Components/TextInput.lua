local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local Highlighter = require(Packages.Highlighter)

local Layout = require(script.Parent.Layout)
local Text = require(script.Parent.Text)

local e = Roact.createElement

local MAX_TEXTBOX_CHARS = 16300
export type TextInputProps = {
	autoSize: Enum.AutomaticSize?,
	disabled: boolean?,
	readonly: boolean?,
	text: string?,
	textSize: number?,
	textColor: (Color3 | Enum.StudioStyleGuideColor)?,
	size: UDim2?,
	position: UDim2?,
	zindex: number?,
	order: number?,
	font: Enum.Font?,
	multiline: boolean?,
	wrapped: boolean?,
	placeholder: string?,
	maxHeight: number?,
	selectAllOnFocus: boolean?,
	syntaxHighlight: boolean?,
	caption: string?,

	onChanged: ((TextBox) -> ())?,
	onSubmit: ((TextBox) -> ())?,
	onFocus: ((TextBox) -> ())?,
	onFocusLost: ((TextBox) -> ())?,
}

local function TextInput(props: TextInputProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local hover, setHover = hooks.useState(false)
	local press, setPress = hooks.useState(false)
	local focus, setFocus = hooks.useState(false)
	local height, setHeight = hooks.useState(400)
	local captionHeight, setCaptionHeight = hooks.useState(0)

	local inputRef = hooks.useValue(Roact.createRef())

	local colors = hooks.useMemo(function()
		local modifiers = { background = nil, foreground = nil, border = nil, placeholder = nil, caption = nil }

		if props.disabled then
			modifiers.background = Enum.StudioStyleGuideModifier.Disabled
			modifiers.foreground = Enum.StudioStyleGuideModifier.Disabled
			modifiers.border = Enum.StudioStyleGuideModifier.Disabled
			modifiers.placeholder = Enum.StudioStyleGuideModifier.Disabled
			modifiers.caption = Enum.StudioStyleGuideModifier.Disabled
		elseif focus then
			modifiers.background = Enum.StudioStyleGuideModifier.Selected
			modifiers.foreground = Enum.StudioStyleGuideModifier.Default
			modifiers.border = Enum.StudioStyleGuideModifier.Selected
			modifiers.placeholder = Enum.StudioStyleGuideModifier.Selected
			modifiers.caption = Enum.StudioStyleGuideModifier.Selected
		elseif press then
			modifiers.background = Enum.StudioStyleGuideModifier.Pressed
			modifiers.foreground = Enum.StudioStyleGuideModifier.Pressed
			modifiers.border = Enum.StudioStyleGuideModifier.Pressed
			modifiers.placeholder = Enum.StudioStyleGuideModifier.Pressed
			modifiers.caption = Enum.StudioStyleGuideModifier.Pressed
		elseif hover then
			modifiers.background = Enum.StudioStyleGuideModifier.Hover
			modifiers.foreground = Enum.StudioStyleGuideModifier.Hover
			modifiers.border = Enum.StudioStyleGuideModifier.Hover
			modifiers.placeholder = Enum.StudioStyleGuideModifier.Hover
			modifiers.caption = Enum.StudioStyleGuideModifier.Hover
		else
			modifiers.caption = Enum.StudioStyleGuideModifier.Disabled
		end

		return {
			background = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, modifiers.background),
			border = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, modifiers.border),
			placeholder = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText, modifiers.placeholder),
			foreground = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifiers.foreground),
			caption = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifiers.caption),
		}
	end, { hover, press, focus, props.disabled, theme })

	local onInputBegan = hooks.useCallback(function(_, input: InputObject)
		if props.disabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(true)
		elseif input.UserInputType.Name:match("MouseButton%d+") then
			setPress(true)
		end
	end, { props.disabled })

	local function onInputEnded(_, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(false)
			setPress(false)
		elseif input.UserInputType.Name:match("MouseButton%d+") then
			setPress(false)
		end
	end

	local function onInputChanged(_, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHover(true)
		end
	end

	return e("ImageButton", {
		Active = not props.disabled,
		AutoButtonColor = false,
		BackgroundColor3 = colors.border,
		Position = props.position,
		LayoutOrder = props.order,
		Size = UDim2.new(
			1,
			0,
			0,
			height + 2 + (styles.spacing * 2) + (props.caption and (captionHeight + (styles.spacing / 2)) or 0)
		),
		ZIndex = props.zindex,
		Image = "",

		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
		[Roact.Event.InputChanged] = onInputChanged,

		[Roact.Event.Activated] = function()
			local input = inputRef.value:getValue()

			if input then
				input:CaptureFocus()
			end
		end,
	}, {
		corners = e(Layout.Corner),
		padding = e(Layout.Padding, { 1 }),

		layout = e(Layout.ListLayout, {
			direction = Enum.FillDirection.Vertical,
			gap = styles.spacing / 2,
		}),

		caption = props.caption and e(Text, {
			autoSize = Enum.AutomaticSize.Y,
			size = UDim2.fromScale(1, 0),
			text = props.caption,
			textColor = colors.caption,
			order = 10,

			onAbsoluteSizeChanged = function(rbx)
				setCaptionHeight(rbx.AbsoluteSize.Y)
			end,
		}, {
			padding = e(Layout.Padding, {
				bottom = styles.spacing / 2,
			}),
		}),

		content = e("Frame", {
			BackgroundColor3 = colors.background,
			Size = UDim2.new(1, 0, 0, height + styles.spacing * 2),
			LayoutOrder = 20,
			ClipsDescendants = true,
		}, {
			padding = e(Layout.Padding),

			corners = e(Layout.Corner, {
				radius = styles.borderRadius - 1,
			}),

			input = e("TextBox", {
				Active = not props.disabled,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, height),
				Font = props.font or styles.font.default,
				Text = props.text and string.sub(props.text, 1, MAX_TEXTBOX_CHARS),
				TextSize = props.textSize or styles.fontSize,
				TextColor3 = colors.foreground,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				ClearTextOnFocus = false,
				TextEditable = not (props.readonly or props.disabled),
				TextWrapped = props.wrapped,
				Selectable = not props.disabled,
				ClipsDescendants = true,
				MultiLine = props.multiline,
				PlaceholderText = props.placeholder,
				PlaceholderColor3 = colors.placeholder,

				[Roact.Ref] = inputRef.value,
				[Roact.Change.TextBounds] = function(rbx: TextBox)
					setHeight(rbx.TextBounds.Y + 2)

					if props.syntaxHighlight then
						Highlighter.highlight({
							textObject = rbx,
							forceUpdate = true,
						})
					end
				end,

				[Roact.Change.AbsoluteSize] = function(rbx: TextBox)
					if props.syntaxHighlight then
						Highlighter.highlight({
							textObject = rbx,
							forceUpdate = true,
						})
					end
				end,

				[Roact.Change.Text] = function(rbx: TextBox, ...)
					if props.onChanged then
						task.spawn(props.onChanged, rbx, ...)
					end

					if props.syntaxHighlight then
						Highlighter.highlight({
							textObject = rbx,
						})
					end
				end,

				[Roact.Event.Focused] = function(rbx: TextBox)
					setFocus(true)

					if props.selectAllOnFocus then
						rbx.CursorPosition = #rbx.Text + 1
						rbx.SelectionStart = 1
					end

					if props.onFocus then
						props.onFocus(rbx)
					end
				end,

				[Roact.Event.FocusLost] = function(rbx: TextBox, enterPressed: boolean)
					setFocus(false)
					setHover(false)
					setPress(false)

					if enterPressed and props.onSubmit then
						props.onSubmit(rbx)
					end

					if props.onFocusLost then
						props.onFocusLost(rbx)
					end
				end,
			}, {
				maxHeight = if props.maxHeight
					then e("UISizeConstraint", {
						MaxSize = Vector2.new(math.huge, props.maxHeight),
					})
					else nil,
			}),
		}),
	})
end

return Hooks.new(Roact)(TextInput, {
	defaultProps = {
		autoSize = Enum.AutomaticSize.Y,
		size = UDim2.fromScale(1, 0),
		wrapped = true,
		text = "",
	},
})
