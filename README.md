<!-- Links -->
[plugin]: https://create.roblox.com/marketplace/asset/4749111907
[itch]: https://csqrl.itch.io/codify
[repo]: https://github.com/csqrl/codify-plugin
[issues]: https://github.com/csqrl/codify-plugin/issues
[rojo]: https://rojo.space
[devforum-thread]: https://devforum.roblox.com/t/473076
[devforum-dm]: https://devforum.roblox.com/new-message?username=csqrl&title=%5BCodify%5D%20Bug%20Report
[twitter]: https://twitter.com/csqrI
[yt-demo]: https://youtu.be/aLFWPKNiBGU

<!-- Images -->
[images/cover]: https://github.com/csqrl/codify-plugin/raw/main/assets/Cover.png
[images/roblox-badge]: https://gist.github.com/csqrl/56c5f18b229ca1e61feb6eb5fb149f43/raw/robloxAnimated.svg
[images/itch-badge]: https://gist.github.com/csqrl/56c5f18b229ca1e61feb6eb5fb149f43/raw/itch.svg
[images/github-badge]: https://gist.github.com/csqrl/56c5f18b229ca1e61feb6eb5fb149f43/raw/githubSource.svg
[images/screenshots-row]: https://github.com/csqrl/codify-plugin/raw/main/assets/PluginScreenshots.png
[images/yt-demo]: https://github.com/csqrl/codify-plugin/raw/main/assets/YouTubeEmbed.png

<!-- Content -->
<div align="center">

![Codify Cover Image][images/cover]

[![Get it on Roblox][images/roblox-badge]][plugin] [![Get it on Itch|48x48][images/itch-badge]][itch]

Codify converts your pre-existing Roblox UI, models and more into code snippets in a flash. Whether you use vanilla Roblox Luau, or a framework like Roact or Fusion, Codify has you covered!

</div>

## :inbox_tray: Installation

Codify is available from the [Roblox Plugin Marketplace][plugin] for 350 Robux, or can be downloaded for **free** via [GitHub][repo] (self-build) or its [Itch.io store page][itch] (optional donation).

### Plugin Marketplace

The Creator Marketplace is the easiest way to install Codify. You'll get quick and easy access to updates via the Plugin Management window, and you'll be able to use the plugin anywhere you have Roblox Studio installed.

[![Get it on Roblox][images/roblox-badge]][plugin]

Don't forget to leave a :thumbsup: like if you enjoy the plugin!

### Itch.io

Currently, there's no way to automatically install and update plugins purchased through Itch. You'll need to manually download and drop the plugin file into your Studio plugins folder every time there's an update. You'll also have to repeat this process for every device you want to use the plugin on.

[![Get it on Itch][images/itch-badge]][itch]

### Manual Installation

If you don't want to use the Plugin Marketplace or Itch.io, you can clone the plugin source from GitHub. You'll need to compile the plugin binary yourself using a tool like [Rojo][rojo], and you'll also be responsible for keeping the plugin up to date.

This might be a great option for you if you want to modify the plugin source code, or if you're concerned about security. However, this method sacrifices convenience of installation and updates.

[![Get it on GitHub][images/github-badge]][repo]

## :bug: Found a Bug?

If you think you've found a bug, please report it! Here's all the places you can report bugs:

* [Reply to the DevForum thread][devforum-thread]
* [DevForum Direct Message][devforum-dm]
* [GitHub Issues][issues]
* [Twitter][twitter]

## :shield: Overview of Permissions

### HTTP Requests

Codify **requires** the ability to make HTTP requests to keep the plugin and Studio in-sync. The table below shows an overview of the domains Codify will make requests to, and why (and if) they're required.

| Domain | Required | Reason |
|--------|----------|--------|
| `s3.amazonaws.com` | :white_check_mark: | Studio metadata and API dump |
| `api.github.com` | :x: | List of contributors who helped make Codify possible |

### Script Injection

Script injection is a completely optional permission. You won't be prompted to give access to this until using the **Save to Device** feature. This feature allows you to save your code snippets to your computer.

This permission is exclusive to the **Save to Device**, and is not required for any other feature. Save to Device is great for exporting snippets longer than the TextBox character limit, or for accessing your snippets outside of Roblox Studio.

Save to Device will create a temporary ModuleScript in order to export your snippet. The ModuleScript is unarchivable, meaning it won't be saved to your place during publishing/(auto-)saving. The ModuleScript is also deleted immediately after the snippet is exported.

## :framed_picture: Screenshots

[![See Demo on YouTube][images/yt-demo]][yt-demo]

![Screenshots][images/screenshots-row]

## :thinking: Plugin Limitations

Codify does not support Instance properties which accept another Instance as its value. This means properties such as `Adornee` or `ObjectValue.Value` are not supported; however, Codify will try its best to link the Parent property to the Instance it's referencing, as long as it's in the tree.

Roblox's TextBoxes are also subject to a character limit. This means you may find large snippets of code are truncated. You can use the **Save to Device** feature to export your code to a ModuleScript, which is subject to a much larger character limit. However, if you're reaching these limits, you may want to consider reviewing your components/models, and seeing how you can split them down further. This will help you with maintainability and keep your codebase clean.

## :package: Open Source Projects

> :mega: Shoutout to @boatbomber for their help with expanding Codify's scope to include more than just Roact. You should [check out their Itch.io store](https://boatbomber.itch.io/) for more of their work, and how you can support them!

Codify is built on top of a few open source projects. Here's a list of the projects Codify uses:

* [highlighter](https://github.com/boatbomber/highlighter) by @boatbomber
* [studio-plugin](https://github.com/csqrl/studio-plugin) by @csqrl
* [studio-theme](https://github.com/csqrl/studio-theme) by @csqrl
* [roblox-lua-promise](https://github.com/evaera/roblox-lua-promise) by @evaera
* [roact](https://github.com/roblox/roact) by @roblox
* [roact-hooks](https://github.com/kampfkarren/roact-hooks) by @kampfkarren
* [roact-router](https://github.com/reselim/roact-router) by @reselim
* [rodux](https://github.com/roblox/rodux) by @roblox
* [rodux-hooks](https://github.com/solarhorizon/rodux-hooks) by @solarhorizon
* [sift](https://github.com/csqrl/sift) by @csqrl

## :warning: Disclaimer

The code snippets produced by Codify are not 100% perfect. You should consider the snippets as a starting point, and not a finished product. You should always review the code snippets before using them in your own projects. This still shouldn't put you off from using Codify, though!
