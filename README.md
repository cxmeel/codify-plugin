<!-- Link References -->
[marketplace-page]: https://create.roblox.com/marketplace/asset/4749111907/Codify
[itch-page]: https://cxmeel.itch.io/codify
[github-page]: https://github.com/cxmeel/codify-plugin

<!-- Image References -->
[image-banner]: https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/c/4/3/e/c43e3785a823d131a2d1cca146385ed56ce9df2a.png
[button-roblox]: https://gist.githubusercontent.com/cxmeel/0dbc95191f239b631c3874f4ccf114e2/raw/roblox_dev-animated.svg
[button-itch]: https://gist.githubusercontent.com/cxmeel/0dbc95191f239b631c3874f4ccf114e2/raw/itch.svg
[button-github]: https://gist.githubusercontent.com/cxmeel/0dbc95191f239b631c3874f4ccf114e2/raw/github_source.svg
[button-itch-icon]: https://gist.githubusercontent.com/cxmeel/0dbc95191f239b631c3874f4ccf114e2/raw/itch-icon.svg

<!-- Content -->

> **:information_source: Important information:**\
> This repo is for **Codify v2**, which is no longer being maintained. **Codify3** is in development and will supersede this version.
>
> [**Learn more &rarr;**](docs/Deprecation.md)

<div align="center">

[![Banner image][image-banner]][marketplace-page]

[![Purchase on Roblox][button-roblox]][marketplace-page] [![Purchase on Itch.io][button-itch-icon]][itch-page]

Codify v2 converts Roblox Instances into code snippets in a flash. Whether you use vanilla **Roblox Luau**, [**TypeScript JSX**](https://roblox-ts.com/docs/guides/roact-jsx), or a framework like [**React**](https://github.com/jsdotlua/react-lua#readme) or [**Fusion**](https://github.com/dphfox/Fusion#readme), Codify's got you covered!

</div>

## :inbox_tray: Installation

Codify v2 is available on the Roblox Plugin Marketplace, Itch, and GitHub. You can find the links below:

### Creator Marketplace

The Creator Marketplace is the easiest way to install Codify v2. You'll get access to automatic updats, and you'll be able to use the plugin anywhere you have Roblox Studio installed.

[![Get it on Roblox][button-roblox]][marketplace-page]

Don't forget to leave a :thumbsup: like if you enjoy the plugin!

### Itch

Currently, there's no way to automatically install and update plugins purchased through Itch. You'll need to manually download and drop the plugin file into your Studio plugins folder every time there's an update. You'll also have to repeat this process for every device you want to use the plugin on.

[![Get it on Itch.io][button-itch]][itch-page]

### Manual Installation

This is not recommended for most users, but you can clone this repository and build the plugin yourself. You'll need to know how to compile model binaries using [Rojo](https://github.com/rojo-rbx/rojo), and how to manually install local plugins in Roblox Studio.

[![Get it on GitHub][button-github]][github-page]

## :framed_picture: Gallery

<table>
    <tr>
        <td colspan="4">
            <a title="Watch demo on YouTube" href="https://youtu.be/aLFWPKNiBGU" rel="noreferrer noopener">
                <img alt="Screenshot of YouTube video" src="https://img.youtube.com/vi/aLFWPKNiBGU/maxresdefault.jpg" width="100%" />
                <br />
                <span>Watch demo on YouTube &rarr;</span>
            </a>
        </td>
    </tr>
    <tr>
        <td>
            <a title="Show screenshot" rel="noreferrer noopener" href="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/d/e/5/a/de5a89938136c1096ee1c69535617668f43a106b.png">
                <img alt="Screenshot showing Luau generation (no framework)" src="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/d/e/5/a/de5a89938136c1096ee1c69535617668f43a106b.png" />
            </a>
        </td>
        <td>
            <a href="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/9/d/7/b/9d7bea922719029cf18f418c6a4265cca24f394e.png" title="Show screenshot" rel="noreferrer noopener">
                <img alt="Screenshot showing React generation" src="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/9/d/7/b/9d7bea922719029cf18f418c6a4265cca24f394e.png" />
            </a>
        </td>
        <td>
            <a href="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/8/a/a/2/8aa2ffcf83e546b8ac875124b6ef4550d7bb477c.png" title="Show screenshot" rel="noreferrer noopener">
                <img alt="Screenshot showing Fusion generation" src="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/8/a/a/2/8aa2ffcf83e546b8ac875124b6ef4550d7bb477c.png" />
            </a>
        </td>
        <td>
            <a href="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/1/b/7/c/1b7c6d77d9dee4227abdab440ccc1264542086c8.png" title="Show screenshot" rel="noreferrer noopener">
                <img alt="Screenshot showing TypeScript JSX generation" src="https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/1/b/7/c/1b7c6d77d9dee4227abdab440ccc1264542086c8.png" />
            </a>
        </td>
    </tr>
</table>

## :shield: Permissions

### HTTP Requests

Codify **requires** the ability to make HTTP requests to fetch metadata about the Instances you're converting.

| Domain | Required | Reason |
|--------|----------|--------|
| `s3.amazonaws.com` | :white_check_mark: | Studio metadata and API dump |

### Script Injection

Script injection is a completely optional permission. You won't be prompted to give access to this until using the **Save to Device** feature. This feature allows you to save your code snippets to your computer.

## :warning: Disclaimer

The code snippets produced by Codify are not 100% perfect. You should consider the snippets as a starting point, and not a finished product. You should always review the code snippets before using them in your own projects. This still shouldn't put you off from using Codify, though!
