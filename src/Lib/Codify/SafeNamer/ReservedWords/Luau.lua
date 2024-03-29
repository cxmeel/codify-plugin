--!strict
--[[
	A list of reserved words in Luau. This includes keywords,
	Lua globals, Roblox globals, and libraries.
]]
return {
	-- Keywords
	"and",
	"break",
	"continue",
	"do",
	"else",
	"elseif",
	"end",
	"false",
	"for",
	"function",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"true",
	"until",
	"while",

	-- Lua Globals
	"assert",
	"collectgarbage",
	"error",
	"getfenv",
	"getmetatable",
	"ipairs",
	"loadstring",
	"newproxy",
	"next",
	"pairs",
	"pcall",
	"print",
	"rawequal",
	"rawget",
	"rawset",
	"select",
	"setfenv",
	"setmetatable",
	"tonumber",
	"tostring",
	"type",
	"unpack",
	"xpcall",
	"_G",
	"_VERSION",

	-- Roblox Globals
	"delay",
	"DebuggerManager",
	"elapsedTime",
	"gcinfo",
	"PluginManager",
	"printidentity",
	"require",
	"settings",
	"spawn",
	"stats",
	"tick",
	"time",
	"typeof",
	"UserSettings",
	"version",
	"wait",
	"warn",
	"Enum",
	"game",
	"plugin",
	"shared",
	"script",
	"workspace",

	-- Libraries
	"bit32",
	"coroutine",
	"debug",
	"math",
	"os",
	"string",
	"table",
	"task",
	"utf8",
} :: { string }
