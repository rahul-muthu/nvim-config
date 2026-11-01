#!/usr/bin/env bash
# Link live configs to the files tracked by this repository.
set -euo pipefail
repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
kitty_dir="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"

link_config() {
    local source="$1" target="$2"
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ "$target" -ef "$source" ]]; then
            return
        fi
        printf 'Refusing to overwrite existing config: %s\n' "$target" >&2
        exit 1
    fi
    ln -s -- "$source" "$target"
}

mkdir -p -- "$kitty_dir"
link_config "$repo_dir/kitty/kitty.conf" "$kitty_dir/kitty.conf"
link_config "$repo_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
