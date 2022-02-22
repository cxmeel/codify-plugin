export type IOptions = {
	isDevMode: boolean?,
	build: string?,
}

return function(options: IOptions)
	return {
		type = "SET_PLUGIN_METADATA",
		payload = options,
	}
end
