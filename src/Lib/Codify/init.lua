--!strict
local Packages = script.Parent.Parent.Packages

local DumpParser = require(Packages.DumpParser)
local Packager = require(Packages.Packager)

local Codify = {}

Codify.__index = Codify

function Codify.new(apiDump: any)
	local self = setmetatable({}, Codify)

	self.dump = DumpParser.new(apiDump)
	self.packager = Packager.new(self.dump)

	return self
end

function Codify:GenerateSnippet()
	-- Step 1: Generate flat package
	-- Step 2: Generate safe variable names
	-- Step 3: Convert to tree package
	-- Step 4: Generate code (pass to generator)
	--   Step 4.1: Create root Instance
	--   Step 4.2: Serialise and assign properties
	--   Step 4.3: Assign attributes (if enabled)
	--   Step 4.4: Assign tags (if enabled)
	--   Step 4.5: Repeat for children
	--   Step 4.6: Assign Parent property
	-- Step 5: Return code
end

return Codify
