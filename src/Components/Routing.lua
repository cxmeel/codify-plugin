local Packages = script.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local StudioTheme = require(Packages.StudioTheme)
local RoactRouter = require(Packages.RoactRouter)
local Hooks = require(Packages.Hooks)

local Navigation = require(script.Parent.Navigation)
local Pages = require(script.Parent.Pages)

local e = Roact.createElement

local function Routing(_, hooks)
	local theme = StudioTheme.useTheme(hooks)

	return e("Frame", {
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		router = e(RoactRouter.Router, {}, {
			navigationTabs = e(Navigation.Container, nil, {
				home = e(Navigation.Tab, {
					label = "Codify",
					icon = "Brand",
					order = 10,
					location = "/",
				}),

				settings = e(Navigation.Tab, {
					label = "Settings",
					icon = "Settings",
					order = 20,
					location = "/settings",
				}),
			}),

			content = e("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 36),
				Size = UDim2.new(1, 0, 1, -36),
			}, {
				home = e(RoactRouter.Route, {
					path = "/",
					exact = true,
					component = Pages.Home,
					alwaysRender = true,
				}),

				settings = e(RoactRouter.Route, {
					path = "/settings",
					exact = true,
					component = Pages.Settings,
					alwaysRender = true,
				}),
			}),
		}),
	})
end

return Hooks.new(Roact)(Routing)
