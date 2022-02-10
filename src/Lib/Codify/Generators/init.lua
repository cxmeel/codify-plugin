local Handlers = {}

for _, child in ipairs(script:GetChildren()) do
	if child:IsA("ModuleScript") then
		Handlers[child.Name] = require(child)
	end
end

return Handlers