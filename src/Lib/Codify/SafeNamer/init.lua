--!strict
local Packages = script.Parent.Parent.Parent.Packages

local Sift = require(Packages.Sift)

--[=[
	@class SafeNamer
]=]
local SafeNamer = {}

--[=[
	@prop RESERVED_WORDS { [string]: { string } }
	@within SafeNamer

	Contains a list of reserved words for various languages.
	These words will be prefixed with the variable prefix when sanitizing
	to prevent conflicts with the language's reserved words.
]=]
SafeNamer.RESERVED_WORDS = {
	LUAU = require(script.ReservedWords.Luau),
	TYPESCRIPT = require(script.ReservedWords.TypeScript),
}

--[=[
	@interface SanitizeOptions
	@within SafeNamer
	.reservedWords { string }? -- A list of reserved words to check against
	.variablePrefix string? -- The prefix to use when an invalid variable name is generated
	.separator string? -- The separator to use when replacing invalid characters
	.unknownName string? -- The name to use when sanitizing an empty string

	Default values:
	```lua
	{
		reservedWords = SafeNamer.RESERVED_WORDS.LUAU,
		variablePrefix = "var",
		separator = "_",
		unknownName = "unknown",
	}
	```
]=]
export type SanitizeOptions = {
	reservedWords: { string }?,
	variablePrefix: string?,
	separator: string?,
	unknownName: string?,
}

local DEFAULT_SANITIZE_OPTIONS: SanitizeOptions = {
	reservedWords = SafeNamer.RESERVED_WORDS.LUAU,
	variablePrefix = "var",
	separator = "_",
	unknownName = "unknown",
}

--[=[
	@interface EscapeOptions
	@within SafeNamer
	.singleQuote boolean? -- Whether to escape single quotes instead of double quotes
	.unicodeEscape boolean? -- Whether to escape with unicode instead of byte escape sequences

	Default values:
	```lua
	{
		singleQuote = false,
		unicodeEscape = false,
	}
	```
]=]
export type EscapeOptions = {
	singleQuote: boolean?,
	unicodeEscape: boolean?,
}

local DEFAULT_ESCAPE_OPTIONS: EscapeOptions = {
	singleQuote = false,
	unicodeEscape = false,
}

local ESCAPE_SEQUENCES = {
	["\a"] = "\\a",
	["\b"] = "\\b",
	["\f"] = "\\f",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\t"] = "\\t",
	["\v"] = "\\v",
	["\\"] = "\\\\",
	["\0"] = "\\0",
}

local function trimString(str: string, char: string?): string
	local removeChar = char or "%s"
	local trimmed = str:gsub(`^{removeChar}*(.-){removeChar}*$`, "%1")

	return trimmed
end

--[=[
	@function Sanitize
	@within SafeNamer

	@param word string -- The string to sanitize
	@param options SanitizeOptions? -- The options to use when sanitizing
	@return string

	Sanitizes a string to be a valid variable name.
]=]
function SafeNamer.Sanitize(word: string, options: SanitizeOptions?)
	local opt = Sift.Dictionary.merge(DEFAULT_SANITIZE_OPTIONS, options)
	local newWord = trimString(word):gsub("%W", opt.separator)

	if table.find(opt.reservedWords, newWord) then
		newWord = `{opt.variablePrefix}{opt.separator}{newWord}`
	end

	if newWord:match("^%d") then
		newWord = `{opt.variablePrefix}{opt.separator}{newWord}`
	end

	newWord = trimString(newWord:gsub(`{opt.separator}+`, opt.separator), opt.separator)

	if #newWord == 0 then
		newWord = `{opt.variablePrefix}{opt.separator}{opt.unknownName}`
	end

	return newWord
end

--[=[
	@function SanitizeMultiple
	@within SafeNamer

	@param words { string } -- The strings to sanitize
	@param options SanitizeOptions? -- The options to use when sanitizing
	@return { string }

	Sanitizes a list of strings to be valid variable names.
]=]
function SafeNamer.SanitizeMultiple(words: { string }, options: SanitizeOptions?)
	local opt = Sift.Dictionary.merge(DEFAULT_SANITIZE_OPTIONS, options)
	local newWords: { string } = {}
	local WORD_STACK = {}

	for _, word in words do
		local newWord = SafeNamer.Sanitize(word, options)
		WORD_STACK[newWord] = -1
	end

	for index, word in words do
		local newWord = SafeNamer.Sanitize(word, options)
		local increment = WORD_STACK[newWord] + 1

		WORD_STACK[newWord] = increment

		if increment > 0 then
			local clashes = false
			local targetWord: string

			repeat
				targetWord = (`{newWord}{opt.separator}{increment}`):gsub(`{opt.separator}+`, opt.separator)
				clashes = WORD_STACK[targetWord] ~= nil

				if clashes then
					increment += 1
					WORD_STACK[newWord] = increment
				end
			until not clashes

			newWord = targetWord
		end

		newWords[index] = newWord
	end

	return newWords
end

--[=[
	@function EscapeString
	@within SafeNamer

	@param input string -- The string to escape
	@return string

	Converts a string to a valid Lua string literal, i.e.
	replaces control characters with their escape sequences.

	```lua
	SafeNamer.EscapeString([[Hello
	World]])) -- "Hello\nWorld"
	SafeNamer.EscapeString("Hello    world!") -- "Hello\tworld!"
	```
]=]
function SafeNamer.EscapeString(input: string, options: EscapeOptions?): string
	local opt = Sift.Dictionary.merge(DEFAULT_ESCAPE_OPTIONS, options)
	local quote = opt.singleQuote and "'" or '"'

	local escaped = input:gsub("[%c%p%z]", function(char)
		if char:match("%p") then
			if char == quote then
				return `\\{char}`
			end

			return ESCAPE_SEQUENCES[char] or char
		end

		if ESCAPE_SEQUENCES[char] then
			return ESCAPE_SEQUENCES[char]
		end

		if opt.unicodeEscape then
			return ("\\u{%d}"):format(utf8.codepoint(char))
		end

		return `\\{string.byte(char)}`
	end)

	return escaped
end

return SafeNamer
