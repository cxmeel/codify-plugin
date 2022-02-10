local StudioService = game:GetService("StudioService")

local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local RoactRouter = require(Packages.RoactRouter)

local Store = require(script.Parent.Parent.Parent.Store)

local Text = require(script.Parent.Parent.Text)
local Icon = require(script.Parent.Parent.Icon)
local Layout = require(script.Parent.Parent.Layout)
local TextInput = require(script.Parent.Parent.TextInput)
local Button = require(script.Parent.Parent.Button)
local Alert = require(script.Parent.Parent.Alert)

local isWindows = game:GetService("GuiService").IsWindows
local e = Roact.createElement

local copyText = if isWindows then "CTRL+C to Copy" else "Command+C to Copy"

local function Page(_, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)
	local showCopy, setShowCopy = hooks.useState(false)

	local state = Store.useStore(hooks)

	local createMethod = hooks.useMemo(function()
		if state.Settings.CreateMethod and #state.Settings.CreateMethod > 0 then
			return state.Settings.CreateMethod
		end

		return "Roact.createElement"
	end, { state })

	local activeSelection = hooks.useMemo(function()
		local name = "Nothing selected"
		local icon = StudioService:GetClassIcon("Instance")

		if state.RootTarget then
			name = state.RootTarget.Name
			icon = StudioService:GetClassIcon(state.RootTarget.ClassName)
		end

		return {
			name = name,
			icon = icon,
		}
	end, { state })

	return e(RoactRouter.Route, {
		path = "/",
		exact = true,
	}, {
		content = e(Layout.ScrollColumn, {
			paddingTop = styles.spacing,
			paddingBottom = styles.spacing,
		}, {
			padding = e(Layout.Padding),

			heading = e(Layout.Forms.Section, {
				heading = "Roact Snippet",
				hint = "Output formatting can be configured via the Settings tab.",
				order = 10,
			}),

			activeSelection = e(Layout.Frame, {
				order = 20,
			}, {
				padding = e(Layout.Padding, { 0, 16, 0, 0 }),
				layout = e(Layout.ListLayout),

				icon = e(Icon, {
					icon = activeSelection.icon.Image,
					imageOffset = activeSelection.icon.ImageRectOffset,
					imageSize = activeSelection.icon.ImageRectSize,
					colour = Color3.new(1, 1, 1),
					size = 16,
					order = 10,
				}),

				label = e(Text, {
					text = activeSelection.name,
					font = styles.font.mono,
					textSize = styles.fontSize + 2,
					order = 20,
				}),
			}),

			largeInstance = if state.LargeInstance
				then e(Alert, {
					label = "This Instance appears to have a lot of children! Can it be broken into smaller components?",
					variant = Enum.MessageType.MessageWarning,
					order = 30,
				})
				else nil,

			generateButton = e(Button, {
				order = 40,
				label = "Generate Snippet",
				primary = not state.LargeInstance,
				size = UDim2.fromScale(1, 0),
				autoSize = Enum.AutomaticSize.Y,
				disabled = state.RootTarget == nil or state.SnippetProcessing,

				onActivated = function()
					Store.Actions.GenerateSnippet:Fire()
				end,
			}),

			snippet = e(Layout.Frame, {
				order = 50,
			}, {
				layout = e(Layout.ListLayout, {
					direction = Enum.FillDirection.Vertical,
					alignX = Enum.HorizontalAlignment.Right,
				}),

				snippetText = e(TextInput, {
					order = 20,
					placeholder = table.concat({
						"return " .. createMethod .. '("Lorem", {',
						'  ipsum = "dolor"',
						'  sit = "amet"',
						'  consectetur = "adipiscing"',
						'  elit = "sed"',
						'  do = "eiusmod"',
						'  tempor = "incididunt"',
						'  ut = "labore"',
						'  et = "dolore"',
						'  magna = "aliqua"',
						'  ut = "enim"',
						'  ad = "minim"',
						'  veniam = "quis"',
						'  nostrud = "exercitation"',
						'  ullamco = "laboris"',
						"})",
					}, "\n"),
					text = if state.Snippet then state.Snippet.Snippet else nil,
					font = styles.font.mono,
					textSize = styles.fontSize + 2,
					readonly = true,
					disabled = state.Snippet == nil,
					wrapped = false,
					maxHeight = 500,
					selectAllOnFocus = true,

					onFocus = function()
						setShowCopy(true)
					end,

					onFocusLost = function()
						setShowCopy(false)
					end,
				}),

				copyText = if showCopy
					then e(Text, {
						text = copyText,
						textColour = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
						textSize = styles.fontSize - 2,
						font = styles.font.semibold,
						order = 30,
					})
					else nil,

				downloadButton = e(Button, {
					primary = true,
					disabled = state.Snippet == nil,
					order = 40,
					label = "Save to Device",
					icon = "Download",

					onActivated = function()
						Store.Actions.SaveSnippet:Fire()
					end,
				}),
			}),
		}),
	})
end

return Hooks.new(Roact)(Page, {
	componentType = "PureComponent",
})
