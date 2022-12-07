--!strict
--[[
	Based on StyledComponents/ThemeProvider.
	License: MIT

	https://github.com/styled-components/styled-components/blob/457192969a1086547d80390a2445f5a23dba3765/packages/styled-components/src/models/ThemeProvider.tsx
]]
local T = require(script.Parent.Parent["init.d"])
local React = require(script.Parent.Parent.Packages.React)
local Sift = require(script.Parent.Parent.Packages.Sift)

local useContext, useMemo = React.useContext, React.useMemo

export type DefaultTheme = {
	[string]: any,
}

type ThemeFunction = (outerTheme: DefaultTheme?) -> DefaultTheme
type ThemeArgument = DefaultTheme | ThemeFunction

type Props = T.PropsWithChildren<{
	theme: ThemeArgument,
}>

local ThemeContext = React.createContext(nil)
local ThemeConsumer = ThemeContext.Consumer

local ERRORS = {
	[7] = "ThemeProvider: Please return an object from your theme function.",
	[8] = 'ThemeProvider: Please make your "theme" prop an object.',
	[14] = 'ThemeProvider: "theme" prop is required.',
}

local function mergeTheme(theme: ThemeArgument, outerTheme: DefaultTheme?): DefaultTheme
	if not theme then
		error(ERRORS[14], 2)
	end

	if typeof(theme) == "function" then
		local mergedTheme = theme(outerTheme)

		if mergedTheme == nil or Sift.Array.is(mergedTheme) or typeof(mergedTheme) ~= "table" then
			error(ERRORS[7], 2)
		end

		return mergedTheme
	end

	if Sift.Array.is(theme) or typeof(theme) ~= "table" then
		error(ERRORS[8], 2)
	end

	return outerTheme and Sift.Dictionary.merge(outerTheme, theme) or theme
end

local function ThemeProvider(props: Props)
	local outerTheme = useContext(ThemeContext)

	local themeContext = useMemo(function()
		return mergeTheme(props.theme, outerTheme)
	end, { props.theme, outerTheme })

	if not props[React.Children] then
		return nil
	end

	return React.createElement(ThemeContext.Provider, {
		value = themeContext,
	}, props[React.Children])
end

local function useTheme()
	return useContext(ThemeContext)
end

return {
	ThemeContext = ThemeContext,
	ThemeProvider = ThemeProvider,
	ThemeConsumer = ThemeConsumer,

	useTheme = useTheme,
}
