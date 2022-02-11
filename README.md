<!-- Links -->
[repo/homepage]: https://github.com/csqrl/roactify-plugin
[repo/releases]: https://github.com/csqrl/roactify-plugin/releases

[plugin/toolbox]: https://roblox.com/library/4749111907

[devhub/managing-plugins]: https://developer.roblox.com/en-us/articles/Intro-to-Plugins#finding-and-managing-plugins

[roact/repo]: https://github.com/roblox/roact
[fusion/repo]: https://github.com/elttob/fusion

<!-- Images -->
[image/cover]: assets/Cover.png
[image/demo-gif]: assets/Demo.gif
[image/plugin-screenshots]: assets/PluginScreenshots.png

<div align="center">

[![Cover][image/cover]][plugin/toolbox]

✨ Stop writing render code and start designing your components visually!

[📦 Source Code][repo/homepage] | [⏩ Install Codify *(formerly Roactify)*][plugin/toolbox]

</div>

Codify is a collaborative project between @boatbomber and @csqrl, which converts your pre-existing GUI objects into code.

Whether you work with vanilla Instances, or use a framework like [Roact][roact/repo] or [Fusion][fusion/repo], Codify has you covered!
# Installation
## Plugin Marketplace

The simplest way to install Codify is to install it from the plugin marketplace. This gives you access to the latest version of the plugin, and easy updates via the [Plugin Management][devhub/managing-plugins] window.

- [Install Codify &rarr;][plugin/toolbox]

## Manual Installation

Codify is an open-source plugin. New releases are automatically published to both the Roblox plugin marketplace and GitHub releases. If you'd rather install the plugin manually, download the latest binary (`.rbxm` or `.rbxmx`) from the [releases page][repo/releases], and drop it into your Studio plugins directory.

# Overview of Permissions

## HTTP Requests
Codify uses HTTP requests to fetch the latest information about Roblox Instances. This is **required** to enable core plugin functionality, as this is not possible without access to API dumps.

Below is a list of URLs used by Codify *(all requests are unauthenticated)*:

- https://s3.amazonaws.com/setup.roblox.com/versionQTStudio
- https://s3.amazonaws.com/setup.roblox.com/{{version-hash}}-API-Dump.json
- https://api.github.com/repos/csqrl/roactify-plugin/contributors?anon=1

## Script Injection
This is a completely optional permission and will not degrade functionality if disabled. You will only be prompted for this permission when selecting the **Save to Device** button.

This is necessary to the Save to Device feature only. The plugin will *temporarily* create a ModuleScript inside of ServerStorage that will be used to prompt to save a file to your device. The ModuleScript will be **destroyed immediately** after closing the save dialogue.

- Temporary scripts are also unarchivable (`.Archivable` property set to `false`). This means that they will not be saved when (auto-)saving your project, or saving/publishing to Roblox.

# Screenshots

![GIF Demoing Plugin][image/demo-gif]

![Screenshot of the Plugin][image/plugin-screenshots]

## Disclaimer
The code Codify produces is not 100% perfect. You should consider that the snippets produced are not optimal, but that shouldn't put you off using it!
