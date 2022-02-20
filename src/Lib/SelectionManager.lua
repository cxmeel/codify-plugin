local Selection = game:GetService("Selection")

export type SelectionManagerOptions = {
	classFilter: { string | (Instance) -> boolean }?,
}

local Manager = {}
Manager.__index = Manager

function Manager.new(plugin: Plugin, options: SelectionManagerOptions?)
	local self = setmetatable({}, Manager)
	local config = options or {}

	self._changeEvent = Instance.new("BindableEvent")
	self.Changed = self._changeEvent.Event

	self.plugin = plugin
	self.classFilter = config.classFilter or {}

	Selection.SelectionChanged:Connect(function()
		local selection = self:GetCurrentSelection()
		self._changeEvent:Fire(selection)
	end)

	return self
end

function Manager:GetCurrentSelection(): Instance?
	local ok, selection = pcall(function()
		local selection = Selection:Get()[1]

		if not selection then
			return
		end

		if #self.classFilter == 0 then
			return selection
		end

		local passesChecks = true

		for _, class in ipairs(self.classFilter) do
			if type(class) == "function" then
				passesChecks = class(selection)
			elseif type(class) == "string" then
				passesChecks = selection:IsA(class)
			end
		end

		if passesChecks then
			return selection
		end
	end)

	return if ok then selection else nil
end

return Manager
