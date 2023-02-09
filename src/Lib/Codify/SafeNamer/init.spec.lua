--!strict
local SafeNamer = require(script.Parent)

local TEST_STRINGS = {
	["hello"] = "hello",
	["hello world"] = "hello_world",
	["hello world!"] = "hello_world",
	["contains\nnewline"] = "contains_newline",
	["contains\ttab"] = "contains_tab",
	["_____has___underscores__"] = "has_underscores",
	["has an em🤯oji"] = "has_an_em_oji",
	["123 starts with number"] = "var_123_starts_with_number",
	["then"] = "var_then",
	["continue"] = "var_continue",
	[""] = "undefined",
	["_"] = "undefined",
}

local TEST_ESCAPES = {
	["hello\nworld"] = "hello\\nworld",
	["hello\tworld"] = "hello\\tworld",
	['"hello" world'] = '\\"hello\\" world',
}

return function()
	it("should sanitize a string for use as a variable name", function()
		for input, expected in TEST_STRINGS do
			expect(SafeNamer.Sanitize(input)).to.equal(expected)
		end
	end)

	it("should escape a string for use within a non-multiline string", function()
		for input, expected in TEST_ESCAPES do
			expect(SafeNamer.EscapeString(input)).to.equal(expected)
		end
	end)
end
