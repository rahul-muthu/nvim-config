# Neovim, Kitty, and tmux configuration

Neovim uses Monokai Pro's `pro` filter, with background `#2a2428` and text
`#cccccc`, matching [sampsn/nvim](https://github.com/sampsn/nvim).
Kitty and tmux use the same palette.

## Link the live configurations

From this checkout, run:

```sh
./scripts/link-configs.sh
```

This creates these symbolic links (and refuses to overwrite existing configs):

- `~/.config/kitty/kitty.conf` → `<checkout>/kitty/kitty.conf`
- `~/.tmux.conf` → `<checkout>/tmux/tmux.conf`

Kitty uses `$XDG_CONFIG_HOME/kitty` if `XDG_CONFIG_HOME` is set.
Edit the live paths or the repo files: both access the same contents, and Git
tracks the changes here. Configure editors to follow symlinks when saving;
replacing a link with a new file breaks the connection. Keep this checkout in
place, and rerun the script on other machines after cloning. Git tracks the
actual config files so their contents are available on the remote.

Restart Neovim to load its theme. Reload Kitty with Ctrl+Shift+F5 (macOS:
Cmd+Ctrl+,), or restart Kitty. Reload an existing tmux server with:

```sh
tmux source-file ~/.tmux.conf
```

After editing any of the configs, commit and push from this repository:

```sh
git add lua/plugins.lua nvim-pack-lock.json kitty/kitty.conf tmux/tmux.conf
git commit -m "Update terminal and editor configuration"
git push
```
