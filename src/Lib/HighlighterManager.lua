local Studio = settings():GetService("Studio") :: Studio
local Plugin = script.Parent.Parent

local Highlighter = require(Plugin.Packages.Highlighter)

local Manager = {}
Manager.__index = Manager

function Manager.new(plugin: Plugin)
	local self = setmetatable({}, Manager)

	self.plugin = plugin
	self.highlighter = Highlighter

	self:UpdateColorScheme()

	Studio.ThemeChanged:Connect(function()
		self:UpdateColorScheme()
	end)

	return self
end

function Manager:UpdateColorScheme()
	local theme = Studio.Theme :: StudioTheme

	self.highlighter.setTokenColors({
		background = theme:GetColor(Enum.StudioStyleGuideColor.ScriptBackground),
		iden = theme:GetColor(Enum.StudioStyleGuideColor.ScriptText),
		keyword = theme:GetColor(Enum.StudioStyleGuideColor.ScriptKeyword),
		builtin = theme:GetColor(Enum.StudioStyleGuideColor.ScriptBuiltInFunction),
		string = theme:GetColor(Enum.StudioStyleGuideColor.ScriptString),
		number = theme:GetColor(Enum.StudioStyleGuideColor.ScriptNumber),
		comment = theme:GetColor(Enum.StudioStyleGuideColor.ScriptComment),
		operator = theme:GetColor(Enum.StudioStyleGuideColor.ScriptOperator),
	})
end

return Manager
