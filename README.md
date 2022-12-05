<!-- References -->
<!---- Links -->
[plugin/roblox-store-page]: https://create.roblox.com/marketplace/asset/4749111907
[plugin/itch-store-page]: https://csqrl.itch.io/codify

[plugin/repo]: https://github.com/csqrl/codify-plugin
[plugin/repo/issues]: https://github.com/csqrl/codify-plugin/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc
[plugin/repo/contributors]: https://github.com/csqrl/codify-plugin/graphs/contributors

[devforum/plugin-thread]: https://devforum.roblox.com/t/473076
[devforum/direct]: https://devforum.roblox.com/new-message?username=csqrl&title=%5BCodify%5D%20Bug%20Report
[csqrl/twitter]: https://twitter.com/csqrI
[youtube/plugin-demo]: https://youtu.be/aLFWPKNiBGU
[boatbomber/itch]: https://boatbomber.itch.io

<!---- Images -->
[images/cover]: assets/Cover.png
[images/youtube-embed]: assets/YouTubeEmbed.png

[images/roblox-badge]: https://gist.github.com/csqrl/0dbc95191f239b631c3874f4ccf114e2/raw/roblox_dev-animated.svg
[images/itch-badge]: https://gist.github.com/csqrl/0dbc95191f239b631c3874f4ccf114e2/raw/itch.svg
[images/itch-badge/icon]: https://gist.github.com/csqrl/0dbc95191f239b631c3874f4ccf114e2/raw/itch-icon.svg
[images/github-badge/source]: https://gist.github.com/csqrl/0dbc95191f239b631c3874f4ccf114e2/raw/github_source.svg
[images/github-badge/icon]: https://gist.github.com/csqrl/0dbc95191f239b631c3874f4ccf114e2/raw/github-icon.svg

<!-- Contents -->
<div align="center">

![Codify Cover Image][images/cover]

[![Get it on Roblox][images/roblox-badge]][plugin/roblox-store-page] [![Get it on Itch][images/itch-badge/icon]][plugin/itch-store-page] [![Source on GitHub][images/github-badge/icon]][plugin/itch-store-page]

</div>

Codify converts existing UI, models and more into snippets of code, just like magic! Whether you use [vanilla Roblox Luau](https://luau-lang.org), [TypeScript](https://roblox-ts.com), [Rojo](https://rojo.space) or frameworks like [Roact](https://github.com/Roblox/roact) or [Fusion](https://github.com/Elttob/Fusion), Codify has you covered!

## :inbox_tray: Installation

Codify is available to purchase through the [Roblox Creator Marketplace][plugin/roblox-store-page]. It's also **available for free** via its [Itch.io store page][plugin/itch-store-page] (optional donation) or [GitHub][plugin/repo] (self-build).

### Creator Marketplace

The Creator Marketplace is the simplest way to install Codify. You'll get quick and easy access to updates via the Plugin Manager, and you'll be able to use the plugin anywhere you have Roblox Studio installed with a single click!

Don't forget to leave the plugin a :thumbsup: if you like it!

[![Get it on Roblox][images/roblox-badge]][plugin/roblox-store-page]

### Itch.io

Plugins currently cannot be automatically updated or installed via Itch.io. You'll need to manually update the plugin whenever a new release is available. You'll also have to repeat this process for every device you wish to use Codify on.

Codify can currently be obtained for free via Itch.io. An optional donation is recommended to show your support for creators, but is not required.

[![Get it on Itch][images/itch-badge]][plugin/itch-store-page]

### Manual Installation

If you don't want to use the Creator Marketplace or Itch.io, you can install Codify manually. You'll be responsible for keeping the plugin up-to-date and will be required to manually build the plugin using Rojo before you can use it.

This might be the best option for you if you want to modify the plugin source code. However, it sacrifices the convenience of easy updates via the Plugin Manager.

[![Source on GitHub][images/github-badge/source]][plugin/repo]

## :framed_picture: Screenshots

[![See Demo on YouTube][images/youtube-embed]][youtube/plugin-demo]

## :bug: Found a Bug?

If you find a bug, please report it! Here's a list of ways you can report a bug:

- [Reply to the DevForum thread][devforum/plugin-thread]
- [Direct message via DevForum][devforum/direct]
- [GitHub Issues][plugin/repo/issues]
- [Twitter][csqrl/twitter]

## :shield: Overview of Permissions

### HTTP Requests

Codify **requires** the ability to make HTTP requests in order to keep the plugin in sync with the latest version of Roblox Studio. The table below outlines the domains Codify will make requests to, and why (or if) they are required.

| Domain | Required | Reason |
|:-------|:---------|:-------|
| `s3.amazonaws.com` | :heavy_check_mark: | Studio metadata and API dump |

### Script Injection

Script injection is an optional permission. You'll only be prompted to allow injection when exporting snippets.

When exporting to device, Codify will create a temporary script which you will then be prompted to save to your device. The temporary script is non-Archivable and will not save when (auto-)saving or publishing your game.

## :package: Credits

> Special thanks to Zack ([@boatbomber](https://github.com/boatbomber)) for their help with expanding the scope of Codify. Please [check out their Itch.io store][boatbomber/itch] for a full overview of their work and to show your support!

### Open Source

Codify wouldn't be possible without the help of the following open source projects:

- [DumpParser](https://github.com/csqrl/dump-parser) by [@csqrl](https://github.com/csqrl)
- [Highlighter](https://github.com/boatbomber/highlighter) by [@boatbomber](https://github.com/boatbomber)
- [Packager](https://github.com/csqrl/packager) by [@csqrl](https://github.com/csqrl)
- [Promise](https://github.com/evaera/roblox-lua-promise) by [@evaera](https://github.com/evaera)
- [RoactRodux](https://github.com/grilme99/roact-rodux) by [@grilme99](https://github.com/grilme99) ([fork](https://github.com/Roblox/roact-rodux))
- [RoactCompat](https://github.com/grilme99/CorePackages) by [@grilme99](https://github.com/grilme99) ([port](https://github.com/grilme99/CorePackages#roact17))
- [Rodux](https://github.com/roblox/rodux) by [@roblox](https://github.com/roblox)
- [Sift](https://github.com/csqrl/sift) by [@csqrl](https://github.com/csqrl)

## :warning: Disclaimer

You should not expect code snippets produced by Codify to be 100% perfect. You should always review the generated snippets before use.
