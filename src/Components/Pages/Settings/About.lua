local Plugin = script.Parent.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Config = require(Plugin.Data.Config)
local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type AboutProps = {
	order: number?,
}

local function About(props: AboutProps)
	return e(Layout.Forms.Section, {
		heading = "About",
		divider = true,
		order = props.order,
	}, {
		version = e(Layout.Forms.Section, {
			heading = "Version",
			hint = Config.version,
			formItem = true,
			order = 10,
		}),
	})
end

return About
