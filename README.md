<!-- Links -->

[repo/homepage]: https://github.com/csqrl/roactify-plugin
[repo/releases]: https://github.com/csqrl/roactify-plugin/releases
[repo/contributors]: https://github.com/csqrl/roactify-plugin/graphs/contributors
[plugin/toolbox]: https://roblox.com/library/4749111907
[devhub/managing-plugins]: https://developer.roblox.com/en-us/articles/Intro-to-Plugins#finding-and-managing-plugins
[roact/repo]: https://github.com/roblox/roact
[fusion/repo]: https://github.com/elttob/fusion
[csqrl/github]: https://github.com/csqrl
[boatbomber/github]: https://github.com/boatbomber
[boatbomber/site]: https://www.boatbomber.com
[boatbomber/site/donate]: https://www.boatbomber.com/#h.aiqhaejpfy6p

<!-- Images -->

[image/cover]: assets/Cover.png
[image/demo-gif]: assets/Demo.gif
[image/plugin-screenshots]: assets/PluginScreenshots.png

<div align="center">

[![Cover][image/cover]][plugin/toolbox]

✨ Design UI in Studio; convert it to code!

[📦 Source Code][repo/homepage] | [⏩ Install Codify][plugin/toolbox]

</div>

Codify _(formerly Roactify)_ is a collaborative project between [@boatbomber][boatbomber/github] and [@csqrl][csqrl/github], which converts your pre-existing GUI objects into code.

Whether you work with vanilla Instances, or use a framework like [Roact][roact/repo] or [Fusion][fusion/repo], Codify has you covered!

# Installation

Codify is 100% free to download, but if you like this plugin, please **consider sponsoring** via the "Sponsor this project" panel!

> This project wouldn't have been possible without the help of [@boatbomber][boatbomber/github] and our [other contributors][repo/contributors]. If you'd like to show your support for [@boatbomber][boatbomber/github] too, follow the link below to find out how!
>
> [Learn more &rarr;][boatbomber/site/donate]

## itch.io

_Coming soon!_

## Plugin Marketplace

The simplest way to install Codify is to install it from the plugin marketplace. This gives you access to the latest version of the plugin, and easy updates via the [Plugin Management][devhub/managing-plugins] window.

- [Install Codify &rarr;][plugin/toolbox]

## Manual Installation

Codify is an open-source plugin. New releases are automatically published to both the Roblox plugin marketplace and GitHub releases. If you'd rather install the plugin manually, download the latest binary (`.rbxm` or `.rbxmx`) from the [releases page][repo/releases], and drop it into your Studio plugins directory.

# Overview of Permissions

## HTTP Requests

Codify uses HTTP requests to fetch the latest information about Roblox Instances. This is **required** to enable core plugin functionality, as this is not possible without access to API dumps.

Below is a list of URLs used by Codify _(all requests are unauthenticated)_:

- https://s3.amazonaws.com/setup.roblox.com/versionQTStudio
- https://s3.amazonaws.com/setup.roblox.com/{{version-hash}}-API-Dump.json
- https://api.github.com/repos/csqrl/roactify-plugin/contributors?anon=1

## Script Injection

This is a completely optional permission and will not degrade functionality if disabled. You will only be prompted for this permission when selecting the **Save to Device** button.

This is necessary to the Save to Device feature only. The plugin will _temporarily_ create a ModuleScript inside of ServerStorage that will be used to prompt to save a file to your device. The ModuleScript will be **destroyed immediately** after closing the save dialogue.

- Temporary scripts are also unarchivable (`.Archivable` property set to `false`). This means that they will not be saved when (auto-)saving your project, or saving/publishing to Roblox.

# Screenshots

![GIF Demoing Plugin][image/demo-gif]

![Screenshot of the Plugin][image/plugin-screenshots]

## Open Source Projects

The following open-source projects helped to make Codify possible!

- [highlighter](https://github.com/boatbomber/Highlighter/tree/v0.4.5) by @boatbomber
- [studio-plugin](https://github.com/csqrl/studio-plugin/tree/1.0.1) by @csqrl
- [studio-theme](https://github.com/csqrl/studio-theme/tree/1.0.2) by @csqrl
- [roblox-lua-promise](https://github.com/evaera/roblox-lua-promise/tree/v3.2.1) by @evaera
- [llama](https://github.com/freddylist/llama/tree/v1.1.1) by @freddylist
- [roact-hooks](https://github.com/Kampfkarren/roact-hooks/tree/0.3.0) by @kampfkarren
- [roact-router](https://github.com/Reselim/roact-router/tree/v1.0.0) by @reselim
- [roact](https://github.com/Roblox/roact/tree/v1.4.2) by @roblox
- [rodux](https://github.com/Roblox/rodux/tree/v3.0.0) by @roblox
- [rodux-hooks](https://github.com/SolarHorizon/rodux-hooks/tree/0.2.1) by @solarhorizon

## Disclaimer

The code Codify produces is not 100% perfect. You should consider that the snippets produced are not optimal, but that shouldn't put you off using it!
