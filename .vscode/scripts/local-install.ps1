$PLUGIN_NAME = "codify-v3"

aftman install
Remove-Item -Force "$env:LOCALAPPDATA\Roblox\Plugins\$PLUGIN_NAME.rbxm" -ErrorAction Ignore
rojo build .\default.project.json -o "$env:LOCALAPPDATA\Roblox\Plugins\$PLUGIN_NAME.rbxm"
