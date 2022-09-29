$PLUGIN_NAME = "codify_dev_6c3fdf81"

aftman install
Remove-Item -Force "$env:LOCALAPPDATA\Roblox\Plugins\$PLUGIN_NAME.rbxm" -ErrorAction Ignore
rojo build .\default.project.json -o "$env:LOCALAPPDATA\Roblox\Plugins\$PLUGIN_NAME.rbxm"
