export type SetSettingsEnumPayload = {
	key: string,
	value: any,
}

return function(payload: SetSettingsEnumPayload)
	return {
		type = "SET_SETTING",
		payload = payload,
	}
end
