local Frameworks = {}

for _, child in ipairs(script:GetChildren()) do
	if child:IsA("ModuleScript") then
		Frameworks[child.Name] = require(child)
	end
end

return Frameworks