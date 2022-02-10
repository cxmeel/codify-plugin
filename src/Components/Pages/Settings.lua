local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)
local RoactRouter = require(Packages.RoactRouter)

local Store = require(script.Parent.Parent.Parent.Store)
local Config = require(script.Parent.Parent.Parent.Config)

local TextInput = require(script.Parent.Parent.TextInput)
local Layout = require(script.Parent.Parent.Layout)
local Button = require(script.Parent.Parent.Button)

local e = Roact.createElement

local function Page(_, hooks)
	local _, styles = StudioTheme.useTheme(hooks)
	local state = Store.useStore(hooks)

	local contributors, setContributors = hooks.useState({})

	hooks.useEffect(function()
		Config.FetchContributors()
			:andThen(function(data)
				setContributors(data)
			end)
			:catch(function(...)
				if Config.IsDev then
					warn(...)
				end
			end)
	end, {})

	return e(RoactRouter.Route, {
		path = "/settings",
		exact = true,
	}, {
		content = e(Layout.ScrollColumn, {
			paddingTop = styles.spacing,
			paddingBottom = styles.spacing,
		}, {
			padding = e(Layout.Padding),

			snippetSection = e(Layout.Forms.Section, {
				heading = "Snippets",
				hint = "Customise the formatting of your generated code snippets. You will need to regenerate your snippets to reflect changes.",
				order = 10,
			}, {
				createMethod = e(Layout.Forms.Section, {
					heading = "Create Method",
					hint = "If you've assigned createElement to a variable, you can specify this here.",
					formItem = true,
					order = 10,
				}, {
					input = e(TextInput, {
						placeholder = "Roact.createElement",
						text = state.Settings.CreateMethod,
						font = styles.font.mono,
						textSize = styles.fontSize + 2,

						onChanged = function(rbx: TextBox)
							Store:SetState({
								Settings = {
									CreateMethod = rbx.Text,
								},
							})
						end,
					}),
				}),

				color3Format = e(Layout.Forms.Section, {
					heading = "Color3 Format",
					hint = "Configure how Color3 values are displayed in code snippets.",
					formItem = true,
					order = 20,
				}, {
					selection = e(Button, {
						label = Store.Enum.Color3Format[state.Settings.Color3Format][1],
						hint = Store.Enum.Color3Format[state.Settings.Color3Format][2],
						alignX = Enum.HorizontalAlignment.Left,
						size = UDim2.fromScale(1, 0),
						autoSize = Enum.AutomaticSize.Y,

						onActivated = function()
							Store.IncrementEnum("Color3Format")
						end,
					}),
				}),

				udim2Format = e(Layout.Forms.Section, {
					heading = "UDim2 Format",
					hint = "Configure how UDim2 values are displayed in code snippets.",
					formItem = true,
					order = 30,
				}, {
					selection = e(Button, {
						label = Store.Enum.UDim2Format[state.Settings.UDim2Format][1],
						hint = Store.Enum.UDim2Format[state.Settings.UDim2Format][2],
						alignX = Enum.HorizontalAlignment.Left,
						size = UDim2.fromScale(1, 0),
						autoSize = Enum.AutomaticSize.Y,

						onActivated = function()
							Store.IncrementEnum("UDim2Format")
						end,
					}),
				}),

				enumFormat = e(Layout.Forms.Section, {
					heading = "Enum Format",
					hint = "Configure how Enum values are displayed in code snippets.",
					formItem = true,
					order = 40,
				}, {
					selection = e(Button, {
						label = Store.Enum.EnumFormat[state.Settings.EnumFormat][1],
						hint = Store.Enum.EnumFormat[state.Settings.EnumFormat][2],
						alignX = Enum.HorizontalAlignment.Left,
						size = UDim2.fromScale(1, 0),
						autoSize = Enum.AutomaticSize.Y,

						onActivated = function()
							Store.IncrementEnum("EnumFormat")
						end,
					}),
				}),

				namingShceme = e(Layout.Forms.Section, {
					heading = "Naming Scheme",
					hint = "Determines how child names are generated.",
					formItem = true,
					order = 50,
				}, {
					selection = e(Button, {
						label = Store.Enum.NamingScheme[state.Settings.NamingScheme][1],
						hint = Store.Enum.NamingScheme[state.Settings.NamingScheme][2],
						alignX = Enum.HorizontalAlignment.Left,
						size = UDim2.fromScale(1, 0),
						autoSize = Enum.AutomaticSize.Y,

						onActivated = function()
							Store.IncrementEnum("NamingScheme")
						end,
					}),
				}),

				-- syntaxHighlight = e(Layout.Forms.Section, {
				-- 	heading = "Syntax Highlighting",
				-- 	hint = "Enables syntax highlighting for code snippets. Turn this off to save some performance.",
				-- 	formItem = true,
				-- 	order = 60,
				-- }, {
				-- 	option = e(Button, {
				-- 		label = if state.Settings.SyntaxHighlight then "Enabled" else "Disabled",
				-- 		icon = if state.Settings.SyntaxHighlight then "Tick" else "Cross",
				-- 		alignX = Enum.HorizontalAlignment.Left,
				-- 		size = UDim2.fromScale(1, 0),
				-- 		autoSize = Enum.AutomaticSize.Y,

				-- 		onActivated = function()
				-- 			Store:SetState({ Settings = { SyntaxHighlight = not state.Settings.SyntaxHighlight } })
				-- 		end,
				-- 	}),
				-- }),
			}),

			aboutSection = e(Layout.Forms.Section, {
				heading = "About",
				divider = true,
				order = 20,
			}, {
				version = e(Layout.Forms.Section, {
					heading = "Version",
					hint = Config.Version .. " (" .. Config.VersionTag .. ")",
					formItem = true,
					order = 10,
				}),

				originalAuthor = if Config.OriginalAuthor
					then e(Layout.Forms.Section, {
						heading = "Original Author",
						hint = Config.OriginalAuthor.Username,
						formItem = true,
						order = 20,
					})
					else nil,

				author = e(Layout.Forms.Section, {
					heading = if Config.OriginalAuthor then "Fork Author" else "Author",
					hint = Config.Author.Username,
					formItem = true,
					order = 25,
				}),

				contributors = if #contributors > 0
					then e(Layout.Forms.Section, {
						heading = "Contributors",
						hint = table.concat(contributors, ", "),
						formItem = true,
						order = 30,
					})
					else nil,
			}),
		}),
	})
end

return Hooks.new(Roact)(Page, {
	componentType = "PureComponent",
})
