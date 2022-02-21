local Plugin = script.Parent.Parent.Parent.Parent

local RoduxHooks = require(Plugin.Packages.RoduxHooks)
local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.Hooks)

local Config = require(Plugin.Data.Config)
local Thunks = require(Plugin.Thunks)

local Layout = require(Plugin.Components.Layout)

local e = Roact.createElement

export type AboutProps = {
	order: number?,
}

local function About(props: AboutProps, hooks)
	local dispatch = RoduxHooks.useDispatch(hooks)

	local attribution = RoduxHooks.useSelector(hooks, function(state)
		return state.attribution
	end)

	hooks.useEffect(function()
		dispatch(Thunks.FetchAuthors())
		dispatch(Thunks.FetchContributors(Config.repo))
	end, {})

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

		author = #attribution.authors > 0 and e(Layout.Forms.Section, {
			heading = "Authors",
			hint = table.concat(attribution.authors, ", "),
			formItem = true,
			order = 20,
		}),

		contributors = #attribution.contributors > 0 and e(Layout.Forms.Section, {
			heading = "Contributors",
			hint = table.concat(attribution.contributors, ", "),
			formItem = true,
			order = 30,
		}),
	})
end

return Hooks.new(Roact)(About)
