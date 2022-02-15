local Plugin = script.Parent.Parent

local Config = require(Plugin.Data.Config)
local Actions = require(Plugin.Actions)

local Manager = {}
Manager.__index = Manager

function Manager.new(plugin: Plugin, store)
	local self = setmetatable({}, Manager)

	self.plugin = plugin
	self.store = store
	self.key = "0e9eb429"
	self.version = Config.version

	self:RestoreSettings()

	self.store.changed:connect(function(state, oldState)
		if state.userSettings ~= oldState.userSettings then
			self:SaveSettings()
		end
	end)

	return self
end

function Manager:SaveSettings()
	local state = self.store:getState()

	self.plugin:SetSetting(self.key, {
		version = self.version,
		settings = state.userSettings,
	})
end

function Manager:RestoreSettings()
	local savedSettings = self.plugin:GetSetting(self.key)

	if not (type(savedSettings) == "table" and savedSettings.settings) then
		return
	end

	for key, value in pairs(savedSettings.settings) do
		self.store:dispatch(Actions.SetSetting({
			key = key,
			value = value,
		}))
	end
end

return Manager
