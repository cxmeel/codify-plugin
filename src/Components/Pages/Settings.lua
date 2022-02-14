local Plugin = script.Parent.Parent.Parent

local StudioTheme = require(Plugin.Packages.StudioTheme)
local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)
local Llama = require(Plugin.Packages.Llama)

local Config2 = require(Plugin.Data.Config)
local Config = require(Plugin.Config)
local Thunks = require(Plugin.Thunks)
local Store = require(Plugin.Store)

local TextInput = require(Plugin.Components.TextInput)
local Checkbox = require(Plugin.Components.Checkbox)
local Layout = require(Plugin.Components.Layout)
local FrameworkSelect = require(Plugin.Components.FrameworkSelect)
local Dropdown = require(Plugin.Components.Dropdown)

local e = Roact.createElement

local function GetDropdownOptionsForSettingsEnum(enum)
	return Llama.Dictionary.values(Llama.Dictionary.map(enum, function(item, key)
		return {
			label = item[1],
			hint = item[2],
			value = key,
		}
	end))
end

local function Page(_, hooks)
	local _, styles = StudioTheme.useTheme(hooks)
	local state = Store.useStore(hooks)

	local SETTINGS_ENUMS = hooks.useMemo(function()
		return {
			Color3Format = GetDropdownOptionsForSettingsEnum(Store.Enum.Color3Format),
			UDim2Format = GetDropdownOptionsForSettingsEnum(Store.Enum.UDim2Format),
			NumberRangeFormat = GetDropdownOptionsForSettingsEnum(Store.Enum.NumberRangeFormat),
			EnumFormat = GetDropdownOptionsForSettingsEnum(Store.Enum.EnumFormat),
			NamingScheme = GetDropdownOptionsForSettingsEnum(Store.Enum.NamingScheme),
		}
	end, {})

	local dispatch = RoduxHooks.useDispatch(hooks)
	local contributors = RoduxHooks.useSelector(hooks, function(state)
		return state.contributors
	end)

	hooks.useEffect(function()
		dispatch(Thunks.FetchContributors(Config2.repo))
	end, {})

	return e(Layout.ScrollColumn, {
		paddingTop = styles.spacing,
		paddingBottom = styles.spacing,
	}, {
		padding = e(Layout.Padding),

		framework = e(FrameworkSelect, {
			order = 10,
		}),

		snippetSection = e(Layout.Forms.Section, {
			heading = "Snippets",
			hint = "Customise the formatting of your generated code snippets. You will need to regenerate your snippets to reflect changes.",
			divider = true,
			order = 20,
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
				selection = e(Dropdown, {
					label = Store.Enum.Color3Format[state.Settings.Color3Format][1],
					hint = Store.Enum.Color3Format[state.Settings.Color3Format][2],

					value = state.Settings.Color3Format,
					options = SETTINGS_ENUMS.Color3Format,

					onChanged = function(value)
						Store:SetState({ Settings = { Color3Format = value } })
					end,
				}),
			}),

			udim2Format = e(Layout.Forms.Section, {
				heading = "UDim2 Format",
				hint = "Configure how UDim2 values are displayed in code snippets.",
				formItem = true,
				order = 30,
			}, {
				selection = e(Dropdown, {
					label = Store.Enum.UDim2Format[state.Settings.UDim2Format][1],
					hint = Store.Enum.UDim2Format[state.Settings.UDim2Format][2],

					value = state.Settings.UDim2Format,
					options = SETTINGS_ENUMS.UDim2Format,

					onChanged = function(value)
						Store:SetState({ Settings = { UDim2Format = value } })
					end,
				}),
			}),

			numberRangeFormat = e(Layout.Forms.Section, {
				heading = "NumberRange Format",
				hint = "Configure how NumberRange values are displayed in code snippets.",
				formItem = true,
				order = 40,
			}, {
				selection = e(Dropdown, {
					label = Store.Enum.NumberRangeFormat[state.Settings.NumberRangeFormat][1],
					hint = Store.Enum.NumberRangeFormat[state.Settings.NumberRangeFormat][2],

					value = state.Settings.NumberRangeFormat,
					options = SETTINGS_ENUMS.NumberRangeFormat,

					onChanged = function(value)
						Store:SetState({ Settings = { NumberRangeFormat = value } })
					end,
				}),
			}),

			enumFormat = e(Layout.Forms.Section, {
				heading = "Enum Format",
				hint = "Configure how Enum values are displayed in code snippets.",
				formItem = true,
				order = 50,
			}, {
				selection = e(Dropdown, {
					label = Store.Enum.EnumFormat[state.Settings.EnumFormat][1],
					hint = Store.Enum.EnumFormat[state.Settings.EnumFormat][2],

					value = state.Settings.EnumFormat,
					options = SETTINGS_ENUMS.EnumFormat,

					onChanged = function(value)
						Store:SetState({ Settings = { EnumFormat = value } })
					end,
				}),
			}),

			namingScheme = e(Layout.Forms.Section, {
				heading = "Naming Scheme",
				hint = "Determines how child names are generated.",
				formItem = true,
				order = 60,
			}, {
				selection = e(Dropdown, {
					label = Store.Enum.NamingScheme[state.Settings.NamingScheme][1],
					hint = Store.Enum.NamingScheme[state.Settings.NamingScheme][2],

					value = state.Settings.NamingScheme,
					options = SETTINGS_ENUMS.NamingScheme,

					onChanged = function(value)
						Store:SetState({ Settings = { NamingScheme = value } })
					end,
				}),
			}),

			syntaxHighlight = e(Layout.Forms.Section, {
				heading = "Syntax Highlighting",
				hint = "Enables syntax highlighting for code snippets. Turn this off to save some performance.",
				formItem = true,
				order = 70,
			}, {
				option = e(Checkbox, {
					label = "Highlight Code Snippets",
					order = 60,

					value = state.Settings.SyntaxHighlight,

					onChanged = function(value: boolean)
						Store:SetState({ Settings = { SyntaxHighlight = value } })
					end,
				}),
			}),
		}),

		aboutSection = e(Layout.Forms.Section, {
			heading = "About",
			divider = true,
			order = 30,
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

			contributors = #contributors > 0 and e(Layout.Forms.Section, {
				heading = "Contributors",
				hint = table.concat(contributors, ", "),
				formItem = true,
				order = 30,
			}),
		}),
	})
end

return Hooks.new(Roact)(Page, {
	componentType = "PureComponent",
})
