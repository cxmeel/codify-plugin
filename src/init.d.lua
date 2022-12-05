--!strict
local React = require(script.Parent.Packages.React)

export type ReactChildren = typeof(React.Children)

export type PropsWithChildren<T> = {
	[ReactChildren]: ReactChildren?,
} & T

return {}
