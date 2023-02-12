--!strict
export type SettingConfig = {
	name: string,
	description: string,
} & ({
	type: "boolean",
	default: boolean,
} | {
	type: "number",
	default: number,
	validate: ((value: number, setting: Setting) -> boolean)?,
} | {
	type: "string",
	default: string,
	validate: ((value: string, setting: Setting) -> boolean)?,
} | {
	type: "enum",
	default: string,
	options: { [string]: { name: string, description: string, value: any } },
})

export type Setting = {
	Name: string,
	Description: string,
	Type: "boolean" | "number" | "string" | "enum",
	Default: any,
	Validate: ((value: any, setting: Setting) -> boolean)?,
	Options: { [string]: { Name: string, Description: string, Value: any } }?,
}

return function(config: SettingConfig): Setting
	local options = nil

	if config.type == "enum" then
		options = {}

		for key, option in pairs(config.options) do
			options[key] = {
				Name = option.name,
				Description = option.description,
				Value = option.value,
			}
		end
	end

	return {
		Name = config.name,
		Description = config.description,
		Type = config.type,
		Default = config.default,
		Options = options,
	}
end
