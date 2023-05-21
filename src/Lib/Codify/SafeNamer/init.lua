--!strict
local Packages = script.Parent.Parent.Parent.Packages

local Sift = require(Packages.Sift)
local Array, Dictionary = Sift.Array, Sift.Dictionary

--[=[
	@class SafeNamer
]=]
local SafeNamer = {}

--[=[
	@type CasingFormat "PASCAL_CASE" | "CAMEL_CASE" | "UPPERCASE" | "LOWERCASE"
	@within SafeNamer

	An enum of casing formats.
]=]
export type CasingFormat = "PASCAL_CASE" | "CAMEL_CASE" | "UPPERCASE" | "LOWERCASE"

--[=[
	@interface FormatCaseOptions
	@within SafeNamer
	.case CasingFormat? -- The casing format to use
	.separator string? -- The separator between words

	Default values:
	```lua
	{
		case = "LOWERCASE",
		separator = "_",
		variablePrefix = "var",
	}
	```
]=]
export type FormatCaseOptions = {
	case: CasingFormat?,
	separator: string?,
	variablePrefix: string?,
	prefixSeparator: string?,
}

--[=[
	@interface SanitizeOptions
	@within SafeNamer
	.reservedWords { string }? -- A list of reserved words to check against
	.variablePrefix string? -- The prefix to use when an invalid variable name is generated
	.separator string? -- The separator to use when replacing invalid characters
	.unknownName string? -- The name to use when sanitizing an empty string

	Extends [FormatCaseOptions](#FormatCaseOptions).

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
export type SanitizeOptions = FormatCaseOptions & {
	reservedWords: { string }?,
	variablePrefix: string?,
	prefixSeparator: string?,
	separator: string?,
	unknownName: string?,
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

--[=[
	@prop RESERVED_WORDS { [string]: { string } }
	@within SafeNamer

	Contains a list of reserved words for various languages.
	These words will be prefixed with the variable prefix when sanitizing
	to prevent conflicts with the language's reserved words.
]=]
SafeNamer.RESERVED_WORDS = table.freeze({
	LUAU = require(script.ReservedWords.Luau),
})

--[=[
	@prop CASE { [string]: CasingFormat }
	@within SafeNamer

	An enum of casing formats for ease of use.
]=]
SafeNamer.CASE = table.freeze({
	PASCAL_CASE = "PASCAL_CASE",
	CAMEL_CASE = "CAMEL_CASE",
	UPPERCASE = "UPPERCASE",
	LOWERCASE = "LOWERCASE",
})

local DEFAULT_FORMAT_CASE_OPTIONS: FormatCaseOptions = {
	case = "CAMEL_CASE",
	separator = "",
	variablePrefix = "var",
	prefixSeparator = "_",
}

local DEFAULT_SANITIZE_OPTIONS: SanitizeOptions = Dictionary.merge(DEFAULT_FORMAT_CASE_OPTIONS, {
	reservedWords = SafeNamer.RESERVED_WORDS.LUAU,
	unknownName = "unknown",
})

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

--[[
	@function trimString
	@private
	@param str string -- The string to trim
	@param char string? -- The character to trim
	@return string
]]
local function trimString(str: string, char: string?): string
	local removeChar = char or "%s"
	local trimmed = str:gsub(`^{removeChar}*(.-){removeChar}*$`, "%1")

	return trimmed
end

--[=[
	@function FormatCase
	@within SafeNamer

	@param input string -- The string to format
	@param options FormatCaseOptions? -- The options to use when formatting
	@return string

	Formats a string to a specific casing format.

	```lua
	SafeNamer.FormatCase("hello_world", {
		case = "PASCAL_CASE",
	}) -- "Hello_World"

	SafeNamer.FormatCase("hello_world", {
		case = "CAMEL_CASE",
	}) -- "hello_World"
	```
]=]
function SafeNamer.FormatCase(input: string, options: FormatCaseOptions?)
	local opt: FormatCaseOptions = Dictionary.merge(DEFAULT_FORMAT_CASE_OPTIONS, options)
	local separator = opt.separator ~= "" and opt.separator or "\0"
	local newSeparator = opt.separator ~= "" and opt.separator or ""

	local words = input:split(separator)
	local prefix: string?

	if words[1] == opt.variablePrefix then
		prefix = table.remove(words, 1)
	end

	-- split the words array further at any uppercase characters followed by at least one lowercase character
	if opt.case == "CAMEL_CASE" or opt.case == "PASCAL_CASE" then
		words = Array.reduce(words, function(acc, word)
			if word:match("%u%l+") then
				for splitWord in word:gmatch("%u%l*") do
					table.insert(acc, splitWord)
				end
			else
				table.insert(acc, word)
			end

			return acc
		end, {})
	end

	local newWords = Array.map(words, function(word: string, index)
		if opt.case == "UPPERCASE" then
			return word:upper()
		elseif opt.case == "LOWERCASE" or (opt.case == "CAMEL_CASE" and index == 1) then
			return word:lower()
		elseif opt.case == "PASCAL_CASE" or opt.case == "CAMEL_CASE" then
			return `{word:sub(1, 1):upper()}{word:sub(2):lower()}`
		end

		return nil
	end)

	if prefix ~= nil then
		table.insert(newWords, 1, `{prefix}{opt.prefixSeparator}`)
	end

	return table.concat(newWords, newSeparator)
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
	local opt = Dictionary.merge(DEFAULT_SANITIZE_OPTIONS, options)
	local separator = opt.separator ~= "" and opt.separator or "\0"

	local newWord = trimString(word):gsub("'", ""):gsub("%W", separator)

	if table.find(opt.reservedWords, newWord) then
		newWord = `{opt.variablePrefix}{opt.prefixSeparator}{newWord}`
	end

	if newWord:match("^%d") then
		newWord = `{opt.variablePrefix}{opt.prefixSeparator}{newWord}`
	end

	newWord = trimString(newWord:gsub(`{separator}+`, separator), separator)

	if #newWord == 0 then
		newWord = `{opt.variablePrefix}{opt.prefixSeparator}{opt.unknownName}`
	end

	return SafeNamer.FormatCase(newWord, opt)
end

--[=[
	@function SanitizeMultiple
	@within SafeNamer

	@param words { string } -- The strings to sanitize
	@param options SanitizeOptions? -- The options to use when sanitizing
	@return { string }

	Sanitizes a list of strings to be valid variable names.
]=]
function SafeNamer.SanitizeMultiple(words: { [any]: string }, options: SanitizeOptions?)
	local opt = Dictionary.merge(DEFAULT_SANITIZE_OPTIONS, options)
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
	local opt = Dictionary.merge(DEFAULT_ESCAPE_OPTIONS, options)
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
