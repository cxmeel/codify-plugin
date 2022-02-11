local Packages = script.Parent.Packages

local BasicState = require(Packages.BasicState)
local Llama = require(Packages.Llama)

local Store = BasicState.new({
	Settings = {
		Framework = "Regular",
		CreateMethod = nil,
		Color3Format = "RGB",
		UDim2Format = "SMART",
		EnumFormat = "FULL",
		NamingScheme = "ALL",
		SyntaxHighlight = true,
	},

	RootTarget = nil,
	LargeInstance = false,

	SnippetProcessing = false,
	Snippet = nil,
})

Store.Enum = {
	Framework = {
		Regular = { "Regular", "Instance.new('Frame')" },
		Roact = { "Roact", "Roact.createElement('Frame', {})" },
		Fusion = { "Fusion", "New 'Frame' {}" },
	},
	Color3Format = {
		HEX = { "Hex", "Color3.fromHex" },
		RGB = { "RGB", "Color3.fromRGB" },
		HSV = { "HSV", "Color3.fromHSV" },
		FULL = { "Full", "Color3.new" },
	},
	UDim2Format = {
		SMART = { "Smart", "" },
		FULL = { "Full", "UDim2.new" },
	},
	EnumFormat = {
		FULL = { "Full", "Enum.ScaleType.Fit" },
		NUMBER = { "Number", "3" },
		STRING = { "String", '"Fit"' },
	},
	NamingScheme = {
		ALL = { "All", "frame, textButton" },
		NONE = { "None", "" },
		CHANGED = { "Changed", "myButton" },
	},
}

function Store.IncrementEnum(enum: string)
	local state = Store:GetState()
	local currentFormat = state.Settings[enum]

	local enumKeys = Llama.Dictionary.keys(Store.Enum[enum])
	local currentIndex = table.find(enumKeys, currentFormat)
	local newIndex = currentIndex + 1

	if newIndex > #enumKeys then
		newIndex = 1
	end

	Store:SetState({
		Settings = {
			[enum] = enumKeys[newIndex],
		},
	})
end

function Store.useStore(hooks)
	local state, setState = hooks.useState(Store:GetState())

	hooks.useEffect(function()
		local connection = Store.Changed:Connect(function()
			setState(Store:GetState())
		end)

		return function()
			connection:Disconnect()
		end
	end, {})

	return state
end

Store.Actions = {
	GenerateSnippet = Instance.new("BindableEvent"),
	SaveSnippet = Instance.new("BindableEvent"),
}

return Store
