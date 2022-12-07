--!strict
--[[
	Based on StyledComponents/StylesProvider.
	License: MIT

	https://github.com/styled-components/styled-components/blob/457192969a1086547d80390a2445f5a23dba3765/packages/styled-components/src/models/StylesProvider.tsx
]]
local T = require(script.Parent.Parent["init.d"])
local React = require(script.Parent.Parent.Packages.React)
local Sift = require(script.Parent.Parent.Packages.Sift)

local useContext, useMemo = React.useContext, React.useMemo

export type DefaultStyles = {
	[string]: any,
}

type StylesFunction = (outerStyles: DefaultStyles?) -> DefaultStyles
type StylesArgument = DefaultStyles | StylesFunction

type Props = T.PropsWithChildren<{
	styles: StylesArgument,
}>

local StylesContext = React.createContext(nil)
local StylesConsumer = StylesContext.Consumer

local ERRORS = {
	[7] = "StylesProvider: Please return an object from your styles function.",
	[8] = 'StylesProvider: Please make your "styles" prop an object.',
	[14] = 'StylesProvider: "styles" prop is required.',
}

local function isDictionary(value: any): boolean
	return typeof(value) == "table" and not Sift.Array.is(value)
end

local function mergeStyles(styles: StylesArgument, outerStyles: DefaultStyles?): DefaultStyles
	if not styles then
		error(ERRORS[14], 2)
	end

	if typeof(styles) == "function" then
		local mergedStyles = styles(outerStyles)

		if mergedStyles == nil or not isDictionary(mergedStyles) then
			error(ERRORS[7], 2)
		end

		return mergedStyles
	end

	if not isDictionary(styles) then
		error(ERRORS[8], 2)
	end

	return outerStyles and Sift.Dictionary.merge(outerStyles, styles) or styles
end

local function useStyles()
	return useContext(StylesContext)
end

local function StylesProvider(props: Props)
	local outerStyles = useStyles()

	local stylesContext = useMemo(function()
		return mergeStyles(props.styles, outerStyles)
	end, { props.styles, outerStyles })

	if not props[React.Children] then
		return nil
	end

	return React.createElement(StylesContext.Provider, {
		value = stylesContext,
	}, props[React.Children])
end

return {
	StylesContext = StylesContext,
	StylesProvider = StylesProvider,
	StylesConsumer = StylesConsumer,

	useStyles = useStyles,
}
