--!strict
local Packages = script.Parent.Parent.Parent.Packages

local Sift = require(Packages.Sift)

local SafeNamer = {}

SafeNamer.RESERVED_WORDS = {
	LUAU = require(script.ReservedWords.Luau),
	TYPESCRIPT = require(script.ReservedWords.TypeScript),
}

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

local function trimString(str: string, char: string?): string
	local removeChar = char or "%s"
	local trimmed = str:gsub(`^{removeChar}*(.-){removeChar}*$`, "%1")

	return trimmed
end

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

return SafeNamer
