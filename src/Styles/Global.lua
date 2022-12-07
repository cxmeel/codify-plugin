--!strict
local FONT_SANS = "rbxasset://fonts/families/SourceSansPro.json"
local FONT_MONO = "rbxasset://fonts/families/Inconsolata.json"

local GlobalStyles = {
	font = {
		main = {
			face = Font.new(FONT_SANS),
			size = 18,
		},
		mono = {
			face = Font.new(FONT_MONO),
			size = 16,
		},
		bold = {
			face = Font.new(FONT_SANS, Enum.FontWeight.Bold),
			size = 18,
		},
		light = {
			face = Font.new(FONT_SANS, Enum.FontWeight.Light),
			size = 18,
		},
	},
	borderRadius = 4,
	spacing = 8,
}

return GlobalStyles
